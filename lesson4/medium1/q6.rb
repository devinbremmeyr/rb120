class Computer
  attr_accessor :template

  def create_template
    @template = 'template 14231'
  end

  def show_template
    template
  end
end

class Computer
  attr_accessor :template

  def create_template
    self.template = 'template 14231'
  end

  def show_template
    self.template
  end
end

# What is the difference in how the code works?

# For Computer#create_template the second version makes use of the setter method
# rather than setting the instance variable @template directly. It is better to 
# use the setter method if one is defined. Even if it is a minor difference at 
# this point if more functionality is added to the setter method it can be 
# unclear how other methods are influencing the instance variable.

# For Computer#show_template it is literally the same and in the second version
# the self is unnecessary.
