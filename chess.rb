class Game

end

class GameBoard

	def initialize
		@board = Array.new(8) { Array.new(8) { nil } }
	end

	def place_pawns

	end


end

class Piece
	def initialize(coordinates)
		@coordinates = coordinates
		@captured = false
	end

end

class Pawn < Piece

end

class Rook < Piece

end

class Bishop < Piece

end

class Knight < Piece

end

class King < Piece

end

class Queen < Piece

end