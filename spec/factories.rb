FactoryGirl.define do
  factory :timed_order, :class => Spree::TimedOrder do |t|
    t.association :order, :factory => :order
  end
end