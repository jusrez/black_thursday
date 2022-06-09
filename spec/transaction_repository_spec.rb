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

	it 'can create a new transaction' do
		transaction_repository = TransactionRepository.new("./data/transactions.csv")
		test_transaction = transaction_repository.create(
			{:invoice_id => "5",
			:credit_card_number => "9393939393939393",
			:credit_card_expiration_date => "0822",
			:result => "success",
			})

		expect(test_transaction.id).to eq("4986")
    expect(test_transaction.invoice_id).to eq("5")
    expect(test_transaction.credit_card_number).to eq("9393939393939393")
    expect(test_transaction.created_at).to be_instance_of(Time)
    expect(transaction_repository.find_by_id(4986)).to eq(transaction_repository.all.last)

	end

	it 'can update a transaction' do
		transaction_repository = TransactionRepository.new("./data/transactions.csv")
		expect(transaction_repository.find_by_id(1).credit_card_number).to eq("4068631943231473")
		expect(transaction_repository.find_by_id(1).credit_card_expiration_date).to eq("0217")
		expect(transaction_repository.find_by_id(1).result).to eq("success")
		expect(transaction_repository.find_by_id(1).updated_at).to eq("2012-02-26 20:56:56 UTC")

		transaction_repository.update(1, {:credit_card_number => "9393939393939393",
			:credit_card_expiration_date => "0822",
			:result => "success",
			:updated_at => Time.now.round
			})

		expect(transaction_repository.find_by_id(1).credit_card_number).to eq("9393939393939393")
		expect(transaction_repository.find_by_id(1).credit_card_expiration_date).to eq("0822")
		expect(transaction_repository.find_by_id(1).result).to eq("success")
		expect(transaction_repository.find_by_id(1).updated_at).to eq(Time.now.round)
	end

	it 'can delete a transaction' do
		transaction_repository = TransactionRepository.new("./data/transactions.csv")
		expect(transaction_repository.find_by_id(1).credit_card_number).to eq("4068631943231473")

		transaction_repository.delete(1)
		expect(transaction_repository.find_by_id(1)).to eq(nil)
	end
end
