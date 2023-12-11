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

  def expand_by(n)
    insert_rows_at = []
    @space.each_with_index do |line, idx|
      if line.all? { |char| char == "." }
        insert_rows_at << idx
      end
    end
    insert_rows_at.map { |y_pos| @galaxies.select { |galaxy| galaxy[:y] > y_pos } }.flatten.each do |galaxy|
      galaxy[:y] = galaxy[:y] + n
    end

    insert_cols_at = []
    (0..@space[0].length - 1).each do |idx|
      if (0..@space.length - 1).map { |idy| @space[idy][idx] }.all? { |char| char == "." }
        insert_cols_at << idx
      end
    end

    insert_cols_at.map { |x_pos| @galaxies.select { |galaxy| galaxy[:x] > x_pos } }.flatten.each do |galaxy|
      galaxy[:x] = galaxy[:x] + n
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
      acc + (idx + 1..length - 1).reduce(0) do |lacc, galaxy_jdx|
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

  def print_galaxies
    @galaxies.each do |galaxy|
      puts "#{galaxy[:x]}, #{galaxy[:y]}"
    end
  end
end

class CosmicExpansion
  def initialize
  end

  def sum_of_shortest_paths(lines, expand_by)
    universe = Universe.new
    lines.each_with_index do |line, index|
      line.strip.chars.each do |char|
        universe.add_entity(index, char)
      end
    end
    universe.position_galaxies
    universe.expand_by(expand_by)
    universe.sum_galaxy_distances
  end

end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts CosmicExpansion.new.sum_of_shortest_paths(lines, 1)
end

puts "Doing problem 2"
File.open("input-2.txt", "r") do |f|
  lines = f.readlines
  puts CosmicExpansion.new.sum_of_shortest_paths(lines, 999999)
end