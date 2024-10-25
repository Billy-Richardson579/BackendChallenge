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
    total = 0

    basket.inject(Hash.new(0)) { |items, item| items[item] += 1; items }.each do |item, count|
      if item == :apple || item == :pear
        if (count % 2 == 0)
          total += prices.fetch(item) * (count / 2)
        else
          total += prices.fetch(item) * count
        end
      elsif item == :banana || item == :pineapple
        if item == :pineapple
          total += (prices.fetch(item) / 2)
          total += (prices.fetch(item)) * (count - 1)
        else
          total += (prices.fetch(item) / 2) * count
        end
      elsif item == :mango
        discount = count / 4  # 1 free for every 3 bought
        total += prices.fetch(item) * (count - discount)  # Subtract the free Mangos from total
      else
        total += prices.fetch(item) * count
      end
    end

    total
  end

  private

  def basket
    @basket ||= Array.new
  end
end
