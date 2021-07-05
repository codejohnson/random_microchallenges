def rot45(mtrx, clock = True):
    def slide_frame(deep, ticks):
        top = len(mtrx) - deep - 1
        row = col = deep
        _WALL = 2
        _Y = 0
        _X = 1
        _RIGHT = ( 0,  1, lambda : col == top) 
        _DOWN  = ( 1,  0, lambda : row == top) 
        _LEFT  = ( 0, -1, lambda : col == deep) 
        _UP    = (-1,  0, lambda : row == deep)
        route = [_RIGHT, _DOWN, _LEFT, _UP] if clock else [_DOWN, _RIGHT, _UP, _LEFT]
        while ticks > 0:
            router = 0
            going = route[0]
            mov = mtrx[row][col]
            while True:
                if going[_WALL]():
                    router += 1
                    going = route[router]
                row += going[_Y]
                col += going[_X]
                pop = mtrx[row][col]
                mtrx[row][col] = mov
                mov = pop
                if (row,col) == (deep, deep):
                    break
            row , col = deep, deep
            ticks -= 1
    
    width = len(mtrx)
    level = 0
    while width >= 2:
        ticks = width // 2 - (1 if width % 2 == 0 else 0)
        slide_frame(level,ticks)
        level += 1
        width -=2
    return mtrx

def rot90(mtrx, clock = True):
    cmtrx = []
    for c in range(len(mtrx[0])):
        vec = [mtrx[r][c] for r in range(len(mtrx))]
        cmtrx.append(vec[::-1]) if (clock) else cmtrx.append(vec)
    return cmtrx

def rotate_by_angle(mtrx, angle):
    angle %= 360
    giro = angle / 90.0
    clock = giro > 0
    r90,r45 = divmod(abs(giro),1)
    for r in range(int(r90)):
        mtrx = rot90(mtrx,clock)
    if r45 > 0.0:
        mtrx = rot45(mtrx,clock)
    return mtrx
