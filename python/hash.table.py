#!/usr/bin/env python3

import hashlib

def generate_hashtable_one_array():
    # define a hashtable [key]=value
    D = {}
    D['a'] = 1
    D['b'] = 2
    D['c'] = 3

    print(D)
    print(D['a'])

    for k in D.keys():
        print(D[k])
    
    for k,v in D.items():
        print(k,':',v)

def generate_hashtable_two_arrays():
    keys = ['a', 'b', 'c']
    values = [1, 2, 3]
    hashtable = {k:v for k,v in zip(keys, values)}
    print(hashtable)

def generate_hashtable_hashlib():
    print hashlib.md5('a')
    print hashlib.md5('a').digest()
    print hashlib.md5('a').hexdigest()
    
    print hashlib.sha512('a')
    print hashlib.sha512('a').digest()
    print hashlib.sha512('a').hexdigest()

def main():
    generate_hashtable_one_array()
    generate_hashtable_two_arrays()
    generate_hashtable_hashlib()

if __name__ == "__main__":
    try:
        main()
    except (KeyboardInterrupt, SystemExit):
        pass

