<h1 align=center>📖 42_minishell_tester</h1>
<h2 align="center">Forked from <a href="https://github.com/zstenger93">zstenger93</a>'s <a href="https://github.com/zstenger93/42_minishell_tester">original tester</a> by <a href="https://github.com/LeaYeh">LeaYeh</a> and <a href="https://github.com/itislu">itislu</a> from 42 Vienna</h2>
<img align=center src="/media/tester.png">

# Updates

- Add support for readline.
- More rigorous memory leak checks.
- Memory leak checks in child processes without false positives from external commands.
- File descriptor leak checks.
- Crash detection.
- Smart stderror comparison with bash.
- Minishell output filtering (start message, prompt, exit message).
- Output failed test cases and valgrind results to files.
- Updated test cases for updated subject (v7.1).
- Subshell test cases.
- Compatibility and tester speed-up with GitHub Actions.

---

# Table of Contents

- [Install & Run](#how-to-install-and-run)

- [Usage](#how-to-launch-the-tester)

- [CI with GitHub Actions](#continuous-integration-with-github-actions)

- [Troubleshooting](#troubleshooting)

  - [All the STDOUT/STDERR tests fail](#all-the-stdoutstderr-tests-fail)

  - [The tester gets stuck at the first test](#the-tester-gets-stuck-at-the-first-test)

  - [The tester reports leaks which cannot be reproduced](#the-tester-reports-leaks-which-cannot-be-reproduced)

  - [Bash in the tester behaves differently than in manual testing](#bash-in-the-tester-behaves-differently-than-in-manual-testing)

  - [The output of minishell looks the same as bash's, but the test fails](#the-output-of-minishell-looks-the-same-as-bashs-but-the-test-fails)

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

<img align=center src="/media/usage.png">

---

# Continuous Integration with GitHub Actions

[How to Re-use Our CI/CD Framework For Your Own Minishell](https://github.com/LeaYeh/minishell?tab=readme-ov-file#how-to-re-use-our-cicd-framework-for-your-own-minishell)

---

# Troubleshooting

## All the STDOUT/STDERR tests fail

This is probably because you print something which bash does not print, at least not in non-interactive mode.<br>
What is non-interactive mode?<br>
Because the tester cannot simulate interactive user input coming from the terminal, it **pipes** the tests into the stdin of minishell/bash, (roughly) like this:
```bash
echo -n "test-command" | ./minishell
echo -n "test-command" | bash
```
It then tries to filter out a lot of variances after capturing the output, but depending on your implementation, there might still be some differences between the outputs of your minishell and bash.<br>
You can check the output in the `mstest_output` directory in your minishell directory to see which exact printouts cause problems.

**Solution:**
- Check in your code if you are in "interactive mode" (`isatty()`) and only print the problematic message if you are.
  This is how bash does it for its "exit" message too.<br>
  For more information, see [here](https://github.com/LeaYeh/minishell/pull/270).

## The tester gets stuck at the first test

As described in the previuos point, the tester pipes the test commands into the stdin of the minishell.<br>
The side effect of that is that once the process which pipes the test command into the minishell finished and exited, the pipe between the two gets closed.<br>
From the perspective of the minishell, this means stdin got closed, which is the same as receiving `Ctrl+D` in interactive mode.<br>

As a side note, `Ctrl+D` is **not** a signal, it just closes stdin, which is the same as reading `EOF`.

**Solution:**
- Make sure that your minishell can handle `Ctrl+D` and exits when receiving it.

## The tester reports leaks which cannot be reproduced

By default, the tester uses the `--track-fds=all` flag for valgrind to track file descriptor leaks.<br>
The difference to `--track-fds=yes` is that it also tracks fds `0`, `1` and `2` (stdin, stdout and stderr).<br>
The standard file descriptors get inherited from the parent process that spawned minishell.<br>
If you don't modify them, valgrind won't report any errors (`<inherited from parent>`).<br>
However, if you do modify the standard fds, f.e. you used `dup()` and `dup2()` to restore the original stdfds, valgrind will report them as leaking if you don't close them again in the same process in which you touched them.<br>

A common test case to reproduce these leaks from `--track-fds=all` is to combine a redirection with a simple builtin: `cd > outfile`.<br>
Because the builtin gets executed without any pipes, it does not run in a child process.<br>
In turn that means after redirecting stdout to a file and executing the builtin, the stdout has to be restored before the next iteration of the input loop. All within the same process.

If you don't want the standard fds to ever get reported as leaking, you can run the tester with the `--no-stdfds` flag.

**Solution:**
- Close the standard file descriptors if you touched them with `dup2()`, or run the tester with the `--no-stdfds` flag.

## Bash in the tester behaves differently than in manual testing

The tester runs bash in [POSIX mode](https://www.gnu.org/software/bash/manual/html_node/Bash-POSIX-Mode.html) (`bash --posix`).<br>
POSIX (Portable Operating System Interface) is a standard ensuring compatibility across Unix-like systems.<br>
The most relevant differences for minishell are:
- Redirection operators do not perform word splitting on the word in the redirection (`export VAR="a b" ; > $VAR`)
- The export builtin command displays its output in the format required by POSIX (`export` vs `declare -x`)

If you prefer to stick with the normal bash behavior that is not fully POSIX compliant, you can run the tester with the `--non-posix` flag.

**Solution:**
- When you test bash's behavior manually, start bash with the `--posix` flag, or run the tester with the `--non-posix` flag.

## The output of minishell looks the same as bash's, but the test fails

This most likely is caused by one of the following three issues:
1. **You don't print the name of your shell when bash does.**

   You probably noticed that bash (most of the time) starts its output with `bash: `.<br>
   It would of course be silly to expect that all minishells also print `bash: ` as their program name in front of (most of) their outputs.<br>
   Therefore, the tester only expects that you put _some_ program name where bash puts its.<br>

   It doesn't matter if it's gonna be `minishell: `, `shell: ` or `42shell: `, the tester just cares about that you print out _something_ that has the same purpose as bash's printout.<br>
   The tester achieves this by first learning what your minishell prints out in certain scenarios, and then filtering out these program-specific printouts.<br>
   If, however, you don't print out any program name when bash does, the tester will filter out something else from the minishell's output, and the test fails.<br>

   A very common example is `cd not_existing`.<br>
   - bash stderr: `bash: cd: not_existing: No such file or directory`<br>
     -> bash filtered stderr: `cd: not_existing: No such file or directory`<br>
   - minishell stderr `cd: not_existing: No such file or directory`<br>
     -> minishell filtered stderr: `not_existing: No such file or directory`
   
2. **There is a trailing whitespace in your printout.**

3. **The test case inherently produces inconsistent results.**

   Some test cases are known to not output exactly the same every time they are run, not even in bash.<br>
   They are still included in the tester because they test the stability of critical parts of a shell.<br>

   One example is a very long sequence of piped commands.<br>
   Because each command spawns in its own process, they run in parallel and the order of their outputs are not guaranteed.<br>

   We deemed it more important to cover as much of the minishell with tricky tests as possible, than to strive for the possibility of 0 failed test cases.<br>
   If you have ideas how to make certain test cases which cause inconsistencies more consistent, without making the test easier to pass, we are extremely glad for every suggestion!

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
EXIT_CODE=$?
rm -f $SUPPRESSION_FILE
echo "Exit code: $EXIT_CODE"
exit $EXIT_CODE
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
