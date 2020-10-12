# What is used in this class but doesn't add any value?

class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.information
    return "I want to turn on the light with a birghtness level of super high and a color of green"
  end
end

# attr_accessor could be attr_reader
# unncecessary explicit return in Light::information
