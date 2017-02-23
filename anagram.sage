from collections import Counter
from itertools import combinations, permutations, groupby

def get_words(fname):
    with open(fname) as f:
        return [line.rstrip("\n") for line in f]
@parallel
def test_hash(s):
    import hashlib
    h = hashlib.md5(s).hexdigest()
    return (h, h in targets)

@parallel
def test_words(ws):
    remaining = c1 - sum(map(Counter,ws),Counter(""))
    remain = counter_to_string(remaining)
    last_words = patterns.get(remain)
    if last_words is None: return None
    mstr = max(ws)
    temp = []
    for last in last_words:
        if last<mstr: continue
        word_lists = ws + [last]
        strings = [" ".join(w) for w in Permutations(word_lists)]
# Parallel call
        # ans = sorted(list(test_hash(strings)))
        # ans = [(t[0][0][0], t[1][0], t[1][1]) for t in ans]
# Sequenctial call
        ans = zip(strings, map(test_hash, strings))
        temp.extend(ans)
    return temp
    L = [test_hash(" ".join(w)) for w in Permutations(ws).list()]
    return L

def take(iter, N=1):
    L = []
    try:
        for _ in range(N):
            L.append(iter.next())
    except:
        pass
    return L

def counter_to_string(c):
    return "".join(sorted("".join([k*c[k] for k in c])))

def sorted_string(s):
    return "".join(sorted(s))

targets = ["e4820b45d2277f3844eac66c903e84be", "23170acc097c24edb98fc5488ab033fe", "665e5bcb0c20062fe8abaaf4628bb154"]
original = "poultryoutwitsants"
c1 = Counter(original)

output_file = "ans.out"

fout = open(output_file, "w")
possible_words =get_words("./possible_words")
patterns = {"":[""]}
for k, g in groupby(possible_words, sorted_string):
    patterns[k] = list(g)


cnt = 0
THREADS = 8
cc = combinations(possible_words,2)
cs = take(cc,THREADS)

# cs = ['wilton trust', 'tuny outstript', 'alots wintry', 'altruist outpost']
# cs = [s.split(" ") for s in cs]
# L = list(test_words(cs))
# print(L)
# exit()
valid_phrases = []
template = "Words:{}\n\t{}"
while len(cs) > 0:
    cs = map(list,cs)
    L = list(test_words(cs))
    Ls = [(t[0][0][0],t[1]) for t in L]
    valid_phrases.extend(filter(lambda w:w[1] is not None, Ls))
    if cnt%500 == 0:
        print("Counter:{}\tPattern:{}".format(cnt,cs[0]))
        if len(valid_phrases) >0: 
            ans = "\n".join([template.format(t[0],"\n\t".join(map(str,t[1]))) for t in valid_phrases])
            fout.write("{}\n".format(ans))
            valid_phrases = []
    cs = take(cc,THREADS)
    cnt += 1
fout.close()


