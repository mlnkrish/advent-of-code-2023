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

  def focal_length(lines)
    box = {}
    (0..255).each do |i|
      box[i] = []
    end

    if lines.length != 1
      raise "Expected only one line"
    end
    line = lines[0]
    strings = line.split(",")
    strings.each do |string|
      if !string.include?("=") && !string.include?("-")
        raise "Expected string to contain = or -"
      end
      if string.include?("-")
        remove_from_box(box, string[0..string.length - 2])
      else
        string_split = string.split("=")
        add_to_box(box, string_split[0], string_split[1].to_i)
      end
    end

    box.keys.map do |key|
      tot = 0
      b = key + 1
      box[key].each_with_index do |it, idx|
        tot = tot + (b * (idx + 1) * it[:value])
      end
      tot
    end.sum
  end

  def add_to_box(box, lens, value)
    key = make_hash(lens)
    idx = box[key].index { |it| it[:lens] == lens }
    if !idx.nil?
      box[key][idx][:value] = value
    else
      box[key] << { lens: lens, value: value }
    end
  end

  def remove_from_box(box, lens)
    key = make_hash(lens)
    idx = box[key].index { |it| it[:lens] == lens }
    if !idx.nil?
      box[key].delete_at(idx)
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

puts "Doing problem 2"
File.open("input-2.txt", "r") do |f|
  lines = f.readlines
  puts LensLibrary.new.focal_length(lines)
end