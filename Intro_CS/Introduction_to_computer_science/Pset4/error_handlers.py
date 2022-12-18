a = 1
try:
    print('try antes')
    float(a)
    print('try Despues')
except:
    #raise ValueError('Error1')
    print('except')
    raise ValueError('Error2')
else:
    print('else')
finally:
    print('finally')

print(a)