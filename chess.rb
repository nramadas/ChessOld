#!/usr/bin/env ruby

require 'debugger'
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

	def execute_move(player, start_coord, end_coord)
		if valid_move?(player, start_coord, end_coord)
			# Grab what's in the start and end
			start_piece = @board[start_coord[0]][start_coord[1]]
			end_piece = @board[end_coord[0]][end_coord[1]]

			# If the end has an opponent's piece, get rid of it
			if other_player(player).pieces_remaining.include?(end_piece)
				other_player(player).pieces_remaining.delete(end_piece)
			end

			# Move the piece
			@board[start_coord[0]][start_coord[1]] = nil
			@board[end_coord[0]][end_coord[1]] = start_piece
			start_piece.coordinates = end_coord
		else
			puts "invalid move"
		end
	end

	def valid_move?(player, start_coord, end_coord)
		#debugger

		start_piece = @board[start_coord[0]][start_coord[1]]
		end_piece = @board[end_coord[0]][end_coord[1]]

		# Check that player owns the piece at the start_coord
		return false unless player.pieces_remaining.include?(start_piece)

		# Check that player doesn't own the piece at the end_coord
		return false if player.pieces_remaining.include?(end_piece)

		# Make sure that the piece can move in that way
		possible_moves = start_piece.get_moves

		move_to_eval = possible_moves.select { |move| move[:coord] == end_coord }[0]
		return false if move_to_eval.nil?

		# Special bit if piece is a Pawn
		if start_piece.is_a?(Pawn)
			if move_to_eval[:coord][1] != start_coord[1] # trying to move diagonally
				return false if end_piece.nil? # Just make sure a piece is there. We
				# already check that it isn't ours above
				return true
			else
				return path_clear?(move_to_eval[:prev_move]) if end_piece.nil?
				return false
			end
		end

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
			return path_clear?(move[:prev_move])
		end
	end

	def other_player(player)
		player == @player1 ? @player2 : @player1
	end
end

if __FILE__ == $PROGRAM_NAME
	board = GameBoard.new
	board.print_board
	# puts board.board[6][3].get_moves

	# puts board.valid_move?(board.player1, [1, 1], [2, 1])
	# puts board.valid_move?(board.player1, [1, 1], [2, 2])
	# puts board.valid_move?(board.player1, [1, 1], [1, 2])
	# puts board.valid_move?(board.player1, [1, 1], [0, 2])
	# puts board.valid_move?(board.player1, [1, 1], [0, 1])
	# puts board.valid_move?(board.player1, [1, 1], [3, 1])

	# puts board.valid_move?(board.player1, [0, 2], [0, 1])
	# puts board.valid_move?(board.player1, [0, 2], [1, 1])
	# puts board.valid_move?(board.player1, [0, 2], [2, 0])
	# puts board.valid_move?(board.player1, [0, 2], [1, 3])
	# puts board.valid_move?(board.player1, [0, 2], [2, 4])
	# puts board.valid_move?(board.player1, [0, 2], [5, 5])
	board.execute_move(board.player2, [6,0], [4,0])
	board.print_board
	board.execute_move(board.player2, [4,0], [3,0])
	board.print_board
	board.execute_move(board.player2, [3,0], [2,0])
	board.print_board
	board.execute_move(board.player2, [2,0], [1,1])
	board.print_board
	board.execute_move(board.player1, [0,2], [1,1])
	board.print_board
	board.execute_move(board.player1, [1,1], [6,6])
	board.print_board
	board.execute_move(board.player2, [7,6], [5,6])
	board.print_board
	board.execute_move(board.player2, [7,6], [5,5])
	board.print_board
end