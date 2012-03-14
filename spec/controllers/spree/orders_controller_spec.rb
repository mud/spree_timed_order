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
    end
  end
end
