
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

class ThreeDPoint < Point
    attr_accessor :z

    def initialize (x,y,z)
        super(x,y)
        @z = z
    end

    def distFromOrigin ()
        d = super()
        Math.sqrt(d*d + @z*@z)
    end

    def distFromOrigin2 ()
        d = super ()
        Math.sqrt(d*d + z*z)
    end
end

class PolarPoint < Point
    # By not calling super constructor, no x and y instance vars 
    # In Java/C#/Samlltalk would just have unused x, y fields
    def initialize (r,theta)
        @r = r
        @theta = theta
    end

    def x ()
        @r * Math.cos(@theta)
    end

    def y ()
        @r * Math.sin(@theta)
    end

    def x= (a)
        b = y #avoids multiple calls to y method
        @theta = Math.atan(b / a)
        @r = Math.sqrt(a*a + b*b)
        self
    end

    def y= (b)
        a = x #avoid multiple calls to x method
        @theta = Math.atan(b / a)
        @r = Math.sqrt(a*a + b*b)
        self
    end

    def distFromOrigin () # must override
        @r
    end
    # inherited distFromOrigin2 already works!!!
end

