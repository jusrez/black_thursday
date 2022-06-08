require './lib/merchant'

RSpec.describe Merchant do
  merchant = Merchant.new(:id => 1, :name => "Bob's Burgers")

  it "exists" do
    expect(merchant).to  be_instance_of(Merchant)
  end

  it "can return a name" do
    expect(merchant.name).to eq("Bob's Burgers")
  end

	it "can return an id" do
		expect(merchant.id).to eq(1)
	end
end
