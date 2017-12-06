class Hand
  attr_accessor :cards, :score

  def initialize
    @cards = []
    @score = 0
  end

  def clear
    @cards.clear
    @score = 0
  end

  def show_cards
    pictures = []
    @cards.each { |card| pictures << card.pic }
    pictures
  end

  def points_calc(value)
    if value.nil?
      @score < 11 ? 11 : 1
    else
      value
    end
  end

  def score_points
    sum = 0
    @cards.each do |card|
      sum += points_calc(card.value)
    end
    @score = sum
  end
end
