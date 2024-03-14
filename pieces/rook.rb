require_relative "piece"
class Rook < Piece
    def picture
    "\u265C"
    end

    def valid_move?(to)
    return false unless super

    from_row, from_column = position
    to_row, to_column = to

    return true if from_column == to_column || from_row == to_row
  end
end