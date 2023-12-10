# frozen_string_literal: true
class String
  def black
    "\e[30m#{self}\e[0m"
  end

  def red
    "\e[31m#{self}\e[0m"
  end

  def green
    "\e[32m#{self}\e[0m"
  end

  def brown
    "\e[33m#{self}\e[0m"
  end

  def blue
    "\e[34m#{self}\e[0m"
  end

  def magenta
    "\e[35m#{self}\e[0m"
  end

  def cyan
    "\e[36m#{self}\e[0m"
  end

  def gray
    "\e[37m#{self}\e[0m"
  end

  def bg_black
    "\e[40m#{self}\e[0m"
  end

  def bg_red
    "\e[41m#{self}\e[0m"
  end

  def bg_green
    "\e[42m#{self}\e[0m"
  end

  def bg_brown
    "\e[43m#{self}\e[0m"
  end

  def bg_blue
    "\e[44m#{self}\e[0m"
  end

  def bg_magenta
    "\e[45m#{self}\e[0m"
  end

  def bg_cyan
    "\e[46m#{self}\e[0m"
  end

  def bg_gray
    "\e[47m#{self}\e[0m"
  end

  def bold
    "\e[1m#{self}\e[22m"
  end

  def italic
    "\e[3m#{self}\e[23m"
  end

  def underline
    "\e[4m#{self}\e[24m"
  end

  def blink
    "\e[5m#{self}\e[25m"
  end

  def reverse_color
    "\e[7m#{self}\e[27m"
  end
end

class Pipe
  @@facing_map = {
    "|" => { "N" => [0, -1, "N"], "S" => [0, 1, "S"] },
    "-" => { "E" => [1, 0, "E"], "W" => [-1, 0, "W"] },
    "L" => { "S" => [1, 0, "E"], "W" => [0, -1, "N"] },
    "7" => { "E" => [0, 1, "S"], "N" => [-1, 0, "W"] },
    "F" => { "W" => [0, 1, "S"], "N" => [1, 0, "E"] },
    "J" => { "S" => [-1, 0, "W"], "E" => [0, -1, "N"] },
  }

  def initialize(x, y, connection)
    @x = x
    @y = y
    @connection = connection
    @is_within_loop = true
    @is_part_of_loop = false
  end

  def x
    @x
  end

  def y
    @y
  end

  def connection
    @connection
  end

  def next_pipe_index_and_facing(facing)
    @@facing_map[@connection][facing]
  end

  def is_pipe?
    @connection != "." && @connection != "S"
  end

  def is_symbol?
    ["F", "L", "J", "7"].include?(@connection)
  end

  def is_part_of_loop?
    @is_part_of_loop
  end

  def set_part_of_loop
    @is_part_of_loop = true
  end

  def horizontal_block?(prev_symbol, p, n)
    if connection == "J"
      return %w[F].include?(prev_symbol.connection) && %w[F L -].include?(n.connection)
    end
    if connection == "7"
      return %w[L].include?(prev_symbol.connection) && %w[L F -].include?(n.connection)
    end
    if connection == "L"
      return %w[7].include?(prev_symbol.connection) && %w[7 J -].include?(n.connection)
    end
    if connection == "F"
      return %w[J].include?(prev_symbol.connection) && %w[J 7 -].include?(n.connection)
    end
  end

  def vertical_block?(prev_symbol, p, n)
    if connection == "J"
      return %w[F].include?(prev_symbol.connection) && %w[F 7 |].include?(n.connection)
    end
    if connection == "7"
      return %w[L].include?(prev_symbol.connection) && %w[L J |].include?(n.connection)
    end
    if connection == "L"
      return %w[7].include?(prev_symbol.connection) && %w[7 F |].include?(n.connection)
    end
    if connection == "F"
      return %w[J].include?(prev_symbol.connection) && %w[J L |].include?(n.connection)
    end
  end

  def to_s
    "x:#{@x} y:#{@y} c:#{@connection}"
  end

  def set_connection(connection)
    @connection = connection
  end

  def set_out_of_loop
    @is_within_loop = false
  end

  def is_within_loop?
    @is_within_loop
  end
end

class Maze
  def initialize
    @pipes = []
    @loop = []
  end

  def loop
    @loop
  end

  def add_pipe(line_no, pipe)
    if @pipes[line_no].nil?
      @pipes[line_no] = []
    end
    @pipes[line_no] << pipe
    @left_bounds = {}
    @right_bounds = {}
    @top_bounds = {}
    @bottom_bounds = {}
  end

  def print_bounds
    puts "Left bounds"
    @left_bounds.keys.sort.each do |key|
      puts "y: #{key}, #{@left_bounds[key]}"
    end

    puts "Right bounds"
    @right_bounds.keys.sort.each do |key|
      puts "y: #{key}, #{@right_bounds[key]}"
    end

    puts "Top bounds"
    @top_bounds.keys.sort.each do |key|
      puts "x: #{key}, #{@top_bounds[key]}"
    end

    puts "Bottom bounds"
    @bottom_bounds.keys.sort.each do |key|
      puts "x: #{key}, #{@bottom_bounds[key]}"
    end
  end

  def print_loop(start)
    @pipes.each_with_index do |pipes, y|
      pipes.each_with_index do |pipe, x|
        # if @loop.include?(pipe)
        #   if pipe.x == start[:x] && pipe.y == start[:y]
        #     print " #{pipe.connection} ".green.bg_magenta
        #   else
        #     print " #{pipe.connection} ".bold
        #   end
        # else
        #   print " #{pipe.connection} "
        # end
        if @left_bounds[y] == x
          print " #{pipe.connection} ".bg_red
        elsif @right_bounds[y] == x
          print " #{pipe.connection} ".bg_red
        elsif @top_bounds[x] == y
          print " #{pipe.connection} ".bg_blue
        elsif @bottom_bounds[x] == y
          print " #{pipe.connection} ".bg_blue
        else
          if pipe.is_part_of_loop?
            print " #{pipe.connection} ".magenta
          elsif pipe.is_within_loop?
            print " #{pipe.connection} ".bg_green
          else
            print " #{pipe.connection} ".bg_brown
          end
        end
      end
      puts ""
    end
  end

  def make_loop(start)
    @loop << @pipes[start[:y]][start[:x]]
    facing = find_viable_direction(start)
    final_facing = do_loop({ y: facing[0], x: facing[1] }, facing[2])
    finish = loop[1]
    start = loop[-1]

    if final_facing == "E"
      if finish.y == start.y
        @loop[0].set_connection("-")
      end
      if finish.y < start.y
        @loop[0].set_connection("J")
      end
      if finish.y > start.y
        @loop[0].set_connection("7")
      end
    end

    if final_facing == "W"
      if finish.y == start.y
        @loop[0].set_connection("-")
      end
      if finish.y < start.y
        @loop[0].set_connection("L")
      end
      if finish.y > start.y
        @loop[0].set_connection("F")
      end
    end

    if final_facing == "N"
      if finish.x == start.x
        @loop[0].set_connection("|")
      end
      if finish.x < start.x
        @loop[0].set_connection("F")
      end
      if finish.x > start.x
        @loop[0].set_connection("7")
      end
    end

    if final_facing == "S"
      if finish.x == start.x
        @loop[0].set_connection("|")
      end
      if finish.x < start.x
        @loop[0].set_connection("L")
      end
      if finish.x > start.x
        @loop[0].set_connection("J")
      end
    end

    prev_symbol = @loop.reverse.find { |p| p.is_symbol? }
    @loop.each_with_index do |pipe, index|
      add_to_bounds(prev_symbol, pipe, @loop[index - 1], @loop[(index + 1) % loop.length])
      if pipe.is_symbol?
        prev_symbol = pipe
      end
    end
  end

  def tiles_within_the_loop
    @loop.each do |pipe|
      pipe.set_part_of_loop
      pipe.set_out_of_loop
    end

    horizontal_connected = [[]]
    vertical_connected = [[]]
    @pipes.each_with_index do |pipes, y|

      pipes.each do |pipe|
        if pipe.is_part_of_loop?
          horizontal_connected << []
        else
          horizontal_connected.last << pipe
        end
      end
      horizontal_connected.each do |connected_pipes|
        unbound = connected_pipes.any? do |pipe|
          !is_bound_on_top?(pipe.x, pipe.y) || !is_bound_on_bottom?(pipe.x, pipe.y) || !is_bound_on_left?(pipe.x, pipe.y) || !is_bound_on_right?(pipe.x, pipe.y)
        end
        if unbound
          connected_pipes.each do |pipe|
            pipe.set_out_of_loop
          end
        end
      end
    end

    (0..@pipes[0].length - 1).each do |x|
      (0..@pipes.length - 1).each do |y|
        pipe = @pipes[y][x]
        if pipe.is_part_of_loop?
          vertical_connected << []
        else
          vertical_connected.last << pipe
        end
      end
      vertical_connected.each do |connected_pipes|
        unbound = connected_pipes.any? do |pipe|
          !is_bound_on_left?(pipe.x, pipe.y) || !is_bound_on_right?(pipe.x, pipe.y) || !is_bound_on_top?(pipe.x, pipe.y) || !is_bound_on_bottom?(pipe.x, pipe.y)
        end
        if unbound
          connected_pipes.each do |pipe|
            pipe.set_out_of_loop
          end
        end
      end
    end

    # 50000.times do
    #   horizontal_connected.each do |connected_pipes|
    #     unbound = connected_pipes.any? do |pipe|
    #       !pipe.is_within_loop?
    #     end
    #     if unbound
    #       connected_pipes.each do |pipe|
    #         pipe.set_out_of_loop
    #       end
    #     end
    #   end
    #
    #   vertical_connected.each do |connected_pipes|
    #     unbound = connected_pipes.any? do |pipe|
    #       !pipe.is_within_loop?
    #     end
    #     if unbound
    #       connected_pipes.each do |pipe|
    #         pipe.set_out_of_loop
    #       end
    #     end
    #   end
    # end

    @pipes.reduce(0) do |acc, pipes|
      acc + pipes.reduce(0) do |lacc, pipe|
        if pipe.is_within_loop?
          lacc + 1
        else
          lacc
        end
      end
    end
  end

  private

  def is_bound_on_left?(x, y)
    @left_bounds[y].nil? || @left_bounds[y] < x
  end

  def is_bound_on_right?(x, y)
    @right_bounds[y].nil? || @right_bounds[y] > x
  end

  def is_bound_on_top?(x, y)
    @top_bounds[x].nil? || @top_bounds[x] < y
  end

  def is_bound_on_bottom?(x, y)
    @bottom_bounds[x].nil? || @bottom_bounds[x] > y
  end

  def do_loop(pos, facing)
    x = pos[:x]
    y = pos[:y]
    pipe = @pipes[y][x]

    while pipe.connection != "S"
      @loop << pipe

      next_pipe_index_and_facing = pipe.next_pipe_index_and_facing(facing)
      facing = next_pipe_index_and_facing[2]
      y = y + next_pipe_index_and_facing[1]
      x = x + next_pipe_index_and_facing[0]
      pipe = @pipes[y][x]
    end

    facing
  end

  def add_to_bounds(prev_symbol, pipe, p, n)
    x = pipe.x
    y = pipe.y

    if pipe.connection == "|" || pipe.vertical_block?(prev_symbol, p, n)
      if @left_bounds[y].nil? || @left_bounds[y] > x
        @left_bounds[y] = x
      end
    end

    if pipe.connection == "|" || pipe.vertical_block?(prev_symbol, p, n)
      if @right_bounds[y].nil? || @right_bounds[y] < x
        @right_bounds[y] = x
      end
    end

    if pipe.connection == "-" || pipe.horizontal_block?(prev_symbol, p, n)
      if @top_bounds[x].nil? || @top_bounds[x] > y
        @top_bounds[x] = y
      end
    end

    if pipe.connection == "-" || pipe.horizontal_block?(prev_symbol, p, n)
      if @bottom_bounds[x].nil? || @bottom_bounds[x] < y
        @bottom_bounds[x] = y
      end
    end
  end

  def find_viable_direction(start)
    y = start[:y]
    x = start[:x]
    if @pipes[y - 1][x].is_pipe? && %w[| 7 F].include?(@pipes[y - 1][x].connection)
      [y - 1, x, "N"]
    elsif @pipes[y +1][x].is_pipe? && %w[| L J].include?(@pipes[y + 1][x].connection)
      [y + 1, x, "S"]
    elsif @pipes[y][x - 1].is_pipe? && %w[- F L].include?(@pipes[y][x - 1].connection)
      [y, x - 1, "W"]
    elsif @pipes[y][x + 1].is_pipe? && %w[- J 7].include?(@pipes[y][x + 1].connection)
      [y, x + 1, "E"]
    else
      raise "No viable direction"
    end
  end
end

class PipeMaze
  def initialize
  end

  def farthest_point_in_the_loop(lines)
    maze = Maze.new
    start = nil
    lines.each_with_index do |line, y_index|
      line.strip.chars.each_with_index do |char, x_index|
        if char == "S"
          start = { x: x_index, y: y_index }
        end
        maze.add_pipe(y_index, Pipe.new(x_index, y_index, char))
      end
    end
    maze.make_loop(start)
    maze.loop.length / 2
  end

  def tiles_within_the_loop(lines)
    maze = Maze.new
    start = nil
    lines.each_with_index do |line, y_index|
      line.strip.chars.each_with_index do |char, x_index|
        if char == "S"
          start = { x: x_index, y: y_index }
        end
        maze.add_pipe(y_index, Pipe.new(x_index, y_index, char))
      end
    end
    maze.make_loop(start)
    # maze.print_bounds
    xx = maze.tiles_within_the_loop
    maze.print_loop(start)
    xx
  end

end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts PipeMaze.new.farthest_point_in_the_loop(lines)
end

puts "Doing problem 2"
File.open("input-2.txt", "r") do |f|
  lines = f.readlines
  puts PipeMaze.new.tiles_within_the_loop(lines)
end
