import bitstring, random 

span = 10000000
its = 100

def ieee754(flt):
    return bitstring.BitArray(float=flt, length=32)

f1 =  open("../dumps/adder_truthtable.txt", "w")
f2 =  open("../dumps/multp_truthtable.txt", "w")
f3 =  open("../dumps/subtr_truthtable.txt", "w")
f4 =  open("../dumps/dvidr_truthtable.txt", "w")

for i in range(its):
    b = ieee754(random.uniform(-span, span))
    c = ieee754(random.uniform(-span, span))
    sum = ieee754(b.float + c.float)
    sub = ieee754(b.float - c.float)
    mul = ieee754(b.float * c.float)
    div = ieee754(b.float / c.float)
    
    f1.write(f"{b.hex} {c.hex} {sum.hex}\n")
    f2.write(f"{b.hex} {c.hex} {mul.hex}\n")
    f3.write(f"{b.hex} {c.hex} {sub.hex}\n")
    f4.write(f"{b.hex} {c.hex} {div.hex}\n")