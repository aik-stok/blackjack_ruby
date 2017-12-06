class Deck
  CARDS_HASH = { '2♠' => 2, '3♠' => 3, '4♠' => 4, '5♠' => 5,
                 '6♠' => 6, '7♠' => 7, '8♠' => 8, '9♠' => 9,
                 '10♠' => 10,  'J♠' => 10, 'Q♠' => 10, 'K♠' => 10,
                 'A♠' => nil,  '2♣' => 2, '3♣' => 3, '4♣' => 4,
                 '5♣' => 5,  '6♣' => 6, '7♣' => 7, '8♣' => 8,
                 '9♣' => 9,  '10♣' => 10, 'J♣' => 10, 'Q♣' => 10,
                 'K♣' => 10, 'A♣' => nil, '2♦' => 2, '3♦' => 3,
                 '4♦' => 4,  '5♦' => 5,  '6♦' => 6, '7♦' => 7,
                 '8♦' => 8,  '9♦' => 9,  '10♦' => 10, 'J♦' => 10,
                 'Q♦' => 10, 'K♦' => 10, 'A♦' => nil, '2♥' => 2,
                 '3♥' => 3,  '4♥' => 4,  '5♥' => 5,  '6♥' => 6,
                 '7♥' => 7,  '8♥' => 8,  '9♥' => 9,  '10♥' => 10,
                 'J♥' => 10, 'Q♥' => 10, 'K♥' => 10, 'A♥' => nil }.freeze

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