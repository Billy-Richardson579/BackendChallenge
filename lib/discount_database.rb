# lib/discount_database.rb

class DiscountDatabase
  def initialize
    @discounts = {
      :apple => { type: 'two_for_1' },
      :pear => { type: 'two_for_1' },
      :banana => { type: 'half_price' },
      :pineapple => { type: 'half_price', limit: 1 },  # Limited to 1 per customer
      :mango => { type: 'buy_3_get_1_free' },
    }
  end

  def get_discount(item)
    @discounts[item.to_sym]  # Convert item to symbol for lookup
  end
end
