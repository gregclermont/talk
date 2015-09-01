def list_objects
  Object.constants.map { |name| Object.const_get(name) }
end

def try(object, method, default = nil)
  object.respond_to?(method) ? object.send(method) : default
end

def describe(object)
  desc = {
    name: try(object, :name),
    class: object.class.name,
    superclass: try(object, :superclass),
    included_modules: try(object, :included_modules, [])
  }

  desc[:included_modules] -= object.superclass.included_modules if desc[:superclass]

  desc
end

def color(name)
  {
    'Module' => 'blue',
    'Class' => 'black'
  }[name] || 'green'
end

def graph(objects)
  objects = objects.map { |object| describe object }

  puts 'digraph G {'

  objects.select { |o| %w(Module Class).include? o[:class] }.each do |o|
    puts %(  "#{o[:name]}" [color=#{color o[:class]}])
  end

  objects.select { |o| o[:superclass] }.each do |o|
    puts %(  "#{o[:superclass]}" -> "#{o[:name]}" [color=#{color 'Class'}])
  end

  objects.each do |o|
    o[:included_modules].each do |m|
      puts %(  "#{m}" -> "#{o[:name]}" [color=#{color 'Module'}])
    end
  end

  puts '}'
end

graph list_objects
