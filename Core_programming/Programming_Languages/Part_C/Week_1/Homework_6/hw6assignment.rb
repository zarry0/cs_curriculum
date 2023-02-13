# University of Washington, Programming Languages, Homework 6, hw6runner.rb

class MyPiece < Piece
    # The constant All_My_Pieces should be declared here
    All_My_Pieces = All_Pieces + 
    [rotations([ [0,0], [1,0], [0,1], [1,1], [-1,0] ]),   # sideways P
      [ [ [0,0], [-1,0], [1,0], [2,0], [3,0] ],           # 5 square line
        [ [0,0], [0,-1], [0,1], [0,2], [0,3] ] ],
      rotations([ [0,0], [0,1], [1,0] ])]                 # corner
    
    # your enhancements here
    def self.next_piece (board)
      if !(board.cheat_active)
        MyPiece.new(All_My_Pieces.sample, board)
      else
        board.cheat_active = false
        MyPiece.new([ [[0,0]] ], board)
      end
    end
  end
  
  class MyBoard < Board
    # your enhancements here
    attr_accessor :cheat_active

    def initialize (game)
      super
      @current_block = MyPiece.next_piece(self)
      @cheat_active = false
    end

    def store_current
      locations = @current_block.current_rotation
      displacement = @current_block.position
      n = locations.length() - 1
      (0..n).each{|index| 
        current = locations[index];
        @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
        @current_pos[index]
      }
      remove_filled
      @delay = [@delay - 2, 80].max
    end

    def next_piece
      @current_block = MyPiece.next_piece(self)
      @current_pos = nil
    end

    # rotates the current piece 180 deg
    def rotate_180 
      if !game_over? and @game.is_running?
        @current_block.move(0, 0, 2)
      end
      draw
    end

    def cheat
      if !game_over? and @game.is_running?
        if @score >= 100 and !@cheat_active
          @score -= 100
          @cheat_active = true
        end
      end
      draw
    end

  end
   
  class MyTetris < Tetris
    # your enhancements here

    def set_board
      @canvas = TetrisCanvas.new
      @board = MyBoard.new(self)
      @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
      @board.draw
    end

    # maps keys to actions defined as methods in MyBoard class
    def key_bindings 
      super
      @root.bind('u', proc {@board.rotate_180})
      @root.bind('c', proc {@board.cheat})
    end
  end