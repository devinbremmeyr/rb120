class Cat
  def initialize(type)
    @type = type
  end

  def to_s
    "I am a #{@type} cat"
  end
end

# How could we change the to_s output on this method to look like this:
# I am a tabby cat
# assuming tabby is the type

tabby = Cat.new('tabby')
puts tabby
