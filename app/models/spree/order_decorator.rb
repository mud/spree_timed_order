Spree::Order.class_eval do
  has_one :timed_order, :dependent => :destroy
  scope :unexpired, lambda { joins(:timed_order, :line_items).where("#{Spree::TimedOrder.table_name}.expires_at > ?", Time.now.utc) }
  
  def expired?
    # only set expired if item_count is > 0
    if !timed_order.nil? && line_items.count > 0
      timed_order.expired?
    else
      true
    end
  end
  
  # override methods
  def checkout_allowed?
    line_items.count > 0 && !expired?
  end
end