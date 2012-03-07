Spree::BaseHelper.module_eval do
  def link_to_cart(text = nil)
    return "" if current_page?(cart_path)

    text = text ? h(text) : t('cart')
    css_class = nil

    if current_order.nil? or current_order.line_items.empty?
      text = "#{text}: (#{t('empty')})"
      css_class = 'empty'
    else
      text = "#{text}: (#{current_order.item_count})  <span class='amount'>#{order_subtotal(current_order)}</span>".html_safe
      if current_order.expired?
        text << " Expired #{time_ago_in_words(current_order.timed_order[:expires_at])} ago"
      else
        text << " Valid for #{time_ago_in_words(current_order.timed_order[:expires_at])}"
      end
      css_class = 'full'
    end

    link_to text, cart_path, :class => css_class
  end
end
