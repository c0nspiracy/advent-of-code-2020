# frozen_string_literal: true

# Models an image tile
class Tile
  TOP = 0
  RIGHT = 1
  BOTTOM = 2
  LEFT = 3

  attr_reader :id, :image, :unique_edges

  def initialize(id, image, unique_edges = [])
    @id = id.to_i
    @image = image
    @unique_edges = unique_edges
  end

  def ==(other)
    id == other.id
  end

  def type
    case unique_edges.count
    when 2 then :corner
    when 1 then :edge
    else :inside
    end
  end

  def unique_edge_positions
    matching_edges = edges.select do |edge|
      unique_edges.include?(edge) || unique_edges.include?(edge.reverse)
    end

    matching_edges.map do |edge|
      edges.index(edge) || edges.index(edge.reverse)
    end
  end

  def edges?(other_edges)
    other_edges.all? { |other_edge| edge?(other_edge) }
  end

  def edge?(other_edge)
    edges.include?(other_edge) || edges.include?(other_edge.reverse)
  end

  def edge_position(edge)
    edges.index(edge) || -edges.index(edge.reverse)
  end

  def all_orientations
    [%i[itself rotate rotate rotate], %i[flip_horizontal rotate rotate rotate]].flat_map do |orientations|
      base_tile = self
      orientations.map { |method| base_tile = base_tile.send(method) }
    end
  end

  def top
    edges[0]
  end

  def right
    edges[1]
  end

  def bottom
    edges[2]
  end

  def left
    edges[3]
  end

  def edges
    @edges ||= [
      image.first.join,
      transposed_image.last.join,
      image.last.join,
      transposed_image.first.join
    ]
  end

  def flip_horizontal
    Tile.new(id, image.map(&:reverse), unique_edges)
  end

  def rotate
    Tile.new(id, transposed_image.map(&:reverse), unique_edges)
  end

  def assign_unique_edges(all_unique_edges)
    @unique_edges = edges.select { |edge| all_unique_edges.include?(edge) }
  end

  def to_s
    "Tile #{id}:\n#{image.map(&:join).join("\n")}"
  end

  def inspect
    "#<Tile #{id} (#{type})>"
  end

  private

  def transposed_image
    @transposed_image ||= image.transpose
  end
end
