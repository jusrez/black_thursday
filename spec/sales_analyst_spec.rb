require "./lib/sales_engine"
require "./lib/item_repository"
require "./lib/merchant_repository"
require "./lib/invoice_repository"
require "./lib/transaction_repository"
require "./lib/customer_repository"
require "./lib/invoice_item_repository"
require "./lib/sales_analyst"

RSpec.describe SalesAnalyst do

	sales_engine = SalesEngine.from_csv({
		:items         => "./data/items.csv",
		:merchants     => "./data/merchants.csv",
		:invoices      => "./data/invoices.csv",
		:customers     => "./data/customers.csv",
		:transactions  => "./data/transactions.csv",
		:invoice_items => "./data/invoice_items.csv"})

	sales_analyst = sales_engine.analyst

	it 'exists' do
		expect(sales_analyst).to be_an_instance_of(SalesAnalyst)
	end

	it 'can return the average items per merchant' do
		expect(sales_analyst.average_items_per_merchant).to eq(2.88)
	end

	it 'can return the standard deviation of average items per merchant' do
		expect(sales_analyst.average_items_per_merchant_standard_deviation).to eq(3.26)
	end

	it 'can display the merchants who have the most items for sale' do
		expect(sales_analyst.merchants_with_high_item_count).to be_a(Array)
		# 52 was the length of our merchants_with_high_sales array
		expect(sales_analyst.merchants_with_high_item_count.count).to eq(52)
	end

	it 'can return average price of a merchants items' do
		expect(sales_analyst.average_item_price_for_merchant(12334159)).to be_a(BigDecimal)
		expect(sales_analyst.average_item_price_for_merchant(12334159)).to eq(3150.0)
	end

	it 'can return average of the average price per merchant' do
		expect(sales_analyst.average_average_price_per_merchant).to be_a(BigDecimal)
		expect(sales_analyst.average_average_price_per_merchant).to eq(0.251e5) #(25108.91441111924)
	end

	it "can return a standard deviation" do
		expect(sales_analyst.standard_deviation([1, 2 ,3], 2)).to eq(1)
	end

	it 'can return the golden items' do
		expect(sales_analyst.golden_items).to be_a(Array)
	end

	it 'can average invoices per merchant' do
		expect(sales_analyst.average_invoices_per_merchant).to eq(10.49)
	end

	it 'can return standard deviation of average invoices per merchant' do
		expect(sales_analyst.average_invoices_per_merchant_standard_deviation).to eq(3.29)
	end

	it 'can calculate zscore for a merchant' do
		expect(sales_analyst.merchant_z_score(4)).to eq(-1.97)
	end

	it 'can create a hash of merchants by zscore' do
		expect(sales_analyst.merchants_by_zscore.keys.include?("12334753")).to eq(true)
		expect(sales_analyst.merchants_by_zscore.values.include?(1.37)).to eq(true)
		expect(sales_analyst.merchants_by_zscore["12334753"]).to eq(1.37)
	end

	it 'can return the top performing merchants by invoice count' do
		expect(sales_analyst.top_merchants_by_invoice_count.length).to eq(12)
	end

	it 'can return the bottom performing merchants by invoice count' do
		expect(sales_analyst.bottom_merchants_by_invoice_count.length).to eq(463)
	end

	it 'can return the days of the week that see the most sales' do
		expect(sales_analyst.top_days_by_invoice_count).to eq(["Wednesday"])
	end

	it 'can return the day of the week' do
		expect(sales_analyst.date_to_day("2009-02-07")).to eq("Saturday")
	end

	it 'can return the invoices by day of the week' do
		expect(sales_analyst.invoices_by_day.values.count).to eq(7)
	end

	it 'can return the average invoices per day' do
		expect(sales_analyst.average_invoices_per_day).to eq(712)
	end

	it 'can return the average invoices per day standard deviation' do
		expect(sales_analyst.average_invoices_per_day_standard_deviation).to eq(18.07)
	end

	it 'can calculate z score for a day of the week' do
		expect(sales_analyst.weekday_by_zscore.keys.include?("Saturday")).to eq(true)
		expect(sales_analyst.weekday_by_zscore.values[0].class).to eq(Float)
	end

	it 'can return the percentage of invoices by status' do
		expect(sales_analyst.invoice_status(:pending)).to eq(29.55)
		expect(sales_analyst.invoice_status(:shipped)).to eq(56.95)
		expect(sales_analyst.invoice_status(:returned)).to eq(13.5)
	end

	it 'will return true or false if an invoice is paid in full' do
		expect(sales_analyst.invoice_paid_in_full?(2179)).to eq(true)
	end

	it 'will return the total dollar amount of an invoice' do
		expect(sales_analyst.invoice_total(2179)).to eq(518497.0)
	end

	it 'will return the total revenue by date' do
		expect(sales_analyst.total_revenue_by_date("2009-12-17")).to eq(13635)
		expect(sales_analyst.total_revenue_by_date("2009-12-09")).to eq(13635)
	end

	it 'can find the top_revenue_earners' do
		expect(sales_analyst.revenue_by_merchant(12334160)).to be_a(Float)
		# expect(sales_analyst.top_revenue_earners.count).to eq(20)
		# expect(sales_analyst.top_revenue_earners(5).count).to eq(5)
	end

	it 'can find merchants with pending invoices' do

		expect(sales_analyst.merchants_with_pending_invoices).to be_a(Array)
		expect(sales_analyst.merchants_with_pending_invoices.count).to eq(768)
	end

	it 'can find merchants with only one item' do
		expect(sales_analyst.merchants_with_only_one_item).to be_a(Array)
		expect(sales_analyst.merchants_with_only_one_item.count).to eq(243)
	end

	xit 'can find merchants that only sell one item by the month they registered' do
		expect(sales_analyst.merchants_with_only_one_item_registered_in_month("February").count).to eq(19)
	end

	it 'can return the revenue by merchant' do
		expect(sales_analyst.revenue_by_merchant(12334160)).to be_a(Float)
		expect(sales_analyst.revenue_by_merchant(12334160)).to eq(13598206.0)
	end

	it 'can return the most sold item for a given merchant' do
		expect(sales_analyst.most_sold_item_for_merchant(12334160)[0]).to be_a(InvoiceItem)
	end
end
