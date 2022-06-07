require './lib/sales_engine'
require './lib/customer_repository'
require './lib/customer'
require './lib/item_repository'
require 'time'

RSpec.describe CustomerRepository do
	it 'exists' do
		customers = "./data/customers.csv"
		customers_repo = CustomerRepository.new(customers)
		expect(customers_repo).to be_an_instance_of CustomerRepository
	end

end
