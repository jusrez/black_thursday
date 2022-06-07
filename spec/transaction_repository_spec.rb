require './lib/item.rb'
require './lib/item_repository'
require './lib/merchant_repository'
require './lib/merchant'
require './lib/invoice'
require './lib/invoice_repository'
require './lib/transaction'
require './lib/transaction_repository'
require 'CSV'

RSpec.describe TransactionRepository do

  it "exists" do
    transaction_repository = TransactionRepository.new("./data/transactions.csv")

		expect(transaction_repository).to be_instance_of(TransactionRepository)
  end

  it "can return an array of all transactions" do
    transaction_repository = TransactionRepository.new("./data/transactions.csv")

		expect(transaction_repository.all.count).to eq(4985)
  end

  it "can find by a transaction id" do
    transaction_repository = TransactionRepository.new("./data/transactions.csv")

		expect(transaction_repository.find_by_id(1)).to be_instance_of(Transaction)
  end

  it 'can find all by invoice id' do
    transaction_repository = TransactionRepository.new("./data/transactions.csv")

		expect(transaction_repository.find_all_by_invoice_id("2179")).to be_instance_of(Array)
    expect(transaction_repository.find_all_by_invoice_id("2179").count).to eq(2)
    expect(transaction_repository.find_all_by_invoice_id("100000")).to eq([])
  end

	it 'can find all by credit card number' do
		transaction_repository = TransactionRepository.new("./data/transactions.csv")

		expect(transaction_repository.find_all_by_credit_card_number(9393939393939393)).to eq([])
		expect(transaction_repository.find_all_by_credit_card_number(4839506591130477).count).to eq(1)
	end

	it 'can find all by result' do
		transaction_repository = TransactionRepository.new("./data/transactions.csv")

		expect(transaction_repository.find_all_by_result("success").count).to eq(4158)
		expect(transaction_repository.find_all_by_result("success")[0]).to be_a(Transaction)

	end
end
