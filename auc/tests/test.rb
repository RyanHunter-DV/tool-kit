#! /usr/bin/env ruby

class SVClass
	def elaborate &blk
		blk.call
	end
end

def a &blk
	c = SVClass.new()
	##c.elaborate &blk
	c.instance_eval &blk
end

a do
	puts "hello, #{self.inspect}"
	elaborate do
		puts "hi"
	end
end
