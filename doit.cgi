#!/usr/bin/ruby
require 'cgi'
load 'writeout.r'

$c = CGI.new

a,t,d,l,o,lulu = %w%author title document numbers ouija lulu%.map {|par| [$c[par]].flatten.first}

lulu = (lulu == 'true')

uid = $c.params.inspect.md5

(d.writeout(uid); fork {load 'wrapup.r'; pdfelatexbook(uid, a, t, o.to_i, l=='true', lulu)}) unless File.exist?(uid)

guts, pdf = *%w%.guts .pdf%.map {|suff| File.exist?(uid+suff)}

$c.out {
  (pdf ? "<a href='#{uid}.pdf'>pdf</a>#{" and Lulu-sized <a href='#{uid}cover.pdf'>cover</a>" if lulu}<p>" : (
    (guts ? "making the book guts" : "generating the footnotes") + " at #{Time.now.to_s[/\d\d:\d\d:\d\d [A-Z]{3}/]}"	# so that PeriodicUpdater, and we, will always have something new
  ))
}
