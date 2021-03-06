def prompt(message)
  puts("=> #{message}")
end

def integer?(input)
  input.to_i.to_s == input
end

def float?(input)
  input.to_f.to_s == input
end

def number?(input)
  integer?(input) || float?(input)
end

def operation_to_message(operation)
  case operation
  when '1' then 'Adding'
  when '2' then 'Subtracting'
  when '3' then 'Mutiplying'
  when '4' then 'Dividing'
  end
end

prompt('Welcome to Calculator! Enter your name:')
name = ''
loop do
  name = gets.chomp
  break unless name.empty?
  prompt('Please use a valid name')
end

prompt("Hi #{name}!")

loop do
  number_1 = ''
  loop do
    prompt("What's the first number?")
    number_1 = gets.chomp
    break if number?(number_1)
    prompt('Number is invalid, please try again!')
  end

  number_2 = ''
  loop do
    prompt("What's the second number?")
    number_2 = gets.chomp
    break if number?(number_2)
    prompt('Number is invalid, please try again!')
  end

  operator_prompt = <<-MSG
    What operation would you like to perform?
        1) Add
        2) Subtract
        3) Multiply
        4) Divide
  MSG

  prompt(operator_prompt)

  operator = ''
  loop do
    operator = gets.chomp
    break if %w(1 2 3 4).include?(operator)
    prompt('Please enter 1, 2, 3 or 4')
  end

  prompt("#{operation_to_message(operator)} the two numbers...")

  result =  case operator
            when '1' then number_1.to_f + number_2.to_f
            when '2' then number_1.to_f - number_2.to_f
            when '3' then number_1.to_f * number_2.to_f
            else number_1.to_f / number_2.to_f
            end

  prompt("The result is #{result}")

  prompt('Do you want to perform another calculation?')
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt('Thank you for using Calculator! Bye!')
