require 'byebug'

class Piece
  DELTAS = {
    diagonals: [
      [-1, -1],
      [ 1,  1],
      [ 1, -1],
      [-1,  1]
    ],
    cardinals: [
      [ 1,  0],
      [ 0,  1],
      [-1,  0],
      [ 0, -1]
    ],
    knights: [
      [-2, -1],
      [-2,  1],
      [-1, -2],
      [-1,  2],
      [ 1, -2],
      [ 1,  2],
      [ 2, -1],
      [ 2,  1]
    ]
  }

  attr_reader :board, :color
  attr_accessor :pos

  def initialize(board, starting_pos, color)
    @board = board
    @pos = starting_pos
    @color = color
  end

  def moves
    x, y = pos
    moves = []

    deltas.each do |delta|
      num_steps.times do |step|
        delta_x, delta_y = delta
        x_move = delta_x * (step + 1)
        y_move = delta_y * (step + 1)
        move = [x + x_move, y + y_move]

        break if !possible_move?(move)
        moves << move
      end
    end

    moves
  end

  def possible_move?(pos)
    board.on_board?(pos) && !same_color_piece?(pos)
  end

  def same_color_piece?(pos)
    board[pos].is_a?(Piece) && color == board[pos].color
  end
end

class SlidingPiece < Piece
  def num_steps
    board.size - 1
  end
end

class Rook < SlidingPiece
  def deltas
    DELTAS[:cardinals]
  end
end

class Bishop < SlidingPiece
  def deltas
    DELTAS[:diagonals]
  end
end

class Queen < SlidingPiece
  def deltas
    DELTAS[:diagonals] + DELTAS[:cardinals]
  end
end

class SteppingPiece < Piece
  def num_steps
    1
  end
end

class Knight < SteppingPiece
  def deltas
    DELTAS[:knights]
  end
end

class King < SteppingPiece
  def deltas
    DELTAS[:diagonals] + DELTAS[:cardinals]
  end
end

class Pawn < Piece
  def initialize(starting_pos, board, color)
    super(starting_pos, board, color)
    @first_move = true
  end

  def first_move?
    @first_move
  end

  def moves
    x, y = pos
    moves = [[x + 1, y]]
    attack_deltas = [[1,1], [1,-1]]

    moves << [x + 2, y] if first_move?

    attack_deltas.each do |delta|
      delta_x, delta_y = delta
      move = [x + delta_x, y + delta_y]
      possible_move = board.on_board?(move) && board[move].is_a?(Piece) &&
        board[move].color != color

      moves << move if possible_move
    end

    moves
  end
end
