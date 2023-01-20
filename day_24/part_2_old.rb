# frozen_string_literal: true

$tiles = {}

# Models a hexagonal tile
class Tile
  WHITE = 0
  BLACK = 1

  attr_reader :colour
  attr_accessor :neighbours

  def initialize
    @colour = WHITE
    @neighbours = {}
    $tiles[object_id] = self
  end

  def create_neighbours
    @neighbours["nw"] ||= Tile.new
    @neighbours["ne"] ||= Tile.new
    @neighbours["e"] ||= Tile.new
    @neighbours["se"] ||= Tile.new
    @neighbours["sw"] ||= Tile.new
    @neighbours["w"] ||= Tile.new

    neighbours["nw"].set_neighbour("se", self)
    neighbours["nw"].set_neighbour("sw", neighbours["w"])
    neighbours["nw"].set_neighbour("e", neighbours["ne"])

    neighbours["ne"].set_neighbour("sw", self)
    neighbours["ne"].set_neighbour("w", neighbours["nw"])
    neighbours["ne"].set_neighbour("se", neighbours["e"])

    neighbours["e"].set_neighbour("w", self)
    neighbours["e"].set_neighbour("nw", neighbours["ne"])
    neighbours["e"].set_neighbour("sw", neighbours["se"])

    neighbours["se"].set_neighbour("nw", self)
    neighbours["se"].set_neighbour("w", neighbours["sw"])
    neighbours["se"].set_neighbour("ne", neighbours["e"])

    neighbours["sw"].set_neighbour("ne", self)
    neighbours["sw"].set_neighbour("nw", neighbours["w"])
    neighbours["sw"].set_neighbour("e", neighbours["se"])

    neighbours["w"].set_neighbour("e", self)
    neighbours["w"].set_neighbour("ne", neighbours["nw"])
    neighbours["w"].set_neighbour("se", neighbours["sw"])
  end

  def set_neighbour(position, tile)
    neighbours[position] = tile
  end

  def inspect
    "#<Tile #{object_id}: #{colour == BLACK ? 'BLACK' : 'WHITE'}, neighbours at #{neighbours.keys.join(', ')}>"
  end

  def flip!
    # @colour = colour == WHITE ? BLACK : WHITE
    create_neighbours
    neighbours.values.each(&:create_neighbours)
    if colour == WHITE
      #puts "Flipping WHITE to BLACK"
      @colour = BLACK
      1
    else
      #puts "Flipping BLACK to WHITE"
      @colour = WHITE
      -1
    end
  end

  # def apply(to_flip, seen = [])
  #   return 0 if seen.include?(object_id)
  #
  #   seen << object_id
  #   ret = if to_flip.include?(object_id)
  #           to_flip.delete(object_id)
  #           flip!
  #         else
  #           0
  #         end
  #
  #   ret + neighbours.values.sum { |neighbour| neighbour.apply(to_flip, seen) }
  # end

  def count_black(seen = [])
    return 0 if seen.include?(object_id)

    seen << object_id
    colour + neighbours.values.sum { |neighbour| neighbour.count_black(seen) }
  end

  # def count_living_neighbours(seen = [], created = [])
  #   return {} if seen.include?(object_id)
  #
  #   unless created.include?(object_id)
  #     existing_neighbours = neighbours.keys
  #     create_neighbours
  #     created.concat neighbours.slice(*(neighbours.keys - existing_neighbours)).values.map(&:object_id)
  #   end
  #
  #   ret = {
  #     object_id => [colour, neighbours.values.sum(&:colour)]
  #   }
  #
  #   seen << object_id
  #
  #   ret.merge!(
  #     neighbours.values.map { |n| n.count_living_neighbours(seen, created) }.reduce(&:merge)
  #   )
  #
  #   ret
  # end
end

def count_living_neighbours
  $tiles.keys.map { |oid|
    tile = $tiles[oid]
    tile.create_neighbours
    tile.neighbours.values.each(&:create_neighbours)
    [oid, [tile.colour, tile.neighbours.values.sum(&:colour)]]
  }.to_h
end

def apply(to_flip)
  to_flip.sum do |oid|
    $tiles[oid].flip!
  end
end

instructions = ARGF.readlines(chomp: true).map { |line| line.scan(/[ns]?[ew]/) }

centre_tile = Tile.new
centre_tile.create_neighbours

black_tile_count = 0

instructions.each do |steps|
  current_tile = centre_tile

  steps.each do |step|
    current_tile.create_neighbours
    current_tile.neighbours.values.each(&:create_neighbours)
    current_tile = current_tile.neighbours[step]
  end
  black_tile_count += current_tile.flip!
end

puts centre_tile.count_black
puts black_tile_count

days = 100
days.times do |day|
  generation = count_living_neighbours

  to_flip = []
  generation.each do |k, (c, n)|
    to_flip << k if c == Tile::BLACK && (n.zero? || n > 2)
    to_flip << k if c == Tile::WHITE && n == 2
  end

  black_tile_count += apply(to_flip)
  puts "Day #{day + 1}: #{black_tile_count}"
end
