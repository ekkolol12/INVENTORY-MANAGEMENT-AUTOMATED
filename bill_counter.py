# bill_counter.py
bill_number = 4

def get_next_bill_number():
    global bill_number
    next_bill_number = bill_number
    bill_number += 1
    return next_bill_number
