class HumanPlayer

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def play_turn
    start_pos = get_coords("Choose the coordinates of the piece you want to move.")
    end_pos = get_coords("Where would you like to move this piece?")
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
