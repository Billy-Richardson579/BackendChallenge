# spec/discount_database_spec.rb

require 'discount_database'

RSpec.describe DiscountDatabase do
  let(:discount_db) { DiscountDatabase.new }

  describe '#get_discount' do
    it 'returns the correct discount for apples' do
      expect(discount_db.get_discount(:apple)).to eq({ type: 'two_for_1' })
    end

    it 'returns the correct discount for pears' do
      expect(discount_db.get_discount(:pear)).to eq({ type: 'two_for_1' })
    end

    it 'returns the correct discount for bananas' do
      expect(discount_db.get_discount(:banana)).to eq({ type: 'half_price' })
    end

    it 'returns the correct discount for pineapples' do
      expect(discount_db.get_discount(:pineapple)).to eq({ type: 'half_price', limit: 1 })
    end

    it 'returns the correct discount for mangos' do
      expect(discount_db.get_discount(:mango)).to eq({ type: 'buy_3_get_1_free' })
    end

    it 'returns nil for items without discounts' do
      expect(discount_db.get_discount(:orange)).to be_nil
    end
  end
end
