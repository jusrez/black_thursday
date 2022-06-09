require './lib/customer'
require 'time'

RSpec.describe Customer do
	c = Customer.new({
	:id => 6,
	:first_name => "Joan",
	:last_name => "Clarke",
	:created_at => Time.now.round,
	:updated_at => Time.now.round
	})

	it 'exists' do
		expect(c).to be_an_instance_of Customer
	end

	it 'can return the customer id' do
		expect(c.id).to eq(6)
	end

	it 'can return the customers first name' do
		expect(c.first_name).to eq("Joan")
	end

	it 'can return the customers last name' do
		expect(c.last_name).to eq("Clarke")
	end

	it 'can return the time a customers profile was created' do
		expect(c.created_at).to eq(Time.now.round)
	end

	it 'can return the time the customers profile was updated' do
		expect(c.updated_at).to eq(Time.now.round)
	end
end
