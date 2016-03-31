load 'ls.r'
def pdfelatexbook(ifile, auth, tit, freq10k, unlined, lulu)
  safen = :tr["^0-9A-Za-z", ' ']
  sauth = safen[auth]
  stit = safen[tit]
  makebookguts(ifile, freq10k, unlined, ifile + ".guts")
  pagecount = `cp slurp.tex #{ifile}.tex; (echo #{lulu ? 'lulu' : 'notlulu'}; echo #{sauth} ; echo #{stit} ; echo #{ifile}.guts) | pdfelatex #{ifile}`.
		scan(/\((\d+) pages?,/)[-1].to_a.first.to_i
  return -1 if pagecount < 1
  `cp splat.tex #{ifile}cover.tex; (echo #{sauth}; echo #{stit}; echo #{stit.upcase}; echo #{882 + pagecount.to_f * 3 / 25}) | pdfelatex #{ifile}cover` if lulu
  pagecount
end

# milestones:  \ifile\.guts, \ifile\.tex \ifile\.pdf \ifile\cover.pdf
