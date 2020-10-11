module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed
  def go_slow
    puts "I am safe and driving slow."
  end
end

small_car = Car.new
small_car.go_fast # => "I am a Car and going super fast!"

# How does the output string contain the class of small_car?
#   The Speed#go_fast method uses string interpolation on the result of calling
#   Kernel#class on `self`. In the context of this instance method `self` refers
#   to the reciever of the #go_fast method. In the case of `small_car.go_fast`,
#   `Car` will be returned by `self.class`. Finally string interpolation
#   implicitly calls #to_s on `Car` before the string can be output by puts.
#   Since `Car` is a class Class#to_s will be called which is defined by the 
#   superclass `Class` inherits from `Module`. Module#to_s will return a string
#   represntation of `Car`.
