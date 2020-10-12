# How could you change the method name below so that the method name is more 
# clear and less repetitive?

class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.light_status
    "I have a brightness level of #{brightness} and a color of #{color}"
  end
end

# simply call Light::light_status, Light::status
# albiet the function of this method appears it should not be defined as a 
# class method and should be an instance method.
