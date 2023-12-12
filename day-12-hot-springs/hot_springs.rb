# frozen_string_literal: true

class SpringData
  def initialize(symbols, win_condition)
    @symbols = symbols
    @win_condition = win_condition
  end

  def possible_combinations
    combinations = make_combinations(@symbols, ".", "#")
    wins = combinations.reject {|c| c.length == 0}.count { |possible_combination| is_win(possible_combination) }
    # puts ">>>>>> WINS #{wins}"
    wins
  end

  def make_combinations(symbols, repl1, repl2)
    # puts "TRY #{symbols}"

    if !has_potential?(symbols)
      return []
    end

    if !symbols.include?('?')
      return symbols
    end

    question_index = symbols.index('?')

    [repl1, repl2].flat_map do |repl|
      n = symbols.dup
      n[question_index] = repl
      make_combinations(n, repl1, repl2)
    end
  end

  def has_potential?(symbols)
    subbed = symbols.gsub(/[.]+/, '|')
    if subbed[0] == "|"
      subbed = subbed[1..subbed.length-1]
    end
    splits = subbed.split("|")
    @win_condition.each_with_index do |num, idx|
      sub = splits[idx]
      if sub.nil?
        return true
      end
      count_of_hash = sub.split("?").map {|x| x.count("#")}.min || 0
      if count_of_hash > num
        # puts "+++>>> #{symbols} --- #{sub} --- #{count_of_hash}"
        return false
      end
      if !sub.include?("?")
        if count_of_hash != num
          # puts ">>> #{symbols} --- #{sub} --- #{count_of_hash}"
          return false
        end
      else
        return true
      end
    end
    return true
  end

  def is_win(possible_combination)
    subbed = possible_combination.gsub(/[.]+/, '|')
    if subbed[0] == "|"
      subbed = subbed[1..subbed.length-1]
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

end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts HotSprings.new.possible_combinations(lines)
end

# puts "Doing problem 2"
# File.open("input-2.txt", "r") do |f|
#   lines = f.readlines
#   puts CosmicExpansion.new.sum_of_shortest_paths(lines, 999999)
# end