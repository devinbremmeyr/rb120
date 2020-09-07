require 'pry'
class Vehicle
  attr_reader :speed, :year, :model, :color
  @@number_of_vehicles = 0
  def initialize(year, color, model)
    @@number_of_vehicles += 1
    @year = year
    @color = color
    @model = model
    @speed = 0
    @running = false
  end

  def self.number_of_vehicles
    @@number_of_vehicles
  end

  def self.gas_mileage(miles, gallons)
    miles / gallons
  end

  def running?
    self.running
  end

  def accelerate(speed)
    @speed += speed if @running == true
  end

  def brake(speed)
    @speed -= speed if @running == true
  end

  def start
    @running = true
  end

  def turn_off
    @running = false
  end

  def spray_paint(color)
    @color = color
  end

  def age
    calculate_age(current_year).to_s
  end

  private

  def calculate_age
    Time.now.year - self.year.to_i
  end
end

module Loadable
  def load(material)
    @bed_contents << material # probably bad form to change instance variables from module
                              # it does work though
  end
end

class MyCar < Vehicle
    NUMBER_OF_DOORS = 4
    def to_s
    "My car is a #{self.color}, #{self.year}, #{self.model}"
  end
end

class MyTruck < Vehicle
  attr_reader :bed_contents

  include Loadable
  NUMBER_OF_DOORS = 2
  def initialize(year, color, model)
    super
    @bed_contents = []
  end

  def to_s
    "My car is a #{self.color}, #{self.year}, #{self.model}"
  end
end

vibe = MyCar.new('2003', 'red', 'vibe')
ranger = MyTruck.new('1990', 'blue', 'ranger')
binding.pry
puts "BEEP BEEP"
