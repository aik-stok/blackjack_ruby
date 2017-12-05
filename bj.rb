require_relative 'bank'
require_relative 'score'

CARDS_ARRAY = [{ '2♠' => 2 }, { '3♠' => 3 }, { '4♠' => 4 }, { '5♠' => 5 },
               { '6♠' => 6 }, { '7♠' => 7 }, { '8♠' => 8 }, { '9♠' => 9 },
               { '10♠' => 10 }, { 'J♠' => 10 }, { 'Q♠' => 10 }, { 'K♠' => 10 },
               { 'A♠' => nil }, { '2♣' => 2 }, { '3♣' => 3 }, { '4♣' => 4 },
               { '5♣' => 5 }, { '6♣' => 6 }, { '7♣' => 7 }, { '8♣' => 8 },
               { '9♣' => 9 }, { '10♣' => 10 }, { 'J♣' => 10 }, { 'Q♣' => 10 },
               { 'K♣' => 10 }, { 'A♣' => nil }, { '2♦' => 2 }, { '3♦' => 3 },
               { '4♦' => 4 }, { '5♦' => 5 }, { '6♦' => 6 }, { '7♦' => 7 },
               { '8♦' => 8 }, { '9♦' => 9 }, { '10♦' => 10 }, { 'J♦' => 10 },
               { 'Q♦' => 10 }, { 'K♦' => 10 }, { 'A♦' => nil }, { '2♥' => 2 },
               { '3♥' => 3 }, { '4♥' => 4 }, { '5♥' => 5 }, { '6♥' => 6 },
               { '7♥' => 7 }, { '8♥' => 8 }, { '9♥' => 9 }, { '10♥' => 10 },
               { 'J♥' => 10 }, { 'Q♥' => 10 }, { 'K♥' => 10 }, { 'A♥' => nil }]

PLAYERS_MENU_1 = "
  1.Пропустить
  2.Добавить карту
  3.Открыть карты
  ".freeze

PLAYERS_MENU_2 = "
1.Пропустить
2.Открыть карты
".freeze

class Game
  def initialize
    @table = []
    @players_cards = []
    @dealers_cards = []
    @score = Score.new
    @bank = Bank.new
  end

  def compare_points
    result = @score.dealer <=> @score.player
    if result == 1
      @bank.award_dealer
      'Дилер выиграл'
    else
      @bank.award_player
      'Игрок выиграл'
    end
  end

  def who_wins?
    if @score.dealer > 21 && @score.player > 21
      @bank.draw
      'У обоих игроков перебор. Ничья.'
    elsif @score.dealer == @score.player
      @bank.draw
      'У обоих игроков поровну очков. Ничья.'
    elsif @score.dealer > 21
      @bank.award_player
      'У Дилера перебор.Выигрывает Игрок.'
    elsif @score.player > 21
      @bank.award_dealer
      'У Игрока перебор.Выигрывает Дилер.'
    else compare_points
    end
  end

  def skip
    p 'Пропускаю ход'
  end

  def give_two_cards
    2.times { @table << @deck.delete(@deck[0]) }
  end

  def give_one_card
    @table << @deck.delete(@deck[0])
  end

  def score_player
    print "Игрок #{@players_name} получает:\n"
    @table.each do |card|
      card.each do |pic, value|
        @players_cards << pic
        @score.calc_player(value)
        p pic
      end
    end
    @table.clear
  end

  def score_dealer
    print "Дилер получает:\n"
    @table.each do |card|
      card.each do |pic, value|
        p '**'
        @dealers_cards << pic
        @score.calc_dealer(value)
      end
    end
    @table.clear
  end

  def clear_players_cards
    @players_cards.clear
    @dealers_cards.clear
  end

  def one_card_dealer
    give_one_card
    score_dealer
  end

  def show_cards
    p "Карты Дилера: #{@dealers_cards}"
    p "Карты игрока #{@players_name}: #{@players_cards}"
  end

  def dealer_turn
    if @score.dealer < 11 && @dealers_cards.count < 3
      one_card_dealer
    elsif @score.dealer < 17 && @dealers_cards.count < 3
      send %i[skip one_card_dealer].sample
    else skip
    end
  end

  def six_cards?
    p @players_cards.count, @dealers_cards.count
    if @players_cards.count == 3 && @dealers_cards.count == 3
      p who_wins?
      clear_players_cards
      @score.clear
    else
      false
    end
  end

  def menu_one
    print PLAYERS_MENU_1
    players_choice = gets.chomp.to_i
    case players_choice
    when 1
      skip
      dealer_turn
    when 2
      give_one_card
      score_player
      dealer_turn
      p "Текущие очки игрока #{@players_name}: #{@score.player}"
      :break if six_cards?
    when 3
      p "Карты Дилера: #{@dealers_cards}"
      p "Карты игрока #{@players_name}: #{@players_cards}"
      p who_wins?
      @score.clear
      clear_players_cards
      :break
    end
  end

  def menu_two
    print PLAYERS_MENU_2
    players_choice = gets.chomp.to_i
    case players_choice
    when 1
      skip
      dealer_turn
      :break if six_cards?
    when 2
      show_cards
      p who_wins?
      @score.clear
      clear_players_cards
      :break
    end
  end

  def start
    p 'Введите имя'
    @players_name = gets.chomp
    until @bank.player_cash.zero? || @bank.dealer_cash.zero?
      @deck = CARDS_ARRAY.clone.shuffle!
      p @bank.show_money
      @bank.banking
      p 'Раздача: по две карты каждому.'
      give_two_cards
      score_player
      p "Текущие очки игрока #{@players_name}: #{@score.player}"
      print "____________________________\n"
      give_two_cards
      score_dealer
      print "____________________________\n"
      loop do
        if @players_cards.count < 3
          break if menu_one == :break
        else
          break if menu_two == :break
        end
      end
    end
  end

  def run
    answer = 'да'
    while answer == 'да'
      start
      @bank.reset_money
      p 'Игра закончена. Хотите повторить?  (да/нет)'
      answer = gets.chomp
    end
  end
end

Game.new.run
