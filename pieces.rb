class Piece
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
