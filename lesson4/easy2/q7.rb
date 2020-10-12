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

# Explain what the @@cats_count variable is and what it does.
  # This is a class variable that all instances of the Cat class have access to.
  # In fact all instances of Cat share the same copy of the @@cats_count variable.
  # This can potentially be confusing as this means all instances of Cat have
  # a paritally shared state.

  # In the Cat class each time a new cat object is created @@cats_count is 
  # incremented by 1. If three cat objects were created Cats.cats_count would 
  # return 3.

  

# Example code:
fluffy = Cat.new('tiger')
squeaks = Cat.new('calico')
rocket = Cat.new('siamese')
p Cat.cats_count
