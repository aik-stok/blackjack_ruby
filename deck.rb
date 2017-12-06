class Deck

  def initialize
    @deck = []
    build_deck
  end

  def build_deck
    CARDS_HASH.each do |pic, value|
      @deck << Card.new(pic, value)
    end
    @deck.shuffle!
  end

  def give_card(num)
    @deck.pop(num)
  end
end
