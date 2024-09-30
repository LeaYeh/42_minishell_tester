# **************************************************************************** #
#                                    CRASH                                     #
# **************************************************************************** #

echo <<<> ok

echo seg <>> echo seg

>echo>
/bin/rm -f echo

<echo<
/bin/rm -f echo

>>echo>>
/bin/rm -f echo

(echo hi && ((echo hi && (echo hi) && echo hi)))

/bin/echo $"HOME"$USER

/bin/echo $"HOM"E$USER

/bin/echo $"HOME"

/bin/echo $"42$"

/bin/echo \$USER

/bin/echo \\$USER

/bin/echo \\\$USER

/bin/echo \\\\$USER

/bin/echo \\\\\$USER

/bin/echo \\\\\\\\\$USER

/bin/echo \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\$USER \$PATH \\$PWD

/bin/echo ""'totally logical'""

echo '$'$'$'$'$'

echo '$'$'$'$'$'$'$'

echo "$"$'$'$"$"$"$"$'$'

>| echo sure

echo cd ~

echo $"HOME"$USER

echo $"HOM"E$USER

echo $"HOME"

echo $"42$"

echo \$USER

echo \\$USER

echo \\\$USER

echo \\\\$USER

echo \\\\\$USER

echo \\\\\\\\\$USER

echo \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\$USER \$PATH \\$PWD

cd --

cd '/////' 2>/dev/null

cd "doesntexist" 2>/dev/null

cd "wtf" 2>/dev/null

pwd
cd ~
cd - ananas dot jpeg
pwd

pwd
cd ~ asd w dd q asd
pwd

pwd
cd ~
cd -
pwd

pwd
cd ~
pwd

env what

export --TEST=123

export -TEST=100

export -TEST=123

export TES\~T=123

export TEST+=100

unset $""

unset TES;T

unset -TEST

unset TES\~T

touch "
"
/bin/rm -f "
"

/bin/echo $"'HOM'E"$USER

/bin/echo $'HOM'E$USER

/bin/echo $'HOME'

/bin/echo $"$"

/bin/echo $'$'

echo $"$"

echo $'$'

cd..

cd ~

cd ~/Desktop/
pwd

env -i ./minishell
cd /bin/
ls

<<<<<<<<<

~

> > > >

>> >> >> >>

<<

\\\

>| echo wtf
/bin/rm -rf echo

echo ">| echo wtf"

<>

echo "env | /usr/bin/wc -l" | env -i $MINISHELL_PATH"/"$EXECUTABLE
echo $?

echo "ls" | env -i $MINISHELL_PATH"/"$EXECUTABLE
echo $?

echo "unset PATH" | env -i $MINISHELL_PATH"/"$EXECUTABLE
echo $?

echo <<> echo

echo seg <> echo seg

echo segf >| echo is this invalid
/bin/rm -rf echo

echo seg <<<> echo segf

echo <<< echo seegf

unset PATH
env

cd
cd ~

unset PATH
pwd
cd ~
pwd

unset PATH
pwd
cd ~
pwd
cd -
pwd

/bin/echo $USER =intergalaktikus miaf*szomez
