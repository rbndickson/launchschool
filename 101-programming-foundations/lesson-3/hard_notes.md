```
# What will happen when the greeting variable is referenced?

if false
  greeting = “hello world”
end

greeting

# greeting is nil here, and no "undefined method or local variable" exception
# is thrown. Typically, when you reference an uninitialized variable, Ruby
# will raise an exception, stating that it’s undefined. However, when you
# initialize a local variable within an if block, even if that if block doesn’t
# get executed, the local variable is initialized to nil.
```

```
# What is the result of the last line of code?

greetings = { a: 'hi' }
informal_greeting = greetings[:a]
informal_greeting << ' there'

puts informal_greeting  #  => "hi there"
puts greetings

# The output is {:a=>"hi there"}. The reason is because informal_greeting is a
# reference to the original object. The line informal_greeting << ' there' was
# using the String#<< method, which modifies the object that called it.
# This means that the original object was changed,
# thereby impacting the value in greetings.
```
