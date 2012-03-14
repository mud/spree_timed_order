Spree::Order.class_eval do
  has_one :timed_order, :dependent => :destroy
  scope :unexpired, lambda { joins(:timed_order).where("#{Spree::TimedOrder.table_name}.expires_at > ?", Time.now.utc) }
  scope :contains_variant, lambda { |variant| joins(:line_items).where("#{Spree::LineItem.table_name}.variant_id = ?", variant[:id]) }
  
  def expired?
    if timed_order.nil?
      self.timed_order = Spree::TimedOrder.new({ :expires_at => SpreeTimedOrder::Config[:expire_duration].minutes.from_now })
      self.save!
    end
    # only set expired if item_count is > 0
    if line_items.count > 0
      timed_order.expired?
    else
      true
    end
  end
  
  # override methods
  def checkout_allowed?
    line_items.count > 0 && !expired?
  end
  
  class << self
    def contains_variant(variant)
      Spree::Order.joins(:timed_order, :line_items).where("#{Spree::TimedOrder.table_name}.expires_at > ? and #{Spree::LineItem.table_name}.variant_id = ?", Time.now.utc, variant[:id]).order("#{Spree::TimedOrder.table_name}.expires_at asc")
    end
  end
end