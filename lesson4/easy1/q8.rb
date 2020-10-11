# What does `self` mean in make_one_year_older method?

class Cat
  attr_accessor :type, :age

  def initialize(type)
    @tpye = type
    @age = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

# self refers to the reciever of the Cat#make_one_year_older method.
