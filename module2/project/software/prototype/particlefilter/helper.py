# Draw box border thickness
BORDER_THICKNESS = 2

"""
Draw a box on the frame
"""
def draw_box(frame, x, y, size, color):
    draw_rect(frame, x, y, size, size, color)

"""
Draw a rectangle on the frame
"""
def draw_rect(frame, x, y, w, h, color):
    leftx = x
    rightx = x + w
    topy = y
    bottomy = y + h

    for i in xrange(leftx, rightx):
        for j in xrange(topy, bottomy):
            if(i < leftx + BORDER_THICKNESS or i > rightx - BORDER_THICKNESS or j < topy + BORDER_THICKNESS or j > bottomy - BORDER_THICKNESS):
                frame[j, i] = color
