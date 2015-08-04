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

  attr_accessor :pos

  def initialize(starting_pos, board)
    @pos = starting_pos
    @board = board
  end
end

class SlidingPiece < Piece

end

class SteppingPiece < Piece

end

class Pawn < Piece

end
