# Data manipulation with `awk/gawk`

`Awk` is a scripting language used for manipulating data and generating reports.The `awk` command programming language requires no compiling, and allows the user to use variables, numeric functions, string functions, and logical operators.

A lot of research data is in tabular format. Sometimes you want to cut columns, re-order columns or do arithmetic on column values. The `awk` language can help you with that and can be used in combination with other `Unix` command.

Let's have a look at the `wells` folder

```
ls wells

well_0001.txt  well_0010.txt  well_0019.txt  well_0028.txt  well_0037.txt  well_0046.txt  well_0055.txt
well_0002.txt  well_0011.txt  well_0020.txt  well_0029.txt  well_0038.txt  well_0047.txt  well_0056.txt
well_0003.txt  well_0012.txt  well_0021.txt  well_0030.txt  well_0039.txt  well_0048.txt  well_0057.txt
well_0004.txt  well_0013.txt  well_0022.txt  well_0031.txt  well_0040.txt  well_0049.txt  well_0058.txt
well_0005.txt  well_0014.txt  well_0023.txt  well_0032.txt  well_0041.txt  well_0050.txt  well_0059.txt
well_0006.txt  well_0015.txt  well_0024.txt  well_0033.txt  well_0042.txt  well_0051.txt
well_0007.txt  well_0016.txt  well_0025.txt  well_0034.txt  well_0043.txt  well_0052.txt
well_0008.txt  well_0017.txt  well_0026.txt  well_0035.txt  well_0044.txt  well_0053.txt
well_0009.txt  well_0018.txt  well_0027.txt  well_0036.txt  well_0045.txt  well_0054.txt
```

Here are 59 files, all formatted the same way and following the same naming scheme. The first four lines of every file give some information about the content of the file while the rest contains two columns with data specified in line 2 and line 3 of the file.

```
head -n 4 well_0001.txt

# Well: well_0001
# Column 1: Depth MDRKB (m)
# Column 2: Tcorr one way time (ms)

```

The goal of this lesson is to create one single file containing 3 columns where the first column contains the *well number* (as stated in the first line of every file), the second column contains the *depth* and the third column the *one-way time*, like this:

```
more all_wells.txt

well_0001 1000 522.43
well_0001 1130 581.34
well_0001 1500 757.53
...
...
...
well_0059 17050 2029.82
well_0059 17200 2041.96
well_0059 17250 2043.78
```

# Working with columns

Let's write our first `awk` command. What do you expect the following command will print to `stdout`

```
cat well_0002.txt | awk '{print $1}'
```

<details><summary>Solution</summary>

```
#
#
#

5520
7000
8400
9300
9770
10530
10750
12750
13350
```

It prints the first columns of all the records.
</details>
<p></p>

I do not want the first 4 lines and want to remove them from the output. For this, we can look at a buid-in variable of `awk` called `FNR`, which is the *field record number* (which can be compared to the line number).

```
cat well_0002.txt | awk '{if (FNR > 4) print $1}'
```

<details><summary>Other build-in variable in `awk`</summary>
[<a href="https://www.thegeekstuff.com/2010/01/8-powerful-awk-built-in-variables-fs-ofs-rs-ors-nr-nf-filename-fnr/">8 Powerful Awk Built-in Variables – FS, OFS, RS, ORS, NR, NF, FILENAME, FNR</a>
</details>
<p></p>

I also want to add the second column and I want the columns to be separated with a `TAB`. To do the last, we introduce a new build-in variable called `OFS`, which stands for *output field separator*.

```
cat well_0002.txt | awk '{OFS="\t"; if (FNR > 4) print $1, $2}'
```
or
```
cat well_0002.txt | awk 'BEGIN {OFS="\t"} {if (FNR > 4) print $1, $2}'
```

Now, I want to add a first column that contains the string *well_0002*, which is located in the first line of the file. I can get hold on that string in the beginning of the `awk` statement by setting a variable.

```
cat well_0002.txt | awk 'BEGIN {OFS="\t"} {if (FNR == 1) {well_name = $3}; if (FNR > 4) print well_name, $1, $2}'

well_0002       5520    843.2
well_0002       7000    1089.3
well_0002       8400    1303.3
well_0002       9300    1434.3
well_0002       9770    1492.3
well_0002       10530   1570.4
well_0002       10750   1580.4
well_0002       12750   1700.4
well_0002       13350   1767.4
```

Now I want to do this for all my wells. How can we do that?

```
for i in $(ls *.txt); do cat $i | awk 'BEGIN {OFS="\t"} {if (FNR == 1) {well_name = $3}; if (FNR > 4) print well_name, $1, $2}'; done
```

Last but not least, I want to write it to a file:

```
for i in $(ls *.txt); do cat $i | awk 'BEGIN {OFS="\t"} {if (FNR == 1) {well_name = $3}; if (FNR > 4) print well_name, $1, $2}'; done > file.asc
```

# Manipulating columns (if time is left)

I have forgotten to check one thing before I started and that is whether all *depth* values are given in meters. Some of these files might have depth values in *feet*. I want to adjust the files containing depth values in *feet*

```
egrep "(ft)" *

well_0002.txt:# Column 1 depth MDRKB (ft)
well_0003.txt:# Column 1 depth MDRKB (ft)
well_0004.txt:# Column 1 depth MDRKB (ft)
well_0005.txt:# Column 1 depth MDRKB (ft)
well_0006.txt:# Column 1 depth MDRKB (ft)
well_0007.txt:# Column 1 depth MDRKB (ft)
well_0011.txt:# Column 1 depth MDRKB (ft)
well_0015.txt:# Column 1 depth MDRKB (ft)
well_0016.txt:# Column 1 depth MDRKB (ft)
well_0017.txt:# Column 1 depth MDRKB (ft)
well_0018.txt:# Column 1 depth MDRKB (ft)
well_0019.txt:# Column 1 depth MDRKB (ft)
well_0021.txt:# Column 1 depth MDRKB (ft)
well_0022.txt:# Column 1 depth MDRKB (ft)
well_0024.txt:# Column 1 depth MDRKB (ft)
well_0025.txt:# Column 1 depth MDRKB (ft)
well_0026.txt:# Column 1 depth MDRKB (ft)
well_0027.txt:# Column 1 depth MDRKB (ft)
well_0028.txt:# Column 1 depth MDRKB (ft)
well_0029.txt:# Column 1 depth MDRKB (ft)
well_0055.txt:# Column 1 depth MDRKB (ft)
well_0056.txt:# Column 1 depth MDRKB (ft)
well_0057.txt:# Column 1 depth MDRKB (ft)
well_0059.txt:# Column 1 depth MDRKB (ft)
```

and with the use of the earlier learned `cut` command we get:

```
egrep "(ft)" * | cut -d: -f1

well_0002.txt
well_0003.txt
well_0004.txt
well_0005.txt
well_0006.txt
well_0007.txt
well_0011.txt
well_0015.txt
well_0016.txt
well_0017.txt
well_0018.txt
well_0019.txt
well_0021.txt
well_0022.txt
well_0024.txt
well_0025.txt
well_0026.txt
well_0027.txt
well_0028.txt
well_0029.txt
well_0055.txt
well_0056.txt
well_0057.txt
well_0059.txt
```

Now we can run a loop on these files and manipulate their depth columns

```
for i in $(egrep "(ft)" * | cut -d: -f1); do cat $i | awk 'BEGIN {OFS="\t"} {if (FNR < 4) {print $0} else {print int($1*0.3048), $2}}' > $i.new; done
```
