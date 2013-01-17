#!/usr/bin/env ruby

require 'colorize'
require './pieces.rb'
require './player.rb'

class Game

end

class GameBoard
	attr_reader :board, :player1, :player2

	def initialize
		@board = Array.new(8) { Array.new(8) { nil } }
		@player1 = Player.new("Bill", :player1)
		@player2 = Player.new("Charlie", :player2)
		build_board([@player1, @player2])
	end

	def build_board(players)
		players.each do |player|
			player.pieces_remaining.each do |piece|
				row, col = piece.coordinates

				@board[row][col] = piece
			end
		end
	end

	def print_board
		puts "  \u2009 0  1  2  3  4  5  6  7"
		@board.each_with_index do |row, row_index|
			print "#{row_index} |"
			row.each_with_index do |piece, col_index|
				print "\u0332" unless col_index==0
				if piece.nil?
					print "  |"
				else
					if piece.player_type == :player1
						print piece.token.red
					else
						print piece.token.yellow
					end
					print " |"
				end
			end
			puts
		end
	end

	def valid_move?(player, start_coord, end_coord)
		piece = @board[start_coord[0]][start_coord[1]]

		# Check that player owns the piece at the start_coord
		unless player.pieces_remaining.include?(piece)
			return false
		end

		# Check that player doesn't own the piece at the end_coord
		if player.pieces_remaining.include?(piece)
			return false
		end

		# Make sure that the piece can move in that way
		case piece.is_a?
		when Pawn

		else
			possible_moves = piece.get_moves
		end

		move_to_eval = possible_moves.select { |move| move[:coord] == end_coord }[0]
		return false if move_to_eval.nil?

		# Make sure that the path is clear for the piece to move
		return path_clear?(move_to_eval[:prev_move])

	end

	def path_clear?(move)
		row, col = move[:coord]

		if move[:prev_move].nil?
			return true
		elsif !@board[row][col].nil?
			return false
		else
			return path_blocked?(move[:prev_move])
		end
	end
end



include CalculateMoves

if __FILE__ == $PROGRAM_NAME
	board = GameBoard.new
	board.print_board
	puts board.board[6][3].get_moves
	# puts board.valid_move?(board.player1, [1, 0], [2, 0])
	# puts board.valid_move?(board.player1, [1, 0], [2, 1])
	# puts board.valid_move?(board.player1, [1, 0], [1, 1])
	# puts board.valid_move?(board.player1, [1, 0], [0, 1])
	# puts board.valid_move?(board.player1, [1, 0], [0, 0])
	# puts board.valid_move?(board.player1, [1, 0], [3, 0])

	# puts board.valid_move?(board.player1, [0, 2], [0, 1])
	# puts board.valid_move?(board.player1, [0, 2], [1, 1])
	# puts board.valid_move?(board.player1, [0, 2], [2, 0])
	# puts board.valid_move?(board.player1, [0, 2], [1, 3])
	#puts board.valid_move?(board.player1, [0, 2], [2, 4])
	# puts board.valid_move?(board.player1, [0, 2], [5, 5])



end