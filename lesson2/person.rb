class Person
  include Comparable
  attr_reader :first_name
  attr_accessor :last_name
  
  def initialize(full_name)
    parts = full_name.split
    @first_name = parts.first
    @last_name = parts.size > 1 ? parts.last : ''
  end

  def name=(full_name)
    parts = full_name.split
    @first_name = parts.first
    @last_name = parts.size > 1 ? parts.last : ''
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def to_s
    name
  end

  def <=>(other_person)
    name <=> other_person.name
  end
end

bob = Person.new('Robert Smith')
puts "The person's name is: #{bob}"


