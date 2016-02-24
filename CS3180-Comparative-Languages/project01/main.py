# Project01
# Andrew Berger
# CS 3180
# Spring 2016

class WordFinder:
  '''WordFinder enables even a child to search for a list of words in a matrix of letters.'''

  def __init__(self, matrix):
    '''
    matrix is an iterable of iterables containing ASCII characters (e.g. 2d array of chars, tuple of strings, etc)
    '''
    self.char2pos = {}
    self.pos2char = {}
    
    # we don't care about case
    matrix = [r.lower() for r in matrix]

    # populate the dictionaries
    for row in range(len(matrix)):
      for col in range(len(matrix[row])):
        # map each (row, col) position pair to the value at that position
        self.pos2char[(row, col)] = matrix[row][col]

        # map characters to a list of (row, col) position pairs indicating locations where
        # that character can be found in the matrix
        if matrix[row][col] in self.char2pos:
          self.char2pos[matrix[row][col]] = self.char2pos[matrix[row][col]] + [(row, col)]
        else:
          self.char2pos[matrix[row][col]] = [(row, col)]

  def word_at_pos(self, word, pos, delta_row, delta_col):
    '''
    Returns true if word is found in the input matrix at position pos in the direction
    specified by delta-row and delta-col. By definition, a word with length 0 is always found.
    '''
    try:
      for i in range(len(word)):
        if word[i] == self.pos2char[pos]:
          # current char matches expected, keep on moving
          pos = (pos[0] + delta_row, pos[1] + delta_col)
        else:
          # current char doesn't match expected :(
          return False
    except KeyError:
      # tried to check an out-of-bounds position, must not have found the whole word
      return False

    return True

  def word_in_matrix(self, word):
    '''
    Returns true if word can be found in the input matrix along horizontals, verticals, or diagonals
    either forwards or backwards.
    '''
    try:
      in_matrix = False
      for pos in self.char2pos[word[0]]:
        # check all eight directions: E, W, S, N, SE, SW, NE, NW
        in_matrix = self.word_at_pos(word, pos, 0, 1) or \
          self.word_at_pos(word, pos, 0, -1) or \
          self.word_at_pos(word, pos, 1, 0) or \
          self.word_at_pos(word, pos, -1, 0) or \
          self.word_at_pos(word, pos, 1, 1) or \
          self.word_at_pos(word, pos, 1, -1) or \
          self.word_at_pos(word, pos, -1, 1) or \
          self.word_at_pos(word, pos, -1, -1)
        if in_matrix:
          return True
    except KeyError:
      return False

    # ultimately couldn't find the word
    return False    

  def find_words(self, words):
    '''
    Returns a subset of words which can be found in the input matrix along horizontals, verticals, 
    or diagonals either forwards or backwards.
    '''
    # return filter(self.word_in_matrix, [w.lower() for w in words])
    return [w for w in words if self.word_in_matrix(w.lower())]

def find_words(width, length, letters):
  '''
  Returns a list of words at least four characters long found within
  http://www.cs.duke.edu/~ola/ap/linuxwords that are also found in the letters provided in the letters argument.
  A word is only found if the word can be composed of consecutive letters in order within a single row,
  single column, or single diagonal in the letters matrix either forwards or backwards.
  '''
  try:
    linuxwords = None
    with open("linuxwords") as f:
      linuxwords = [line.rstrip('\n') for line in f]
    finder = WordFinder(letters)
    # return finder.find_words(filter(lambda word: len(word) >= 4, linuxwords))
    return finder.find_words([word for word in linuxwords if len(word) > 3])
  except:
    print "Couldn't find linuxwords"

if __name__ == '__main__':
  testmatrix_small = ("catss","dogst","flogo","zlzpp","fling")
  testmatrix_large = ( \
    "catsscatsscatsscatsscatsscatsscatsscatss" \
    "dogstdogstdogstdogstdogstdogstdogstdogst" \
    "flogoflogoflogoflogoflogoflogoflogoflogo" \
    "zlzppzlzppzlzppzlzppzlzppzlzppzlzppzlzpp" \
    "flingflingflingflingflingflingflingfling" \
    "catsscatsscatsscatsscatsscatsscatsscatss" \
    "dogstdogstdogstdogstdogstdogstdogstdogst" \
    "flogoflogoflogoflogoflogoflogoflogoflogo" \
    "zlzppzlzppzlzppzlzppzlzppzlzppzlzppzlzpp" \
    "flingflingflingflingflingflingflingfling" \
    "catsscatsscatsscatsscatsscatsscatsscatss" \
    "dogstdogstdogstdogstdogstdogstdogstdogst" \
    "flogoflogoflogoflogoflogoflogoflogoflogo" \
    "zlzppzlzppzlzppzlzppzlzppzlzppzlzppzlzpp" \
    "flingflingflingflingflingngstatesmanlike")

  print "Searching a 5x5 test matrix..."
  result = find_words(5, 5, testmatrix_small) == ['cats', 'coop', 'dogs', 'fling', 'flog', 'floss', 'golf', 'logo', 'loss', 'pots', 'stop']
  print "Found all the words: ", result

  print "Searching a 40x40 test matrix..."
  result = find_words(40, 40, testmatrix_large) == ['cats', 'dogs', 'fling', 'flog', 'gods', 'golf', 'like', 'logo', 'state', 'states', 'statesman', 'statesmanlike', 'tate']
  print "Found all the words: ", result
