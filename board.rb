require 'byebug'
require_relative 'pieces'

class Board
  STARTING_POSITIONS = {
    0 => Rook,
    1 => Knight,
    2 => Bishop,
    3 => Queen,
    4 => King,
    5 => Bishop,
    6 => Knight,
    7 => Rook
  }

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
    piece.pos = end_pos

    piece.first_move_taken if piece.is_a?(Pawn)
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
      piece.moves.any? { |move| move == king.pos }
    end
  end

  def pieces
    grid.flatten.compact
  end

  def dup
    dup = Board.new
    pieces.each { |piece| dup[piece.pos] = piece.dup }

    dup
  end

  def piece?(pos)
    self[pos].is_a?(Piece)
  end

  def checkmate?(color)
    pieces = self.pieces.select { |piece| piece.color == color }

    in_check?(color) && pieces.all? { |piece| piece.valid_moves.empty? }
  end

  def populate_grid
    STARTING_POSITIONS.each do |coord, piece|
      drop_piece(piece, [0, coord],                :black)
      drop_piece(piece, [(BOARD_SIZE - 1), coord], :white)
    end

    (0...BOARD_SIZE).each do |coord|
      drop_piece(Pawn, [1, coord],                :black)
      drop_piece(Pawn, [(BOARD_SIZE - 2), coord], :white)
    end
  end

  def render
    grid.each do |row|
      puts row.map { |space| (space.nil?) ? "_" : space.to_s }.join
    end
  end

  protected
  attr_reader :grid

  private
  def drop_piece(piece, pos, color)
    self[pos] = piece.new(self, pos, color)
  end
end
