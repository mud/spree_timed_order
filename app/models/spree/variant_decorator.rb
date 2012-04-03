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
end