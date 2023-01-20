# frozen_string_literal: true

foods_by_allergen = Hash.new { |h, k| h[k] = [] }
all_ingredients = []
ARGF.readlines(chomp: true).each do |line|
  ingredients, allergens = line.split(" (contains ")
  allergens = allergens.chomp(")").split(", ")
  ingredients = ingredients.split

  allergens.each do |allergen|
    foods_by_allergen[allergen] << ingredients
  end

  all_ingredients.concat ingredients
end

potential_allergens = {}
foods_by_allergen.each do |allergen, foods|
  potential_allergens[allergen] = foods.reduce(:&)
end

loop do
  break if potential_allergens.values.all?(&:one?)

  potential_allergens.select { |_, v| v.one? }.each do |allergen, (ingredient)|
    potential_allergens.each do |other_allergen, ingredients|
      next if other_allergen == allergen

      ingredients.delete(ingredient)
    end
  end
end

puts potential_allergens.sort_by(&:first).map(&:last).join(",")
