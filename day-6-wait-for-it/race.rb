# frozen_string_literal: true

class BoatRace
  def initialize(time, distance)
    @time = time
    @distance = distance
  end

  def to_s
    "#{@time} ==> #{@distance}"
  end

  def ways_to_win
    earliest_way_to_win = earliest_way_to_win(1, @time)
    latest_way_to_win = latest_way_to_win(1, @time)
    latest_way_to_win - earliest_way_to_win + 1
  end

  private

  def earliest_way_to_win(start_point, end_point)
    mid_point = (start_point + end_point) / 2
    if is_win?(mid_point)
      if !is_win?(mid_point - 1)
        mid_point
      else
        earliest_way_to_win(start_point, mid_point)
      end
    else
      earliest_way_to_win(mid_point, end_point)
    end
  end

  def latest_way_to_win(start_point, end_point)
    mid_point = (start_point + end_point) / 2

    if is_win?(mid_point)
      if !is_win?(mid_point + 1)
        mid_point
      else
        latest_way_to_win(mid_point, end_point)
      end
    else
      latest_way_to_win(start_point, mid_point)
    end
  end

  def is_win?(time_held)
    (@time - time_held) * (time_held) > @distance
  end

end

class Race
  def initialize

  end

  def record_breaker(lines)
    race_times = lines[0].split(":")[1].strip.split(" ").map { |n| n.strip.to_i }
    race_distances = lines[1].split(":")[1].strip.split(" ").map { |n| n.strip.to_i }
    races = race_times.map.with_index do |time, idx|
      BoatRace.new(time, race_distances[idx])
    end

    races.reduce(1) do |num, race|
      num * race.ways_to_win
    end
  end

end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts Race.new.record_breaker(lines)
end

# puts "Doing problem 2"
# File.open("input-2.txt", "r") do |f|
#   lines = f.readlines
#   puts Seed.new.range_of_seeds_to_location(lines)
# end


