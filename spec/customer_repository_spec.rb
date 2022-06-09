require './lib/sales_engine'
require './lib/customer_repository'
require './lib/customer'
require './lib/item_repository'
require 'time'

RSpec.describe CustomerRepository do
	customers = "./data/customers.csv"
	customers_repo = CustomerRepository.new(customers)

	it 'exists' do
		expect(customers_repo).to be_an_instance_of CustomerRepository
	end

	it 'returns an array of all customers' do
		expect(customers_repo.all).to be_a(Array)
	end

	it 'can find a customer by id' do
		expect(customers_repo.find_by_id(977)).to be_a(Customer)
		expect(customers_repo.find_by_id(977).first_name).to eq("Werner")
	end

	it 'can find all customers with first name' do
		expect(customers_repo.find_all_by_first_name("Lord Farquad")).to eq([])
		expect(customers_repo.find_all_by_first_name("Emerson")[0]).to be_a(Customer)
	end

	it 'can find all customers with last name' do
		expect(customers_repo.find_all_by_last_name("Blooregard")).to eq([])
		expect(customers_repo.find_all_by_last_name("Tromp")[0]).to be_a(Customer)
	end

	it 'can create a new customer' do
		expect(customers_repo.create({:first_name => "Larry", :last_name => "Larrington"})).to be_a(Customer)
		expect(customers_repo.all.last.first_name).to eq("Larry")
	end

	it 'can update an existing customer' do
		expect(customers_repo.update(960, {:first_name => "Dirk", :last_name => "Nowitzki"})).to be_a(Customer)
		expect(customers_repo.find_by_id(960).first_name).to eq("Dirk")
	end

	it 'can delete a customer' do
		expect(customers_repo.find_by_id(960)).to be_a(Customer)
		customers_repo.delete(960)
		expect(customers_repo.find_by_id(960)).to eq(nil)
	end
end
