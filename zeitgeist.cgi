#!/usr/bin/ruby
require 'cgi'
$c=CGI.new('html4')

def href(url,descr) $c.a('href' => url) {descr} end

lastseven = `ls -t [0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f] | head -n 12`.split(/\s+/)
$c.out {
  lastseven.map {|filename|
    snippet = IO.readlines(filename)[0,10].join(' ').tr('^A-Za-z',' ').gsub(/ +/,' ')[0,70]+"..."
    ([snippet, href(filename,"full text"), href(filename+".pdf","pdf")] + (File.exists?(filename+"cover.pdf") ? [href(filename+"cover.pdf","cover")] : [])).join(' ')
  }.join($c.br)
}
