module Steppable
  def moves
    moves = []
    movements.each do |movement|
      move = [row + movement[0], col + movement[1]]
      moves << move if board.on?(move) && (board[move].nil? || board[move].color != color)
    end

    moves
  end
end