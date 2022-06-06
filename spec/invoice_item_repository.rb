require './lib/invoice_item_repository'
require 'BigDecimal'
require CSV

Rspec.describe InvoiceItemRepository do
  it 'exists' do
    invoice_items = './data/invoice_items.csv'
    ii_repo = InvoiceItemRepository.new(invoice_items)
    expect(ii_repo).to be_a(InvoiceItemRepository)
  end

  it 'returns an array of all known InvoiceItem instances' do
    invoice_items = './data/invoice_items.csv'
    ii_repo = InvoiceItemRepository.new(invoice_items)
    expect(ii_repo.all).to be_a(Array)

    it '' do
      invoice_items = './data/invoice_items.csv'
      ii_repo = InvoiceItemRepository.new(invoice_items)
    end

    it '' do
      invoice_items = './data/invoice_items.csv'
      ii_repo = InvoiceItemRepository.new(invoice_items)
    end

    it '' do
      invoice_items = './data/invoice_items.csv'
      ii_repo = InvoiceItemRepository.new(invoice_items)
    end

    it '' do
      invoice_items = './data/invoice_items.csv'
      ii_repo = InvoiceItemRepository.new(invoice_items)
    end

    it '' do
      invoice_items = './data/invoice_items.csv'
      ii_repo = InvoiceItemRepository.new(invoice_items)
    end

    it '' do
      invoice_items = './data/invoice_items.csv'
      ii_repo = InvoiceItemRepository.new(invoice_items)
    end 
end