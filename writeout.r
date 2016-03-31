require 'digest/md5'
load 'sym2proc.r'

class String
 def writeout(f) File.open(f,'w',&:write[self]);self end  #ersatz monad
 def md5(size=16) Digest::MD5.hexdigest(self)[0,size] end
end
