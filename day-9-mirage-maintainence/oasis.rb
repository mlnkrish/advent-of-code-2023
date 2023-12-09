# frozen_string_literal: true

class Oasis
  def initialize
  end

  def predict(lines)
    readings = lines.map { |line| line.split(" ").map { |val| val.strip.to_i } }
    readings.reduce(0) do |acc, reading|
      reduced = reduce_down([], reading)
      acc = acc + reduced.map { |r| r[-1] }.sum
    end
  end

  private

  def reduce_down(acc, reading)
    acc << reading
    if reading.all? { |val| val == 0 }
      acc
    else
      reduce_down(acc, diff(reading))
    end
  end

  def diff(reading)
    to_ret = []
    (0..reading.length - 2).each do |i|
      to_ret << reading[i + 1] - reading[i]
    end
    to_ret
  end
end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts Oasis.new.predict(lines)
end

# puts "Doing problem 2"
# File.open("input-2.txt", "r") do |f|
#   lines = f.readlines
#   puts Wasteland.new.steps_to_end_as_a_ghost(lines)
# end
