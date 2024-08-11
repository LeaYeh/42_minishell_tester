<h1 align=center>📖 42_minishell_tester</h1>
<h2 align="center">Forked from <a href="https://github.com/zstenger93">zstenger93</a>'s <a href="https://github.com/zstenger93/42_minishell_tester">original tester</a> by <a href="https://github.com/LeaYeh">LeaYeh</a> and <a href="https://github.com/itislu">itislu</a> from 42 Vienna</h2>
<img align=center src="https://github.com/LeaYeh/42_minishell_tester/blob/master/media/tester.png">

# Updates

- Add support for readline.
- More rigorous memory leak checks.
- Memory leak checks in child processes without false positives from external commands.
- File descriptor leak checks.
- Smart stderror comparison with bash.
- Output failed test case and valgrind results to files.
- Updated test cases for updated subject (v7.1).
- Subshell test cases.
- Compatibility and tester speed-up with GitHub Actions.

---

# Menu

- [Install & Run](#how-to-install-and-run)

- [Usage](#how-to-launch-the-tester)

- [CI with GitHub Actions](#continuous-integration-with-github-actions)

- [Troubleshooting](#troubleshooting)

  - [All my STDOUT tests fail](#all-my-stdout-tests-fail)

- [Valgrind Command](#how-to-test-with-valgrind)

- [Disclaimer](#disclaimer)

- [Contributors](#the-people-who-made-this-tester-possible)

---

# How To Install and Run

To install the script, copy and run the following command:

```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/LeaYeh/42_minishell_tester/master/install.sh)"
```

The tester will be installed in the `$HOME/42_minishell_tester` directory.

After installation an alias `mstest` will be automaticly added in `.zshrc` or `.bashrc`

So that you can run the program in any directory (where your minishell is) by calling

```
mstest
```

---

# How To Launch the Tester

<img align=center src="https://github.com/LeaYeh/42_minishell_tester/blob/master/media/usage.png">

```
mstest m  # Run mandatory tests
```
```
mstest vm  # Run mandatory tests with memory leak checks
```
```
mstest b  # Run bonus tests
```
```
mstest vb  # Run bonus tests with memory leak checks
```
```
mstest ne  # Run empty environment tests
```
```
mstest vne  # Run empty environment tests with memory leak checks
```
```
mstest d  # Run death tests (hardcore)
```
```
mstest vd  # Run death tests with memory leak checks (hardcore)
```
```
mstest a  # Run all tests
```
```
mstest va  # Run all tests with memory leak checks
```
```
mstest -l  # Enable memory leak checks for any test
```
```
mstest --no-std-fds  # Don't report fd leaks of stdin, stdout, and stderr for any test
```
```
mstest -n  # Run any test with an empty environment
```
```
mstest -f <file>  # Run tests specified in a file
```
```
mstest --dir <directory>  # Run tests specified in a directory
```
```
mstest --non-posix  # Compare with normal bash instead of POSIX mode bash
```
```
mstest -h  # Display the usage instructions
```

---

# Continuous Integration with GitHub Actions

[How to Re-use Our CI/CD Framework For Your Own Minishell](https://github.com/LeaYeh/minishell?tab=readme-ov-file#how-to-re-use-our-cicd-framework-for-your-own-minishell)

---

# Troubleshooting

## All my STDOUT tests fail

  It is because you print your exit message to STDOUT instead of STDERR.

  You can fix this in two ways:
  - Check in your code if you are in "interactive mode" (`isatty()`) and only print the exit message if you are. This is how bash does it.
  - Print the exit message to STDERR. In interactive mode, bash does it this way too (try out `exit 2>/dev/null`).<br>
    For more information, see [here](https://github.com/LeaYeh/minishell/pull/270).

---

# How to test with Valgrind

To manually test your minishell with Valgrind with the same flags as the tester, you can use this command:
```bash
bash -c '
export SUPPRESSION_FILE=$(mktemp)
curl -s https://raw.githubusercontent.com/LeaYeh/42_minishell_tester/master/utils/minishell.supp > $SUPPRESSION_FILE
export VALGRIND=$(which valgrind)
export VALGRINDFLAGS="--errors-for-leak-kinds=all --leak-check=full --read-var-info=yes --show-error-list=yes --show-leak-kinds=all --suppressions=$SUPPRESSION_FILE --trace-children=yes --track-origins=yes"
export VALGRINDFDFLAGS="--track-fds=all"
export IGNORED_PATHS="/bin/* /usr/bin/* /usr/sbin/* $(which -a norminette)"
export VALGRINDFLAGS+=" --trace-children-skip=$(echo $IGNORED_PATHS | sed '"'"'s/ /,/g'"'"')"
export PATH="/bin:/usr/bin:/usr/sbin:$PATH"
$VALGRIND $VALGRINDFLAGS $VALGRINDFDFLAGS ./minishell
rm -f $SUPPRESSION_FILE
'
```

---

# Disclaimer

DO NOT FAIL SOMEONE BECAUSE THEY AREN'T PASSING ALL TESTS!

NEITHER LET THEM PASS JUST BECAUSE THEY DO, CHECK THE CODE WELL!

DO YOUR OWN TESTING. TRY TO BREAK IT! ^^

HAVE FUN WITH YOUR BEAUTIFUL MINISHELL

Tests without environment are a bit tricky to do well because if you run `env -i bash` it disables only partially.
It will still have most things, but if you do `unset PATH` afterwards, will see the difference.
Also this part is pretty much what you aren't required to handle.
The main point is to not to crash/segfault when you launch without environment.

Try to write your own test first and don't just run a tester mindlessly
You don't have to pass all the cases in this tester
If you want to check leaks outside of your manual checking:

[This is also a good one to check valgrind](https://github.com/thallard/minishell_tester)
A bit more time to set it up, but worth it
The first time if you run the tester above and expect a lot of errors
Then redirect each of the output from stdin and strerror to a file otherwise you won't be able see all of the errors

Even though the required changes have been made to your proram, it might still going to throw you only KO STD_OUT.
This is because readline version. (then you probably have the older version where it isn't checking where does the input coming from(the tester or you))

If a test just hanging in infinite loop, you can use the link to go there and comment it out in the test file until you fix it.

---

# The People Who Made This Tester Possible

Base made by: [Tim](https://github.com/tjensen42) & [Hepple](https://github.com/hepple42)

Upgraded by: [Zsolt](https://github.com/zstenger93)

Parsing hell and mini_death by: [Kārlis](https://github.com/kvebers)

Extra bonus tests by: [Mouad](https://github.com/moabid42)

and

```
Our passion for minishell
```
