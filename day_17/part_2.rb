# frozen_string_literal: true

require "./life_4d"

INACTIVE = 0
ACTIVE = 1
CYCLES = 6

DIMENSIONS = 4
DELTAS = ([-1, 0, 1].repeated_permutation(DIMENSIONS).to_a - [[0] * DIMENSIONS]).freeze

nested_universe = Hash.new do |wh, wk|
  wh[wk] = Hash.new do |zh, zk|
    zh[zk] = Hash.new do |yh, yk|
      yh[yk] = Hash.new do |xh, xk|
        xh[xk] = INACTIVE
      end
    end
  end
end

initial_state = File.readlines(ARGV.first, chomp: true)

initial_state.each_with_index do |line, y|
  line.each_char.with_index do |char, x|
    nested_universe[0][0][y][x] = char == "#" ? ACTIVE : INACTIVE
  end
end

def active_count(hash)
  hash.sum { |_, value| value.is_a?(Hash) ? active_count(value) : value }
end

life = Life4D.new(initial_state.size)

CYCLES.times do
  life.expand_universe

  changes = life.each_cube.each_with_object({}) do |(w, z, y, x), memo|
    state = nested_universe[w][z][y][x]

    active_neighbours = DELTAS.count do |wd, zd, yd, xd|
      nested_universe[w + wd][z + zd][y + yd][x + xd] == ACTIVE
    end

    case state
    when ACTIVE
      memo[[w, z, y, x]] = INACTIVE unless active_neighbours.between?(2, 3)
    when INACTIVE
      memo[[w, z, y, x]] = ACTIVE if active_neighbours == 3
    end
  end

  changes.each do |(w, z, y, x), v|
    nested_universe[w][z][y][x] = v
  end
end

puts active_count(nested_universe)
