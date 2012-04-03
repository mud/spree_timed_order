# whenever an item is added, increase expire by 10mins
ActiveSupport::Notifications.subscribe(/spree.cart.add/) do |name, start, finish, id, payload|
  Rails.logger.debug(["[Spree::TimedOrder Notification]:", name, start, finish, id, payload].join(" "))
  Spree::TimedOrder.product_added_to_order(payload[:order])
end

ActiveSupport::Notifications.subscribe(/spree.cart.contents_changed/) do |name, start, finish, id, payload|
  Rails.logger.debug(["[Spree::TimedOrder Notification]:", name, start, finish, id, payload].join(" "))
  Spree::TimedOrder.contents_changed_to_order(payload[:order])
end
