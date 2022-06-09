require "./lib/sales_engine"
require "./lib/item_repository"
require "./lib/merchant_repository"
require "./lib/invoice_repository"
require "./lib/transaction_repository"
require "./lib/customer_repository"
require "./lib/invoice_item_repository"
require "./lib/sales_analyst"

RSpec.describe SalesEngine do

  sales_engine = SalesEngine.from_csv({
		:items         => "./data/items.csv",
		:merchants     => "./data/merchants.csv",
		:invoices      => "./data/invoices.csv",
		:customers     => "./data/customers.csv",
		:transactions  => "./data/transactions.csv",
		:invoice_items => "./data/invoice_items.csv"})

  it "exists" do
    expect(sales_engine).to be_instance_of SalesEngine
  end

  it "can return an array of all items" do
    expect(sales_engine.items).to be_instance_of ItemRepository
  end

  it "can return an array of all merchants" do
    expect(sales_engine.merchants).to be_instance_of MerchantRepository
  end

  it "can return an array of all invoices" do
    expect(sales_engine.invoices).to be_instance_of InvoiceRepository
  end
end
