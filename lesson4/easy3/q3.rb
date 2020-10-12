class AngryCat
  def initialize(age, name)
    @age = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hisssss!!!"
  end
end

grumpy_cat = AngryCat.new(10, "Grump")
enraged_cat = AngryCat.new(2, "Sparky")

grumpy_cat.name
grumpy_cat.age

enraged_cat.name
enraged_cat.age
