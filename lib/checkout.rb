require_relative 'discount_database'
class Checkout
  attr_reader :prices
  private :prices

  def initialize(prices)
    @prices = prices
    @discount_db = DiscountDatabase.new  # Initialize the discount database
    @basket = []
  end

  def scan(item)
    basket << item.to_sym
  end

  def total
    total = calculate_base_total
    total = apply_discounts(total)  # Ensure total is updated after applying discounts
    total
  end

  private

  def calculate_base_total
    @basket.inject(0) do |sum, item|
      sum + prices.fetch(item, 0)  # Fetch price or default to 0 if not found
    end
  end

  def apply_discounts(total)
    @basket.uniq.each do |item|
      discount = @discount_db.get_discount(item)  # Get discount for the item
      if discount && discount[:type] == 'two_for_1'
        item_count = @basket.count(item)
        free_items = item_count / 2
        total -= prices.fetch(item) * free_items  # Subtract the value of free items
      end
    end
    total  # Return the updated total
  end

  private

  def basket
    @basket ||= Array.new
  end
end
