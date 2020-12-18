# frozen_string_literal: true

require "./node"

# Parses an arithmetic expression into a binary tree
class Parser
  def initialize(precedence = {})
    @precedence = precedence
  end

  def parse(expression)
    @op_stack = []
    @node_stack = []

    expression.each_char { |token| parse_token(token) }
    branch until no_operations_remaining?

    @node_stack.last
  end

  private

  def parse_token(token)
    case token
    when "0".."9"
      push_node token
    when "("
      push_op token
    when "*", "+"
      branch while last_operation_has_higher_priority_than?(token)
      push_op token
    when ")"
      branch while within_grouped_expression?
      @op_stack.pop # Remove the (
    end
  end

  def push_node(token)
    @node_stack.push Node.new(token.to_i)
  end

  def push_op(token)
    @op_stack.push Node.new(token)
  end

  def branch
    node = @op_stack.pop
    node.right = @node_stack.pop
    node.left = @node_stack.pop
    @node_stack.push node
  end

  def last_operation_has_higher_priority_than?(operation)
    return false if no_operations_remaining?

    within_grouped_expression? && precedence(last_operation) >= precedence(operation)
  end

  def no_operations_remaining?
    @op_stack.empty?
  end

  def within_grouped_expression?
    last_operation != "("
  end

  def last_operation
    @op_stack.last.token
  end

  def precedence(operation)
    @precedence.fetch(operation, 0)
  end
end
