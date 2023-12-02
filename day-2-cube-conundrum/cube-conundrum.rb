# frozen_string_literal: true

class Cubes
  def initialize

  end

  def possible_games(lines)
    lines.reduce(0) do |num, line|
      game_play_split = line.split(":")
      game_number = game_play_split[0].split(" ")[1].to_i
      games = game_play_split[1].split(";")
      balls_by_game = games.reduce([]) do |bbg, game|
        ball_splits = game.strip.split(", ")
        balls_count = { "red" => 0, "blue" => 0, "green" => 0 }
        ball_splits.each do |ball_split|
          color = ball_split.split(" ")[1]
          count = ball_split.split(" ")[0].to_i
          balls_count[color] = balls_count[color] + count
        end
        bbg << balls_count
      end

      impossible = balls_by_game.any? do |game|
        is_invalid_game(game)
      end

      if impossible
        num
      else
        num + game_number
      end
    end
  end

  def is_invalid_game(game)
    game["red"] > 12 || game["blue"] > 14 || game["green"] > 13
  end

  def sum_of_powers(lines)
    lines.reduce(0) do |num, line|
      game_play_split = line.split(":")
      games = game_play_split[1].split(";")

      balls_to_satisfy = { "red" => 0, "blue" => 0, "green" => 0 }
      games.each do |game|
        ball_splits = game.strip.split(", ")
        ball_splits.each do |ball_split|
          color = ball_split.split(" ")[1]
          count = ball_split.split(" ")[0].to_i
          if balls_to_satisfy[color] < count
            balls_to_satisfy[color] = count
          end
        end
      end

      power_of_game = balls_to_satisfy.values.reduce(1) { |num, val| num * val }

      num + power_of_game
    end
  end

end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts Cubes.new.possible_games(lines)
end

puts "Doing problem 2"
File.open("input-2.txt", "r") do |f|
  lines = f.readlines
  puts Cubes.new.sum_of_powers(lines)
end


