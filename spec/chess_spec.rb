require "rspec"
require "chess"

describe GameBoard do
  let(:gameboard) { GameBoard.new }

	context "Pawns move correctly" do
    before(:each) do
      gameboard.execute_move(gameboard.player1, [1,0], [2,0])
    end

		it "only moves forward" do
      gameboard.execute_move(gameboard.player1, [2,0], [1,0]).should be_false
    end

		it "can move two spaces on the first move" do
      gameboard.execute_move(gameboard.player1, [1,1], [3,1]).should be_true
    end

		it "can only move one space after the first move" do
      gameboard.execute_move(gameboard.player1, [2,0], [4,0]).should be_false
    end
	end

	context "Pawns capture correctly" do
    before(:each) do
      gameboard.execute_move(gameboard.player1, [1,0], [3,0])
      gameboard.execute_move(gameboard.player2, [6,1], [4,1])
      gameboard.execute_move(gameboard.player2, [6,0], [4,0])
    end

		it "can capture diagonally" do
      gameboard.execute_move(gameboard.player1, [3,0], [4,1])
      gameboard.player2.pieces_remaining.count.should == 15
    end

		it "cannot capture straight" do
      gameboard.execute_move(gameboard.player1, [3,0], [4,0]).should be_false
    end
	end

  context "Rooks move and capture correctly" do
    before(:each) do
      gameboard.execute_move(gameboard.player1, [1,0], [3,0])
      gameboard.execute_move(gameboard.player1, [0,0], [2,0])
    end

    it "can move horizontally" do
      gameboard.execute_move(gameboard.player1, [2,0], [2,7]).should be_true
    end

    it "can move vertically" do
      gameboard.execute_move(gameboard.player1, [2,0], [2,7])
      gameboard.execute_move(gameboard.player1, [2,7], [5,7]).should be_true
    end

    it "can move backwards" do
      gameboard.execute_move(gameboard.player1, [2,0], [0,0]).should be_true
    end

    it "cannot move diagonally" do
      gameboard.execute_move(gameboard.player1, [2,0], [4,2]).should be_false
    end

    it "can capture" do
      gameboard.execute_move(gameboard.player1, [2,0], [2,7])
      gameboard.execute_move(gameboard.player1, [2,7], [6,7])
      gameboard.player2.pieces_remaining.count.should == 15
    end
  end

  context "Bishops move and capture correctly" do
    before(:each) do
      gameboard.execute_move(gameboard.player1, [1,1], [2,1])
      gameboard.execute_move(gameboard.player1, [1,2], [3,2])
      gameboard.execute_move(gameboard.player1, [1,3], [2,3])
    end

    it "can move diagonally left" do
      gameboard.execute_move(gameboard.player1, [0,2], [2,0]).should be_true
    end

    it "can move diagonally right" do
      gameboard.execute_move(gameboard.player1, [0,2], [2,4]).should be_true
    end

    it "cannot move in a straightline" do
      gameboard.execute_move(gameboard.player1, [0,2], [1,2]).should be_false
    end

    it "can move backwards" do
      gameboard.execute_move(gameboard.player1, [0,2], [2,0])
      gameboard.execute_move(gameboard.player1, [2,0], [0,2]).should be_true
    end

    it "can capture" do
      gameboard.execute_move(gameboard.player1, [0,2], [2,0])
      gameboard.execute_move(gameboard.player1, [2,0], [6,4])
      gameboard.player2.pieces_remaining.count.should == 15
    end
  end

  context "Knights move and capture correctly" do
    it "moves knight-like to the left" do
      gameboard.execute_move(gameboard.player1, [0,1], [2,0]).should be_true
    end

    it "moves knight-like to the right" do
      gameboard.execute_move(gameboard.player1, [0,1], [2,2]).should be_true
    end

    it "cannot move any other way" do
      gameboard.execute_move(gameboard.player1, [1,1], [3,1])
      gameboard.execute_move(gameboard.player1, [0,1], [1,1]).should be_false
    end

    it "can move backwards" do
      gameboard.execute_move(gameboard.player1, [0,1], [2,0])
      gameboard.execute_move(gameboard.player1, [2,0], [0,1]).should be_true
    end

    it "can capture" do
      gameboard.execute_move(gameboard.player1, [0,1], [2,0])
      gameboard.execute_move(gameboard.player1, [2,0], [4,1])
      gameboard.execute_move(gameboard.player1, [4,1], [6,0])
      gameboard.player2.pieces_remaining.count.should == 15
    end
  end

  context "King moves and captures correctly" do
    before(:each) do
      gameboard.execute_move(gameboard.player1, [1,4], [3,4])
    end

    it "can move one space forward" do
      gameboard.execute_move(gameboard.player1, [0,4], [1,4]).should be_true
    end

    it "can move one space diagonal" do
      gameboard.execute_move(gameboard.player1, [0,4], [1,4])
      gameboard.execute_move(gameboard.player1, [1,4], [2,3]).should be_true
    end

    it "can move backwards" do
      gameboard.execute_move(gameboard.player1, [0,4], [1,4])
      gameboard.execute_move(gameboard.player1, [1,4], [0,4]).should be_true
    end

    it "can capture" do
      gameboard.execute_move(gameboard.player2, [6,6], [4,6])
      gameboard.execute_move(gameboard.player2, [4,6], [3,6])
      gameboard.execute_move(gameboard.player2, [3,6], [2,6])
      gameboard.execute_move(gameboard.player2, [2,6], [1,5])
      gameboard.execute_move(gameboard.player1, [0,4], [1,5])
      gameboard.player2.pieces_remaining.count.should == 15
    end
  end

  context "Queen moves and captures correctly" do
    before(:each) do
      gameboard.execute_move(gameboard.player1, [1,2], [2,2])
      gameboard.execute_move(gameboard.player1, [1,3], [3,3])
      gameboard.execute_move(gameboard.player1, [1,4], [2,4])
    end

    it "can move in straight lines" do
      gameboard.execute_move(gameboard.player1, [0,3], [2,3]).should be_true
    end

    it "can move diagonally" do
      gameboard.execute_move(gameboard.player1, [0,3], [4,7]).should be_true
    end

    it "can move backwards" do
      gameboard.execute_move(gameboard.player1, [0,3], [4,7])
      gameboard.execute_move(gameboard.player1, [4,7], [0,3]).should be_true
    end

    it "can capture" do
      gameboard.execute_move(gameboard.player1, [0,3], [4,7])
      gameboard.execute_move(gameboard.player1, [4,7], [6,7])
      gameboard.player2.pieces_remaining.count.should == 15
    end
  end

  context "No friendly fire" do
    it "cannot capture own piece" do
      gameboard.execute_move(gameboard.player1, [0,0], [1,0]).should be_false
    end

    it "pieces other than Knights cannot jump piece" do
      gameboard.execute_move(gameboard.player1, [0,0], [2,0]).should be_false
    end
  end

  context "No cheating" do
    it "Cannot move other player's pieces" do
      gameboard.execute_move(gameboard.player1, [6,0], [4,0]).should be_false
    end
  end

  context "Check" do
    before(:each) do
      gameboard.execute_move(gameboard.player2, [6,4], [4,4])
      gameboard.execute_move(gameboard.player2, [4,4], [3,4])
      gameboard.execute_move(gameboard.player2, [3,4], [2,4])
    end

    it "Can put a player in check" do
      gameboard.execute_move(gameboard.player2, [2,4], [1,3])
      gameboard.should be_check(gameboard.player1)
    end

    it "Cannot move into a check" do
      gameboard.execute_move(gameboard.player1, [1,3], [3,3])
      gameboard.execute_move(gameboard.player1, [0,4], [1,3]).should be_false
    end

    it "Cannot move ignoring a check" do
      gameboard.execute_move(gameboard.player2, [2,4], [1,3])
      gameboard.execute_move(gameboard.player2, [1,0], [3,0]).should be_false
    end

    it "Can exit a check" do
      gameboard.execute_move(gameboard.player2, [2,4], [1,3])
      gameboard.execute_move(gameboard.player1, [0,3], [1,3])
      gameboard.should_not be_check(gameboard.player1)
    end
  end

  context "Checkmate" do
    it "Can put a player into checkmate" do
      gameboard.execute_move(gameboard.player2, [6,5], [5,5])
      gameboard.execute_move(gameboard.player2, [6,6], [4,6])
      gameboard.execute_move(gameboard.player1, [1,4], [2,4])
      gameboard.execute_move(gameboard.player1, [0,3], [4,7])
      gameboard.should be_checkmate(gameboard.player2)
    end
  end

end