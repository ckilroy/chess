require 'byebug'
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

  def move(start_pos, end_pos)
    piece = self[start_pos]

    if piece.nil?
      raise ArgumentError.new "Nil starting piece"
    elsif !piece.moves.include?(end_pos)
      raise ArgumentError.new "Invalid move"
    end

    self[start_pos] = nil
    self[end_pos] = piece
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, BOARD_SIZE-1) }
  end

  def in_check?(color)
    king = pieces.find do |piece|
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
    grid.flatten.compact
  end

  private
  attr_reader :grid
end
