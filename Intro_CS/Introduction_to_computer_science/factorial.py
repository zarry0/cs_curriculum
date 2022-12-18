def factI(n):
    if n == 0:
        return 1
    ans = 1
    while n > 1:
        ans *= n
        n -= 1
    return ans

def factR(n):
    if n == 0:
        return 1
    return n*factR(n-1)


for n in range(10):
    i = factI(n)
    r = factR(n)
    print('n =',n ,'    Iterativo:', i, '    Recursivo:', r)