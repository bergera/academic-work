# Assignment
Using the descriptions below, write a scanner for numbers, symbols, comments, arithmetic operators, parenthesis, and EOF in both Python and Racket. (Note: I chose to use Ruby instead of Python)

```
- a number is
     one or more digits |
     zero of more digits followed by a decimal point followed by one or more digits |
     one or more digits followed by a decimal point followed by zero or more digits

- a symbol is
     one or more characters from the set [_A-Za-z] followed by zero or more characters from the set [_A-Za-z0-9]

- a comment is
     the literal string "//" followed by zero or more characters until the end of the line

- an arithmetic operator is
     + |
     - |
     * |
     /  

- a parenthesis is 
     ( |
     )

- EOF is 
   the literal end of input
```

Turn in your scanner implementations and test cases. Your test cases should show that your scanner produces a correct list of tokens when given valid input and the scanner output should contain an ERROR token when given invalid input.
