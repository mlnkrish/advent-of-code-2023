# frozen_string_literal: true

class Hand
  @@card_ranks = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]

  def initialize(hand, bid)
    @hand = hand
    @bid = bid
  end

  def to_s
    "#{@hand} ==> #{@bid}"
  end

  def hand
    @hand
  end

  def bid
    @bid
  end

  def is_five_of_a_kind?
    @hand.chars.uniq.length == 1
  end

  def is_four_of_a_kind?
    uniq = @hand.chars.uniq
    if uniq.length == 2
      @hand.chars.count(uniq[0]) == 4 || @hand.chars.count(uniq[1]) == 4
    else
      false
    end
  end

  def is_full_house?
    uniq = @hand.chars.uniq
    if uniq.length == 2
      @hand.chars.count(uniq[0]) == 3 || @hand.chars.count(uniq[1]) == 3
    else
      false
    end

  end

  def is_three_of_a_kind?
    uniq = @hand.chars.uniq
    if uniq.length == 3
      @hand.chars.count(uniq[0]) == 3 || @hand.chars.count(uniq[1]) == 3 || @hand.chars.count(uniq[2]) == 3
    else
      false
    end
  end

  def is_two_pair?
    uniq = @hand.chars.uniq
    if uniq.length == 3
      count_of_first = @hand.chars.count(uniq[0]) == 2
      count_of_second = @hand.chars.count(uniq[1]) == 2
      count_of_third = @hand.chars.count(uniq[2]) == 2
      count_of_first && count_of_second || count_of_first && count_of_third || count_of_second && count_of_third
    else
      false
    end
  end

  def is_one_pair?
    uniq = @hand.chars.uniq
    if uniq.length == 4
      count_of_first = @hand.chars.count(uniq[0]) == 2
      count_of_second = @hand.chars.count(uniq[1]) == 2
      count_of_third = @hand.chars.count(uniq[2]) == 2
      count_of_fourth = @hand.chars.count(uniq[3]) == 2
      count_of_first || count_of_second || count_of_third || count_of_fourth
    else
      false
    end
  end

  def is_high_card?
    true
  end

  def get_rank
    if is_five_of_a_kind?
      7
    elsif is_four_of_a_kind?
      6
    elsif is_full_house?
      5
    elsif is_three_of_a_kind?
      4
    elsif is_two_pair?
      3
    elsif is_one_pair?
      2
    elsif is_high_card?
      1
    end
  end

  def better_than?(other)
    if self.get_rank > other.get_rank
      true
    elsif self.get_rank == other.get_rank
      self.hand.chars.each_with_index do |card, index|
        if card != other.hand.chars[index]
          return @@card_ranks.index(card) < @@card_ranks.index(other.hand.chars[index])
        end
      end
    else
      false
    end
  end

  def <=>(other)
    if self.better_than?(other)
      1
    else
      @bid < other.bid
      -1
    end
  end
end

class CamelCards
  def initialize
  end

  def rank_and_bid(lines)
    hand_and_bids = lines.map do |line|
      hand, bid = line.split(" ")
      Hand.new(hand.strip, bid.strip.to_i)
    end

    sum = 0
    hand_and_bids.sort.each.with_index do |hand_and_bid, index|
      sum = sum + hand_and_bid.bid * (index + 1)
    end
    sum
  end
end

puts "Doing problem 1"
File.open("input-1.txt", "r") do |f|
  lines = f.readlines
  puts CamelCards.new.rank_and_bid(lines)
end

# puts "Doing problem 2"
# File.open("input-2.txt", "r") do |f|
#   lines = f.readlines
#   puts Race.new.single_race(lines)
# end
