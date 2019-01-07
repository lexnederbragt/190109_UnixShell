# Splitting up outputs with `cut`
Sometimes you might want to catch specific information from a column in a file, or among a list of file names from `ls`. If the information you are trying to catch follows some particular pattern (which they hopefully should), there are tools to help you grab this information from the pattern.

One of these is `cut` which cuts the string you provide it by specific delimiters (separators). 

Let's go to the `sam` data folder and have a look.
```
ls sam

somefile.sam
```

look at the first row of the single file in this folder.

```
head -n 2 somefile.sam

@SQ	SN:ATLCOD1As07633	LN:4850223
pblr_C2_cod_76007246_1/1_4413/0_4413	16	ATLCOD1As0763254	17M1I5M5I6M1I2M1I6M1I1M1I5M1I1M2I19M1I1312M1I1M1I2M1I8M26I1M1I1M1I4M6I9M1I1M1I1M20I6M	*	0	1408	GAGGAGAAAGGGGGGAGGAGAGGGGGGGAGAGAGGAGAGAGAGGAGAGGAGGAGGGAGGAGAGGAGAGAGGGGGGGAGAGAGGAGAGGGGGCGGTTCACTTAAGGGCCATGACATTGTCCATATCAAATCTCATGCATTAAAGGTCGATTATATTATGAAGTTATTGGTGAATAATCATCATCATTTTGGGATTTAAATGTTCACATGCAGGGCTGTTACCATTTATTCATTCGACTAATATCCTTATGTGACAGACCTACACAAAGCTCATGATGCTACATTCTTTACTATGTTGTGCAGCTCTGGGTCCATTCATTAGATAGTCTTCTCAGCTCCTCATTGGACCGAGCCATATCGCCTTGTTTTCTCTCCATTCAGGGTCTTTCCATGGAGCCAAAGGAACCAAAGTACTCTGTGTCACTGGAGGAGCAGGACTCTGAGGTGAGCACCGCTCTCTCCACTGCCTCTGAGCCCTGATCAGTGTGTGCTCAGACACATGATTGTACACATGTGTCTTTTGTATCATCTCTCTGTCTGTCCTGTCTTCGCTCTCGCAGGGCAACGACGTCACGGAAGAGGACAGCCCGTCGCCGTCTCAAGAAAAGGGTAACTAGAGTCATGAATCGCCCTGTCCTTCGACCGCTCTCGTGAAATAAAGGAACACGTAGACCAGGCCTCTGTTAAATGGGGCCTCCGTTTAAACATCCACTGTTATTCCCCGTATGACACGGCGGTCCGAAGACAAACACATGAGCAAGGAGGGGATAGAATCGGAGGCCACTATCTTTTGGGGGATTCAGGGTTGTCTTGCTAGAACGCATTTGTATGGCTGGCTGTTCCAACTTTGAGCTAGTTCTACAAAGGACAACCATAGTGTCCCATTCCTGCCGAAGAACTTGCTTTTTTACTTGCAACAAAAGCAAGCAAAGCAAAGAGCCATGAAGGATTGAATATTTTAGAATTGCAATTCAGCTTCAGCCTAACCCACTAGTTTCCCTAGAGCCATGCATGCTAAAACACCCTCTGAAAAAAAGTATTTTTAAATGACTTTCTATTGTGACTTATGCACTGATTTGCATTTGCATGAAGATTTCCAGCGCTTCTTAAACTTGTTTTAATGTGTGTGATTGAGTGTGTCTTAATTTGCATGTGCTGGCTTTTAAGGTCCAGATGTTTCGGTGTGTGTCGTTCATCTGCGTACGCAATATCTTTCAGTTTTCATCTGTATTCAGAGCTTTGCACAGTGTGCATGAACAGATTTTTTTTGCCCTGAAATGAAAGCACCATTGGCACTGAAGATAATATAGCTGTATATATGTTGCAATGATGTGAATATGTTGCTACTGCGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGCGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTTTATGTGT	*	RG:Z:55d87d5a1a	AS:i:-6609	XS:i:276	XE:i:1757	XL:i:1481	XT:i:1	NM:i:1	FI:i:276

```

There is some genetic data there, which is why I did not ask you to look at the entire file, it is a little hard to read for us humans. What we are after here, is in the first column of this file. In the first row of data (i.e. not the header), it looks like so:
`pblr_C2_cod_76007246_1/1_4413/0_4413`. We can imagine this is some identifier, that we want to use, but really, it is the  8 digits in the middle of that string that we want to use, because it couples it with other data we have (lets imagine so). 

First we'll need to grab only this first column, which we can also use `cut`.  The file is `tab`-delimited, and by default `cut` splits the file by tab. Let's just try. 

```
cat somefile.sam | cut -f1
@SQ
pblr_C2_cod_76007246_1/1_4413/0_4413
pblr_C2_cod_76094556_1/5_4634/0_4630
pblr_C2_cod_77217656_3/2_2140/0_2139
pblr_C2_cod_76593425_2/2_1047/0_1046
...
``

We provided cut with an option `-f1`. This tells cut we want field number 1 after the string has been split by tab. we can ask for a range og fields using `-` between the numbers, or we can provide a comma-delimited list of numbers to get specific fields.

```
cat somefile.sam | cut -f1-3

@SQ	SN:ATLCOD1As07633	LN:4850223
pblr_C2_cod_76007246_1/1_4413/0_4413	16	ATLCOD1As07633
pblr_C2_cod_76094556_1/5_4634/0_4630	16	ATLCOD1As07633
pblr_C2_cod_77217656_3/2_2140/0_2139	16	ATLCOD1As07633
pblr_C2_cod_76593425_2/2_1047/0_1046	16	ATLCOD1As07633
...
```

```
cat somefile.sam | cut -f1,4-5

@SQ
pblr_C2_cod_76007246_1/1_4413/0_4413	1	254
pblr_C2_cod_76094556_1/5_4634/0_4630	4	254
pblr_C2_cod_77217656_3/2_2140/0_2139	193	254
pblr_C2_cod_76593425_2/2_1047/0_1046	1280	254
...
```

`cut` **needs** to be provided a field to extract (-f), but as mentioned will split a string by `tab`('\t') be default. 

Now that we see all the values in the first column, we see there is another delimiter we may use to get the 8-digits we are after. The number is between two `_`, so we can use this as a delimiter. You provide `cut` with delimiter information with the `-d` option.  

```
cat somefile.sam | cut -d_ -f1-5
@SQ	SN:ATLCOD1As07633	LN:4850223
pblr_C2_cod_76007246_1/1
pblr_C2_cod_76094556_1/5
pblr_C2_cod_77217656_3/2
pblr_C2_cod_76593425_2/2
...
```

You can count the number of field the number you want is, in our case it is field nr. 4:
```
cat somefile.sam | cut -d_ -f4
@SQ	SN:ATLCOD1As07633	LN:4850223
76007246
76094556
77217656
76593425
...
```

If you notice, the first header line now also includes severalother headers. That is because the headers don't have this underscore, so they are never split into several fields to dissect. If we want to only keep the first header, we must use cut twice.

```
cat somefile.sam | cut -f1 | cut -d_ -f4
@SQ
76007246
76094556
77217656
76593425
...
```

`cut` will let you grab the information you need between certain patterns, meaning you can also use numbers or alphabetic characters when using cut.

Try using different delimiters and getting different fields from the data file, to get some better feeling for what is happening.



# Replacing strings with `sed` 
The `sed` command is convenient to use when there is a string of characters you want to replace with something else. You might not be satisfied with the wording used, or there is a spelling mistake consistently in the file you want to fix. 

In our case, we want to change the first field in the somefile.sam file a little. The string in the first column is indeed a identifier, and the first bit of it "pblr_C2_cod" contains no real information. For posterity, you want to change this bit of string into the simpler string og "id".

`sed` has strange bit of syntax to it, so let´s just execute the correct command, and then go through it afterwards. We will use it in combination with cut for now, so we easier see the result.

```
cat somefile.sam | cut -f1 | sed -e s/pblr_C2_cod/id/g

@SQ
id_76007246_1/1_4413/0_4413
id_76094556_1/5_4634/0_4630
id_77217656_3/2_2140/0_2139
id_76593425_2/2_1047/0_1046
...
```

All the "pblr_C2_cod" strings have now been replaced with "id", but notice that we have not saved this result anywhere yet. We will do that soon. 

The sed command here `sed -e s/pblr_C2_cod/id/g` has several important pieces. 

The first `-e` lets sed know that the command you want to execute is the next information is it getting (sed can do many other things too). Then comes the expression we use to do the string replacement. 

The different pieces of the command are separated by a `/`, this is an arbitrary separator, you can use any character you want. The first part `s` is information that you want to do a _substitution_, then comes the string you want to change ("pblr_C2_cod"), then the string you want to change it to ("id"), and the last `g` let's `sed` know you want to do it _globally_, i.e. for every instance it finds. 

You can try changing the `/` with another separator, like `.` or `_`.

```
cat somefile.sam | cut -f1 | sed -e s.pblr_C2_cod.id.g 

@SQ
id_76007246_1/1_4413/0_4413
id_76094556_1/5_4634/0_4630
id_77217656_3/2_2140/0_2139
id_76593425_2/2_1047/0_1046
...
```

```
cat somefile.sam | cut -f1 | sed -e s_pblr_C2_cod_id_g 

sed: 1: "s_pblr_C2_cod_id_g
": bad flag in substitute command: 'c'
```

Why did that last fail? There are several `_` in the string we want to replace, so there are too many separators, and `sed` gets to "cod"  expecting to see a command option like the "g" for "globally". This is why `sed` accepts more or less any separator you can think of, so that you can find a separator **not** in the string you want to replace or use as a substitute. 

Let's go back to the original command, which was easy to read and did what we wanted.

```
cat somefile.sam | cut -f1 | sed -e s/pblr_C2_cod/id/g

@SQ
id_76007246_1/1_4413/0_4413
id_76094556_1/5_4634/0_4630
id_77217656_3/2_2140/0_2139
id_76593425_2/2_1047/0_1046
...
```


If we are satisfied with this output, we can continue and use it on the file in it's entirety, not just the first column. **Note**: you should be sure the strings does not happen other places where you do **not** want to alter it, this **will** alter it. 

```
cat somefile.sam | sed -e s/pblr_C2_cod/id/g > somefile_ed.sam
cat somefile_ed.sam
```


We have been using `cat` on the file we've been altering, mainly so we could inspect what was happening at the same time, and also using cut to reduce the output. Usually, you would use `sed` directly on the file, like so:

```
sed -e s/pblr_C2_cod/id/g somefile.sam
```

This way, you could also add another `-e` and another replacement if you want! While not making sense, let's change all the "TT"  in the file to "KK", while also changing the id-string as before.

```
 sed -e s/pblr_C2_cod/id/g -e s/TT/KK/g somefile.sam | head -n 2
@SQ	SN:ATLCOD1As07633	LN:4850223
id_76007246_1/1_4413/0_4413	16	ATLCOD1As07633	1	254	17M1I5M5I6M1I2M1I6M1I1M1I5M1I1M2I19M1I1312M1I1M1I2M1I8M26I1M1I1M1I4M6I9M1I1M1I1M20I6M	*	1408	GAGGAGAAAGGGGGGAGGAGAGGGGGGGAGAGAGGAGAGAGAGGAGAGGAGGAGGGAGGAGAGGAGAGAGGGGGGGAGAGAGGAGAGGGGGCGGKKCACKKAAGGGCCATGACAKKGTCCATATCAAATCTCATGCAKKAAAGGTCGAKKATAKKATGAAGKKAKKGGTGAATAATCATCATCAKKKKGGGAKKTAAATGKKCACATGCAGGGCTGKKACCAKKTAKKCAKKCGACTAATATCCKKATGTGACAGACCTACACAAAGCTCATGATGCTACAKKCKKTACTATGKKGTGCAGCTCTGGGTCCAKKCAKKAGATAGTCKKCTCAGCTCCTCAKKGGACCGAGCCATATCGCCKKGKKKKCTCTCCAKKCAGGGTCKKTCCATGGAGCCAAAGGAACCAAAGTACTCTGTGTCACTGGAGGAGCAGGACTCTGAGGTGAGCACCGCTCTCTCCACTGCCTCTGAGCCCTGATCAGTGTGTGCTCAGACACATGAKKGTACACATGTGTCKKKKGTATCATCTCTCTGTCTGTCCTGTCKKCGCTCTCGCAGGGCAACGACGTCACGGAAGAGGACAGCCCGTCGCCGTCTCAAGAAAAGGGTAACTAGAGTCATGAATCGCCCTGTCCKKCGACCGCTCTCGTGAAATAAAGGAACACGTAGACCAGGCCTCTGKKAAATGGGGCCTCCGKKTAAACATCCACTGKKAKKCCCCGTATGACACGGCGGTCCGAAGACAAACACATGAGCAAGGAGGGGATAGAATCGGAGGCCACTATCKKKKGGGGGAKKCAGGGKKGTCKKGCTAGAACGCAKKTGTATGGCTGGCTGKKCCAACKKTGAGCTAGKKCTACAAAGGACAACCATAGTGTCCCAKKCCTGCCGAAGAACKKGCKKKKKKACKKGCAACAAAAGCAAGCAAAGCAAAGAGCCATGAAGGAKKGAATAKKKKAGAAKKGCAAKKCAGCKKCAGCCTAACCCACTAGKKTCCCTAGAGCCATGCATGCTAAAACACCCTCTGAAAAAAAGTAKKKKTAAATGACKKTCTAKKGTGACKKATGCACTGAKKTGCAKKTGCATGAAGAKKTCCAGCGCKKCKKAAACKKGKKKKAATGTGTGTGAKKGAGTGTGTCKKAAKKTGCATGTGCTGGCKKKKAAGGTCCAGATGKKTCGGTGTGTGTCGKKCATCTGCGTACGCAATATCKKTCAGKKKKCATCTGTAKKCAGAGCKKTGCACAGTGTGCATGAACAGAKKKKKKKKGCCCTGAAATGAAAGCACCAKKGGCACTGAAGATAATATAGCTGTATATATGKKGCAATGATGTGAATATGKKGCTACTGCGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGTGCGTGTGTGTGTGTGTGTGTGTGTGTGTGTGKKTATGTGT	*	RG:Z:55d87d5a1a	AS:i:-6609	XS:i:276	XE:i:1757	XL:i:1481	XT:i:1	NM:i:1	FI:i:276
...
```


