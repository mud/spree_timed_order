require 'spec_helper'

describe Spree::OrdersController do
  ORDER_TOKEN = 'ORDER_TOKEN'

  let(:user) { Factory(:user) }
  let(:guest_user) { Factory(:user) }
  let(:order) { Spree::Order.new }

  before do
    Spree::User.stub :anonymous! => guest_user
  end

  context 'when no order exists in the session' do
    before { Spree::Order.stub :new => order }

    context '#populate' do
      context 'when not logged in' do
        it 'should create timed_order' do
          post :populate
          order.timed_order.nil? == false
          order.expired? == false
        end
      end

      context 'when authenticated as a registered user' do
        before { controller.stub :current_user => user }

        it 'should create timed_order' do
          Spree::User.should_not_receive :anonymous!
          post :populate
          order.timed_order.nil? == false
          order.expired? == false
        end
      end

      context 'when not authenticated' do
        it 'should create timed_order' do
          Spree::User.should_receive(:anonymous!).and_return guest_user
          post :populate
          order.timed_order.nil? == false
          order.expired? == false
        end
      end
    end
  end

  context 'when an order exists in the session' do
    let(:token) { 'some_token' }

    before do
      controller.stub :current_order => order
      controller.stub :current_user => user
    end

    context '#populate' do
      it 'should check if user is authorized for :edit' do
        controller.should_receive(:authorize!).with(:edit, order, token)
        post :populate, :token => token
      end
    end

    context '#edit' do
      it 'should check if user is authorized for :edit' do
        controller.should_receive(:authorize!).with(:edit, order, token)
        get :edit, :token => token
      end
    end

    context '#update' do
      it 'should check if user is authorized for :edit' do
        order.stub :update_attributes
        controller.should_receive(:authorize!).with(:edit, order, token)
        post :update, :token => token
      end
    end

    context '#empty' do
      it 'should check if user is authorized for :edit' do
        controller.should_receive(:authorize!).with(:edit, order, token)
        post :empty, :token => token
      end
    end
  end

  context 'when no authenticated user' do
    let(:order) { Factory(:order, :number => 'R123') }

    context '#show' do
      context 'when token parameter present' do
        it 'should store as guest_token in session' do
          get :show, {:id => 'R123', :token => order.token }
          session[:access_token].should == order.token
        end
      end

      context 'when no token present' do
        it 'should not store a guest_token in the session' do
          get :show, {:id => 'R123'}
          session[:access_token].should be_nil
        end

        it 'should respond with 404' do
          get :show, {:id => 'R123'}
          response.code.should == '404'
        end
      end
    end
  end
end
