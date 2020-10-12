class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

tv = Television.new
tv.manufacturer # => NoMethodError
tv.model # => successful method call

Television.manufacturer # => successful method call
Television.model # => NoMethod Error
