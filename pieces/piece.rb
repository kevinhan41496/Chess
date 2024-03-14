class Piece
  attr_reader :color, :board
  attr_accessor :position

  def initialize(color, position, board)
    @color, @position, @board = color, position, board

    board[position] = self
  end

  def display
    " #{picture} ".colorize(color: colorize_color)
  end

  def colorize_color
    color == :white ? :light_white : :black
  end

  def row
    position[0]
  end

  def col
    position[1]
  end

  def valid_moves
    moves.reject { |move| move_to_check?(move) }
  end

  def move_to_check?(move)
    temp_board = board.dup

    temp_board.move_piece!(position, move)

    temp_board.in_check?(color)
  end

  def moves
    []
  end
end