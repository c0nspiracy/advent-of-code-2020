# frozen_string_literal: true

# Models the Handheld Game Console in AOC Quesstion 8
class GameConsole
  attr_reader :accumulator, :state

  def initialize(instructions)
    @instructions = instructions
    reset
  end

  def run(patches = {})
    @patches = patches
    reset

    loop do
      break unless @state == :ok

      execute_current_instruction
      check_state
    end
  end

  private

  def reset
    @accumulator = 0
    @instruction_pointer = 0
    @visited = {}
    @state = :ok
  end

  def execute_current_instruction
    mark_instruction_visited
    operation, argument = current_instruction
    jump = 1

    case operation
    when "acc"
      @accumulator += argument.to_i
    when "jmp"
      jump = argument.to_i
    end

    jump_relative(jump)
  end

  def check_state
    if reached_end_of_instructions?
      @state = :terminated
    elsif instruction_already_visited?
      @state = :looped
    end
  end

  def current_instruction
    @patches[@instruction_pointer] || @instructions[@instruction_pointer]
  end

  def jump_relative(offset)
    @instruction_pointer += offset
  end

  def reached_end_of_instructions?
    @instruction_pointer > @instructions.length
  end

  def instruction_already_visited?
    @visited[@instruction_pointer]
  end

  def mark_instruction_visited
    @visited[@instruction_pointer] = true
  end
end
