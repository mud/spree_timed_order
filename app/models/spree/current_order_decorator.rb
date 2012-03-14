Spree::Core::CurrentOrder.module_eval do
  # override current_order
  alias :current_order_orig :current_order unless method_defined?(:current_order_orig)
  def current_order(create_order_if_necessary = false)
    order = current_order_orig(create_order_if_necessary)
    if !order.nil? && order.timed_order.nil? && order.line_items.size > 0
      order.timed_order = Spree::TimedOrder.new({ :expires_at => SpreeTimedOrder::Config[:expire_duration].minutes.from_now })
      order.save!
    end
    order
  end
end
