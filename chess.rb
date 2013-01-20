#!/usr/bin/env ruby

require 'debugger'
require 'colorize'
require 'YAML'
require_relative 'lib/pieces.rb'
require_relative 'lib/player.rb'
require_relative 'lib/gameboard.rb'

class Game
	def initialize
		@game_board = GameBoard.new
	end

	def play
		while true
			# Play function split up this way so that @player1 and @player2
			# are properly refreshed after every restore. Also, it allows us
			# to print text in two colors.

			@game_board.print_board
			while true
				if @game_board.check?(@game_board.player1)
					if @game_board.checkmate?(@game_board.player1)
						puts "Checkmate! Player 1 loses.".red
						return
					else
						puts "Player 1 in check.".red
					end
				end
				puts "Player 1 (top) please move...".red
				move = @game_board.player1.get_move
				break if @game_board.execute_move(@game_board.player1, move[0], move[1])
				puts "Invalid move, try again.".red
			end

			@game_board.print_board
			while true
				if @game_board.check?(@game_board.player2)
					if @game_board.checkmate?(@game_board.player2)
						puts "Checkmate! Player 2 loses.".yellow
						return
					else
						puts "Player 2 in check.".yellow
					end
				end
				puts "Player 2 (bottom) please move...".yellow
				move = @game_board.player2.get_move
				break if @game_board.execute_move(@game_board.player2, move[0], move[1])
				puts "Invalid move, try again.".yellow
			end
		end
	end
end

if __FILE__ == $PROGRAM_NAME
	game = Game.new
	game.play
end