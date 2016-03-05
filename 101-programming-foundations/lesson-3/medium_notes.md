```
numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.shift(1)
end
# 1
# 3
# => [3, 4]
# The iterator is working on the original array in real time
```

```
# Are theses different?
def rolling_buffer1(buffer, max_buffer_size, new_element)
  buffer << new_element
  buffer.shift if buffer.size >= max_buffer_size
  buffer
end

def rolling_buffer2(input_array, max_buffer_size, new_element)
  buffer = input_array + [new_element]
  buffer.shift if buffer.size >= max_buffer_size
  buffer
end
# Yes, in rolling_buffer1 the input buffer will be modified.
# In rolling_buffer2 the input buffer will not be modified.
```

```
# What is wrong with this code? How can you fix it?
limit = 15

def fib(first_num, second_num)
  while second_num < limit
    sum = first_num + second_num
    first_num = second_num
    second_num = sum
  end
  sum
end

result = fib(0, 1)
puts "result is #{result}"
# The limit variable is not within the scope of the fib method.
# Fix it by passing the variable to the method.
```

```
# Write your own version of the rails titleize implementation.
words.split.map { |word| word.capitalize }.join(' ')
```

```
# What will the output be?
def tricky_method(a_string_param, an_array_param)
  a_string_param += "rutabaga"
  an_array_param << "rutabaga"
end
```

```
my_string = "pumpkins"
my_array = ["pumpkins"]
tricky_method(my_string, my_array)

puts "My string looks like this now: #{my_string}"
puts "My array looks like this now: #{my_array}"
# My string looks like this now: pumpkins
# My array looks like this now: ["pumpkins", "rutabaga"]
```
