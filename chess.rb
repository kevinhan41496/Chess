require 'colorize'

class Board
  attr_reader :grid
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    set_up_pieces
  end

  def display
    @grid.each_with_index do |row, i|
      row.each_with_index do |spot, j|

        background = :white if (i+j).even?
        background = :black if (i+j).odd?

        print "   ".colorize(background: background) if spot.nil?
        print spot.display.colorize(background: background) unless spot.nil?
      end
      puts
    end
  end

  def set_piece(piece, coordinate)
    row, column = coordinate.chars.map(&:to_i)

    @grid[row][column] = piece
  end

  def get_piece(coord)
    row, column = coord.chars.map(&:to_i)

    @grid[row][column]
  end

  def set_up_pieces
    (10..17).each do |coord|
      set_piece(Pawn.new("black"), coord.to_s)
    end
    set_piece(Rook.new("black"), "00")
    set_piece(Rook.new("black"), "07")
    set_piece(King.new("black"), "51")

    (60..67).each do |coord|
      set_piece(Pawn.new("white"), coord.to_s)
    end

    set_piece(Rook.new("white"), "70")
    set_piece(Rook.new("white"), "77")
    set_piece(King.new("white"), "71")
  end

  def move_piece(start_coord, end_coord, whites_turn)
    start_row, start_column = start_coord.chars.map(&:to_i)
    end_row, end_column = end_coord.chars.map(&:to_i)

    piece = @grid[start_row][start_column]

    return false if piece.nil?
    return false if piece.color == 'black' && whites_turn
    return false if piece.color == 'white' && !whites_turn
    return false unless piece.valid_move?(start_coord, end_coord, self)

    @grid[start_row][start_column] = nil
    @grid[end_row][end_column] = piece
  end

  def in_check?(color)
    @grid.each_with_index do |row, i|
      row.each_with_index do |spot, j|
        next if spot.nil?
        next unless spot.class == Pawn
        next if spot.color == color

        return true if spot.is_attacking?("#{i}#{j}", self)
      end
    end

    false
  end
end

class Pawn
  def initialize(color)
    @color = color
  end

  def display
    return " \u265F ".colorize(color: :light_white) if @color == 'white'
    return " \u265F ".colorize(color: :light_black) if @color == 'black'
  end

  def valid_move?(from, to, board)
    from_row, from_column = from.chars.map(&:to_i)
    to_row, to_column = to.chars.map(&:to_i)

    return true if from_row + direction == to_row && from_column == to_column

    moving_diagonally = from_row + direction == to_row && (from_column + 1 == to_column || from_column -1 == to_column)
    piece = board.get_piece(to)
    return true if moving_diagonally && !piece.nil? && piece.color != @color

    false
  end

  def is_attacking?(coord,board)
    coord_row, coord_column = coord.chars.map(&:to_i)

    piece_1 = board.get_piece("#{coord_row + direction}#{coord_column + 1}")
    piece_2 = board.get_piece("#{coord_row + direction}#{coord_column - 1}")

    return true if !piece_1.nil? && piece_1.class == King && piece_1.color != @color
    return true if !piece_2.nil? && piece_2.class == King && piece_2.color != @color

    false
  end

  def color
    @color
  end

  def direction
    @color == "white" ? -1 : 1
  end
end

class Rook
  def initialize(color)
    @color = color
  end

  def display
    return " \u265C ".colorize(color: :light_white) if @color == 'white'
    return " \u265C ".colorize(color: :light_black) if @color == 'black'
  end

  def color
    @color
  end
end

class King
  def initialize(color)
    @color = color
  end

  def display
    return " \u265A ".colorize(color: :light_white) if @color == 'white'
    return " \u265A ".colorize(color: :light_black) if @color == 'black'
  end

  def color
    @color
  end
end