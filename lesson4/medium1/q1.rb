class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end

# Alyssa calims Ben forgot the @ before balance in BankAccount#positive_balance?
# Ben claims this is valid

# Who is right? Why?
# Ben is correct. Ruby will recognize balance in the context of this instance
# method as a method call to the getter method #balance.
