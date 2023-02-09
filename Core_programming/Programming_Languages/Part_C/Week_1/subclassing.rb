
class Point
    attr_accessor :x, :y # defines methods x, y, x=, y=

    def initialize (x,y)
        @x = x
        @y = y
    end

    def distFromOrigin ()
        Math.sqrt(@x * @x + @y * @y) #uses instance variables
    end

    def distFromOrigin2 ()
        Math.sqrt(x * x + y * y) #uses gettr methods
    end
end

class ColorPoint < Point
    attr_accessor :color #defines methods color, color=

    def initialize (x,y,c="clear")
        super(x,y) #keyword super calls same method in superclass
        @color = c
    end
end
