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

  def make_graph
    @nodes.each do |id, node|
      left_node = @nodes[node.left]
      right_node = @nodes[node.right]
      node.set_left_node_and_right_node(left_node, right_node)
    end
  end

  def steps_to(start, finish, instructions)
    count = 0
    index = 0
    current_node = @nodes[start]
    visited = {}
    while true
      remaining_instructions = instructions[index..instructions.length-1]

      if !visited[current_node.id].nil? && visited[current_node.id].include?(remaining_instructions)
        return nil
      end
      if visited[current_node.id].nil?
        visited[current_node.id] = []
      end
      visited[current_node.id] << remaining_instructions

      i = instructions[index]
      count = count + 1
      if i == "R"
        current_node = @nodes[current_node.right]
      elsif i == "L"
        current_node = @nodes[current_node.left]
      end
      if current_node.id == finish
        return count
      end
      index = (index + 1) % instructions.length
    end
  end

  def steps_to_as_ghost(start_nodes, end_nodes, instructions)
    finishes = start_nodes.map do |n|
      end_nodes.map do |e|
        steps_to(n, e, instructions)
      end
    end
    puts "finishes: #{finishes}"
    # I SAW THAT THERE IS ONLY ONE PATH FROM START TO FINISH FOR EACH PAIR OF START AND FINISH
    finishes.flatten.compact.inject(:lcm)
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

  def steps_to_end_as_a_ghost(lines)
    instructions = lines[0].strip
    graph_desc = lines[2..lines.length]
    start_nodes = []
    end_nodes = []
    graph = Graph.new
    graph_desc.each do |line|
      line_split = line.split(" = ")
      id = line_split[0]
      lr_split = line_split[1][1..8].split(", ")
      left = lr_split[0]
      right = lr_split[1]
      start_nodes << id if id[-1] == "A"
      end_nodes << id if id[-1] == "Z"
      graph.add_node(Node.new(id, left, right))
    end
    graph.steps_to_as_ghost(start_nodes, end_nodes, instructions)
  end
end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts Wasteland.new.steps_to_end(lines)
end

puts "Doing problem 2"
File.open("input-2.txt", "r") do |f|
  lines = f.readlines
  puts Wasteland.new.steps_to_end_as_a_ghost(lines)
end
