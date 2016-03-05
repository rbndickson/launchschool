def prompt(message)
  puts("=> #{message}")
end

def positive_integer?(input)
  input.to_i.to_s == input && input.to_i > 0
end

loop do
  loan_amount = ''
  loop do
    prompt('What is the loan amount?')
    loan_amount = gets.chomp
    break if positive_integer?(loan_amount)
    prompt('Amount is invalid, please enter a number.')
  end

  apr_percentage = ''
  loop do
    prompt('What is the Annual Percentage Rate (APR)?')
    prompt('For example, for 5% enter 5')
    apr_percentage = gets.chomp
    break if positive_integer?(apr_percentage)
    prompt('Number is invalid, please give the percentage.')
  end

  loan_years = ''
  loop do
    prompt('What is the duration of the loan in years?')
    loan_years = gets.chomp
    break if positive_integer?(loan_years)
    prompt('Amount is invalid, please enter a number.')
  end

  prompt('Calculating the loan monthly payments...')

  apr_decimal = apr_percentage.to_f / 100
  monthly_interest_rate =  apr_decimal / 12
  loan_amount = loan_amount.to_f
  loan_months = loan_years.to_i * 12

  monthly_payment = loan_amount *
                    (monthly_interest_rate * (1 + monthly_interest_rate)**loan_months) /
                    ((1 + monthly_interest_rate)**loan_months - 1)

  prompt("The monthly payment is #{monthly_payment.round(2)}")

  prompt('Do you want to perform another calculation?')
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt('Thank you for using Mortgage Calculator! Bye!')
