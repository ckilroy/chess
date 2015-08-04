class Board
  BOARD_SIZE = 8

  def initialize(size = BOARD_SIZE)
    @grid = Array.new(size) { Array.new(size) }
  end
end
