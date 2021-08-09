# Problem Set 4A
# Name: Rodrigo Weller Zarrabal
# Collaborators: None
# Time Spent: x:xx

def get_permutations(sequence):
    '''
        Enumerate all permutations of a given string

        sequence (string): an arbitrary string to permute. Assume that it is a
        non-empty string.  

        You MUST use recursion for this part. Non-recursive solutions will not be
        accepted.

        Returns: a list of all permutations of sequence

        Example:
        >>> get_permutations('abc')
        ['abc', 'acb', 'bac', 'bca', 'cab', 'cba']

        Note: depending on your implementation, you may return the permutations in
        a different order than what is listed here.
    '''
    ans = []
    # Base case
    # If the sequence is a single character long, return the singleton list containing character
    if len(sequence) == 1:
        ans.append(sequence)
        return ans

    # Recursive case
    # Generate a new string from the original sequence except the first character
    new_sequence = sequence[1:]
    first_char = sequence[0]
    # Call get_permutations on the new sequence
    # And for each permutation of the new sequence, insert the first character of the original sequence in every position of the string
    for permutation in get_permutations(new_sequence):
        ans += [permutation[:i] + first_char + permutation[i:]
                for i in range(len(permutation) + 1)]
    return ans
    # Alternatively:
    # for n in range(len(permutation) + 1):
    #     s = permutation[:n] + first_char + permutation[n:]
    #     ans.append(s)


if __name__ == '__main__':
    #    #EXAMPLE
    example_input = 'abc'
    print('Input:', example_input)
    print('Expected Output:', ['abc', 'acb', 'bac', 'bca', 'cab', 'cba'])
    print('Actual Output:', get_permutations(example_input))
    print()
#    # Put three example test cases here (for your sanity, limit your inputs
#    to be three characters or fewer as you will have n! permutations for a
#    sequence of length n)
    example_input = 'end'
    print('Input:', example_input)
    print('Expected Output:', ['end', 'edn', 'ned', 'nde', 'den', 'dne'])
    print('Actual Output:', get_permutations(example_input))
    print()

    example_input = 'ask'
    print('Input:', example_input)
    print('Expected Output:', ['ask', 'aks', 'sak', 'ska', 'kas', 'ksa'])
    print('Actual Output:', get_permutations(example_input))
    print()

    example_input = 'but'
    print(f'Input: {example_input}')
    print('Expected Output:', ['but', 'btu', 'ubt', 'utb', 'tbu', 'tub'])
    print('Actual Output:', get_permutations(example_input))
    print()
