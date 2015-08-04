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
    ]
  }

  attr_reader :board
  attr_accessor :pos


  def initialize(starting_pos, board)
    @pos = starting_pos
    @board = board
  end
end

class SlidingPiece < Piece
  def moves
    x, y = pos
    moves = []

    directions.each do |direction|
      DELTAS[direction].each do |delta|
        delta_x, delta_y = delta
        move = [x + delta_x, y + delta_y]

        distance = 1
        while board.on_board?(move)
          moves << move

          distance += 1
          x_move = delta_x * distance
          y_move = delta_y * distance
          move = [x + x_move, y + y_move]
        end
      end
    end

    moves
  end
end

class Rook < SlidingPiece
  def directions
    [:cardinals]
  end
end

class Bishop < SlidingPiece
  def directions
    [:diagonals]
  end
end

class Queen < SlidingPiece
  def directions
    [:diagonals, :cardinals]
  end
end

class SteppingPiece < Piece

end

class Knight < SteppingPiece
end

class King < SteppingPiece
end

class Pawn < Piece

end
