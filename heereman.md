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

Here are 59 files, all formatted the same way and following the same naming scheme. The first four lines of every file give some information about the content of the file w3 columnshile the rest contains two columns with data specified in line 2 and line 3 of the file.

```
head -n 4 well_0001.txt

# Well: well_0001
# Column 1: Depth MDRKB (m)
# Column 2: Tcorr one way time (ms)

```

The goal of this lesson is to create one single file containing 3 columns where the first column conatins the well number (as stated in the first line of every file), the second column contains the depth and the third column the one way time, like this:

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

