class Symbol
  def to_proc(*args) lambda {|*a| a.first.send self, *(args+a[1..-1])} end
  alias [] to_proc
end

def memoize(&b) Hash.new {|h, nu| h[nu] = b[nu]} end
def memoize(&b) h=Hash.new; lambda {|nu| h.fetch(nu) { h[nu]=b[nu] }} end
