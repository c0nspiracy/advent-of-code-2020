# frozen_string_literal: true

# Models a Node in a binary tree
class Node
  attr_accessor :token, :left, :right

  def initialize(token)
    @token = token
  end

  def leaf?
    left.nil? && right.nil?
  end

  def call
    leaf? ? token : left.call.send(token, right.call)
  end
end
