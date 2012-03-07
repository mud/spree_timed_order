module Spree
  class TimedOrder < ActiveRecord::Base
    belongs_to :order
    self.table_name = "timed_orders"
  
    def increase_expire(time_options = { :minutes => 10 })
      update_attribute(:expires_at, Time.now.utc.advance(time_options))
    end
  
    def expired?
      expires_at.utc < Time.now.utc
    end
    
    class << self
      def product_added_to_order(current_order)
        if current_order.timed_order.nil?
          current_order.timed_order = Spree::TimedOrder.new(:expires_at => SpreeTimedOrder::Config[:expire_duration].minutes.from_now)
          current_order.save
        else
          current_order.timed_order.increase_expire({ :minutes => 10 })
        end
        Rails.logger.debug(["[Spree::TimedOrder Increase Expire]", current_order.timed_order.expires_at].join(" "))
      end
    end
  end
end