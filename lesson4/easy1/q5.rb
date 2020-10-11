class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

# Pizza has an instance variable @name because it is assigned using the @ syntax

# Fruit initilize defines a local variable `name` within the initlize method.
# This `name` variable will not be accessible outside the initlize method.

apple = Fruit.new('apple')

cheese_pizza = Pizza.new('cheese')

p apple.instance_variables
p cheese_pizza.instance_variables
