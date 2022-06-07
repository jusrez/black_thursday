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

	it 'returns an array of all customers' do
		customers = "./data/customers.csv"
		customers_repo = CustomerRepository.new(customers)

		expect(customers_repo.all).to be_a(Array)
	end

	it 'can find a customer by id' do
		customers = "./data/customers.csv"
		customers_repo = CustomerRepository.new(customers)

		expect(customers_repo.find_by_id(977)).to be_a(Customer)
		expect(customers_repo.find_by_id(977).first_name).to eq("Werner")
	end

	it 'can find all customers with first name' do
		customers = "./data/customers.csv"
		customers_repo = CustomerRepository.new(customers)

		expect(customers_repo.find_all_by_first_name("Lord Farquad")).to eq([])
		expect(customers_repo.find_all_by_first_name("Emerson")[0]).to be_a(Customer)
	end

	it 'can find all customers with last name' do
		customers = "./data/customers.csv"
		customers_repo = CustomerRepository.new(customers)

		expect(customers_repo.find_all_by_last_name("Blooregard")).to eq([])
		expect(customers_repo.find_all_by_last_name("Tromp")[0]).to be_a(Customer)
	end

	it 'can create a new customer' do
		customers = "./data/customers.csv"
		customers_repo = CustomerRepository.new(customers)

		expect(customers_repo.create({:first_name => "Larry", :last_name => "Larrington"})).to be_a(Customer)
		expect(customers_repo.all.last.first_name).to eq("Larry")
	end
end
