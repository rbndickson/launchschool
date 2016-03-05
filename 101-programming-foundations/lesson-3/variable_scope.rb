# A

def mess_with_vars(one, two, three)
  one = two
  two = three
  three = one
end

one = "one"
two = "two"
three = "three"

mess_with_vars(one, two, three)

puts "one is: #{one}" # one
puts "two is: #{two}" # two
puts "three is: #{three}" # three

# B

def mess_with_vars(one, two, three)
  one = "two"
  two = "three"
  three = "one"
end

one = "one" # one
two = "two" # two
three = "three" # three

mess_with_vars(one, two, three)

puts "one is: #{one}"
puts "two is: #{two}"
puts "three is: #{three}"

# C

def mess_with_vars(one, two, three)
  one.gsub!("one","two")
  two.gsub!("two","three")
  three.gsub!("three","one")
end

one = "one" # two
two = "two" # three
three = "three" # #one

mess_with_vars(one, two, three)

puts "one is: #{one}"
puts "two is: #{two}"
puts "three is: #{three}"
