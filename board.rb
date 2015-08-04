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

  def []=(pos, piece)
    x, y = pos
    grid[x][y] = piece
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, BOARD_SIZE-1) }
  end

  def in_check?(color)
    king = pieces.select do |piece|
      piece.is_a?(King) && piece.color == color
    end

    opposing_pieces = pieces.reject { |piece| piece.color == color }

    opposing_pieces.any? do |piece|
      piece.moves.any? do |move|
        self[move] == king
      end
    end
  end

  def pieces
    pieces = []

    (0...BOARD_SIZE).each do |x|
      (0...BOARD_SIZE).each do |y|
       pos = x, y

       pieces << self[pos] if self[pos].is_a?(Piece)
      end
    end

    pieces
  end

  private
  attr_reader :grid
end
