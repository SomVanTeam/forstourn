import itertools
import datas
from random import Random

rng = Random(67)

combos = list(itertools.combinations(range(0, len(datas.PARTICIPANTS)), 5))
rng.shuffle(combos)

f = open("combos.txt", "w")
combonum = 0
for combo in combos:
    combonum += 1
    matchcombo = datas.MatchCombo(combo, combonum)
    f.write(repr(matchcombo)+"\n")
f.close()