KEY_VALUE_MATCHER = /[.](\S+)\s*=\s*(\S+)/

def ruby_parser
	test_string = "Events[0].Lane=1 
		Events[0].Object.BoundingBox[0]=1248 
		Events[0].Object.BoundingBox[1]=3528 
		Events[0].Object.BoundingBox[2]=1920 
		Events[0].Object.BoundingBox[3]=3848 
		Events[0].Object.Center[0]=1584 
		Events[0].Object.Country=GBR 
		Events[0].SnapSourceCombine=false"

	events_array = test_string.split(' ')
	create_hash(events_array)
end	

def create_hash(events_array)
	hash = Hash.new
	object_hash = Hash.new { |hash, key| hash[key] = [] }
	events_array.each do |event_object|
		match = event_object.match(KEY_VALUE_MATCHER)
		if !match[1].include? 'Object'
			hash[match[1]] = (match[2])
		else
			if match[1] =~ /(\[\d\])/
				string = match[1].gsub(/(\[\d\])/, '')
				strip_object(string)
				object_hash[string] << match[2]
			else
				string = strip_object(match[1])
				object_hash[string] = match[2]
			end	
		end	
	end	
	hash['Object'] = object_hash
	puts hash
end	

def strip_object(string)
	string.gsub!('Object.', '')
end	

ruby_parser