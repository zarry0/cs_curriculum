import string
my_word = 'af p _ e '
other_word = 'apple'

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

def number_of_letters(letter, string):
    #retruns the number of times a letter appears in string
    count = 0
    for char in string:
        if letter == char:
            count += 1
    return count

print(match_with_gaps("te_ t", "tact"))
print(match_with_gaps("a_ _ le", "banana"))
print(match_with_gaps("a_ _ le", "apple"))
print(match_with_gaps("a_ ple", "apple"))
print(match_with_gaps("_ _ _ _ _ ", "apple"))
