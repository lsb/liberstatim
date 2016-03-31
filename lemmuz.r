class Array
  def r_bsearch(v,lo=0,hi=size-1,r=/^#{v}[^a-zA-Z]/)
    p = lo + (hi-lo)/2
    sp = slice p
    return sp if sp[r]
    return nil if lo > hi
    return bsearch(v,lo,p-1) if sp > v
    return bsearch(v,p+1,hi) if sp < v
    raise "roflcopter"
  end
  def bsearch(v,lo=0,hi=size-1,r=/^#{v}[^a-zA-Z]/)
    loop {
	p = lo + (hi-lo)/2
	sp = slice p
	return sp if sp[r]
	return nil if lo>hi
	hi = p-1 if sp > v
	lo = p+1 if sp < v
     }
  end	
end

class String
  def munchdefn() eval(slice(/\[.+/)) end
  def munchnum() tr("^0-9","").to_i end
end
Lemmuz = File.readlines('lemmatizer')
Freaks = File.readlines('freqs')
def cwk(w) lookup = Lemmuz.bsearch(w); lookup ? lookup.munchdefn : [] end
def twf(w) Freaks.bsearch(w).to_s.munchnum end
