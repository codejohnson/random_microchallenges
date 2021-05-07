fn next(x:u64)->u64 { if x % 2 == 1 { 3 * x + 1 } else { x / 2 } }
fn speed(s:u64)->u64 { if s == 1 {0} else { speed(next(s)) + 1 } }     
fn max_speed(n:u64)->(u64,u64) {
    let (mut ms, mut mx)  = (0,0);
    for i in 1..=n {
        let s = speed(i);
        if s > ms  { 
            ms = s; 
            mx = i; 
        }
    }
    return (ms,mx);
}

fn main() {
    let (x,y) = max_speed(10000000);
    println!("{} {}",x, y);
}
