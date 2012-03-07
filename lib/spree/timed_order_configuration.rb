module Spree
  class TimedOrderConfiguration < Spree::Preferences::Configuration
    preference :track_timed_orders, :boolean, :default => true
    preference :expire_duration, :integer, :default => 10
  end
end