
class MyRational

    def initialize (num, den=1)
        if den == 0
            raise "MyRational received an inappropiate argument"
        elsif den < 0
            @num = - num
            @den = - den
        else 
            @num = num
            @den = den
        end
        reduce() # i.e. self.reduce() but private
    end

    def to_s ()
        ans = @num.to_s()
        if @den != 1
            ans += "/"
            ans += @den.to_s()
        end
        ans
    end
    
    def to_s2 ()
        dens = ""
        dens = "/" + @den.to_s() if @den != 1 #funny if syntax
        @num.to_s + dens
    end

    def to_s3 ()  #using things like Racket's quasiquote and unquote
        "#{@num}#{if @den==1 then "" else "/" + @den.to_s() end}"
    end

    def add! (r) #mutate self in-place
        a = r.num() # only works b/c of protected methods bellow
        b = r.den() # only works b/c of protected methods bellow
        c = @num
        d = @den
        @num = (a * d) + (b * c)
        @den = b * d
        reduce()
        self # convenient for stinging calls
    end

    # a functional addition, so we can write r1. + r2 to
    # make a new rational
    # and built-in syntactic sugar will work: cna write r1 + r2
    def + (r)
        ans = MyRational.new(@num,@den)
        ans.add!(r)
        ans
    end

    protected
    # there is very common sugar for this (attr_reader)
    # the better way:
    # attr_reader :num, :den
    # protected :num, :den
    # we do not want these methods public,
    # but we cannot make them private
    # beacause of the add! method above
    def num ()
        @num
    end

    def den ()
        @den
    end

    private
    def gcd (x,y) # recursive method calls work as expected
        if x == y
            x
        elsif x < y
            gcd(x,y-x)
        else
            gcd(y,x)
        end
    end

    def reduce ()
        if @num == 0
            @den = 1
        else
            d = gcd(@num.abs, @den) #notice method call on number
            @num = @num / d
            @den = @den / d
        end
    end
end

# top-level method (just part of Object class) for testing
def use_rationals ()
    r1 = MyRational.new(3,4)
    r2 = r1 + r1 + MyRational.new(-5,2)
    puts(r2.to_s())
    (r2.add!(r1)).add!(MyRational.new(1,-4))
    puts(r2.to_s())
    puts(r2.to_s2())
    puts(r2.to_s3())
end