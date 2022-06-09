require_relative "./sales_engine"
require_relative "./item_repository"
require_relative "./merchant_repository"
require_relative "./invoice_repository"
require_relative "./invoice_item_repository"
require_relative "./customer_repository"
require_relative "./transaction_repository"

require "bigdecimal"
require "bigdecimal/util"
require "date"

class SalesAnalyst
	attr_reader :items, :merchants, :invoices, :invoice_items, :customers, :transactions
	def initialize(items, merchants, invoices, customers, transactions, invoice_items)
		@items = items
		@merchants = merchants
		@invoices = invoices
		@customers = customers
		@transactions = transactions
		@invoice_items = invoice_items
	end

	def average_items_per_merchant
		average_number = items.all.count.to_f / merchants.all.count.to_f
		return average_number.round(2)
	end

	def items_by_merchant
		items_per_merchant = Hash.new(0)
		merchant_ids = items.all.map {|item| item.merchant_id}
		merchant_ids.each do |id|
			items_per_merchant[id] += 1
		end
		return items_per_merchant
	end

	def average_items_per_merchant_standard_deviation
		set = items_by_merchant.values
		mean = average_items_per_merchant
    sums = set.sum { |num| (num - mean)**2 }
    std_dev = Math.sqrt(sums / (set.length - 1).to_f)
    std_dev.round(2)
	end

	def merchants_with_high_item_count
		standard_deviation = average_items_per_merchant_standard_deviation
		mean_and_standard_dev = standard_deviation + average_items_per_merchant
		merchants_with_high_sales = []
		items_by_merchant.each_pair do |merchant, items|
			merchants_with_high_sales << merchant if items > mean_and_standard_dev
		end
		return merchants_with_high_sales
	end

	def average_item_price_for_merchant(merchant_id)
		find_merchant = @items.find_all_by_merchant_id(merchant_id)
		items_sum = find_merchant.sum do |item|
			item.unit_price.to_f
		end
		(items_sum / find_merchant.count).to_d(3)
	end

	def average_average_price_per_merchant
		merchant_price_sums = []
		merchant_ids = items.all.map {|item| item.merchant_id.to_i}
		merchant_ids.each do |id|
			merchant_price_sums	<< average_item_price_for_merchant(id).to_f
		end
		(merchant_price_sums.sum / merchant_price_sums.size).to_d(3)
	end

	def standard_deviation(values, mean)
    sums = values.sum { |value| (value - mean)**2 }
    std_dev = Math.sqrt(sums / (values.length - 1).to_f)
    std_dev.round(2)
  end

	def golden_items
		array_of_all_prices = @items.all.map {|item| item.unit_price.to_i}
		set = array_of_all_prices
		mean = array_of_all_prices.sum / array_of_all_prices.size
		std_dev = standard_deviation(set, mean)
		minimum_golden_price = mean += (2 * std_dev)
		items.all.find_all{ |item| item.unit_price.to_i > minimum_golden_price }
	end

	def average_invoices_per_merchant
		(@invoices.all.size / @merchants.all.size.to_f).round(2)
	end

	def average_invoices_per_merchant_standard_deviation
		set = invoices_by_merchant.values
		avg = average_invoices_per_merchant
		standard_deviation(set, avg)
	end

	def invoices_by_merchant
		invoices_per_merchant = Hash.new(0)
		merchant_ids = invoices.all.map {|invoice| invoice.merchant_id}
		merchant_ids.each do |id|
			invoices_per_merchant[id] += 1
		end
		return invoices_per_merchant
	end

	def merchant_z_score(invoice_count)
		mean = average_invoices_per_merchant
		std_dev = average_invoices_per_merchant_standard_deviation
		z_score = (invoice_count - mean) / std_dev
		return z_score.round(2)
	end

	def merchants_by_zscore
		merchant_by_z_score = Hash.new
		invoices_by_merchant.each do |merchant, invoice_count|
			merchant_by_z_score[merchant] = merchant_z_score(invoice_count)
		end
		return merchant_by_z_score
	end

	def top_merchants_by_invoice_count
		top_merchants = []
		merchants_by_zscore.each do |merchants, zscore|
		top_merchants	<< merchants if zscore > 2
		end
		return top_merchants
	end

	def bottom_merchants_by_invoice_count
		bottom_merchants = []
		merchants_by_zscore.each do |merchants, zscore|
		bottom_merchants	<< merchants if zscore < 2
		end
		return bottom_merchants
	end

	def top_days_by_invoice_count
		top_days = []
		weekday_by_zscore.each do |day, zscore|
		top_days	<< day if zscore > 1
		end
		return top_days
	end

	def date_to_day(date)
		weekday = Date.parse(date)
		weekday_num = weekday.wday
		weekday_name = Date::DAYNAMES[weekday_num]
		return weekday_name
	end

	def invoices_by_day
		invoices_per_day = Hash.new(0)
		invoice_dates = invoices.all.map {|invoice| invoice.created_at}
		invoice_dates.each do |date|
			invoices_per_day[date_to_day(date)] += 1
		end
		return invoices_per_day
	end

	def average_invoices_per_day
	 invoices_by_day.values.sum / invoices_by_day.count
	end

	def average_invoices_per_day_standard_deviation
		set = invoices_by_day.values
		avg = average_invoices_per_day
		standard_deviation(set, avg)
	end

	def weekday_by_zscore
		day_by_z_score = Hash.new
		invoices_by_day.each do |day, invoice_count|
			day_by_z_score[day] = weekday_z_score(invoice_count)
		end
		return day_by_z_score
	end

	def weekday_z_score(invoice_count)
		mean = average_invoices_per_day
		std_dev = average_invoices_per_day_standard_deviation
		z_score = (invoice_count - mean) / std_dev
		return z_score.round(2)
	end

	def invoice_status(status)
		status_percentage = ((invoice_by_status_count[(status)].to_f / invoice_by_status_count.values.sum.to_f)*100)
		return status_percentage.round(2)
	end

	def invoice_by_status
		invoices_per_status = Hash.new
		invoices.all.each do |invoice|
			invoices_per_status[invoice.id] = invoice.status
		end
		return invoices_per_status
	end

	def invoice_by_status_count
		status_count = Hash.new(0)
		invoice_by_status.each do |id, status|
			status_count[status.to_sym] += 1
		end
		return status_count
	end

	def invoice_paid_in_full?(invoice_id)
		transaction = @transactions.find_by_id(invoice_id)
		if transaction.result == "success"
			return true
		else
			return false
		end
	end

	def invoice_total(invoice_id)
		total = 0
		invoices = @invoice_items.find_all_by_invoice_id(invoice_id)
		invoices.each do |invoice|
		total += invoice.unit_price_to_dollars
		end
		return total
	end

	def total_revenue_by_date(date)
		total_revenue = 0
		invoices_of_date = @invoice_items.all.find_all do |invoice|
			invoice.created_at[0..9] == date
		end
		invoices_of_date.each do |invoice|
			total_revenue += invoice.unit_price_to_dollars
		end
		return total_revenue
	end

	def top_revenue_earners(number_of_earners = 20)
 feat/iteration4
		top_to_bottom_merchants = merchant_revenues.sort_by{|merchant, revenue| revenue}.reverse
		top_to_bottom_merchants.first(number_of_earners)
	end


	def revenue_by_merchant(merchant_id)
		merchant_invoice_ids = @invoices.find_all_by_merchant_id(merchant_id.to_i).map{|invoice| invoice.id.to_i}
    invoice_items_by_merchant = merchant_invoice_ids.map {|invoice_id| @invoice_items.find_all_by_invoice_id(invoice_id)}.flatten!
    invoice_items_by_merchant.sum {|item| item.unit_price_to_dollars * item.quantity.to_f}
	end


	def merchant_revenues
		all_revenues = Hash.new
		merchants.all.each do |merchant|
			all_revenues[merchant.id] = revenue_by_merchant(merchant.id)
		end
		return all_revenues
	end

	def merchants_with_pending_invoices
		merchants_with_pending_invoices = []
		pending_invoices = @transactions.find_all_by_result("failed").uniq
		pending_ids = pending_invoices.map {|invoice| invoice.invoice_id}
		invoices.all.each do |invoice|
			merchants_with_pending_invoices << invoice.merchant_id if pending_ids.include?(invoice.id)
		end
		return merchants_with_pending_invoices
	end

	def merchants_with_only_one_item
		merchants_with_only_one_item = []
		items_by_merchant.select do |merchant, items|
			merchants_with_only_one_item << merchant if items == 1
		end
		return merchants_with_only_one_item

	def merchant_revenue(merchant_id)
		total_revenue = 0
		invoices.all.each do |invoice|
			if merchant_id == invoice.merchant_id #&& invoice_paid_in_full?(invoice)
				 total_revenue += ((invoice.unit_price.to_f) * invoice.quantity.to_f)
			end
		end
		return total_revenue
	end

	def merchants_with_only_one_item_registered_in_month(month_name)
    merchants_created_in_month = merchants.all.find_all{|merchant| (Date.parse(merchant.created_at)).strftime("%B") == month_name}
    merchants_created_in_month.find_all{|merchant| @items.find_all_by_merchant_id(merchant.id).count == 1}
  end

	def most_sold_item_for_merchant(merch_id)
    most_sold_items = []
    merchant_items = @items.find_all_by_merchant_id(merch_id)
    items_invoice = merchant_items.flat_map do |item|
      @invoice_items.find_all_by_item_id(item.id)
    end
    most_sold_items << items_invoice.max {|item| item.quantity.to_i}
  end



end
