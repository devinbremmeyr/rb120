class BeesWax
  attr_accessor :type

  def initlize(type)
    @type = type
  end

  def describe_type
    puts "I am a #{type} of Bees Wax"
  end
end

# added attr_accessor :type
# was able to remove the getter and setter method for @type.
# Also changed the reference to @type in the #describe_type method, to
# a call to the type getter method.
