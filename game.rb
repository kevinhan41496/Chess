require_relative 'board'

class Game
  attr_reader :board, :current_player

  ROW_HASH = (1..8).to_a.map(&:to_s).zip((0..7).to_a.reverse).to_h
  COL_HASH = ("a".."h").to_a.zip((0..7).to_a).to_h

  def initialize
    @board = Board.new
    @current_player = :white
  end

  def play
    until board.checkmate?(current_player)
      board.display
      begin
        puts "#{current_player}'s turn."
        puts "Enter position of piece:"
        start_pos = to_coord(gets.chomp)
        puts "Enter position to move:"
        end_pos = to_coord(gets.chomp)

        board.move_piece(current_player, start_pos, end_pos)

        swap_turn!
      rescue StandardError => e
        puts e.message
        retry
      end
    end
    board.display
    puts "#{current_player} is checkmated."

    nil
  end

  private

  def swap_turn!
    @current_player = (current_player == :white) ? :black : :white
  end

  def to_coord(input)
    unless input.length == 2 && input[0].between?("a", "h") && input[1].between?("1", "8")
      raise "Invalid input. Please enter a position on the board (e.g. a2)."
    end

    [ROW_HASH[input[1]], COL_HASH[input[0]]]
  end

end

Game.new.play if __FILE__ == $PROGRAM_NAME