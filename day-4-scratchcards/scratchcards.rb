# frozen_string_literal: true

class Scratchcards
  def initialize

  end

  def winning_numbers(lines)
    lines.reduce(0) do |num, line|
      game_play_split = line.split(":")
      winners_vs_mine = game_play_split[1].split("|")
      winning_list = winners_vs_mine[0].strip.split(" ").map {|n| n.strip.to_i}
      my_list = winners_vs_mine[1].strip.split(" ").map {|n| n.strip.to_i}
      value = 0
      my_list.each do |my_num|
        if winning_list.include?(my_num)
          if value == 0
            value = 1
          else
            value = value * 2
          end
        end
      end

      num + value
    end

  end
end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts Scratchcards.new.winning_numbers(lines)
end

# puts "Doing problem 2"
# File.open("input-2.txt", "r") do |f|
#   lines = f.readlines
#   puts Gears.new.gear_ratio(lines)
# end


