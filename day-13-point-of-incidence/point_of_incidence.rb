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
    horizontal_reflection_point = find_perfect_reflection_point(@lines, false)
    vertical_reflection_point = find_perfect_reflection_point(@lines.transpose, false)
    calculate_value_of_reflection(horizontal_reflection_point, vertical_reflection_point)
  end

  def value_of_reflection_but_smudge
    horizontal_reflection_point = find_perfect_reflection_point(@lines, true)
    vertical_reflection_point = find_perfect_reflection_point(@lines.transpose, true)
    calculate_value_of_reflection(horizontal_reflection_point, vertical_reflection_point)
  end

  private

  def calculate_value_of_reflection(horizontal_reflection_point, vertical_reflection_point)
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

  def find_perfect_reflection_point(lines, smudging_enabled)
    lines.each_with_index do |line, idx|
      if idx == lines.length - 1
        return nil
      end
      if line == lines[idx + 1]
        if is_perfect_reflection_point(lines, idx, !smudging_enabled)
          return idx
        end
      else
        if smudging_enabled && equal_with_smudge_fix(line, lines[idx + 1])
          if is_perfect_reflection_point(lines, idx, !smudging_enabled)
            return idx
          end
        end
      end
    end
  end

  def is_perfect_reflection_point(lines, idx, smudge_fixed)
    sf = smudge_fixed
    (idx + 1).times do |i|
      if lines[idx - i] != lines[idx + 1 + i]
        if sf
          return false
        else
          if !equal_with_smudge_fix(lines[idx - i], lines[idx + 1 + i])
            return false
          end
          sf = true
        end
      end

      if i == idx || (idx + 1 + i) == lines.length - 1
        return sf
      end
    end
  end

  def equal_with_smudge_fix(line1, line2)
    diff = 0
    line1.each_with_index do |char, idx|
      if diff > 1
        return false
      end

      if char != line2[idx]
        diff = diff + 1
      end
    end

    diff == 1
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

  def sum_of_reflections_but_smudge
    @fields.map do |field|
      field.value_of_reflection_but_smudge
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

  def sum_of_reflections_but_smudge(lines)
    i = parse_island(lines)
    i.sum_of_reflections_but_smudge
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

puts "Doing problem 2"
File.open("input-2.txt", "r") do |f|
  lines = f.readlines
  puts PointOfIncidence.new.sum_of_reflections_but_smudge(lines)
end