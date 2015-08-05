require_relative 'board'
require_relative 'human_player'

class Game
  attr_reader :board, :white, :black, :current_player

  def initialize(white_player, black_player)
    @board = Board.new
    @white = white_player
    @black = black_player
    @current_player = white
  end

  def setup
    board.populate_grid

  end

  def play
    until won?
      system("clear")
      board.render

      play_turn
      switch_players!
    end
  end

  def play_turn
    move = nil
    move = current_player.get_move until valid_move?(move)
    start_pos, end_pos = move
    board.move(start_pos, end_pos)
  end

  def valid_move?(move)
    move
  end

  def switch_players!
    @current_player = (current_player = white) ? black : white
  end

  def won?
    [:black, :white].any? { |color| board.checkmate?(color) }
  end
end
