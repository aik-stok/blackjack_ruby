class Score
  attr_accessor :player, :dealer

  def initialize
    @player = 0
    @dealer = 0
  end

  def show
    "Очки. Игрок: #{@player}, Дилер: #{@dealer}"
  end

  def clear
    @player = 0
    @dealer = 0
  end

  def points_calc(value, score)
    if value.nil?
      score < 11 ? 11 : 1
    else
      value
    end
  end

  def calc_player(value)
    self.player += points_calc(value, self.player)
  end

  def calc_dealer(value)
    self.dealer += points_calc(value, self.dealer)
  end
end
