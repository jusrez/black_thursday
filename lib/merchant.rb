class Merchant
  attr_reader :id,
							:created_at

  attr_accessor :name

  def initialize(data)
    @id         = data[:id]
    @name       = data[:name]
		@created_at = data[:created_at]
  end
end
