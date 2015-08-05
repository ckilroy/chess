require 'byebug'

class Piece
  WHITE_PIECES = {
    king: "♔",
    queen: "♕",
    rook: "♖",
    bishop: "♗",
    knight: "♘",
    pawn: "♙"
  }

  BLACK_PIECES = {
    king: "♚",
    queen: "♛",
    rook: "♜",
    bishop: "♝",
    knight: "♞",
    pawn: "♟"
  }

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
    ],
    pawns: [
      [-1, 0],
      [-2, 0]
    ],
    pawns_attack: [
      [-1, -1],
      [ 1,  1]
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

        if possible_move?(move)
          if same_color_piece?(move)
            break
          elsif opponent?(move)
            moves << move
            break
          else
            moves << move
          end
        else
          break
        end
      end
    end

    moves
  end

  def possible_move?(pos)
    board.on_board?(pos)
  end

  def piece?(pos)
    board[pos].is_a?(Piece)
  end

  def same_color_piece?(pos)
    piece?(pos) && color == board[pos].color
  end

  def opponent?(pos)
    !same_color_piece?(pos)
  end

  def to_s
    piece = self.class.to_s.downcase.to_sym
    color == :white ? WHITE_PIECES[piece] : BLACK_PIECES[piece]
  end

  def valid_moves
    test_board = board.dup

    piece.moves.reject do |end_move|
      test_board.move(pos, end_move)
      invalid_move = test_board.in_check?(color)
      test_board.move(end_move, pos)

      invalid_move
    end
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
    get_deltas
  end

  def first_move?
    @first_move
  end

  def moves
    moves = []
    base_deltas = (first_move?) ? move_deltas : move_deltas.drop(1)

    base_deltas.each do |delta|
      move = get_move(pos, delta)
      possible_move = board.on_board?(move) && !piece?(move)

      (possible_move) ? moves << move : break
    end

    attack_deltas.each do |delta|
      move = get_move(pos, delta)
      possible_move = board.on_board?(move) && opponent?(move)

      moves << move if possible_move
    end

    moves
  end

  private
  attr_reader :move_deltas, :attack_deltas

  def get_deltas
    @move_deltas = DELTAS[:pawns]
    @attack_deltas = DELTAS[:pawns_attack]

    if color == :black
      [move_deltas, attack_deltas].each do |delta_set|
        delta_set.map! do |delta|
          delta.map { |el| -el }
        end
      end
    end
  end

  def get_move(pos, deltas)
    x, y = pos
    delta_x, delta_y = deltas

    [x + delta_x, y + delta_y]
  end
end
