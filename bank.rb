class Bank
  attr_reader :dealer_cash, :player_cash

  def initialize
    reset_money
  end

  def reset_money
    @dealer_cash = 100
    @player_cash = 100
  end

  def show_money
    "Деньги игроков. Дилер: #{@dealer_cash}$, Игрок: #{@player_cash}$\n"
  end

  def banking
    @dealer_cash -= 10
    @player_cash -= 10
  end

  def draw
    @dealer_cash += 10
    @player_cash += 10
  end

  def award_player
    @player_cash += 20
  end

  def award_dealer
    @dealer_cash += 20
  end
end
