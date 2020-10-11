class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# In the name of the cats_count method what does self mean?

# self refres to the Cat class.
# self in the method name means we are defining the cats_count method 
# on the class Cat.
# Cat:cats_count can be called from the class Cat but not by instances of the
# cat class.

fluffy = Cat.new('tiger')
p Cat.cats_count
p fluffy.cats_count # => NoMethod Error
