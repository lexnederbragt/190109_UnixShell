Based on a Late Lunch talk by Lex Nederbragt on November 2nd, 2015 entitled "*Insider tips and tricks for using CEES HPC resources*."


## Before we begin

We will use a set of files and folders to practice a bit. Please copy this tarball and extract its content to, for example, your Desktop, or home area on abel:

`https://github.com/lexnederbragt/190109_UnixShell/data.tgz`

Uncompress, for example using `tar`:

`tar -xvzf data.tgz`

This file is also available from abel directly at `/work/users/alexajo/190109_UnixShell_data.tgz`

## The `.bash_login` file
* do you use your `.bash_login` file? It is located in your home area, so it is `~/.bash_login`
* on some systems, the file may be called `.bash_profile` or `.bashrc`
* See this blog post "[Bash Configurations Demystified](https://blog.dghubble.io/post/.bashprofile-.profile-and-.bashrc-conventions/)" from Dalton Hubble on tips, tricks, and how to avoid dangers.

### Aliases

Shell aliases are short, single-word shell commands that really are much longer commands. They make your life easier. You put these in your `.bash_login` file.

Some examples I use:

```
alias ll='ls -l'
alias lh='ls -lh'
alias la='ls -la'
alias lr='ls -ltr'
alias l1='ls -1'
alias cd..='cd ..'
```

NOTE:

* do not use spaces around the '=' sign
* make sure to put the long command in quotation marks
* in order to make these changes become effective, you have to either log out and back in, or execute the `.bash_login` file:

```
source ~/.bash_login
```


**Exercise:** put one or more of these aliases in your `.bash_login` file, execute the file and try the new alias(es) out on the files and folders you copied.

### tar

I use the following aliases to make creating and uncompressing 'tarballs' easier:

```
alias maketar='tar -cvzf'
alias untar='tar -xvzf'
alias tarlist='tar -ztvf'
```

(check out <https://xkcd.com/1168/>)

### passwords

Do you ever need a random password quickly:

```
alias pw="tr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | fold -w 12 | head -n 1"
```

Note that this (for me) only works on Abel, not on my Mac

### Shell variables

Shell variables hold values so they can be reused. Some are builtin, such as $PWD, $HOME and $PATH. But you can set any variable yourself. You can see all your variables by typing

```
env
```

In my `.bash_login` file, I also set a few variables to make my life easier:

```
cod5=cod5.hpc.uio.no
cod6=cod6.hpc.uio.no
cod7=cod7.hpc.uio.no
```

Now I can do this to log in to the cod nodes

```
ssh $cod5
```

Note how I don't have to type my username, this is because I am logging in as the same username I need to use on the cod nodes.

Oh, and when you are on the UiO network, you can log into able like this:

```
ssh abel
```

Instead of

```
ssh username@abel.uio.no
```

We'll come back to why I don't have to type my password...

Other shell variable I use:

```
export D=/projects/cees/
export I=/projects/cees/in_progress
```

Now I can do `cd $D` and `cd $I`

Finally, I have a function in my `.bash_login` file that creates a folder and does a `cd` into it in one go:

```
mkcd () {
mkdir -p "$*"
cd "$*"
}
```

Now I can do:

```
mkcd new_foldername
```

instead of
```
mkdir new_foldername
cd new_foldername
```

**Exercise:** put the above function in your `.bash_login` file, execute the file and make a new folder using `mkcd`.

Putting it all together, this may be a typical start of my work on abel or the cod nodes:

```
ssh $cod5
cd $I/lex
mkcd new_project
```
### The prompt

The prompt is the beginning of the line. For example, when you log into a cod node, you may see

`[username@hostname ~]`

Setting the prompt can be done by changing the PS1 variable, but it is a kind of special language you need to use. Let's first check what it is right now:

```
echo $PS1
```

You may see this:

`[\u@\h \W]\$ `

* `\u` is your username
* `\h` is the name of the server
* `\W` is the name of the current folder

Without going into the details, you can modify as you like. Some people like to have the full path of the current folder, instead of just the current folder. Others like colours.

When I am teaching, I usually set the prompt to only the dollar sign `$` and a space, like this:

```
export PS1='$ '
```

This saves me a lot of 'space' in the terminal window and reduces confusion for novices.

Here are a few other examples, please try them out. Use the `export PS1=''` with the desired settings in the quotations marks.

```
export PS1='[\h \W]$ '
export PS1='[\u@\h \W]\$ '
export PS1='\[\e[32;1m\](\[\e[37;0m\]UiO:\u@\h\[\e[32;1m\])-(\[\e[37;0m\]\w\[\e[32;1m\])\n$ \[\e[0m\]'
```

NOTE:

* do not use spaces around the '=' sign
* you may want to add a space at the end.

Our wiki also has a nice one, see <https://wiki.uio.no/mn/bio/cees-bioinf/index.php/User_manual_cod_nodes#Setting_up_your_environment>

You can also design your prompt by using the 'bashrcgenerator' at <http://bashrcgenerator.com/>.

Once you have selected your prompt, put the `export PS1=''` line in your `.bash_login` file and log out and back in.

Finally, I use this in my `.bash_login` to visualise that I am in a screen:

```
if [ "$TERM" == "screen" ]; then
    export PS1=[SCREEN]$PS1
fi
```
## Those Who Know History Can Choose to Repeat It
(quote from an older version of the [Software Carpentry Unix Shell lesson](http://swcarpentry.github.io/shell-novice/))

Typing `history` will show your last commands, up to 1000.
You can repeat the *nth* command by typing `!` followed by the number:

```
!1013
```

And you can execute the last command with a certain word by typing, for example,

```
!ls
```

You can also use the arrow-up (and down) keys to scroll through your last commands.

But the best tip I have is searching through your history by typing `ctrl-r`, followed by a few characters of the command you are looking for. Once you get some results, it may not be the right one, so you can type `ctrl-r` another time to have the search go even more back in the history (or `ctrl-shift-r` to move forward in the history). I use this *all the time* and it is a real time save.

Another trick that I just recently learned and find myself using every day is `!$`. This repeats the last element of the previous command, for example:

```
ls /projects/cees/in_progress
cd !$
```

The `!$` will expand to `/projects/cees/in_progress`:

```
cd /projects/cees/in_progress
```

I use this very often, as well as:

```
ls /projects/cees/in_progress/lex/somefile.txt
less !$
```

## Viewing files (aka less is more)

The `less` command is really powerful. For this part, we will use a file with demographic data that is part of the files you copied:

```
head gapminderData/gapminderDataFiveYear.txt
country	year	pop	continent	lifeExp	gdpPercap
Afghanistan	1952	8425333	Asia	28.801	779.4453145
Afghanistan	1957	9240934	Asia	30.332	820.8530296
Afghanistan	1962	10267083	Asia	31.997	853.10071
Afghanistan	1967	11537966	Asia	34.02	836.1971382
Afghanistan	1972	13079460	Asia	36.088	739.9811058
Afghanistan	1977	14880372	Asia	38.438	786.11336
Afghanistan	1982	12881816	Asia	39.854	978.0114388
Afghanistan	1987	13867957	Asia	40.822	852.3959448
Afghanistan	1992	16317921	Asia	41.674	649.3413952
```
(see <http://www.gapminder.org/world> for the origin of this data)

### Moving about with less

* type `shift-G` to move to the end. Very useful for for example log files, or when you do `history|less`
* type `g` to go to the beginning of the file

### Searching with less

* after you type `less`, type a forward slash `/` and a search text. The line where the search text was first found will be at the top of your screen
* type `n` to go to the next hit or `shift-n` for the previous one
* make the search case-insensitive by using `less -i`

**Exercise:** try this out by searching (using `less)` in the `gapminderDataFiveYear.txt` file in the `gapminderData` folder

* search for 'Norway' and other countries
* search occurrences of '2007'
* search for 'norway' (lower case!)

### Getting to know your files better

Giving the `cat` command the `-t` flag will show tabs by replacing them with `^I`.

```
cat -t gapminderData/gapminderDataFiveYear.txt |head
country^Iyear^Ipop^Icontinent^IlifeExp^IgdpPercap
Afghanistan^I1952^I8425333^IAsia^I28.801^I779.4453145
Afghanistan^I1957^I9240934^IAsia^I30.332^I820.8530296
Afghanistan^I1962^I10267083^IAsia^I31.997^I853.10071
Afghanistan^I1967^I11537966^IAsia^I34.02^I836.1971382
Afghanistan^I1972^I13079460^IAsia^I36.088^I739.9811058
Afghanistan^I1977^I14880372^IAsia^I38.438^I786.11336
Afghanistan^I1982^I12881816^IAsia^I39.854^I978.0114388
Afghanistan^I1987^I13867957^IAsia^I40.822^I852.3959448
Afghanistan^I1992^I16317921^IAsia^I41.674^I649.3413952
```

Giving the `cat` command the `-n` flag will show line numbers:

```
cat -n gapminderData/gapminderDataFiveYear.txt | head
     1	country	year	pop	continent	lifeExp	gdpPercap
     2	Afghanistan	1952	8425333	Asia	28.801	779.4453145
     3	Afghanistan	1957	9240934	Asia	30.332	820.8530296
     4	Afghanistan	1962	10267083	Asia	31.997	853.10071
     5	Afghanistan	1967	11537966	Asia	34.02	836.1971382
     6	Afghanistan	1972	13079460	Asia	36.088	739.9811058
     7	Afghanistan	1977	14880372	Asia	38.438	786.11336
     8	Afghanistan	1982	12881816	Asia	39.854	978.0114388
     9	Afghanistan	1987	13867957	Asia	40.822	852.3959448
    10	Afghanistan	1992	16317921	Asia	41.674	649.3413952
```

Using `cat -e` will show line endings:

```
cat -e gapminderData/gapminderDataFiveYear.txt |head
country	year	pop	continent	lifeExp	gdpPercap$
Afghanistan	1952	8425333	Asia	28.801	779.4453145$
Afghanistan	1957	9240934	Asia	30.332	820.8530296$
Afghanistan	1962	10267083	Asia	31.997	853.10071$
Afghanistan	1967	11537966	Asia	34.02	836.1971382$
Afghanistan	1972	13079460	Asia	36.088	739.9811058$
Afghanistan	1977	14880372	Asia	38.438	786.11336$
Afghanistan	1982	12881816	Asia	39.854	978.0114388$
Afghanistan	1987	13867957	Asia	40.822	852.3959448$
Afghanistan	1992	16317921	Asia	41.674	649.3413952$
```

**Exercise:** What is 'wrong' with the `barcode/barcode.fasta` file?

If your terminal window is not very wide, using `less` on a file with long lines may cause the lines to wrap around, for example with:

```
less velvet/stats.txt
```

By using `less -S` you avoid the wrapping, and you can use the left and right arrow keys to view the rest of the line, e.g. scrolling through it horizontally:

```
less -S velvet/stats.txt
```

**Exercise:** Try `less` with and without `-S` on the `sam/somefile.sam` file

Columnar files viewed with `cat` or `less`, in which the text in the different rows is of unequal length, may not line up, as for example here:

```
head gapminderData/gapminderDataFiveYear.txt
country	year	pop	continent	lifeExp	gdpPercap
Afghanistan	1952	8425333	Asia	28.801	779.4453145
Afghanistan	1957	9240934	Asia	30.332	820.8530296
Afghanistan	1962	10267083	Asia	31.997	853.10071
Afghanistan	1967	11537966	Asia	34.02	836.1971382
Afghanistan	1972	13079460	Asia	36.088	739.9811058
Afghanistan	1977	14880372	Asia	38.438	786.11336
Afghanistan	1982	12881816	Asia	39.854	978.0114388
Afghanistan	1987	13867957	Asia	40.822	852.3959448
Afghanistan	1992	16317921	Asia	41.674	649.3413952
```

By using the `column` command, with the `-t` flag (for 'create a table'), you will get nicely aligned columns:

```
column -t gapminderData/gapminderDataFiveYear.txt | head
country        year      pop               continent  lifeExp   gdpPercap
Afghanistan    1952      8425333           Asia       28.801    779.4453145
Afghanistan    1957      9240934           Asia       30.332    820.8530296
Afghanistan    1962      10267083          Asia       31.997    853.10071
Afghanistan    1967      11537966          Asia       34.02     836.1971382
Afghanistan    1972      13079460          Asia       36.088    739.9811058
Afghanistan    1977      14880372          Asia       38.438    786.11336
Afghanistan    1982      12881816          Asia       39.854    978.0114388
Afghanistan    1987      13867957          Asia       40.822    852.3959448
Afghanistan    1992      16317921          Asia       41.674    649.3413952
```

Sometimes this is not enough, though, for example try this out on the `velvet/stats.txt` with a not too wide terminal window

Combining column -t and less -S makes for a nicely formatted table you can browse through using the arrow keys:

```
column -t velvet/stats.txt | less -S
```

Magic!

One final thing: if your data is tab separates, you can force `column` to use tabs instead of spaces by running
```
column -t -s $'\t' file.txt
```

## Finding files and looping over them

[Inspired by the Software Carpentry lesson on the `find` command, at <http://swcarpentry.github.io/shell-novice/07-find/index.html>]

If you are in the folder with material for this lesson, and you run `ls` you should see

```
barcode  gapminderData  sam  velvet
```

How can we show all files in the folder? Try `ls *`:

```
ls *
barcode:
barcode.fasta

gapminderData:
gapminderDataFiveYear.txt

sam:
somefile.sam

velvet:
stats.txt  temp
```

Let's add the `-F` flag to make `ls` show what are the folders:

```
ls -F *
barcode:
barcode.fasta

gapminderData:
gapminderDataFiveYear.txt

sam:
somefile.sam

velvet:
stats.txt  temp/
```

We are almost there, as there is a folder `temp` in the `velvet` folder. Does it have files in it?

```
ls -F velvet/temp/
temp.txt
```

An easier way, especially if you have many files and folders, to get all files and folders is by using the `find` command:

```
find .
.
./velvet
./velvet/stats.txt
./velvet/temp
./velvet/temp/temp.txt
./gapminderData
./gapminderData/gapminderDataFiveYear.txt
./sam
./sam/somefile.sam
./barcode
./barcode/barcode.fasta
```

Note we use the `.` here to indicate the current folder. You can also give the `find` command the path to another folder.

We can restrict the output to folders only:

```
find . -type d
.
./velvet
./velvet/temp
./gapminderData
./sam
./barcode
```

Or to files only:

```
find . -type f
./velvet/stats.txt
./velvet/temp/temp.txt
./gapminderData/gapminderDataFiveYear.txt
./sam/somefile.sam
./barcode/barcode.fasta
```

The `find` command does not get it's name from this listing of files and folders alone, but from the possibility to locate locate files (or folders):

```
find . -name *.txt
./velvet/stats.txt
./velvet/temp/temp.txt
./gapminderData/gapminderDataFiveYear.txt
```

This nicely selects only the files which end in `.txt`. There is one problem, though, which you can see by doing this:

```
touch emptyfile.txt
find . -name *.txt
./emptyfile.txt
```

The problem is that the shell expands wildcard characters like `*` before commands are run. Since `*.txt` in the current directory expands to `emptyfile.txt`, the command we actually ran was:

```
find . -name emptyfile.txt
```

The fix is using quotation marks around `*.txt`:

```
find . -name "*.txt"
./velvet/stats.txt
./velvet/temp/temp.txt
./gapminderData/gapminderDataFiveYear.txt
./emptyfile.txt
```

I recommend to *always put quotation marks* around fiename part of the `find` command.

You can restrict the depth of searching in the file tree with `-maxdepth`, e.g.

```
find . -maxdepth 2 -name '*.txt'
./velvet/stats.txt
./gapminderData/gapminderDataFiveYear.txt
./emptyfile.txt
```
Note how the `velvet/temp/temp.txt` file is no longer listed as it was 3 levels deep.

Now, let's do something with the found files by looking at the number of lines each one has:

```
find . -name '*.txt' | xargs wc -l
   672 ./velvet/stats.txt
     0 ./velvet/temp/temp.txt
  1705 ./gapminderData/gapminderDataFiveYear.txt
     0 ./emptyfile.txt
  2377 total
```

`xargs` will run the command following it on all lines of input piped into it.

Thus, we can also look at file sizes this way:

```
find . -name '*.txt' | xargs du -hs
64K	./velvet/stats.txt
0	./velvet/temp/temp.txt
96K	./gapminderData/gapminderDataFiveYear.txt
0	./emptyfile.txt
```

If you are comfortable with using for loops in the shell, you can loop over the output of `find`:

```
for f in $(find . -name '*.txt'); do wc -l $f; done
672 ./velvet/stats.txt
0 ./velvet/temp/temp.txt
1705 ./gapminderData/gapminderDataFiveYear.txt
0 ./emptyfile.txt
```

**Exercise** compare the use of `xargs` and the `for` loop, and explain why the output is different.

Answer: the `xargs` variant effectively runs this:

```
wc -l ./velvet/stats.txt ./velvet/temp/temp.txt ./gapminderData/gapminderDataFiveYear.txt
```

The `wc` command always prints the total number of lines at the end if more than one input file was given.

The `for` loop variant effectively runs these commands:

```
wc -l ./velvet/stats.txt
wc -l ./velvet/temp/temp.txt
wc -l ./gapminderData/gapminderDataFiveYear.txt
```

Here each invocation of `wc` is only on one file, so there is not total given.



## CPUs, memory, running time

### The `top` command

You may know the `top`, command, but not be aware of it's many uses.

* type `top` and within top, type `u` and your username (or someone else's) to show only processes for that username
* you can also use `top -u username`
* within `top`, type `shift-f` to sort processes by different columns, for example memory usage (`N`)
* to have the output of `top` be sent to the screen without going 'into' `top`, type:

```
top -b -n 1 -u alexajo'
```

* `-b` batch mode, send to stdout instead of entering `top`
* `-n 1` Number of iterations (here: just once)

I sometimes want to log the `top` output to a file for a long running job to see which steps used the most CPU or memory:

```
top -b -d 900 -u alexajo >top_output.txt
```

* `-d` delay, waiting time in seconds between each output (here 15 minutes)
* this will run until cancelled

I either use a separate `screen` for this, or I do:

```
top -b -d 900 -u alexajo >top_output.txt&
start_long_running_command
```

The `&` makes the `top` command go into the background, and allows executing more commands.


Finally, to get a quick view of how busy a node is, use

```
uptime
 11:53:14 up 38 days, 7 min, 18 users,  load average: 25.62, 27.67, 29.27
```

This will give the first line of the `top` output. It says how long the node has been running since the last restart, how many users are logged in, and the load, roughly the average number of CPUs busy during the last one, five, and fifteen minutes.

### Runtime and maximum memory usage

The easiest way to log the amount of time a process used is by running the `time` command in front of your command:

```
time your_command
```

Let's try it out, but having the shell wait 3 seconds:

```
time sleep 3

real	0m3.061s
user	0m0.001s
sys	0m0.003s
```

* `real` the elapsed real time between ('clock' time)
* `user` the user CPU time
* `sys` the system CPU time

When the command uses multiple CPUs, `user` time may be higher than `real` time. For a more detailed explanation, see <http://stackoverflow.com/questions/556405/what-do-real-user-and-sys-mean-in-the-output-of-time1>

An alternative logging command is to use `/usr/bin/time` instead of `time`:

```
/usr/bin/time sleep 3
0.00user 0.00system 0:03.01elapsed 0%CPU (0avgtext+0avgdata 600maxresident)k
0inputs+0outputs (0major+180minor)pagefaults 0swaps
```
Here `maxresident` is the *maximum* amount of memory the process used (in kilobytes), this may be useful to determine how much memory to reserve for such a process. To get a full, detailed output, add the `-v` flag to `/usr/bin/time`. More details at <http://www.linuxintheshell.org/2013/02/26/episode-024-time-and-usrbintime/>

### Memory useage
To see how much memory is used by a node, run `free -g`:

```
free -g
             total       used       free     shared    buffers     cached
Mem:          1514       1418         96          0          0       1307
-/+ buffers/cache:        110       1404
Swap:            9          0          9
```

I find the first line not to be informative, but the second one (labelled `-/+ buffers/cache:`) is useful: the `used` number represents to total used memory.


### Putting it all together

After logging in to a node, a quick overview of how busy it is can be obtained by

```
uptime
free -g
```

**Exercise:** run these commands on the cod nodes and on abel

## Setting up password-less ssh login
See these instructions: <https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2>

## Abel

The `squeue` command will list *all* running jobs. To list your jobs only, use:

```
squeue -u alexajo
```
To list jobs for one particular project only, e.g. our `nn9244k` allocation:

```
squeue -A nn9244k
```

In my `.bash_login` file I have

```
alias sq='squeue -u alexajo'
```

To get all porribole information about a running job, use

```
scontrol show job JOBID
```

(replace JOBID with the ID of the job of interest)

To see how busy abel is, type `qsumm`. Below are the first 10 lines of the output:

```
qsumm  | head
Account        Limit  nRun nPend  lRun lPend
--------------------------------------------
akvaforsk         48     1     .     .     .
atlas-low       2500     .     .   768   497
cees             256     8     .     .     .
cicero           256   177     .     .     .
Sum cmbn          64    25     .     .     .
 cmbn             64    25     .     .     .
 cmbnp            64     .     .     .     .
geofag           206     .     .     .     .
```

Here is the end of the output:

```
qsumm | tail
 xa9911k        9075     .     .     .     .
nrr              128     .     .     .     .
nsc               48    21    54     .     .
quiet            260     .     .     .     .
staff          10000    82     .     .     .
test            5000     .     .     .     .
trocks           320   274     .     .     .
uio              527   238   166   192    64
--------------------------------------------
Total sum      11428  7855 20683  1437   833
```

This is the data for our `nn9244k` project:

```
qsumm | grep nn9244k
 nn9244k        9075   362     9     .     .
```

Explanation of the columns, obtained by running `qsumm --help`:

* `Limit` the limit of how many cores the account can use at a time (note that all notur projects have the same number, currently 9075)
* `nRun` the number of cores currently used by normal priority jobs
* `nPend` the number of cores in queue for normal priority jobs
* `lRun` and `lPend` the number of cores currently used and in the queue by lowpri jobs. Check [this link](http://www.uio.no/english/services/it/research/hpc/abel/help/user-guide/job-scripts.html#The_Lowpri_QoS) for information on lowpri.

By default, `qsumm` will show the number of CPUs (cores). By adding `--pe` (or simply `-p`), `qsumm` displays so-called Processor Equivalents instead. From the help text:

>Processor Equivalents (PEs) take the memory usage of a job into account: jobs with `--mem-per-cpu` larger than approximately 2GB will have #PEs > #cores. (Note that the PE displayed in qsumm is an approximation of the PE used by the scheduler.)


```
qsumm --pe | head
Account        Limit  nRun nPend  lRun lPend
--------------------------------------------
akvaforsk         48     1     .     .     .
atlas-low       2500     .     .   756   543
cees             256     8     .     .     .
cicero           256   235     .     .     .
Sum cmbn          64    26     .     .     .
 cmbn             64    26     .     .     .
 cmbnp            64     .     .     .     .
geofag           206     .     .     .     .
```

This has to do with the fact that jobs requesting more memory are accounted in CPU hours proportionally to the amount of memory they use, with around one hour using 4 GB of memory representing one CPU hour. So, reserving a full Abel node of 64 GB RAM counts, even if you only use 1 CPU on it, as 64/16=16 CPUs. Using the full 1TB of a hugemem node counts as 1024/4=256 CPUs!


```
alias qs="qsumm -p|awk 'NR==1||/Sum uio/||/nsc/||/notur/||/nn9244k/||/cees/||/Total/'"
```

Finally, to check how many hours we have left on the `nn9244k` project, use the `cost` command:

```
cost -p nn9244k
Report for account nn9244k on abel.uio.no
Allocation period 2015.2 (start Thu Oct 01 00:00:01 2015)
			 (end Thu Mar 31 23:59:59 2016)
Last updated on Mon Nov 02 11:31:58 2015
==================================================
Account                                 Core hours
==================================================
nn9244k            avail                3909376.93
nn9244k            usage                 935087.07
nn9244k            reserved              155536.00
nn9244k            quota (pri)          5000000.00
nn9244k            quota (unpri)                NA
==================================================
```

If you induced `--detail`, you'll get a breakdown by user.


## Tips for MAC users

If you use a MAC, there are two nice ways to open files using the terminal:

* using the built-in terminal application, you can on *the local harddisk*, type `open` followed by a filename (or path to a file) and it will open in the associated program, e.g.

```
open Documents/thesis/draft.docx
```

this will open `draft.docx` in Microsoft Word.

To choose a different program to open a file, use the `-a` flag:

```
open Documents/thesis/draft.docx -a preview
```

Will open the file in the Preview application instead.

I use [iTerm2](https://www.iterm2.com/) instead of terminal.app. One reason is this: if there is a filename in the iTerm2 window, I can command-click on it (press the `command` key and click with the mouse) and it will open!


## TO DO

* add `.inputrc`

```
set completion-ignore-case on
set completion-prefix-display-length 2
Control-j: menu-complete
Control-k: menu-complete-backward
```

* symlinks
* coloring command prompt based on git status <https://coderwall.com/p/pn8f0g/show-your-git-status-and-branch-in-color-at-the-command-prompt>
