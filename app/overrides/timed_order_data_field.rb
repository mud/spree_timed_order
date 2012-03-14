Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                    :name => "auth_admin_login_navigation_bar",
                    :insert_bottom => "[data-hook='body']",
                    :partial => "timed_orders/expires_at")
