# frozen_string_literal: true

class Universe
  def initialize
    @space = []
    @galaxies = []
  end

  def add_entity(idx, entity)
    if @space[idx].nil?
      @space[idx] = []
    end
    @space[idx] << entity
  end

  def expand
    insert_rows_at = []
    to_insert = (0..@space[0].length - 1).map { "." }
    @space.each_with_index do |line, idx|
      if line.all? { |char| char == "." }
        insert_rows_at << idx
      end
    end
    insert_rows_at.each_with_index do |y_pos, index|
      @space.insert(y_pos + index, to_insert.dup)
    end

    insert_cols_at = []
    to_insert = (0..@space[0].length - 1).map { "." }
    (0..@space[0].length - 1).each do |idx|
      if (0..@space.length - 1).map { |idy| @space[idy][idx] }.all? { |char| char == "." }
        insert_cols_at << idx
      end
    end

    insert_cols_at.each_with_index do |x_pos, index|
      @space.each do |line|
        line.insert(x_pos + index, ".")
      end
    end
  end

  def position_galaxies
    @space.each_with_index do |line, y|
      line.each_with_index do |char, x|
        if char == "#"
          @galaxies << { x: x, y: y }
        end
      end
    end
  end

  def sum_galaxy_distances
    length = @galaxies.length
    @galaxies.each_with_index.reduce(0) do |acc, (galaxy_x, idx)|
      acc + (idx+1..length-1).reduce(0) do |lacc, galaxy_jdx|
        galaxy_y = @galaxies[galaxy_jdx]
        lacc + (galaxy_x[:x] - galaxy_y[:x]).abs + (galaxy_x[:y] - galaxy_y[:y]).abs
      end
    end
  end

  def print_space
    @space.each_with_index do |line, y|
      line.each_with_index do |char, x|
        if @galaxies.any? { |galaxy| galaxy[:x] == x && galaxy[:y] == y }
          print "*"
        else
          print "."
        end
      end
      puts ""
    end
  end
end

class CosmicExpansion
  def initialize
  end

  def sum_of_shortest_paths(lines)
    universe = Universe.new
    lines.each_with_index do |line, index|
      line.strip.chars.each do |char|
        universe.add_entity(index, char)
      end
    end
    universe.expand
    universe.position_galaxies
    # universe.print_space
    universe.sum_galaxy_distances
  end

  def tiles_within_the_loop(lines) end

end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts CosmicExpansion.new.sum_of_shortest_paths(lines)
end

# puts "Doing problem 2"
# File.open("input-2.txt", "r") do |f|
#   lines = f.readlines
#   puts PipeMaze.new.tiles_within_the_loop(lines)
# end
