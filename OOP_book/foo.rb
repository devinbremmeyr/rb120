class Foo
  @@class_var = 'Hello!'

  def self.read_it
    puts @@class_var
  end
end

class Bar < Foo
  @@class_var = 'world'
end

class Baz < Foo
  @@class_var = 'underworld'
end

Foo.read_it
Bar.read_it
Baz.read_it
