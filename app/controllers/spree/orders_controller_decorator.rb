Spree::OrdersController.class_eval do
  before_filter :ensure_not_expired, :only => [:edit, :update]
  
  private
  
  def ensure_not_expired
    order = current_order(true)
    if order.expired? && !order.line_items.empty?
      flash.notice = "Your order has expired and we released all products in your cart."
      order.line_items.destroy_all
    end
  end
end