Spree::Product.class_eval do
  def timed_on_hand
    has_variants? ? variants.inject(0) { |sum, v| sum + v.timed_on_hand } : master.timed_on_hand
  end
  
  def has_stock?
    timed_on_hand > 0
  end
end