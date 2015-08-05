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

      puts "#{current_player.color.to_s.capitalize}'s turn"
      play_turn
      switch_players!
    end

    board.render
    puts "Checkmate!"
  end

  def play_turn
    move = nil
    move = current_player.get_move until valid_move?(move)
    start_pos, end_pos = move
    board.move(start_pos, end_pos)
  end

  def valid_move?(move)
    return false until move

    start_pos = move.first
    board.piece?(start_pos) && board[start_pos].color == current_player.color
  end

  def switch_players!
    @current_player = (current_player == white) ? black : white
  end

  def won?
    [:black, :white].any? { |color| board.checkmate?(color) }
  end
end


#checkmatetest
#6,5, 5,5  - f2, f3
#1,4, 3,4 - e7, e5
#6,6, 4,6 - g2, g4
#0,3 , 4,7  d8, h4 -
