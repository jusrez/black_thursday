require_relative './transaction'
require 'CSV'
class TransactionRepository
	attr_reader :all
  def initialize(transaction_path)
    @transaction_path = transaction_path
    @all = []

    CSV.foreach(@transaction_path, headers: true, header_converters: :symbol) do |row|
    @all << Transaction.new({:id => row[:id],
      :invoice_id => row[:invoice_id],
      :credit_card_number => row[:credit_card_number],
      :result => row[:result],
      :created_at => row[:created_at],
      :updated_at => row[:updated_at]})
    end
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

end
