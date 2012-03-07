Spree::LineItem.class_eval do
  scope :unexpired, lambda { joins(:order => :timed_order).where("#{Spree::TimedOrder.table_name}.expires_at > ?", Time.now.utc) }
end