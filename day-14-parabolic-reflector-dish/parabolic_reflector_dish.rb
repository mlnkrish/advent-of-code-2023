class ParabolicReflectorDish
  def initialize
  end

  def tilt_north_and_calc_load(lines)
    rocks_and_boulders = lines.map do |line|
      line.strip.chars
    end
    # print_mirror(rocks_and_boulders)
    tilt_upwards(rocks_and_boulders)
    calc_load(rocks_and_boulders)
    # print_mirror(rocks_and_boulders)
  end

  def cycle_and_calc_load(lines)
    rocks_and_boulders = lines.map do |line|
      line.strip.chars
    end
    # print_mirror(rocks_and_boulders)
    cache = {}
    cycle = {}
    1000000000.times do |i|
      key = rocks_and_boulders.hash
      if !cache[key].nil?
        cycle = {start: cache[key][0], end: i}
        break
      else
        cache[key] = [i]
      end
      rocks_and_boulders = do_cycle(rocks_and_boulders)
    end
    # puts "_____________ #{cycle}"
    ((1000000000 - cycle[:start]) % (cycle[:end] - cycle[:start])).times do
      rocks_and_boulders = do_cycle(rocks_and_boulders)
    end
    # print_mirror(rocks_and_boulders)
    calc_load(rocks_and_boulders)
  end

  def do_cycle(lines)
    # NORTH
    tilt_upwards(lines)
    # WEST
    tx = lines.transpose
    tilt_upwards(tx)
    lines = tx.transpose
    # SOUTH
    tx = lines.reverse
    tilt_upwards(tx)
    lines = tx.reverse
    # EAST
    tx = lines.transpose.reverse
    tilt_upwards(tx)
    tx.reverse.transpose
  end

  def calc_load(lines)
    l = lines.length
    load = 0
    lines.each_with_index do |line, idx|
      load = load + (line.count("O") * (l - idx))
    end
    load
  end

  def tilt_upwards(lines)
    (1..lines.length - 1).each do |line_idx|
      (1..line_idx).reverse_each do |tx_from|
        # puts "Transferring from #{tx_from} to #{tx_from - 1}"
        lines[tx_from].each_with_index do |char, idx|
          if char == "O" && lines[tx_from - 1][idx] == "."
            lines[tx_from - 1][idx] = "O"
            lines[tx_from][idx] = "."
          end
        end
      end
    end
  end

  def print_mirror(lines)
    lines.each do |line|
      puts line.join("")
    end
  end

end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts ParabolicReflectorDish.new.tilt_north_and_calc_load(lines)
end

puts "Doing problem 2"
File.open("input-2.txt", "r") do |f|
  lines = f.readlines
  puts ParabolicReflectorDish.new.cycle_and_calc_load(lines)
end