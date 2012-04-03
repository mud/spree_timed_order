require 'spec_helper'

describe Spree::OrdersController do
  let(:user) { Factory(:user) }
  let(:order) { stub_model(Spree::Order, :number => "R123", :reload => nil, :save! => true, :coupon_code => nil, :user => user)}
  let(:product) { Factory(:product) }
  before do
    Spree::Order.stub(:find).with(1).and_return(order)
    controller.stub :current_user => user
  end
  

  context 'order has no items' do
    before { Spree::Order.stub(:new).and_return(order) }

    context '#populate' do
      before do
        Spree::Order.stub(:new).and_return(order)
        @variant = mock_model(Spree::Variant)
      end
      
      it 'should create timed_order' do
        post :populate
        order.timed_order.should_not be_nil
      end
      
      it 'should be expired? when line_items are empty' do
        post :populate
        order.line_items.should be_empty
        order.expired?.should be_true
      end
      
      context 'cart not empty' do
        before :each do
          @variant1 = mock_model(Spree::Variant, :product => "product1")
          @variant2 = mock_model(Spree::Variant, :product => "product2")
          @line_items = [mock_model(Spree::LineItem, :variant => @variant1, :variant_id => @variant1.id, :quantity => 1),
                         mock_model(Spree::LineItem, :variant => @variant2, :variant_id => @variant2.id, :quantity => 2)]
          @line_items.stub(:destroy_all).and_return(lambda { order.stub(:line_items => []) })
          order.stub(:line_items => @line_items)
        end
        
        it 'should not be expired? when line_items are not empty' do
          post :populate
        
          order.line_items.should_not be_empty
          order.expired?.should be_false
        end
      
        it 'should empty line_items when expired' do
          post :populate
        
          order.timed_order.should_not be_nil
          order.timed_order.expires_at = 1.minutes.ago
          order.line_items.should_not be_empty
          order.expired?.should be_true
        
          post :populate
          order.stub(:line_items => [])
          order.expired?.should be_true
          order.line_items.should be_empty
        end
      end
    end
  end
end
