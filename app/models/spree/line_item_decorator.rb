Spree::LineItem.class_eval do
  scope :unexpired, lambda { joins(:order => :timed_order).where("#{Spree::TimedOrder.table_name}.expires_at > ? AND #{Spree::Order.table_name}.completed_at IS NULL", Time.now.utc) }
end