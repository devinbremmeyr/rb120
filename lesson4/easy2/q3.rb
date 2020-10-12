module Taste
  def flavor(flavor)
    puts "#{flavor}"
  end
end

class Orange
  include Taste
end

class HotSauce
  include Taste
end

# How do you find where Ruby will look for a method?
# => For an instance method called on an object, ruby will first look in that
# => object's class defnintion. Then up the lookup chain, first in any modules
# => included in the object's class (in reverse order they were included), then
# => ruby will look in the supercalss of the objects class, then any modules
# => included, until it reaches the end of the lookup chain.

# How do you find an objects ancestors?
# => Call Module#ancestors method on the objects class.

# What is the lookup chain for Orange and HotSauce?
p HotSauce.ancestors # => [HotSauce, Taste, Object, Kernel, BasicObject]
p Orange.ancestors # => [Oragne, Taste, Object, Kernel, BasicObject]
