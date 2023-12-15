class LensLibrary
  def initialize
  end

  def sum_of_hashes(lines)
    if lines.length != 1
      raise "Expected only one line"
    end
    line = lines[0]
    strings = line.split(",")
    strings.reduce(0) do |sum, string|
      sum + make_hash(string)
    end
  end

  def make_hash(string)
    # puts "Making hash for #{string} #{string.chars}"
    hash = 0
    string.chars.each do |char|
      hash = hash + char.ord
      hash = hash * 17
      hash = hash % 256
    end
    hash
  end

end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts LensLibrary.new.sum_of_hashes(lines)
end

# puts "Doing problem 2"
# File.open("input-2.txt", "r") do |f|
#   lines = f.readlines
#   puts ParabolicReflectorDish.new.cycle_and_calc_load(lines)
# end