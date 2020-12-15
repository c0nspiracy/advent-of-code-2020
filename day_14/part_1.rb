# frozen_string_literal: true

program = File.readlines(ARGV.first, chomp: true)

memory = {}
bitmask = "0" * 36

program.each do |instruction|
  operation, value = instruction.split(" = ")

  if operation == "mask"
    bitmask = value
  else
    value = value.to_i
    address = operation.scan(/\d+/).first.to_i
    off_mask = "1" * 36
    on_mask = "0" * 36

    bitmask.each_char.with_index do |c, i|
      next if c == "X"

      if c == "0"
        off_mask[i] = "0"
      else
        on_mask[i] = "1"
      end
    end

    value &= off_mask.to_i(2)
    value |= on_mask.to_i(2)
    memory[address] = value
  end
end

puts memory.values.sum
