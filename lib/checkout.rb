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
    @basket << item.to_sym  # Store items as symbols
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
      if discount
        item_count = @basket.count(item)
        puts "Item: #{item}, Count: #{item_count}, Discount Type: #{discount[:type]}"

        case discount[:type]
        when 'two_for_1'
          free_items = item_count / 2
          total -= prices.fetch(item) * free_items  # Subtract the value of free items
          puts "Two for 1 Discount: Free Items: #{free_items}, New Total: #{total}"
        when 'half_price'
          if discount[:limit] == 1
            # Only apply discount for 1 item
            total -= prices.fetch(item) * 0.5  # Discount one item at half price
            puts "Limited Half Price Discount for #{item}: New Total: #{total}"
          else
            total -= (prices.fetch(item) * item_count) / 2  # Halve the total for that item
            puts "Half Price Discount: New Total: #{total}"
          end
        when 'buy_3_get_1_free'
          free_items = item_count / 4
          total -= prices.fetch(item) * free_items  # Subtract the value of free items
          puts "Buy 3 Get 1 Free Discount: Free Items: #{free_items}, New Total: #{total}"
        end
      end
    end
    total  # Return the updated total
  end
end
