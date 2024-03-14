require "colorize"
require_relative "pieces"

class Board

  def initialize(fill_board = true)
    @rows = Array.new(8) { Array.new(8) }
    set_up_pieces if fill_board
  end

  def []=(position, piece)
    row, col = position
    @rows[row][col] = piece
  end

  def [](position)
    row, col = position
    @rows[row][col]
  end

  def checkmate?(color)
    own_pieces = pieces.filter{ |piece| piece.color == color }

    own_pieces.map(&:valid_moves).flatten.empty?
  end

  def move_piece(turn_color, start_pos, end_pos)
    piece = self[start_pos]

    raise 'must move a piece' if piece.nil?
    raise 'can\'t move opponent\'s piece' unless turn_color == piece.color
    raise 'can\'t move piece like that' unless piece.valid_moves.include?(end_pos)

    self[start_pos] = nil
    self[end_pos] = piece
    piece.position = end_pos
  end

  def move_piece!(start_pos, end_pos)
    piece = self[start_pos]

    self[start_pos] = nil
    self[end_pos] = piece
    piece.position = end_pos
  end

  def in_check?(color)
    enemy_pieces = pieces.reject {|piece| piece.color == color}

    enemy_pieces.each do |piece|
      return true if piece.moves.include?(king_position(color))
    end

    false
  end

  def king_position(color)
    king = pieces.find { |piece| piece.color == color && piece.class == King }

    king.position
  end

  def display
    @rows.each_with_index do |row, i|
      row.each_with_index do |square, j|
        bg = (i + j).even? ? :white : :light_black
        piece_display = square.nil? ? "   " : square.display
        print piece_display.colorize(background: bg)
      end
      puts
    end
  end

  def on?(end_pos)
    end_row, end_col = end_pos

    end_row.between?(0,7) && end_col.between?(0,7)
  end

def pieces
    @rows.flatten.reject { |square| square.nil? }
  end

  def dup
    temp_board = Board.new(false)

    pieces.each do |piece|
      piece.class.new(piece.color, piece.position, temp_board)
    end

    temp_board
  end

  private

  def set_up_pieces
    (0..7).each { |i| Pawn.new(:white, [6,i], self) }
    [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook].each_with_index do |piece, i|
      piece.new(:white, [7,i], self)
    end

    (0..7).each { |i| Pawn.new(:black, [1,i], self) }
    [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook].each_with_index do |piece, i|
      piece.new(:black, [0,i], self)
    end

    Pawn.new(:white, [2,4], self)
    # Knight.new(:white, [3,4], self)
  end
end