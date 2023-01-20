# frozen_string_literal: true

# Models a hexagonal tile
class Tile
  WHITE = 0
  BLACK = 1

  attr_reader :colour
  attr_accessor :neighbours

  def initialize
    @colour = WHITE
    @neighbours = {}
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
    if colour == WHITE
      puts "Flipping WHITE to BLACK"
      @colour = BLACK
      1
    else
      puts "Flipping BLACK to WHITE"
      @colour = WHITE
      -1
    end
  end

  def count_black(seen = [])
    return 0 if seen.include?(object_id)

    seen << object_id
    colour + neighbours.values.sum { |neighbour| neighbour.count_black(seen) }
  end
end

instructions = ARGF.readlines(chomp: true).map { |line| line.scan(/[ns]?[ew]/) }

centre_tile = Tile.new
black_tile_count = 0

instructions.each do |steps|
  current_tile = centre_tile

  steps.each do |step|
    current_tile.create_neighbours
    current_tile.neighbours.values.each(&:create_neighbours)
    current_tile = current_tile.neighbours[step]
  end
  puts "At #{current_tile}"
  black_tile_count += current_tile.flip!
end

puts centre_tile.count_black
puts black_tile_count
