# frozen_string_literal: true

# Models a hexagonal tile
class Tile
  WHITE = 0
  BLACK = 1

  attr_reader :x, :y, :z, :colour

  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
    @colour = WHITE
  end

  def flip!
    if colour == WHITE
      @colour = BLACK
      1
    else
      @colour = WHITE
      -1
    end
  end
end

# Models a grid of hex tiles
class Grid
  def initialize
    @grid = {}
  end

  def [](x, y, z)
    @grid[[x, y, z]] ||= Tile.new(x, y, z)
  end

  def apply(to_flip)
    to_flip.sum do |oid|
      self[*oid].flip!
    end
  end

  def count_living_neighbours
    @grid.transform_values do |tile|
      [tile.colour, living_neighbour_count(tile)]
    end
  end

  def neighbour_of(tile, direction, auto_create: true)
    x = tile.x
    y = tile.y
    z = tile.z
    nx, ny, nz = case direction
                 when "nw" then [x + 0, y + 1, z - 1]
                 when "ne" then [x + 1, y + 0, z - 1]
                 when "w"  then [x - 1, y + 1, z + 0]
                 when "e"  then [x + 1, y - 1, z + 0]
                 when "sw" then [x - 1, y + 0, z + 1]
                 when "se" then [x + 0, y - 1, z + 1]
                 end

    if auto_create
      self[nx, ny, nz]
    else
      self[nx, ny, nz] if @grid.key?([nx, ny, nz])
    end
  end

  def living_neighbour_count(tile)
    tiles = %w[nw ne w e sw se].map do |dir|
      neighbour_of(tile, dir, auto_create: false)
    end
    tiles.compact.sum(&:colour)
  end

  def grow!
    @grid.keys.each do |key|
      vivify_neighbours_of(@grid[key])
    end
  end

  def vivify_neighbours_of(tile)
    %w[nw ne w e sw se].each do |dir|
      neighbour_of(tile, dir, auto_create: true)
    end
  end
end

instructions = ARGF.readlines(chomp: true).map { |line| line.scan(/[ns]?[ew]/) }

grid = Grid.new

black_tile_count = 0

instructions.each do |steps|
  current_tile = grid[0, 0, 0]

  steps.each do |step|
    current_tile = grid.neighbour_of(current_tile, step)
  end
  black_tile_count += current_tile.flip!
end

puts black_tile_count

days = 100
days.times do |day|
  grid.grow!
  generation = grid.count_living_neighbours

  to_flip = []
  generation.each do |k, (c, n)|
    to_flip << k if c == Tile::BLACK && (n.zero? || n > 2)
    to_flip << k if c == Tile::WHITE && n == 2
  end

  black_tile_count += grid.apply(to_flip)
  puts "Day #{day + 1}: #{black_tile_count}"
end
