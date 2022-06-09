require './deletable'
require_relative './transaction'
require 'CSV'
class TransactionRepository
	include Deletable

	attr_reader :all

  def initialize(transaction_path)
    @transaction_path = transaction_path
    @all              = []
		parse_csv
  end

  def find_by_id(id)
    @all.find do |transaction|
      transaction.id.to_i == id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    @all.find_all do |transaction|
      transaction.invoice_id == invoice_id
    end
  end

	def find_all_by_credit_card_number(card_number)
    @all.find_all do |transaction|
      transaction.credit_card_number.to_i == card_number
    end
  end

	def find_all_by_result(result)
    @all.find_all do |transaction|
      result == transaction.result
    end
  end

	def create(attributes)
		new_id = @all.last.id.to_i + 1
		new_attribute = attributes
		@all << Transaction.new(
			:id => new_id.to_s,
			:invoice_id => new_attribute[:invoice_id],
			:credit_card_number => new_attribute[:credit_card_number],
			:credit_card_expiration_date => new_attribute[:credit_card_expiration_date],
			:result => new_attribute[:result],
			:created_at => Time.now,
			:updated_at => Time.now)
		return @all.last
	end

	def update(id, attributes)
		updated_transaction = find_by_id(id)
		updated_transaction.credit_card_number = attributes[:credit_card_number]
		updated_transaction.credit_card_expiration_date = attributes[:credit_card_expiration_date]
		updated_transaction.result = attributes[:result]
		updated_transaction.updated_at = Time.now.round
	end


	def delete(id)
		removed_transaction = find_by_id(id)
		@all.delete(removed_transaction)
	end

	private

	def parse_csv
		CSV.foreach(@transaction_path, headers: true, header_converters: :symbol) do |row|
    @all << Transaction.new({:id => row[:id],
      :invoice_id => row[:invoice_id],
      :credit_card_number => row[:credit_card_number],
			:credit_card_expiration_date => row[:credit_card_expiration_date],
      :result => row[:result],
      :created_at => row[:created_at],
      :updated_at => row[:updated_at]})
    end
	end
end
