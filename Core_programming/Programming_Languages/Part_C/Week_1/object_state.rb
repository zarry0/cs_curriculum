class A

    def initialize(f=0)
        @foo = f
    end

    def m1 ()
        @foo = 0
    end

    def m2 (x)
        @foo += x
    end

    def foo ()
        @foo
    end
end

class C 
    # we now add in a class-variable, class-constant, and class-method

    Dans_Age = 38  #class-constant

    def self.reset_bar () # class-method
        @@bar = 0         # class-variable
    end

    def initialize (f=0) #constructor
        @foo = f  # instance variable
    end

    def m2 (x)   #instance method
        @foo += x
        @@bar += 1
    end

    def foo ()
        @foo
    end

    def bar ()
        @@bar
    end
end