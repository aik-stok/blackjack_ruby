require_relative 'bank'
require_relative 'player'
require_relative 'hand'
require_relative 'deck'
require_relative 'dealer'
require_relative 'card'

PLAYERS_MENU_1 = "
  1.Пропустить
  2.Добавить карту
  3.Открыть карты
  ".freeze

PLAYERS_MENU_2 = "
1.Пропустить
2.Открыть карты
".freeze

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

class UI
  def initialize
    @game = Logic.new
  end

  def current_score
    "Текущие очки игрока #{@game.player.name}: #{@game.players_score} \n"
  end

  def dealer_turn
    @game.send @game.dealer.strategy
  end

  def skipping
    print @game.skip(1)
    print dealer_turn
  end

  def skipping_two
    print @game.skip(1)
    print dealer_turn
    return unless @game.six_cards?
    print @game.who_wins?
    @game.clear_players_cards
    :break
  end

  def take_card
    print @game.give_cards_to_player
    print current_score
    dealer_turn
    return unless @game.six_cards?
    print @game.who_wins?
    @game.clear_players_cards
    :break
  end

  def open_cards
    print @game.show_cards
    print @game.who_wins?
    @game.clear_players_cards
    :break
  end

  def menu_one
    print PLAYERS_MENU_1
    players_choice = gets.chomp.to_i
    case players_choice
    when 1 then skipping
    when 2 then take_card
    when 3 then open_cards
    end
  end

  def menu_two
    print PLAYERS_MENU_2
    players_choice = gets.chomp.to_i
    case players_choice
    when 1 then skipping_two
    when 2 then open_cards
    end
  end

  def start
    p 'Введите имя'
    @game.player.name = gets.chomp
    until @game.bank.player_cash.zero? || @game.bank.dealer_cash.zero?
      @game.deck.build_deck
      print @game.bank.show_money
      @game.bank.banking
      print "Раздача: по две карты каждому.\n "
      print @game.give_cards_to_player(2)
      print current_score
      print "____________________________\n"
      print @game.give_cards_to_dealer(2)
      print "____________________________\n"
      loop do
        if @game.player.hand.cards.count < 3
          break if menu_one == :break
        else
          break if menu_two == :break
        end
      end
      print "*********************\n "
    end
  end

  def run
    answer = 'да'
    while answer == 'да'
      start
      @game.bank.reset_money
      p "Игра закончена. Хотите повторить?  (да/нет)\n"
      answer = gets.chomp
    end
  end
end

UI.new.run
