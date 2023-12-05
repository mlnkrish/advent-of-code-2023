# frozen_string_literal: true

class Mapping
  def initialize(from, to)
    @from = from
    @to = to
    @mappings = []
  end

  def generate(src, dest, count)
    @mappings << { src: src, dest: dest, count: count }
  end

  def from
    @from
  end

  def to
    @to
  end

  def transform(from)
    mping = @mappings.find {|m| m[:src] <= from && from < m[:src] + m[:count] }
    if mping.nil?
      from
    else
      mping[:dest] + (from - mping[:src])
    end
  end

end

class Seed
  def initialize

  end

  def seed_to_location(lines)
    seeds_and_mappings = parse_lines_to_mappings(lines)
    seeds = seeds_and_mappings[:seeds]
    mappings = seeds_and_mappings[:mappings]
    map_from("seed", seeds, mappings).min
  end

  private

  def map_from(name, src, mappings)
    mapping_to_use = mappings.find { |mapping| mapping.from == name }
    if mapping_to_use.nil?
      src
    else
      dest = src.map { |num| mapping_to_use.transform(num) }
      map_from(mapping_to_use.to, dest, mappings)
    end
  end

  def parse_lines_to_mappings(lines)
    seeds = []
    next_line_is_a_mapping = false
    mappings = []
    lines.each_with_index do |line, idx|
      if idx == 0
        seeds = line.split(":")[1].strip.split(" ").map { |num| num.strip.to_i }
      else
        if line.strip.length == 0
          next_line_is_a_mapping = true
        else
          if next_line_is_a_mapping
            from_to = line.strip.split(" ")[0].split("-to-")
            mappings << Mapping.new(from_to[0], from_to[1])
            next_line_is_a_mapping = false
          else
            current_mapping = mappings.last
            dest_src_count = line.strip.split(" ")
            current_mapping.generate(dest_src_count[1].to_i, dest_src_count[0].to_i, dest_src_count[2].to_i)
          end
        end
      end
    end
    { seeds: seeds, mappings: mappings }
  end
end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts Seed.new.seed_to_location(lines)
end

# puts "Doing problem 2"
# File.open("input-2.txt", "r") do |f|
#   lines = f.readlines
#   puts Scratchcards.new.copies(lines)
# end


