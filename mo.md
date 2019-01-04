# Splitting up outputs with `cut`
Sometimes you might want to catch certain information from file names, to use later.
For instance, the filenames may contain identifiers you need to match to merge the data with other data.

Have a look in the `generated` folder. 

```
ls generated

Result.220.txt Result.341.txt Result.497.txt Result.755.txt Result.923.txt
Result.232.txt Result.364.txt Result.646.txt Result.759.txt Result.935.txt
Result.248.txt Result.416.txt Result.673.txt Result.854.txt Result.958.txt
Result.285.txt Result.437.txt Result.734.txt Result.916.txt Result.979.txt
```

Here are 20 files, following the same naming schema. These files contain three tab-separated columns:  
- an encryption key
- a numric result
- result status

```
ls generated | xargs cat

81610233c2d4 	 14728 	 complete
93c034654934 	 29888 	 complete
e16ccf0294c9 	 29683 	 complete
18ea95834168 	 247 	 complete
7b37c1b603c9 	 1338 	 complete
a6ecb9cee9ce 	 21797 	 complete
e4e8486e5406 	 28426 	 incomplete
49a9433e0b59 	 2362 	 complete
c5d3e0893649 	 16454 	 complete
2ba3b3021bc4 	 2818 	 incomplete
9b41d81c9fdc 	 4005 	 complete
b00a7b6b4b97 	 15326 	 complete
86f802f262ec 	 24341 	 complete
c43832694e4b 	 1240 	 incomplete
f0bbd1e63f34 	 12619 	 complete
7478d4efd493 	 12638 	 incomplete
d4a7636394f2 	 3464 	 complete
2a402aea091e 	 11423 	 complete
0c3cf0d5d6a7 	 1704 	 complete
2e0092de7901 	 20135 	 complete
```

You want the three numbers in the filenames to use as identifiers to match the data with other sources. The `cut` command can help you with this.

`cut` is a command where you may provide a _delimiter_ by which to split a string up into several pieces. In this case, we are lucky and the number is between two `.`, so we can use this as a delimiter. You provide `cut` with delimiter information with the `-d` option. Secondly, you must inform `cut` which _field_ you want to keep. In this case, there are two `.`, so the string will have three fields. We want to keep the second field. We do this by providing the option `-f`. 

```
ls generated | cut -d. -f2

220
232
248
285
341
364
416
437
497
646
673
734
755
759
854
916
923
935
958
979
```

You may choose to keep several fields with you like.
```
ls generated | cut -d. -f2-3

220.txt
232.txt
248.txt
285.txt
341.txt
364.txt
416.txt
437.txt
497.txt
646.txt
673.txt
734.txt
755.txt
759.txt
854.txt
916.txt
923.txt
935.txt
958.txt
979.txt
```


# Replacing strings with `sed`
The `sed` command is convenient to use when there is a string of characters you want to replace with something else. You might not be satisfied with the wording used, or there is a spelling mistake consistently in the file you want to fix. 

In our case, we might want to change the word "incomplete" in the result files, because we know that this actually means the analysis has failed. 

`sed` has strange bit of syntax to it, so let´s just execute the correct command, and then go through it afterwards.

```
ls generated | xargs cat | sed -e s/incomplete/failed/g

81610233c2d4 	 14728 	 complete
93c034654934 	 29888 	 complete
e16ccf0294c9 	 29683 	 complete
18ea95834168 	 247 	 complete
7b37c1b603c9 	 1338 	 complete
a6ecb9cee9ce 	 21797 	 complete
e4e8486e5406 	 28426 	 failed
49a9433e0b59 	 2362 	 complete
c5d3e0893649 	 16454 	 complete
2ba3b3021bc4 	 2818 	 failed
9b41d81c9fdc 	 4005 	 complete
b00a7b6b4b97 	 15326 	 complete
86f802f262ec 	 24341 	 complete
c43832694e4b 	 1240 	 failed
f0bbd1e63f34 	 12619 	 complete
7478d4efd493 	 12638 	 failed
d4a7636394f2 	 3464 	 complete
2a402aea091e 	 11423 	 complete
0c3cf0d5d6a7 	 1704 	 complete
2e0092de7901 	 20135 	 complete
```

All the "incomplete" strings have now been replaced with "failed", but notice that we have not saved this result anywhere yet. We will do that soon. 

The sed command here `sed -e s/incomplete/failed/g` has several important pieces. The first `-e` lets sed know that the command you want to execute is the next information is it getting (sed can do many other things too). Then comes the expression we use to do the string replacement. The different pieces of the command are separated by a `/`, this is an arbitrary separator, you can use any character you want (except `.`). The first part `s` is information that you want to do a _substitution_, then comes the string you want to change ("incomplete"), then the string you want to change it to ("failed"), and the last `g` let's sed know you want to do it _globally_, i.e. for every instance it finds. 

If we are satisfied with this output, we can save it in it's entirety with the `>` sign.

```
ls generated | xargs cat | sed -e s/incomplete/failed/g > All_results.txt
cat All_results.txt
```

What will happen if you try to replace the word "complete" with the same approach as before, both in the `All_results.txt` file and on this command `ls generated | xargs cat`? What is the difference?



