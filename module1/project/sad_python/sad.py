# O(S*S*N*N)
BLOCK_SIZE = 10
WINDOW_SIZE = 200
SEARCH_STEP = 10

BORDER_THICKNESS = 2
RED = (0, 0, 255)
GREEN = (0, 255, 0)
BLUE = (255, 0, 0)

# SAD
def block_step(prev_frame, frame, x, y, prevx, prevy):
    delta = 0
    for i in xrange(BLOCK_SIZE):
        for j in xrange(BLOCK_SIZE):
            prev = prev_frame[prevy + j, prevx + i]
            new = frame[y + j, x + i]
            
            delta += sad_pixel(prev, new)

    return delta
    

# This treats the whole block as one pixel
def block_step2(prev_frame, frame, x, y, prevx, prevy):
    pr, pg, pb = 0, 0, 0
    r, g, b = 0, 0, 0
    for i in xrange(BLOCK_SIZE):
        for j in xrange(BLOCK_SIZE):
            prev = prev_frame[prevy + j, prevx + i]
            new = frame[y + j, x + i]
            
            pr += prev[0]; pg += prev[1]; pb += prev[2];
            r += new[0]; g += new[1]; b += new[2];

            #delta += sad_pixel(prev, new)

    return abs(pr - r) + abs(pg - g) + abs(pb - b)
    #return delta


def step(prev_frame, frame, windowleftx, windowtopy, search_blockx, search_blocky):
    searches = (WINDOW_SIZE - BLOCK_SIZE)/SEARCH_STEP
    
    s = float("inf")
    blockx, blocky = 0, 0
    for i in xrange(0, searches):
        for j in xrange(0, searches):
            x = windowleftx + (i * SEARCH_STEP)
            y = windowtopy + (j * SEARCH_STEP)
            cur_s = block_step(prev_frame, frame, x, y, search_blockx, search_blocky)

            if(cur_s < s):
                blockx, blocky = x, y
                s = cur_s
    return (blockx, blocky)

def sad_pixel(a, b):
    s = 0
    for i in xrange(0, 3):
        s += abs(a[i] - b[i])
    return s

def draw_box(frame, x, y, size, color):
    leftx = x
    rightx = x + size
    topy = y
    bottomy = y + size

    for i in xrange(leftx, rightx):
        for j in xrange(topy, bottomy):
            if(i < leftx + BORDER_THICKNESS or i > rightx - BORDER_THICKNESS or j < topy + BORDER_THICKNESS or j > bottomy - BORDER_THICKNESS):
                frame[j, i] = color

# x, y coords of block
def center_window(x, y, width, height):
    wx = (x + BLOCK_SIZE/2) - (WINDOW_SIZE/2)
    wy = (y + BLOCK_SIZE/2) - (WINDOW_SIZE/2)

    wx = max(0, wx)
    wy = max(0, wy)

    wx = min(wx, width - WINDOW_SIZE)
    wy = min(wy, height - WINDOW_SIZE)

    return (wx, wy)
