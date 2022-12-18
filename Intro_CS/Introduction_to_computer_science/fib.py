def fibI(n):
    if n == 0:
        return 0
    elif n == 1:
        return 1
    a = 1
    b = 0
    ans = 0
    for _ in range(1,n):
        ans = a + b
        b = a
        a = ans
    return ans

def fibR(n):
    if n == 0:
        return 0
    elif n == 1:
        return 1
    return fibR(n - 1) + fibR(n - 2)

for i in range(12):
    print(i,'   Iterativo:', fibI(i),'      Recursivo:', fibR(i))