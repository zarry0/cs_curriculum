def f(s):
    ans = []
    if len(s) == 1:
        ans.append(s)
        return ans

    new_seq = s[1:]
    f_char = s[0]
    for perm in f(new_seq):
        for n in range(len(perm)+1):
            r = ''
            r = perm[:n] + f_char + perm[n:]
            ans.append(r)
    return ans
#Caso recursivo
    #funcion que devuelve una lista de permutaciones de la secuencia menos el primer caracter ······> f(s[1:]) :-> [p1, p2, p3, ..., pn]
    #la permutacion completa son todas las maneras de incrustar s[0] en cada elemento de f(s[1:])
# s = 'bc'
# c = 'a'
# l = []
# for n in range(len(s)+1):
#     r = ''
#     r = s[:n] + c + s[n:]
#     l.append(r)
# print(l)
print(len(f('abcd')))