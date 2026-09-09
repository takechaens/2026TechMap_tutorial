#!/usr/bin/env python3
"""
Regenerates the cumulative code slices used by MoviePosterTutorial.tutorial.

Why this exists
---------------
Each @Step's @Code panel is diffed by DocC against the previous step's file.
If a step's file *removes or changes* a line (instead of only adding), DocC
renders that line struck through in the tutorial preview, which confuses
beginners. To guarantee every step is purely additive, all slice files
(av-s1-2.swift ... av-s7-4.swift) are generated here as strict line-supersets
of the real shipping file, ../ARViewContainer.swift.

STEPS maps each tutorial step id -> the exact target line numbers it introduces.
Every line 1..N of ../ARViewContainer.swift must be assigned to exactly one step.
The script asserts that, then writes each slice = union of all lines up to that
step, emitted in original order. av-s7-4.swift must come out byte-identical to
../ARViewContainer.swift.

If you edit ../ARViewContainer.swift, update STEPS to cover the new line numbers
and rerun:  python3 _generate_slices.py
"""
import os

RES = os.path.dirname(os.path.abspath(__file__))
# ../../  ->  the app source folder that holds ARViewContainer.swift and the .docc
APP_SRC = os.path.normpath(os.path.join(RES, "..", ".."))
TARGET_AV = os.path.join(APP_SRC, "ARViewContainer.swift")
TARGET_CV = os.path.join(APP_SRC, "ContentView.swift")

with open(TARGET_AV) as f:
    TARGET = f.read().split("\n")
if TARGET and TARGET[-1] == "":
    TARGET = TARGET[:-1]
N = len(TARGET)


def R(*spec):
    out = []
    for s in spec:
        if isinstance(s, int):
            out.append(s)
        else:
            a, b = s
            out.extend(range(a, b + 1))
    return out


# step id -> target line numbers (1-indexed) this step ADDS
STEPS = [
    ("s1-2", R(1, 2, 5, (6, 10), (15, 18), 54, 55, 328)),
    ("s1-3", R((56, 59))),
    ("s2-3", R(3, (21, 26))),
    ("s2-4", R((27, 36))),
    ("s2-5", R((37, 41))),
    ("s2-6", R(42, 43)),
    ("s3-1", R((11, 14), (60, 65), 327)),
    ("s3-2", R(19, 20)),
    ("s3-3", R((44, 49))),
    ("s3-4", R((50, 53))),
    ("s4-1", R((72, 75), 89)),
    ("s4-2", R((78, 80), 88)),
    ("s4-3", R(81, 82)),
    ("s4-4", R((66, 68), 76, 77)),
    ("s4-5", R((83, 87))),
    ("s5-1", R((90, 96), (119, 122), (239, 242), 247, 248)),
    ("s5-2", R((107, 113))),
    ("s5-3", R((114, 118), (128, 140))),
    ("s5-4", R((123, 127))),
    ("s5-5", R((141, 177), (249, 271))),
    ("s5-6", R((231, 236))),
    ("s6-1", R(4, (97, 106))),
    ("s6-2", R((69, 71), (178, 184))),
    ("s6-3", R((185, 191), (310, 326))),
    ("s6-4", R((192, 201))),
    ("s6-5", R((202, 209), (225, 230), 238, (243, 246), (272, 309))),
    ("s7-1", R((210, 216))),
    ("s7-2", R((217, 221))),
    ("s7-3", R((222, 224))),
    ("s7-4", R(237)),
]

seen = set()
for sid, lines in STEPS:
    for ln in lines:
        assert 1 <= ln <= N, (sid, ln)
        assert ln not in seen, f"line {ln} assigned twice (at {sid})"
        seen.add(ln)
missing = sorted(set(range(1, N + 1)) - seen)
assert not missing, f"unassigned lines: {missing}"
print(f"line assignment OK: all {N} lines covered exactly once")

acc = set()
for sid, lines in STEPS:
    acc |= set(lines)
    body = "\n".join(TARGET[i - 1] for i in sorted(acc)) + "\n"
    with open(os.path.join(RES, f"av-{sid}.swift"), "w") as f:
        f.write(body)

final_body = "\n".join(TARGET) + "\n"
with open(TARGET_AV) as f:
    assert final_body == f.read(), "av-s7-4 slice != ARViewContainer.swift (update STEPS)"
print("av-s7-4.swift == ARViewContainer.swift  OK")

with open(TARGET_CV) as f:
    cv = f.read()
with open(os.path.join(RES, "cv.swift"), "w") as f:
    f.write(cv)
print("cv.swift == ContentView.swift  OK")
print(f"wrote {len(STEPS)} slices + cv.swift")
