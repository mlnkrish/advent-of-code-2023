# frozen_string_literal: true

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

  def to_s
    "#{@x}, #{@y}, #{@connection}"
  end
end

class Maze
  def initialize
    @pipes = {}
  end

  def add_pipe(line_no, pipe)
    if @pipes[line_no].nil?
      @pipes[line_no] = []
    end
    @pipes[line_no] << pipe
  end

  def loop_length(start)
    facing = find_viable_direction(start)
    do_loop({ y: facing[0], x: facing[1] }, 0, facing[2]) + 1
  end

  def do_loop(pos, steps, facing)
    x = pos[:x]
    y = pos[:y]
    pipe = @pipes[y][x]

    while pipe.connection != "S"
      steps = steps + 1
      next_pipe_index_and_facing = pipe.next_pipe_index_and_facing(facing)
      facing = next_pipe_index_and_facing[2]
      y = y + next_pipe_index_and_facing[1]
      x = x + next_pipe_index_and_facing[0]
      pipe = @pipes[y][x]
    end
    steps
  end

  def find_viable_direction(start)
    y = start[:y]
    x = start[:x]
    if @pipes[y - 1][x].is_pipe?
      [y - 1, x, "N"]
    elsif @pipes[y +1][x].is_pipe?
      [y + 1, x, "S"]
    elsif @pipes[y][x - 1].is_pipe?
      [y, x - 1, "W"]
    elsif @pipes[y][x + 1].is_pipe?
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
    # top left is 0,0
    start = nil
    lines.each_with_index do |line, y_index|
      line.strip.chars.each_with_index do |char, x_index|
        if char == "S"
          start = { x: x_index, y: y_index }
        end
        maze.add_pipe(y_index, Pipe.new(x_index, y_index, char))
      end
    end
    maze.loop_length(start) / 2
  end

end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts PipeMaze.new.farthest_point_in_the_loop(lines)
end

# puts "Doing problem 2"
# File.open("input-2.txt", "r") do |f|
#   lines = f.readlines
#   puts Oasis.new.predict_prev(lines)
# end
