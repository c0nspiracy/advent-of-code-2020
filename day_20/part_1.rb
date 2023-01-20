# frozen_string_literal: true

require "./tile"

tiles = ARGF.readlines("\n\n", chomp: true).map do |blob|
  info, *image = blob.lines(chomp: true)
  Tile.new(info[/\d+/], image.map(&:chars))
end

all_edges = tiles.flat_map(&:edges)
unique_edges = all_edges.uniq.each_with_object([]) do |edge, memo|
  count = all_edges.count do |other_edge|
    other_edge == edge || other_edge == edge.reverse
  end

  memo << edge if count == 1
end

corners = tiles.each_with_object([]) do |tile, memo|
  unique_edge_count = tile.count_edges_matching(unique_edges)

  memo << tile.id if unique_edge_count == 2
end

puts corners.inject(:*)
