class Player
  attr_accessor :hand, :name

  def initialize(name)
    @name = name
    @hand = Hand.new
  end
end
