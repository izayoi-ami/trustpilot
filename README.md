# Trustpilot Code Challenge

The following tools come handy:
- awk / perl
- SageMath / python

## Dictionary preprocessing

There are around 100000 words reported by the command:
`wc -w wordlist`

The original given phrase is "poultry outwits ants".

A simple observation leads to excluding the words not matching /[ailnoprstuwy]/
The following awk command does the job:
`awk '/^[ailn-pr-uwy]+$/' wordlist >possible`

or in perl:
`perl -ane '/^[ailn-pr-uwy]+$/ && print' wordlist >possible`

The next step is to remove duplicate entries from the possible list:
`sort -u dict`

## Filter and generate hash

There are still approximately 2500 words remaining (a bit too much).
We would better remove words containing more than 1 'i's  etc.

### Filter possible patterns:

```python
def is_valid_word(word):
  from collections.Counter import Counter
  original = "poultryoutwitsants"
# Subtraction of counter behaves like set difference
  return Counter(word) - Counter(original) != Counter("")
```

### itertools.groupby
It is also good to build a pattern-words dictionary to speed up the process:
```python
def sorted_string(s):
    return "".join(sorted(s))

patterns = {"":[""]}
for k, g in groupby(possible_words, sorted_string):
    patterns[k] = list(g)
```

### anagram testing
Finally, one can take all combinations from the word lists and compare with the remaining allowed pattern.
Then, permute to check the md5 hash.

A code in sage with parallel is provided for reference.
