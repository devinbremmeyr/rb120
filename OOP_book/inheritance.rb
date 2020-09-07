class Animal
  attr_accessor :name, :age, :sex
  def initialize(name, age, sex)
    self.name = name
    self.age = age
    self.sex = sex
  end
  def speak
    "#{self.name} says "
  end
  private

  def a_private_method
    'this is private'
  end
end

class Dog < Animal
  attr_accessor :breed
  def initialize(name, age, sex, breed)
    super(name, age, sex)
    self.breed = breed
  end
  def speak
    super + 'woof!'
  end

  def private_info
    a_private_method
  end
end

fido = Dog.new('fido', 5, 'male', 'black lab')
puts fido.private_info
puts fido.speak
p fido

