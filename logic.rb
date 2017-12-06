class Logic
  attr_accessor :deck, :dealer, :player, :bank

  def initialize
    @deck = Deck.new
    @dealer = Dealer.new
    @player = Player.new('default')
    @bank = Bank.new
  end

  def give_cards_to_dealer(number = 1)
    pictures = []
    cards = @deck.give_card(number)
    cards.each do |card|
      @dealer.hand.cards << card
      pictures << '[*]'
    end
    @dealer.hand.score_points
    "Дилер получает #{pictures}\n"
  end

  def give_cards_to_player(number = 1)
    pictures = []
    cards = @deck.give_card(number)
    cards.each do |card|
      @player.hand.cards << card
      pictures << card.pic
    end
    @player.hand.score_points
    "Игрок получает #{pictures}\n"
  end

  def skip(*name)
    name[0].nil? ? 'Дилер пропускает ход' : "#{@player.name} пропускает ход\n"
  end

  def clear_players_cards
    @player.hand.clear
    @dealer.hand.clear
  end

  def show_cards
    "Карты игрока #{@player.name}: #{@player.hand.show_cards} \nКарты Дилера: #{@dealer.hand.show_cards}\n"
  end

  def players_score
    @player.hand.score
  end

  def dealers_score
    @dealer.hand.score
  end

  def six_cards?
    @player.hand.cards.count == 3 && @dealer.hand.cards.count == 3
  end

  def compare_points
    result = dealers_score <=> players_score
    case result
    when 1
      @bank.award_dealer
      "Дилер выиграл набрав больше очков\n"
    when -1
      @bank.award_player
      "Игрок #{@player.name} выиграл набрав больше очков\n"
    when 0
      @bank.draw
      "У обоих игроков поровну очков. Ничья.\n"
    end
  end

  def who_wins?
    if dealers_score > 21 && players_score > 21
      @bank.draw
      'У обоих игроков перебор. Ничья.'
    elsif dealers_score > 21
      @bank.award_player
      "У Дилера перебор.Выигрывает Игрок #{@player.name}\n"
    elsif players_score > 21
      @bank.award_dealer
      'У Игрока перебор.Выигрывает Дилер.\n'
    else compare_points
    end
  end
end