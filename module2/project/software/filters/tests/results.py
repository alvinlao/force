import matplotlib.pyplot as plt

# Measurements
a = open('in', 'r')
# Output
b = open('out', 'r')

ax = []
ay = []
bx = []
by = []
for line in a:
    x, y, acc = [int(x) for x in line.split()]
    ax.append(x)
    ay.append(y)

for line in b:
    x, y = [int(x) for x in line.split()]
    bx.append(x)
    by.append(y)
    
plt.plot(ax, ay, 'ro', bx, by, 'bo')
plt.xlim(0, 320)
plt.ylim(0, 240)
plt.show()

a.close()
b.close()
