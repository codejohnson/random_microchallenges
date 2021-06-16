class security_box:

    def __init__(self, keys):
        self.keys = keys
        self.LAST, self.OK, self.STEP, self.REF = "F",0,1,2   
        self.go = {
            "A":[lambda _: _ < len(keys), 1, self.vertical],
            "B":[lambda _: _ >= 0, -1, self.vertical],
            "I":[lambda _: _ < len(keys[0]), 1, self.horizontal],
            "D":[lambda _: _ >= 0, -1, self.horizontal],
        }

    def vertical(self, target, arrow):
        row, col = target
        r, c = row + (move := self.go[arrow][self.STEP]), col
        while self.go[arrow][self.OK](r):
            if self.keys[r][c] == str(abs(r - row)) + arrow: return r,c
            r += move 

    def horizontal(self, target, arrow):
        row, col = target
        r, c = row, col + (move := self.go[arrow][self.STEP])
        while self.go[arrow][self.OK](c):
            if self.keys[r][c] == str(abs(c - col)) + arrow: return r,c
            c += move 

    def solve(self,cell):
        for arrow in self.go:
            if ( prev_cell := self.go[arrow][self.REF](cell,arrow) ): 
                return self.solve(prev_cell)
        return cell

    def get_last_button(self):
        for r in range(len(self.keys)): 
            for c in range(len(self.keys[0])):
                if self.keys[r][c] == self.LAST: return r,c

    def open(self): return self.solve(self.get_last_button())
