import matplotlib.pyplot as plt
import sys

# Points that define a 2x2 box centered on (0, 0, 0.5)
box = [
    (-0.5, -0.5, 0),
    (0.5, -0.5, 0),
    (0.5, 0.5, 0),
    (-0.5, 0.5, 0),
    (-0.5, -0.5, 1),
    (0.5, -0.5, 1),
    (0.5, 0.5, 1),
    (-0.5, 0.5, 1),
]

# Normal vector of the plane
n = (0, 0, 1)
# Camera vector
print("Camera vector: <x, y, z>")
c = tuple(int(x) for x in raw_input().split())

def dot(a, b):
    return (a[0] * b[0]) + (a[1] * b[1]) + (a[2] * b[2])

def add(a, b):
    return (a[0] + b[0], a[1] + b[1], a[2] + b[2])

def sub(a, b):
    # a - b
    return (a[0] - b[0], a[1] - b[1], a[2] - b[2])

def scale(s, a):
    return (s * a[0], s * a[1], s * a[2])


flattened = []

# For each point
for point in box:
    x, y, z = point
    l = sub(point, c)
    a =  -1.0 * (float(dot(n, point)) / dot(n, l))

    v = add(scale(a, l), point)
    flattened.append(v)


x = []
y = []
for p in flattened:
    x0 = p[0]
    y0 = p[1]
    x.append(x0)
    y.append(y0)
    print(x0, y0)


plt.xlim(-5, 5)
plt.ylim(-5, 5)
plt.plot(x[:4], y[:4], 'bo', x[4:], y[4:], 'ro')
plt.show()

