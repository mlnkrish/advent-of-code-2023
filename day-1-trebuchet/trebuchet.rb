# frozen_string_literal: true

class Trebuchet
  def initialize
    @number_to_digit = {
      "one" => '1',
      "two" => '2',
      "three" => '3',
      "four" => '4',
      "five" => '5',
      "six" => '6',
      "seven" => '7',
      "eight" => '8',
      "nine" => '9',
    }
    @numbers = @number_to_digit.keys
  end

  def decode_as_digits(lines)
    lines.reduce(0) do |num, line|
      first = 0
      last = 0
      found_first = false
      line.chars.each do |char, index|
        if char.match?(/\d/)
          if !found_first
            first = char
            last = char
            found_first = true
          else
            last = char
          end
        end
      end
      num + (first + last).to_i
    end
  end

  def decode_as_numbers_or_digits(lines)
    lines.reduce(0) do |num, line|
      first = 0
      last = 0
      found_first = false
      consumed = ''
      line.chars.each do |char|
        found_number = false
        consumed = consumed + char
        number = ''
        if char.match?(/\d/)
          consumed = ''
          number = char
          found_number = true
        else
          found = @numbers.find { |n| consumed.end_with?(n) }
          if !found.nil?
            number = @number_to_digit[found]
            found_number = true
          end
        end

        if found_number
          if !found_first
            first = number
            last = number
            found_first = true
          else
            last = number
          end
        end
      end
      num + (first + last).to_i
    end
  end
end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts Trebuchet.new.decode_as_digits(lines)
end

puts "Doing problem 2"
File.open("input-2.txt", "r") do |f|
  lines = f.readlines
  puts Trebuchet.new.decode_as_numbers_or_digits(lines)
end


