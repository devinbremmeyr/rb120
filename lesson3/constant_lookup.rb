class A
  module B; end
end

class C < A
  class D
    Module.nesting # => [C::D, D]
    # constant lookup checks ancestors of C::D, not ancestors of C
  end
end

# NameError: uninitialized constant C::D::B

class Animal
  LEGS = 4
  def walk
    "walks on #{LEGS} legs" # call constant useing self.class::LEGS
  end
end

class Human < Animal
  LEGS = 2
end

bob = Human.new
bob.walk
