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

  attr_reader :board
  attr_accessor :pos

  def initialize(starting_pos, board)
    @pos = starting_pos
    @board = board
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

        break if !valid_move?(move)
        moves << move
      end
    end

    moves
  end

  def valid_move?(pos)
    board.on_board?(pos) #&& !board[pos].is_a?(Piece)
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

end
