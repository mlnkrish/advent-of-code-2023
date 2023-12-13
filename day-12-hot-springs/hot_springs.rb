# frozen_string_literal: true

class SpringData
  def initialize(symbols, win_condition)
    @symbols = symbols
    @win_condition = win_condition
    @win_condition_length = win_condition.length
  end

  def possible_combinations
    # puts "start #{Time.now}"
    combinations = make_combinations(@symbols, "#", ".")
    # puts "end #{Time.now}"
    # puts "combinations #{combinations.flatten}"
    combinations.flatten.sum
  end

  def make_combinations(symbols, repl1, repl2)
    # puts "TRY #{symbols}"

    if !has_potential?(symbols, @win_condition) || !has_potential?(symbols.reverse, @win_condition.reverse)
      return 0
    end

    if !symbols.include?('?')
      return 1
    end

    question_index = symbols.index('?')

    [repl1, repl2].map do |repl|
      n = symbols.dup
      n[question_index] = repl
      make_combinations(n, repl1, repl2)
    end
  end

  def has_potential?(symbols, win_condition)
    current_index = -1
    looking_for_next_index = true
    current_index_count = 0

    (0..symbols.length - 1).each do |idx|
      char = symbols[idx]
      if char == "?"
        return true
      end

      if char == "."
        if looking_for_next_index
          next
        else
          if current_index_count != win_condition[current_index]
            return false
          end
          looking_for_next_index = true
        end
      end

      if char == "#"
        if looking_for_next_index
          current_index_count = 0
          current_index = current_index + 1
          looking_for_next_index = false
        end
        current_index_count = current_index_count + 1

        if current_index == @win_condition_length
          return false
        end

        if current_index_count > win_condition[current_index]
          return false
        end
      end
    end

    # puts "3333 #{current_index}"

    current_index == @win_condition_length - 1 && current_index_count == win_condition[current_index]
  end

  def is_win(possible_combination)
    subbed = possible_combination.gsub(/[.]+/, '|')
    if subbed[0] == "|"
      subbed = subbed[1..subbed.length - 1]
    end
    subbed.split("|").map { |x| x.length } == @win_condition
  end
end

class Record
  def initialize
    @spring_data = []
  end

  def add_data(spring_data)
    @spring_data << spring_data
  end

  def sum_of_possible_combinations
    @spring_data.map(&:possible_combinations).reduce(:+)
  end
end

class HotSprings
  def initialize
  end

  def possible_combinations(lines)
    record = Record.new
    lines.each do |line|
      split = line.strip.split(" ")
      symbols = split[0]
      win_conditions = split[1].split(",").map(&:to_i)
      record.add_data(SpringData.new(symbols, win_conditions))
    end
    record.sum_of_possible_combinations
  end

  def possible_combinations_unfolded(lines)
    record = Record.new
    lines.each do |line|
      split = line.strip.split(" ")
      symbol_copy = split[0]
      win_condition_copy = split[1].split(",").map(&:to_i)

      symbols = symbol_copy + "?" + symbol_copy + "?" + symbol_copy + "?" + symbol_copy + "?" + symbol_copy
      win_conditions = win_condition_copy + win_condition_copy + win_condition_copy + win_condition_copy + win_condition_copy

      record.add_data(SpringData.new(symbols, win_conditions))
    end
    record.sum_of_possible_combinations
  end

end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts HotSprings.new.possible_combinations(lines)
end

# puts "Doing problem 2"
# File.open("input-2.txt", "r") do |f|
#   lines = f.readlines
#   puts HotSprings.new.possible_combinations_unfolded(lines)
# end