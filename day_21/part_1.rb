# frozen_string_literal: true

require "set"

foods_by_allergen = Hash.new { |h, k| h[k] = [] }
all_ingredients = []
unique_ingredients = Set.new
ARGF.readlines(chomp: true).each do |line|
  ingredients, allergens = line.split(" (contains ")
  allergens = allergens.chomp(")").split(", ")
  ingredients = ingredients.split

  allergens.each do |allergen|
    foods_by_allergen[allergen] << ingredients
  end

  all_ingredients.concat ingredients
  unique_ingredients.merge ingredients
end

potential_allergens = foods_by_allergen.each_with_object(Set.new) do |(_, foods), memo|
  memo.merge(foods.reduce(:&))
end

safe_ingredients = unique_ingredients - potential_allergens
count = all_ingredients.tally.values_at(*safe_ingredients).sum

puts count
