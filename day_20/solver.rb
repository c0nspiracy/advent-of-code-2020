# frozen_string_literal: true

require "./position"

# Arranges a grid of image tiles so their adjacent borders line up
class Solver
  def initialize(tiles)
    @tiles = tiles
    @current_tile = nil
    @placed_tiles = []
    @stack = []
  end

  def solve
    loop do
      break if @placed_tiles.size == tile_count

      search_for_next_possible_tiles

      n, @current_tile = next_possible_tile
      if n < position.cell
        position.cell = n
        @placed_tiles = @placed_tiles.take(n)
      end
      @placed_tiles << @current_tile

      position.advance
    end

    @placed_tiles
  end

  private

  def next_possible_tile
    @stack.pop
  end

  def search_for_next_possible_tiles
    possible_orientations.each { |tile| @stack << [position.cell, tile] }
  end

  def possible_orientations
    all_orientations.select do |tile|
      if @placed_tiles.empty?
        # Orient tile so unique edges are on the outside of the image
        tile.unique_edge_positions == [Tile::TOP, Tile::LEFT]
      else
        next_tile_edges.all? { |position, edge| tile.edge_position(edge) == position }
      end
    end
  end

  def all_orientations
    next_tiles.flat_map(&:all_orientations)
  end

  def next_tiles
    return tiles_by_type[:corner].take(1) unless @current_tile

    tiles_by_type[next_tile_type].select do |tile|
      !@placed_tiles.include?(tile) && tile.edges?(next_tile_edges.values)
    end
  end

  def next_tile_type
    if position.on_horizontal_edge?
      position.on_vertical_edge? ? :corner : :edge
    else
      position.on_vertical_edge? ? :edge : :inside
    end
  end

  def next_tile_edges
    if position.start_of_row?
      { Tile::TOP => @placed_tiles[position.position_of_tile_above].bottom }
    else
      { Tile::LEFT => @current_tile.right }
    end
  end

  def position
    @position ||= Position.new(tile_count)
  end

  def tile_count
    @tile_count ||= @tiles.size
  end

  def tiles_by_type
    @tiles_by_type ||= @tiles.group_by(&:type)
  end
end
