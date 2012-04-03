Spree::LineItem.class_eval do
  scope :unexpired, lambda { joins(:order => :timed_order).where("#{Spree::TimedOrder.table_name}.expires_at > ? AND #{Spree::Order.table_name}.completed_at IS NULL", Time.now.utc) }
  def sufficient_stock?
    item = Spree::LineItem.unexpired.where("#{Spree::Order.table_name}.id = ?", self.order[:id]).first
    unless item.nil?
      Spree::Config[:allow_backorders] ? true : (self.variant.timed_on_hand >= (self.quantity-item.quantity))
    else
      Spree::Config[:allow_backorders] ? true : (self.variant.timed_on_hand >= self.quantity)
    end
  end
end