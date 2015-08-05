class HumanPlayer

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def get_move
    start_pos = get_coords("Choose the coordinates of the piece you want to move.")
    end_pos = get_coords("Where would you like to move this piece?")

    [start_pos, end_pos]
  end

  def get_coords(prompt)
    puts prompt
    coords = gets.chomp.split(",").map { |coord| Integer(coord) }
  rescue ArgumentError
    puts "Try again."
    retry
      #is there a piece there? is it my color?
  end
end
