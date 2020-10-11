# How can we access the intance variable @volume?

class Cube
  attr_reader :volume

  def initialize(volume)
    @volume = volume
  end
end

block = Cube.new(50)

p block.volume
p block.instance_variable_get("@volume")
