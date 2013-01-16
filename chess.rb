#!/usr/bin/env ruby

require 'colorize'
require './pieces.rb'

class Game

end

class GameBoard

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
						print piece.token.blue
					else
						print piece.token.red
					end
					print " |"
				end
			end
			puts
		end
	end

end

class Player
	attr_accessor :pieces_remaining, :player_name

	def initialize(player_name, player_type)
		@player_name = player_name
		@pieces_remaining = []
		add_pawns(player_type)
		add_rooks(player_type)
		add_knights(player_type)
		add_bishops(player_type)
		add_king(player_type)
		add_queen(player_type)
	end

	def add_pawns(player_type)
		(0...8).each do |column|
			row = (player_type == :player1) ? 1 : 6
			@pieces_remaining << Pawn.new([row,column], player_type)
		end
	end

	def add_rooks(player_type)
		[0,7].each do |column|
			row = (player_type == :player1) ? 0 : 7
			@pieces_remaining << Rook.new([row,column], player_type)
		end
	end

	def add_knights(player_type)
		[1,6].each do |column|
			row = (player_type == :player1) ? 0 : 7
			@pieces_remaining << Knight.new([row,column], player_type)
		end
	end

	def add_bishops(player_type)
		[2,5].each do |column|
			row = (player_type == :player1) ? 0 : 7
			@pieces_remaining << Bishop.new([row,column], player_type)
		end
	end

	def add_king(player_type)
		row = (player_type == :player1) ? 0 : 7
		@pieces_remaining << King.new([row,4], player_type)
	end

	def add_queen(player_type)
		row = (player_type == :player1) ? 0 : 7
		@pieces_remaining << Queen.new([row,3], player_type)
	end

end

if __FILE__ == $PROGRAM_NAME
	board = GameBoard.new
	board.print_board
end