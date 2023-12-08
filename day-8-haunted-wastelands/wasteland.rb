# frozen_string_literal: true

class Node
  def initialize(id, left, right)
    @id = id
    @left = left
    @right = right
  end

  def to_s
    "#{@id} => L:#{@left} R:#{@right}"
  end

  def id
    @id
  end

  def left
    @left
  end

  def right
    @right
  end
end

class Graph
  def initialize
    @nodes = {}
  end

  def add_node(node)
    @nodes[node.id] = node
  end

  def steps_to(start, finish, instructions)
    count = 0
    current_node = @nodes[start]
    instructions.chars.cycle do |i|
      count = count + 1
      if i == "R"
        current_node = @nodes[current_node.right]
      elsif i == "L"
        current_node = @nodes[current_node.left]
      end
      if current_node.id == finish
        return count
      end
    end
  end

  def to_s
    @nodes.each do |id, node|
      puts node
    end
  end
end

class Wasteland
  def initialize
  end

  def steps_to_end(lines)
    instructions = lines[0].strip
    graph_desc = lines[2..lines.length]
    graph = Graph.new
    graph_desc.each do |line|
      line_split = line.split(" = ")
      id = line_split[0]
      lr_split = line_split[1][1..8].split(", ")
      left = lr_split[0]
      right = lr_split[1]
      graph.add_node(Node.new(id, left, right))
    end
    graph.steps_to("AAA", "ZZZ", instructions)
  end

end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts Wasteland.new.steps_to_end(lines)
end

# puts "Doing problem 2"
# File.open("input-2.txt", "r") do |f|
#   lines = f.readlines
#   puts CamelCards.new.rank_and_bid_with_jokers(lines)
# end
