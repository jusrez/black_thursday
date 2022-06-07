class SalesEngine
  attr_reader :items,
              :merchants,
              :invoices,
              :analyst,
							:customers

  def initialize(items_path, merchants_path, invoices_path, customers_path)
    @items      = ItemRepository.new(items_path)
    @merchants  = MerchantRepository.new(merchants_path)
    @invoices   = InvoiceRepository.new(invoices_path)
    @analyst    = SalesAnalyst.new(items, merchants, invoices)
		@customers  = CustomerRepository.new(customers_path)
  end

  def self.from_csv(data)
    return SalesEngine.new(data[:items], data[:merchants], data[:invoices], data[:customers])
  end

end
