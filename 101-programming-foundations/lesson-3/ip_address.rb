# a simple ruby method to determine if an input string is an IP address
# representing dot-separated numbers. e.g. "10.4.5.11".

# "It's a good start, but you missed a few things. You're not returning a
# false condition, and not handling the case that there are more or fewer than
# 4 components to the IP address
# (e.g. "4.5.5" or "1.2.3.4.5" should be invalid)."

# Fix this

 def dot_separated_ip_address?(input_string)
  dot_separated_words = input_string.split(".")
  return false unless dot_separated_words.size == 4

  while dot_separated_words.size > 0 do
    word = dot_separated_words.pop
    return false unless is_a_number?(word)
  end

  true
end
