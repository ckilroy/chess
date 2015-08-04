require_relative 'pieces'

class Board
  BOARD_SIZE = 8

  attr_reader :size

  def initialize(size = BOARD_SIZE)
    @size = size
    @grid = Array.new(size) { Array.new(size) }
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos)
    x, y = pos
    grid[x][y] = pos
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, BOARD_SIZE-1) }
  end

  def in_check?(color)

  end

  def pieces(color)
    pieces = []

    (0...BOARD_SIZE).each do |x|
      (0...BOARD_SIZE).each do |y|
       pos = x, y

       pieces << board[pos] if board[pos].is_a?(Piece)
      end
    end

    pieces
  end

  private
  attr_reader :grid
end
