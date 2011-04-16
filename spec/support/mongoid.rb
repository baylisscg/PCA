# Drop all non system collections
Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
