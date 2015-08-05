class Game
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def setup
    board.populate_grid
  end

  def play
    until won?
    end
  end

  def won?
    [:black, :white].any? { |color| board.checkmate?(color) }
  end
end
