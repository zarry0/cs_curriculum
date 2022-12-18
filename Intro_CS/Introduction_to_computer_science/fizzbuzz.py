#Print numbers from 1 to 100
#If the number is a multiple of 3 print "Fizz"
#If de number is a multiple of 5 print "Buzz"
#If the number is a multiple of both 3 and 5 print "FizzBuzz"
#otherwise print the number

for n in range(1,100):
    if n%3 == 0 and n%5 == 0:
        print('FizzBuzz ', end =' ')
    elif n%5 == 0:
        print('Buzz', end =' ')
    elif n%3 == 0:
        print('Fizz', end =' ')
    else:
        print(n, '', end =' ')