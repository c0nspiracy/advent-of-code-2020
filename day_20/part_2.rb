# frozen_string_literal: true

require "./tile"
require "./solver"

tiles = ARGF.readlines("\n\n", chomp: true).map do |blob|
  info, *image = blob.lines(chomp: true)
  Tile.new(info[/\d+/], image.map(&:chars))
end

image_size = Math.sqrt(tiles.size).to_i

all_edges = tiles.flat_map(&:edges)
all_unique_edges = all_edges.uniq.each_with_object([]) do |edge, memo|
  count = all_edges.count do |other_edge|
    other_edge == edge || other_edge == edge.reverse
  end

  memo << edge if count == 1
end

tiles.each { |tile| tile.assign_unique_edges(all_unique_edges) }

solver = Solver.new(tiles)
placed_tiles = solver.solve

## Remove the edges
final_image = []

(0...image_size).each do |y|
  image_row = nil

  (0...image_size).each do |x|
    pos = (y * image_size) + x
    image = placed_tiles[pos].image

    clipped_image = image[1..-2].map { |line| line[1..-2] }
    if image_row
      clipped_image.each_with_index { |line, i| image_row[i].concat line }
    else
      image_row = clipped_image
    end
  end

  final_image.concat image_row
end

sea_monster = [
  /(?=..................#.)/,
  /(?=#....##....##....###)/,
  /(?=.#..#..#..#..#..#...)/
]

final_tile = Tile.new(0, final_image)

sea_monster_pixels = final_tile.all_orientations.sum do |tile|
  tile.image.each_cons(3).sum do |lines|
    matches = lines.map.with_index do |line, i|
      line.join.to_enum(:scan, sea_monster[i]).map { Regexp.last_match.offset(0)[0] }
    end

    15 * matches.compact.reduce(:&).size
  end
end

roughness = final_image.join.count("#")
puts roughness - sea_monster_pixels
