class Knight < Piece
  include Steppable

  def picture
    "\u265E"
  end

  def movements
    [
      [-2, -1],
      [-2, 1],
      [2, -1],
      [2, 1],
      [-1, -2],
      [-1, 2],
      [1, -2],
      [1, 2],
    ]
  end
end