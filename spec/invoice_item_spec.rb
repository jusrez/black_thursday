require "./lib/invoice_item"
require "bigdecimal"
require "Rspec"

RSpec.describe InvoiceItem do
  data = ({:id => 1,
  :item_id     => 263519844,
  :invoice_id  => 1,
  :quantity    => 5,
  :unit_price  => 13635,
  :created_at  => Time.now,
  :updated_at  => Time.now})

  invoiceitem = InvoiceItem.new(data)

  it 'exists' do
    expect(invoiceitem).to be_an_instance_of(InvoiceItem)
  end

  it "can return the details of an invoice id" do
    expect(invoiceitem.id).to eq(1)
    expect(invoiceitem.item_id).to eq(263519844)
    expect(invoiceitem.quantity).to eq(5)
    expect(invoiceitem.created_at).to be_a(Time)
    expect(invoiceitem.updated_at).to be_a(Time)
  end

  it "can return the unit price as a float" do
    expect(invoiceitem.unit_price_to_dollars).to eq(13635.0)
  end
end
