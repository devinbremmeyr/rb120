module Greet
  def greet
    puts "Hi Devin"
  end
end

class MyClass
  include Greet
end

me = MyClass.new
me.greet
