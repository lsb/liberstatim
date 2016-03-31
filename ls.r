load 'sym2proc.r'; load 'writeout.r'; load 'texcode.r'; load 'splicedefs.r'; load 'lemmuz.r'

#require 'profile'

class String
  def cleanup() tr('_','').gsub(/&.+?;/,' ').gsub(/\n+/,"\n") end
end

$ouija = 3
$slidewin = [nil] * 100
$text_word = /[a-zA-Z]+/
#Gensym = memoize {|s| (0..19).map {rand 10}.join}
Genny = []

def defn_to_tex lemma,meaning
  TeX.df(word_to_num(lemma),TeX.textbf(lem_to_tex(lemma))+' '+meaning.split(',')[0,5].join(','))
end

def word_to_num(word) (word.downcase.tr('-','') + 'a' * 6).tr('a-z','0-9a-z')[0,6].to_i(26) end

Defs = memoize {|w| cwk(w).map {|l,d,_| [l,d,(twf(l.downcase).to_i+twf(l.downcase.capitalize).to_i)/600]}.reject {|l,d,f| d==""}}

def anydefs(word)
  splicedefs(Defs[word].find_all {|lemma,meaning,freq10k| freq10k < $ouija && !$slidewin.include?(lemma+meaning)
                }.map {|l,m,f| $slidewin.shift; $slidewin.push(l+m); [l,m]
                }).map {|l,m| defn_to_tex l,m}.join
end

def lem_to_tex(word) word end
def word_to_url(word) word end
def word_to_tex(word) word end

module Enumerable
  def zip(other) a=[]; o=other.to_a; each_with_index {|e,i| a << [e,o[i]]}; a end
  def inject(z=nil,&f) a = to_a; z = z || a.shift; each {|e| z = f[z,e] } ; z end
  def sort_by(&b) map {|e| [b[e],e]}.sort.map {|ye,e| e} end
end
class File
  def self.read(name) File.new(name).gets(nil) end
end
class String
  def to_i(base=10) downcase.split('').inject(0) {|a,e| "0123456789abcdefghijklmnopqrstuvwxyz".index(e) + base*a} end
end
# because we're running in Ruby 1.6 instead of 1.8.  The functions are (seemingly) functionally equivalent, though faster when coded in C.

def maketex(file)
  wolinenums = File.read(file).gsub(/&#151;/,"---").gsub(/#/,"number").gsub(/@[^@]+@/) {|s| Genny << s[1..-2]; '#' * Genny.size+'{}'}.tr('0-9','').gsub($text_word) {|w| wt = word_to_tex(w); anydefs(w)+wt}.cleanup
  wolinenums.zip(1..(wolinenums.count("\n").next)).
             map{|line,num| (num%10==0 && !$unlined ? TeX.leavevmode+TeX.llap(TeX.scriptsize+num.to_s+'~~') : "")+line}.join.
             gsub(/#+/) {|v| atparse(Genny[v.size-1])}
end

def makebookguts(infile, freqper10k, numbered, outfile) $unlined = !numbered; $ouija = freqper10k; maketex(infile).writeout(outfile) end

#$unlined = "oh yes"
#$ouija=10
#maketex('sallnotags2').writeout('vg_three.tex')

def atparse(s)
  tws = $text_word.source
  case s
    when /^-((\d+)-)?(([^@]+)-)?$/  # @-5-Epilogue-@ or @-@
      ($2 ? TeX.setcounter('section',$2.to_i-1) : '') + TeX.section($4)
    when /^[?](#{tws})(([?]#{tws}=[^?=]+)*)$/ # @?rexe?rego=to do this, that and the other thing?Rexus=the progenitor of Lexis Nexus@
	word = $1; qslm = $2[1..-1].to_s
	qslm.split('?').map {|lm| defn_to_tex(*lm.split('='))}.join + word_to_tex(word)
    else
      TeX.comm(s)
  end
end

