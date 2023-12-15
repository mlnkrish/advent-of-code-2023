# frozen_string_literal: true

class Field
  def initialize(lines)
    @lines = []
    lines.each do |line|
      @lines << line.chars
    end
  end

  def print_field
    @lines.each do |line|
      puts line.join(" ")
    end
  end

  def value_of_reflection
    horizontal_reflection_point = find_perfect_reflection_point(@lines)
    vertical_reflection_point = find_perfect_reflection_point(@lines.transpose)

    if horizontal_reflection_point.nil? && vertical_reflection_point.nil?
      return 0
    end

    if !vertical_reflection_point.nil? && horizontal_reflection_point.nil?
      return vertical_reflection_point + 1
    end

    if !horizontal_reflection_point.nil? && vertical_reflection_point.nil?
      return (horizontal_reflection_point + 1) * 100
    end

    if !horizontal_reflection_point.nil? && !vertical_reflection_point.nil?
      if horizontal_reflection_point >= vertical_reflection_point
        return (horizontal_reflection_point + 1) * 100
      else
        return vertical_reflection_point + 1
      end
    end
    raise "Whhaaaa"
  end

  private

  def find_perfect_reflection_point(lines)
    lines.each_with_index do |line, idx|
      if idx == lines.length - 1
        return nil
      end
      if line == lines[idx + 1]
        if is_perfect_reflection_point(lines, idx)
          return idx
        end
      end
    end
  end

  def is_perfect_reflection_point(lines, idx)
    (idx+1).times do |i|
      if lines[idx - i] != lines[idx + 1 + i]
        return false
      end

      if i == idx || (idx + 1 + i) == lines.length - 1
        return true
      end
    end
  end

end

class Island
  def initialize
    @fields = []
  end

  def add_field(field)
    @fields << field
  end

  def print_island
    @fields.each do |field|
      field.print_field
      puts "..........."
    end
  end

  def sum_of_reflections
    @fields.map do |field|
      field.value_of_reflection
    end.sum
  end
end

class PointOfIncidence
  def initialize
  end

  def sum_of_reflections(lines)
    i = parse_island(lines)
    i.sum_of_reflections
  end

  private

  def parse_island(lines)
    i = Island.new
    new_field = true
    line_group = nil
    lines.each do |line|
      if new_field
        line_group = []
        new_field = false
      end

      if line.strip == ""
        new_field = true
        f = Field.new(line_group)
        i.add_field(f)
        next
      end

      line_group << line.strip
    end
    f = Field.new(line_group)
    i.add_field(f)
    i
  end

end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts PointOfIncidence.new.sum_of_reflections(lines)
end

# puts "Doing problem 2"
# File.open("input-2.txt", "r") do |f|
#   lines = f.readlines
#   puts HotSprings.new.possible_combinations_unfolded(lines)
# end