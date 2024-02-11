# frozen_string_literal: true

# A class for creating the adjacency list of the knight moves from a given node (square)
class AdjencyList
  attr_reader :list

  def pretty_print
    list.each_with_index do |row, i|
      row.each_with_index { |node, j| p [[i, j], node] }
    end
  end

  def get(node)
    list.dig(node[0], node[1])
  end

  private

  attr_writer :list

  def initialize
    adjajency_list = []
    8.times do |i|
      row = []
      8.times do |j|
        row << adjecent_nodes([i, j])
      end
      adjajency_list << row
    end
    self.list = adjajency_list
  end

  def adjecent_nodes(node)
    result = []
    symbol_combinations.each do |symbols|
      2.times do |i|
        2.times do |j|
          next if i == j

          x = node[0].send(symbols[0], i + 1)
          y = node[1].send(symbols[1], j + 1)
          result << [x, y] if x.between?(0, 7) && y.between?(0, 7)
        end
      end
    end
    result
  end

  def symbol_combinations
    arr = %i[+ -]
    arr.product(arr)
  end
end

LIST = AdjencyList.new
MATRIX = Array.new(8) { Array.new(8, 0) }

def visited?(node)
  MATRIX[node.first][node.last] == 1
end

def visit(node)
  MATRIX[node.first][node.last] = 1
end

def knight_moves(start, finish)
  queue = [[start, []]]
  while queue.length.positive?
    pair = queue.shift
    node = pair.first
    next if visited? node

    visit node
    path = pair.last.dup.concat([node])
    return print_path(path) if node == finish

    LIST.get(node).each { |adjecent_node| queue.concat([[adjecent_node, path]]) unless visited? adjecent_node }
  end
end

def print_path(path)
  puts "You made it in #{path.length - 1} move#{path.length - 1 == 1 ? '' : 's'}! Here's your path:"
  path.each { |node| p node }
  path
end

knight_moves([0, 0], [7, 7])
