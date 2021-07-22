#(c) Rodrigo Weller Zarrabal, 21-7-21

annual_salary_input = float(input('Enter the starting salary: '))
annual_salary = annual_salary_input

total_cost = 1000000.0
semi_annual_raise = 0.07
portion_down_payment = 0.25
current_savings = 0.0
r = 0.04
down_payment = portion_down_payment * total_cost
error = 100
low = 0.0
high = 10000
portion_saved = (low + high) / 2      #Initial guess

steps = 0
while abs(current_savings - down_payment) > error:
    steps += 1

    months = 0
    current_savings = 0
    annual_salary = annual_salary_input
    while current_savings < down_payment:       #Determines how many months would take to save enough for the down payment based on the estimated saving rate
        current_savings += (current_savings * r / 12.0) + ((annual_salary / 12.0) * (portion_saved / 10000))
        months += 1
        if months%6 == 0:
            annual_salary += annual_salary * semi_annual_raise
    
    if months > 36:
        low = portion_saved
    else:
        high = portion_saved
    portion_saved = (high + low) / 2

    if portion_saved >= 10000 and months > 36:      #Checks if is not possible to make the downpayment
        break

if months <= 36:
    print('Best savings rate:', "{:.4f}".format(portion_saved / 10000))
    print('Steps in bisection search:', steps)
else:
    print('It is not posible to pay the down payment in three years')
        
