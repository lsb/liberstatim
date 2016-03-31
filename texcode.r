class TeXCode
  def method_missing(sym,*args) "\\"+sym.to_s+args.map {|a| "{#{a}}"}.join end
end
TeX = TeXCode.new
