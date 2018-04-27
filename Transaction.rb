class Transaction

  attr_reader :date, :amount, :description
  def initialize(date, description, amount)
    @date = Time.parse(date)
    @description = description
    @amount = amount
  end

  def to_hash
    {
        date: @date,
        description: @description,
        amount: @amount
    }
  end
end
