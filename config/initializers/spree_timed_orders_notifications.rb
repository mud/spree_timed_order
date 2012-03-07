# whenever an item is added, increase expire by 10mins
ActiveSupport::Notifications.subscribe(/spree.cart.add/) do |name, start, finish, id, payload|
  Rails.logger.debug(["[Spree::TimedOrder Notification]:", name, start, finish, id, payload].join(" "))
  current_user = payload[:user]
  current_order = payload[:order]
  
  Spree::TimedOrder.product_added_to_order(current_order)
end
