```
flintstones = { "Fred" => 0, "Wilma" => 1, "Barney" => 2, "Betty" => 3, "BamBam" => 4, "Pebbles" => 5 }
flintstones.assoc("Barney")
#=> ["Barney", 2]
```

```
ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 5843, "Eddie" => 10, "Marilyn" => 22, "Spot" => 237 }
ages.values.inject(:+) # adds up all the ages
```

```
ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 402, "Eddie" => 10 }
ages.keep_if { |name, age| age < 100 }
```

```
ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 5843, "Eddie" => 10 }
additional_ages = { "Marilyn" => 22, "Spot" => 237 }
ages.merge!(additional_ages)
```

```
flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)
flintstones.push("Dino").push("Hoppy") # is the same as
flintstones.concat(%w(Dino Hoppy))
```

```
statement = "The Flintstones Rock!" #count the number of t's
statement.scan('t').count
```
