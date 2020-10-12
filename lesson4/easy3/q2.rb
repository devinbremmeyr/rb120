class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def self.hi
    puts self
  end

  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

# Change the code above to give the expected output
Hello.hi # => "Hello"
