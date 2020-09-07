class Student
  attr_reader :name

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def to_s
    "#{name} is a student"
  end

  def better_grade_than?(other_student)
    grade > other_student.grade
  end

  protected

  def grade
    @grade
  end
end

joe = Student.new('joe', 80)
bob = Student.new('bob', 75)
puts joe
puts bob
puts "Well done! #{joe.name}" if joe.better_grade_than?(bob)
