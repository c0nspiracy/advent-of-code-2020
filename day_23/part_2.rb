# frozen_string_literal: true

moves = 10_000_000
max = 1_000_000

labels = ARGV.first.chars.map(&:to_i)
labels.concat(((labels.max + 1)..max).to_a)

cups = {}
current = { label: labels[0] }
cups[labels[0]] = current
last = current
head = current
labels[1...max].each do |label|
  node = { label: label }
  cups[label] = node
  node[:next] = head
  last[:next] = node
  last = node
end

moves.times do
  three_start = current[:next]
  three_end = three_start
  three_labels = [three_start[:label]]
  2.times do
    three_end = three_end[:next]
    three_labels << three_end[:label]
  end
  current[:next] = three_end[:next]

  dest_label = current[:label]
  loop do
    dest_label -= 1
    dest_label = max if dest_label < 1
    break unless three_labels.include?(dest_label)
  end

  dest = cups[dest_label]
  three_end[:next] = dest[:next]
  dest[:next] = three_start

  current = current[:next]
end

node = cups[1]
puts node[:next][:label] * node[:next][:next][:label]
