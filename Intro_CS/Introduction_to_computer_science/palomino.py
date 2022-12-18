import string
import fib

def palindrome(s):
    s = s.lower()
    if s == s[::-1]:
        print(s[::-1])
        return True
    else:
        print(s[::-1])
        return False

print(palindrome(input()))

print(fib.fibR(8))