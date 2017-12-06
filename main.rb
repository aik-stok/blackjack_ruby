require_relative 'bank'
require_relative 'player'
require_relative 'hand'
require_relative 'deck'
require_relative 'dealer'
require_relative 'card'
require_relative 'logic'

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

PLAYERS_MENU_1 = "
  1.Пропустить
  2.Добавить карту
  3.Открыть карты
  ".freeze

PLAYERS_MENU_2 = "
1.Пропустить
2.Открыть карты
".freeze

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
