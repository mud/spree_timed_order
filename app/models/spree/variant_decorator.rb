Spree::Variant.class_eval do
  # checks available quantity by looking at the number of line items currently active
  def timed_on_hand
    if SpreeTimedOrder::Config[:track_timed_orders]
      active_count = Spree::LineItem.joins(:order).where("#{Spree::LineItem.table_name}.variant_id = ?", self[:id]).unexpired.sum(:quantity)
      self.count_on_hand - active_count
    else
     self.on_hand
    end
  end
  
  # override in_stock? and use the timed_on_hand instead of on_hand
  def in_stock?
    Spree::Config[:track_inventory_levels] ? timed_on_hand > 0 : true
  end
end