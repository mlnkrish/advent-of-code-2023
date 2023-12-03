# frozen_string_literal: true

class Tok
  def initialize(value, start, finish)
    @value = value
    @start = start # {x: 0, y: 0}
    @finish = finish # {x: 0, y: 0}
    @adjacent_positions = [
      { x: @start[:x] - 1, y: @start[:y] - 1 },
      { x: @start[:x], y: @start[:y] - 1 },
      { x: @start[:x] + 1, y: @start[:y] - 1 },

      { x: @start[:x] - 1, y: @start[:y] },
      { x: @start[:x] + 1, y: @start[:y] },

      { x: @start[:x] - 1, y: @start[:y] + 1 },
      { x: @start[:x], y: @start[:y] + 1 },
      { x: @start[:x] + 1, y: @start[:y] + 1 },
    ]
  end

  def to_s
    { value: @value, start: @start, finish: @finish, adjacent_positions: @adjacent_positions }
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

  def adjacent_positions
    @adjacent_positions
  end
end

class Gears
  def initialize

  end

  def part_numbers(lines)
    numbers_and_symbols = extract_numbers_and_symbols(lines)
    all_symbols = numbers_and_symbols[:symbols]
    adjacent_to_symbol_positions = all_symbols.reduce([]) do |acc, sym|
      acc.concat(sym.adjacent_positions)
      acc
    end

    numbers_and_symbols[:numbers].reduce(0) do |sum, num|
      if is_adjacent_to_any_position?(num, adjacent_to_symbol_positions)
        sum + num.value.to_i
      else
        sum
      end
    end
  end

  def gear_ratio(lines)
    numbers_and_symbols = extract_numbers_and_symbols(lines)
    gear_symbols = numbers_and_symbols[:symbols].select { |sym| sym.value == '*' }
    gear_symbols.reduce(0) do |sum, sym|
      gr = 0
      adjacent_numbers = numbers_and_symbols[:numbers].map do |num|
        if is_adjacent_to_any_position?(num, sym.adjacent_positions)
          num
        else
          nil
        end
      end.compact
      if adjacent_numbers.length == 2
        gr = adjacent_numbers[0].value.to_i * adjacent_numbers[1].value.to_i
      end

      sum + gr
    end
  end

  private

  def is_adjacent_to_any_position?(num, positions)
    positions.any? do |pos|
      xpos = num.start[:x]
      (num.start[:y]..num.finish[:y]).any? do |ypos|
        xpos == pos[:x] && ypos == pos[:y]
      end
    end
  end

  def extract_numbers_and_symbols(lines)
    line_index = 0
    lines.reduce({ numbers: [], symbols: [] }) do |acc, l|
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
  end

end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts Gears.new.part_numbers(lines)
end

puts "Doing problem 2"
File.open("input-2.txt", "r") do |f|
  lines = f.readlines
  puts Gears.new.gear_ratio(lines)
end


