# Problem Set 2, hangman.py
# Name: Rodrigo Weller Zarrabal
# Collaborators: None
# Time spent:

# Hangman Game
# -----------------------------------
# Helper code
# You don't need to understand this helper code,
# but you will have to know how to use the functions
# (so be sure to read the docstrings!)
import random
import string

WORDLIST_FILENAME = "/Users/zarry/Documents/CS/Intro_CS/Introduction_to_computer_science/Lecture_3/Pset2/words.txt"


def load_words():
    """
    Returns a list of valid words. Words are strings of lowercase letters.
    
    Depending on the size of the word list, this function may
    take a while to finish.
    """
    print("Loading word list from file...")
    # inFile: file
    inFile = open(WORDLIST_FILENAME, 'r')
    # line: string
    line = inFile.readline()
    # wordlist: list of strings
    wordlist = line.split()
    print("  ", len(wordlist), "words loaded.")
    return wordlist



def choose_word(wordlist):
    """
    wordlist (list): list of words (strings)
    
    Returns a word from wordlist at random
    """
    return random.choice(wordlist)

# end of helper code

# -----------------------------------

# Load the list of words into the variable wordlist
# so that it can be accessed from anywhere in the program
wordlist = load_words()


def is_word_guessed(secret_word, letters_guessed):
    '''
    secret_word: string, the word the user is guessing; assumes all letters are
      lowercase
    letters_guessed: list (of letters), which letters have been guessed so far;
      assumes that all letters are lowercase
    returns: boolean, True if all the letters of secret_word are in letters_guessed;
      False otherwise
    '''
    # FILL IN YOUR CODE HERE
    
    for char in secret_word:
        if char in letters_guessed:
            pass
        else:
            return False
    return True



def get_guessed_word(secret_word, letters_guessed):
    '''
    secret_word: string, the word the user is guessing
    letters_guessed: list (of letters), which letters have been guessed so far
    returns: string, comprised of letters, underscores (_), and spaces that represents
      which letters in secret_word have been guessed so far.
    '''
    # FILL IN YOUR CODE HERE
    guessed_word = ''
    for char in secret_word:
        if char in letters_guessed:
            guessed_word += char       
        else:
            guessed_word += '_ '
    return guessed_word



def get_available_letters(letters_guessed):
    '''
    letters_guessed: list (of letters), which letters have been guessed so far
    returns: string (of letters), comprised of letters that represents which letters have not
      yet been guessed.
    '''
    # FILL IN YOUR CODE HERE
    available_letters = ''
    for letter in string.ascii_lowercase:
        if letter in letters_guessed:
            pass
        else:
            available_letters += letter
    return available_letters

    
    

def hangman(secret_word):
    '''
    secret_word: string, the secret word to guess.
    
    Starts up an interactive game of Hangman.
    
    * At the start of the game, let the user know how many 
      letters the secret_word contains and how many guesses s/he starts with.
      
    * The user should start with 6 guesses

    * Before each round, you should display to the user how many guesses
      s/he has left and the letters that the user has not yet guessed.
    
    * Ask the user to supply one guess per round. Remember to make
      sure that the user puts in a letter!
    
    * The user should receive feedback immediately after each guess 
      about whether their guess appears in the computer's word.

    * After each guess, you should display to the user the 
      partially guessed word so far.
    
    Follows the other limitations detailed in the problem write-up.
    '''
    # FILL IN YOUR CODE HERE
    guesses_left = 6
    letters_guessed = []
    warnings_left = 3
    vowels = 'aeiou'
    score = 0
    unique_letters = ''
    
    print('Welcome to the game Hangman!')
    print('I am thinking of a word that is', len(secret_word) ,'letters long.')
    print('You have', warnings_left, 'warnings left.')
    print('-------------')
    while not is_word_guessed(secret_word, letters_guessed) and guesses_left > 0:
      
      print('You have', guesses_left, 'guesses left.')
      print('Available letters:', get_available_letters(letters_guessed))
      guess = input('Please guess a letter: ')
      output_message = ''

      if guess.isalpha() and not (guess.lower() in letters_guessed): 
        #valid input
        guess = str.lower(guess)
        letters_guessed += guess
        if guess in secret_word:
          output_message = 'Good guess:'
        else:
          output_message = 'Oops! That letter is not in my word:'
          if guess in vowels:
            guesses_left -= 2
          else:
            guesses_left -= 1
      else:
        #invalid input
        if guess.isalpha():
          output_message = 'Oops! You\'ve already guessed that letter. '
        else:
          output_message = 'Oops! That is not a valid letter. '
        
        if warnings_left <= 0:
          guesses_left -= 1
          output_message += 'You have no warnings left so you lose one guess:'
        else:
          warnings_left -= 1
          output_message += 'You have ' + str(warnings_left) + ' warnings left:'

      print(output_message, get_guessed_word(secret_word, letters_guessed))

      print('-------------')

    if guesses_left <= 0:
      #Game lost
      print('Sorry, you ran out of guesses. The word was', secret_word + '.')
    else:
      #Game won
      for letter in secret_word:
        if not letter in unique_letters:
          unique_letters += letter
      score = guesses_left * len(unique_letters)
      print('Congratulations, you won!')
      print('Your total score for this game is:', score)



# When you've completed your hangman function, scroll down to the bottom
# of the file and uncomment the first two lines to test
#(hint: you might want to pick your own
# secret_word while you're doing your own testing)


# -----------------------------------



def match_with_gaps(my_word, other_word):
  '''
  my_word: string with _ characters, current guess of secret word
  other_word: string, regular English word
  returns: boolean, True if all the actual letters of my_word match the 
  corresponding letters of other_word, or the letter is the special symbol
  _ , and my_word and other_word are of the same length;
  False otherwise: 
  '''
  # FILL IN YOUR CODE HERE
  word = my_word.replace(' ','')
  if len(other_word) == len(word):
    i = 0
    for letter in word:
      if letter == '_': 
        i += 1
      else:
        if number_of_letters(letter, other_word) == number_of_letters(letter, word) and letter == other_word[i]:
          i += 1
        else:
          return False
    return True
  else:
    return False



def show_possible_matches(my_word):
    '''
    my_word: string with _ characters, current guess of secret word
    returns: nothing, but should print out every word in wordlist that matches my_word
             Keep in mind that in hangman when a letter is guessed, all the positions
             at which that letter occurs in the secret word are revealed.
             Therefore, the hidden letter(_ ) cannot be one of the letters in the word
             that has already been revealed.

    '''
    # FILL IN YOUR CODE HERE
    possible_matches = ''
    for word in wordlist:
      if match_with_gaps(my_word, word):
        possible_matches += word + ' '
    if possible_matches == '':
      print('No matches found')
    else:
      print(possible_matches)



def hangman_with_hints(secret_word):
    '''
    secret_word: string, the secret word to guess.
    
    Starts up an interactive game of Hangman.
    
    * At the start of the game, let the user know how many 
      letters the secret_word contains and how many guesses s/he starts with.
      
    * The user should start with 6 guesses
    
    * Before each round, you should display to the user how many guesses
      s/he has left and the letters that the user has not yet guessed.
    
    * Ask the user to supply one guess per round. Make sure to check that the user guesses a letter
      
    * The user should receive feedback immediately after each guess 
      about whether their guess appears in the computer's word.

    * After each guess, you should display to the user the 
      partially guessed word so far.
      
    * If the guess is the symbol *, print out all words in wordlist that
      matches the current guessed word. 
    
    Follows the other limitations detailed in the problem write-up.
    '''
    # FILL IN YOUR CODE HERE 
    guesses_left = 6
    letters_guessed = []
    warnings_left = 3
    vowels = 'aeiou'
    score = 0
    unique_letters = ''
    
    print('Welcome to the game Hangman!')
    print('I am thinking of a word that is', len(secret_word) ,'letters long.')
    print('You have', warnings_left, 'warnings left.')
    print('-------------')
    while not is_word_guessed(secret_word, letters_guessed) and guesses_left > 0:
      
      print('You have', guesses_left, 'guesses left.')
      print('Available letters:', get_available_letters(letters_guessed))
      guess = input('Please guess a letter: ')
      output_message = ''

      if guess.isalpha() and not (guess.lower() in letters_guessed): 
        #valid input
        guess = str.lower(guess)
        letters_guessed += guess
        if guess in secret_word:
          output_message = 'Good guess:'
        else:
          output_message = 'Oops! That letter is not in my word:'
          if guess in vowels:
            guesses_left -= 2
          else:
            guesses_left -= 1
      elif guess == '*':
        output_message = 'Possible word matches are:'
      else:
        #invalid input
        if guess.isalpha():
          output_message = 'Oops! You\'ve already guessed that letter. '
        else:
          output_message = 'Oops! That is not a valid letter. '
        
        if warnings_left <= 0:
          guesses_left -= 1
          output_message += 'You have no warnings left so you lose one guess:'
        else:
          warnings_left -= 1
          output_message += 'You have ' + str(warnings_left) + ' warnings left:'

      if guess == '*':
        print(output_message)
        show_possible_matches(get_guessed_word(secret_word, letters_guessed))
      else:
        print(output_message, get_guessed_word(secret_word, letters_guessed))

      print('-------------')

    if guesses_left <= 0:
      #Game lost
      print('Sorry, you ran out of guesses. The word was', secret_word + '.')
    else:
      #Game won
      for letter in secret_word:
        if not letter in unique_letters:
          unique_letters += letter
      score = guesses_left * len(unique_letters)
      print('Congratulations, you won!')
      print('Your total score for this game is:', score)

def number_of_letters(letter, string):
  #retruns the number of times a letter appears in a string
  count = 0
  for char in string:
    if letter == char:
      count += 1
  return count

# When you've completed your hangman_with_hint function, comment the two similar
# lines above that were used to run the hangman function, and then uncomment
# these two lines and run this file to test!
# Hint: You might want to pick your own secret_word while you're testing.


if __name__ == "__main__":
    # pass

    # To test part 2, comment out the pass line above and
    # uncomment the following two lines.
    
    #secret_word = choose_word(wordlist)
    #hangman(secret_word)
    
###############
    
    # To test part 3 re-comment out the above lines and 
    # uncomment the following two lines. 
    
    secret_word = choose_word(wordlist)
    hangman_with_hints(secret_word)
    
