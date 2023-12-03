# frozen_string_literal: true

class Tok
  def initialize(value, start, finish)
    @value = value
    @start = start # {x: 0, y: 0}
    @finish = finish # {x: 0, y: 0}
  end

  def to_s
    { value: @value, start: @start, finish: @finish}
  end

  def start
    @start
  end

  def finish
    @finish
  end

  def value
    @value
  end
end

class Gears
  def initialize

  end

  def part_numbers(lines)
    line_index = 0
    numbers_and_symbols = lines.reduce({ numbers: [], symbols: [] }) do |acc, l|
      line = l.strip
      length = line.length
      num_start = -1
      num = ''
      nums = []
      syms = []
      line.chars.each_with_index do |char, char_index|
        if char.match?(/\d/)
          if num_start == -1
            num_start = { x: line_index, y: char_index }
          end
          num = num + char
          if char_index == length - 1
            nums << Tok.new(num, num_start, { x: line_index, y: char_index })
          end
        else
          if !num.empty?
            nums << Tok.new(num, num_start, { x: line_index, y: char_index - 1 })
            num_start = -1
            num = ''
          end
          if char != '.'
            syms << Tok.new(char, { x: line_index, y: char_index }, { x: line_index, y: char_index })
          end
        end
      end
      line_index = line_index + 1
      acc[:numbers].concat(nums)
      acc[:symbols].concat(syms)
      acc
    end

    adjacent_to_symbol_positions = numbers_and_symbols[:symbols].reduce([]) do |acc, sym|
      acc.concat([
        { x: sym.start[:x] -1, y: sym.start[:y] - 1 },
        { x: sym.start[:x], y: sym.start[:y] - 1 },
        { x: sym.start[:x] + 1, y: sym.start[:y] - 1 },

        { x: sym.start[:x] -1, y: sym.start[:y] },
        { x: sym.start[:x] + 1, y: sym.start[:y] },

        { x: sym.start[:x] -1, y: sym.start[:y] + 1 },
        { x: sym.start[:x], y: sym.start[:y] + 1 },
        { x: sym.start[:x] + 1, y: sym.start[:y] + 1 },
      ]
      )
      acc
    end

    numbers_and_symbols[:numbers].reduce(0) do |sum, num|
      if is_adjacent_to_symbol?(num, adjacent_to_symbol_positions)
        sum + num.value.to_i
      else
        sum
      end
    end
  end

  def is_adjacent_to_symbol?(num, adjacent_to_symbol_positions)
    adjacent_to_symbol_positions.any? do |pos|
      xpos = num.start[:x]
      (num.start[:y]..num.finish[:y]).any? do |ypos|
        xpos == pos[:x] && ypos == pos[:y]
      end
    end
  end


  def sum_of_powers(lines) end

end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts Gears.new.part_numbers(lines)
end

# puts "Doing problem 2"
# File.open("input-2.txt", "r") do |f|
#   lines = f.readlines
#   puts Cubes.new.sum_of_powers(lines)
# end


