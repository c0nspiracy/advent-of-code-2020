# frozen_string_literal: true

program = File.readlines(ARGV.first, chomp: true)

memory = {}
bitmask = "0" * 36

def apply_floating(floating, memory, address, value)
  i = floating.shift
  off_mask = "1" * 36
  off_mask[i] = "0"
  on_mask = "0" * 36
  on_mask[i] = "1"
  off_address = address & off_mask.to_i(2)
  on_address = address | on_mask.to_i(2)

  if floating.empty?
    memory[off_address] = value
    memory[on_address] = value
  else
    apply_floating(floating.dup, memory, off_address, value)
    apply_floating(floating.dup, memory, on_address, value)
  end
end

program.each do |instruction|
  operation, value = instruction.split(" = ")
  if operation == "mask"
    bitmask = value
  else
    value = value.to_i
    address = operation.scan(/\d+/).first.to_i
    on_mask = "0" * 36
    floating = []
    bitmask.each_char.with_index do |c, i|
      case c
      when "X"
        floating << i
      when "1"
        on_mask[i] = "1"
      end
    end

    address |= on_mask.to_i(2)

    apply_floating(floating, memory, address, value)
  end
end

puts memory.values.sum
