require './lib/item'
require 'time'
require 'bigdecimal'

RSpec.describe Item do
	i = Item.new({
		:id          => 1,
		:name        => "Pencil",
		:description => "You can use it to write things",
		:unit_price  => BigDecimal(10.99,4),
		:created_at  => Time.now.round,
		:updated_at  => Time.now.round,
		:merchant_id => 2
		})

	it 'exists' do
		expect(i).to be_instance_of(Item)
	end

	it 'returns the item id' do
		expect(i.id).to eq(1)
	end

	it 'returns the item name' do
		expect(i.name).to eq("Pencil")
	end

	it 'returns the item description' do
		expect(i.description).to eq("You can use it to write things")
	end

	it 'returns the item unit price' do
		expect(i.unit_price).to eq(BigDecimal(10.99,4))
	end

	it 'returns the time the item was created' do
		expect(i.created_at).to eq(Time.now.round)
	end

	it 'returns the time the item was updated' do
		expect(i.updated_at).to eq(Time.now.round)
	end

	it 'returns the merchant id' do
		expect(i.merchant_id).to eq(2)
	end
end
