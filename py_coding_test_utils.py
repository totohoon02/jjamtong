import sys

input = sys.stdin.readline

def spt():
    return input().split(" ")


def spt_map_int():
    return list(map(int, input().split(" ")))


def assertEqual(a, b):
    assert a == b
