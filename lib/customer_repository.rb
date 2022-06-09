require './deletable'
require 'CSV'
require_relative './customer'
class CustomerRepository

	include Deletable
	attr_reader :all,
              :file_path

	def initialize(file_path)
		@file_path = file_path
		@all = []
		parse_csv
	end

	def find_by_id(id)
		@all.find do |customer|
      customer.id.to_i == id
    end
	end

	def find_all_by_first_name(name_fragment)
    @all.find_all do |customer|
      customer.first_name.downcase.include?(name_fragment.downcase)
    end
  end

	def find_all_by_last_name(name_fragment)
		@all.find_all do |customer|
      customer.last_name.downcase.include?(name_fragment.downcase)
    end
	end

	def create(attribute)
    new_id = @all.last.id.to_i + 1
    new_attribute = attribute
    @all << Customer.new({
			:id => new_id.to_s,
			:first_name => new_attribute[:first_name],
			:last_name => new_attribute[:last_name],
			:created_at => Time.now,
			:updated_at => Time.now
			})
    return @all.last
  end

	def update(id, attributes)
    updated_item = find_by_id(id)
    updated_item.first_name = attributes[:first_name]
		updated_item.last_name = attributes[:last_name]
    updated_item.updated_at = Time.now
		return updated_item
  end


	def delete(id)
		removed_item = find_by_id(id)
		@all.delete(removed_item)
	end

	private

	def parse_csv
		CSV.foreach(@file_path, headers: true, header_converters: :symbol) do |row|
		@all << Customer.new({
			:id => row[:id],
			:first_name => row[:first_name],
			:last_name => row[:last_name],
			:created_at => row[:created_at],
			:updated_at => row[:updated_at]
			})
		end
	end
end
