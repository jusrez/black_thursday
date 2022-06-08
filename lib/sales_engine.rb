class SalesEngine
  attr_reader :items,
              :merchants,
              :invoices,
              :analyst,
							:customers,
							:transactions,
							:invoice_items

  def initialize(items_path, merchants_path, invoices_path, customers_path, transactions_path, invoice_items_path)
    @items         = ItemRepository.new(items_path)
    @merchants     = MerchantRepository.new(merchants_path)
    @invoices      = InvoiceRepository.new(invoices_path)
		@customers     = CustomerRepository.new(customers_path)
		@transactions  = TransactionRepository.new(transactions_path)
		@invoice_items = InvoiceItemRepository.new(invoice_items_path)
		@analyst       = SalesAnalyst.new(items, merchants, invoices, customers, transactions, invoice_items)
  end

  def self.from_csv(data)
    return SalesEngine.new(data[:items], data[:merchants], data[:invoices], data[:customers], data[:transactions], data[:invoice_items])
  end

end
