class Card
  attr_reader :value, :pic

  def initialize(pic, value)
    @pic = pic
    @value = value
  end
end
