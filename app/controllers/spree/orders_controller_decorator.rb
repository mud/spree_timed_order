Spree::OrdersController.class_eval do
  before_filter :ensure_not_expired, :only => [:edit, :update, :populate]
  
  private
  
  def ensure_not_expired
    order = current_order
    if !order.nil? && order.expired? && !order.line_items.empty?
      flash.now[:notice] = "Your order has expired and all items in your cart has been released."
      order.line_items.destroy_all
    end
  end
end