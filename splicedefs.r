def splicedefs(lds)  # lds :: [(Lemma,Definition)]
#	p lds
  return lds if lds == []
  twostringlcp = lambda {|a,b| commonpref = ",#{a},#{b}"[/([^,]+)(?=.*,\1)/]; commonpref ? commonpref+'-' : "#{a}/#{b}"}
  ldh = Hash[*lds.flatten]
#	p ldh
  ldds = lds.map {|l,d| [l,d.split(/\s*,\s*/)]} # the definition is a csv of possible definitions
#	p ldds
  dldsal = ldds.map {|l,ds| ds}.inject(&:+[]).find_all {|d| d.size > 4}.map {|d| [d,ldds.find_all {|l,ds| [] != ds.grep(/#{d.tr '^a-z ','.'}/)}]}.sort_by {|d_lds| d_lds[1].size}
#	p "dldsal",dldsal
  mergeworthy = dldsal.last.to_a[1] # :: [(Lemma, [SplitDefinition])]
#	p mergeworthy
  return lds if !mergeworthy || mergeworthy.size == 1
  # if each 5+-letter word only appears once, then fine, all those defns are appropriate.  otherwise, find the word that's used most often, find the lcp
  mergedlemmata = mergeworthy.map {|lemma, defs| lemma}
#	p mergedlemmata
  mergeddefns = mergedlemmata.map {|lemma| ldh[lemma]} #ldh.values_at(*mergedlemmata)
#	p mergeddefns
  prefix = mergedlemmata.inject(&twostringlcp)
#	p prefix
  longestdefn = mergeddefns.sort_by {|d| [d.count(','),d.size]}.last
#	p longestdefn
  splicedefs((ldh.keys-mergedlemmata).inject([[prefix,longestdefn]]) {|ac,el| ac + [[el,ldh[el]]]})
end

