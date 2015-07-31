constants = Object.constants
  .map { |name| Object.const_get(name) }
  .select { |object| object.respond_to?(:ancestors) }

ancestors = {}

constants.each do |object|
  ancestors[object] = object.ancestors - [object]
end

relations = []

ancestors.each do |object, object_ancestors|
  ancestors_ancestors = object_ancestors.flat_map { |ancestor| ancestors[ancestor] }
  object_ancestors -= ancestors_ancestors
  object_ancestors.each do |ancestor|
    relations.push [object, ancestor]
  end
end

puts 'digraph G {'
relations.each { |object, ancestor| puts %(  "#{ancestor}" -> "#{object}") }
puts '}'
