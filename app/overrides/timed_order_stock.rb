Deface::Override.new(:virtual_path => "spree/products/_cart_form",
                    :name => "product_cart_stock",
                    :insert_bottom => "#product-price div",
                    :partial => "timed_orders/stock")
