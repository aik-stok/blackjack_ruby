class Dealer
  attr_accessor :hand

  def initialize
    @hand = Hand.new
  end

  def strategy
    if hand.score < 11 && hand.cards.count < 3
      :give_cards_to_dealer
    elsif hand.score < 16 && hand.cards.count < 3
      %i[skip give_cards_to_dealer].sample
    else :skip
    end
  end
end
