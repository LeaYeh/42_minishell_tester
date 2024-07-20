#!/usr/bin/env -S --default-signal bash

# Change if you store the tester in another PATH
export MINISHELL_PATH=./
export EXECUTABLE=minishell
RUNDIR=$HOME/42_minishell_tester
TMP_OUTDIR=/tmp/minishell_tester
OUTDIR=$MINISHELL_PATH/tester_output

# Get the name of the minishell by running a command that produces an error
# The name will then be filtered out from error messages
MINISHELL_NAME=$(echo -n "forcing_error_message" | $MINISHELL_PATH/$EXECUTABLE 2>&1 | head -n 1 | awk -F: '{if ($0 ~ /:/) print $1; else print ""}')

NL=$'\n'
TAB=$'\t'

TEST_COUNT=0
TEST_KO_OUT=0
TEST_KO_ERR=0
TEST_KO_EXIT=0
TEST_OK=0
FAILED=0
ONE=0
TWO=0
THREE=0
GOOD_TEST=0
LEAKS=0

main() {
	mkdir -p "$TMP_OUTDIR"
	if [[ ! -f $MINISHELL_PATH/$EXECUTABLE ]] ; then
		echo -e "\033[1;31m# **************************************************************************** #"
		echo "#                            MINISHELL NOT COMPILED                            #"
		echo "#                              TRY TO COMPILE ...                              #"
		echo -e "# **************************************************************************** #\033[m"
		make -C $MINISHELL_PATH
		if [[ ! -f $MINISHELL_PATH/$EXECUTABLE ]] ; then
			echo -e "\033[1;31mCOMPILING FAILED\033[m" && exit 1
		fi
	fi
	if [[ $1 == "m" ]] ; then
		echo "  🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
		echo -e "  🚀                                \033[1;34mMANDATORY\033[m                                   🚀"
		echo "  🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
		test_mandatory
	elif [[ $1 == "vm" ]] ; then
		echo "  🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
		echo -e "  🚀                             \033[1;34mMANDATORY_LEAKS\033[m                                🚀"
		echo "  🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
		test_mandatory_leaks
	elif [[ $1 == "ne" ]] ; then
		echo "  🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
		echo -e "  🚀                                 \033[1;34mNO_ENV\033[m                                     🚀"
		echo "  🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
		test_no_env
	elif [[ $1 == "b" ]] ; then
		echo "  🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
		echo -e "  🚀                                  \033[1;34mBONUS\033[m                                     🚀"
		echo "  🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
		test_bonus
	elif [[ $1 == "va" ]] ; then
		echo "  🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
		echo -e "  🚀                            \033[1;34mALL_LEAKS\033[m                                       🚀"
		echo "  🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
		test_all_leaks
	elif [[ $1 == "a" ]] ; then
		test_mandatory
		test_bonus
	elif [[ $1 == "d" ]] ; then
		echo "  🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
		echo -e "  🚀                                  \033[1;34mMINI_DEATH\033[m                                🚀"
		echo "  🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
		test_mini_death
	elif [[ $1 == "-f" ]] ; then
		[[ ! -f $2 ]] && echo "\"$2\" FILE NOT FOUND"
		[[ -f $2 ]] && test_from_file $2
	else
		echo "usage: mstest [m,vm,ne,b,a]"
		echo "m: mandatory tests"
		echo "vm: mandatory tests with valgrind"
		echo "va: all tests with valgrind"
		echo "ne: tests without environment"
		echo "b: bonus tests"
		echo "a: mandatory and bonus tests"
		echo "d: mandatory pipe segfault test (BRUTAL)"

	fi
	if [[ $TEST_COUNT -gt 0 ]] ; then
		print_stats
	fi
	# \_o_/ this is my ananas.jpeg \_o_/
	rm -rf test
	rm -rf "$TMP_OUTDIR" 2>/dev/null

	if [ "$GITHUB_ACTIONS" == "true" ] ; then
		echo "$GH_BRANCH=$FAILED" >> "$GITHUB_ENV"
	fi

	if [[ $LEAKS -ne 0 ]] ; then
		exit 1
	else
		exit 0
	fi
}

test_no_env() {
	FILES="${RUNDIR}/cmds/no_env/*"
	for file in $FILES
	do
		test_without_env $file
	done
}

test_mandatory_leaks() {
	FILES="${RUNDIR}/cmds/mand/*"
	for file in $FILES
	do
		test_leaks $file
	done
}

test_mandatory() {
	FILES="${RUNDIR}/cmds/mand/*"
	for file in $FILES
	do
		test_from_file $file
	done
}

test_mini_death() {
	FILES="${RUNDIR}/cmds/mini_death/*"
	for file in $FILES
	do
		test_from_file $file
	done
}

test_bonus() {
	FILES="${RUNDIR}/cmds/bonus/*"
	for file in $FILES
	do
		test_from_file $file
	done
}

test_all_leaks() {
	FILES="${RUNDIR}/cmds/**/*.sh"
	for file in $FILES
	do
		test_leaks $file
	done
}


print_stats() {
	echo "🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁"
	echo -e "🏁                                    \033[1;31mRESULT\033[m                                    🏁"
	echo "🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁🏁"
	printf "\033[1;35m%-4s\033[m" "             TOTAL TEST COUNT: $TEST_COUNT "
	printf "\033[1;32m TESTS PASSED: $GOOD_TEST\033[m "
	if [[ $LEAKS == 0 ]] ; then
		printf "\033[1;32m LEAKING: $LEAKS\033[m "
	else
		printf "\033[1;31m LEAKING: $LEAKS\033[m "
	fi
	echo ""
	echo -ne "\033[1;34m                     STD_OUT:\033[m "
	if [[ $TEST_KO_OUT == 0 ]] ; then
		echo -ne "\033[1;32m✓ \033[m  "
	else
		echo -ne "\033[1;31m$TEST_KO_OUT\033[m  "
	fi
	echo -ne "\033[1;33mSTD_ERR:\033[m "
	if [[ $TEST_KO_ERR == 0 ]] ; then
		echo -ne "\033[1;32m✓ \033[m  "
	else
		echo -ne "\033[1;31m$TEST_KO_ERR\033[m  "
	fi
	echo -ne "\033[1;36mEXIT_CODE:\033[m "
	if [[ $TEST_KO_EXIT == 0 ]] ; then
		echo -ne "\033[1;32m✓ \033[m  "
	else
		echo -ne "\033[1;31m$TEST_KO_EXIT\033[m  "
	fi
	echo ""
	echo -e "\033[1;33m                         TOTAL FAILED AND PASSED CASES:"
	echo -e "\033[1;31m                                     ❌ $FAILED \033[m  "
	echo -ne "\033[1;32m                                     ✅ $TEST_OK \033[m  "
	echo ""
}

test_from_file() {
	IFS=''
	i=1
	end_of_file=0
	line_count=0
	dir_name=$(basename $(dirname $1))
	file_name=$(basename --suffix=.sh $1)
	while [[ $end_of_file == 0 ]] ;
	do
		read -r line
		end_of_file=$?
		((line_count++))
		if [[ $line == \#* ]] || [[ $line == "" ]] ; then
			# if [[ $line == "###"[[:blank:]]*[[:blank:]]"###" ]] ; then
			# 	echo -e "\033[1;33m$line\033[m"
			if [[ $line == "#"[[:blank:]]*[[:blank:]]"#" ]] ; then
				echo -e "\033[1;33m		$line\033[m" | tr '\t' '    '
			fi
			continue
		else
			printf "\033[1;35m%-4s\033[m" "  $i:	"
			tmp_line_count=$line_count
			while [[ $end_of_file == 0 ]] && [[ $line != \#* ]] && [[ $line != "" ]] ;
			do
				INPUT+="$line$NL"
				read -r line
				end_of_file=$?
				((line_count++))
			done
			# INPUT=${INPUT%?}
			echo -n "$INPUT" | $MINISHELL_PATH/$EXECUTABLE 2>"$TMP_OUTDIR/tmp_err_minishell" >"$TMP_OUTDIR/tmp_out_minishell"
			exit_minishell=$?
			echo -n "enable -n .$NL$INPUT" | bash --posix 2>"$TMP_OUTDIR/tmp_err_bash" >"$TMP_OUTDIR/tmp_out_bash"
			exit_bash=$?
			echo -ne "\033[1;34mSTD_OUT:\033[m "
			if ! diff -q "$TMP_OUTDIR/tmp_out_minishell" "$TMP_OUTDIR/tmp_out_bash" >/dev/null ;
			then
				echo -ne "❌  " | tr '\n' ' '
				((TEST_KO_OUT++))
				((FAILED++))
				mkdir -p "$OUTDIR/$dir_name/$file_name" 2>/dev/null
				mv "$TMP_OUTDIR/tmp_out_minishell" "$OUTDIR/$dir_name/$file_name/stdout_minishell_$i" 2>/dev/null
				mv "$TMP_OUTDIR/tmp_out_bash" "$OUTDIR/$dir_name/$file_name/stdout_bash_$i" 2>/dev/null
			else
				echo -ne "✅  "
				((TEST_OK++))
				((ONE++))
			fi
			echo -ne "\033[1;33mSTD_ERR:\033[m "
			# Filter out program name prefix before first colon from minishell error messages and "bash: line X" prefix from bash error messages
			stderr_minishell=$(cat "$TMP_OUTDIR/tmp_err_minishell")
			stderr_bash=$(cat "$TMP_OUTDIR/tmp_err_bash")
			if grep -q '^bash: line [0-9]*:' <<< "$stderr_bash" ;
			then
				stderr_bash=$(sed 's/^bash: line [0-9]*:/:/' <<< "$stderr_bash" | sed '/^: syntax error near unexpected token/{n; d}')
				stderr_minishell=$(sed "s/^\\($MINISHELL_NAME: line [0-9]*:\\|$MINISHELL_NAME:\\)/:/" <<< "$stderr_minishell")
				stderr_bash=$(sed '/^: warning: here-document at line [0-9]* /{s/at line [0-9]* //}' <<< "$stderr_bash")
			fi
			if ! diff -q <(echo "$stderr_minishell") <(echo "$stderr_bash") >/dev/null ;
			then
				echo -ne "❌  " | tr '\n' ' '
				((TEST_KO_ERR++))
				((FAILED++))
				mkdir -p "$OUTDIR/$dir_name/$file_name" 2>/dev/null
				mv "$TMP_OUTDIR/tmp_err_minishell" "$OUTDIR/$dir_name/$file_name/stderr_minishell_$i" 2>/dev/null
				mv "$TMP_OUTDIR/tmp_err_bash" "$OUTDIR/$dir_name/$file_name/stderr_bash_$i" 2>/dev/null
			else
				echo -ne "✅  "
				((TEST_OK++))
				((TWO++))
			fi
			echo -ne "\033[1;36mEXIT_CODE:\033[m "
			if [[ $exit_minishell != $exit_bash ]] ;
			then
				echo -ne "❌\033[1;31m [ minishell($exit_minishell)  bash($exit_bash) ]\033[m  " | tr '\n' ' '
				((TEST_KO_EXIT++))
				((FAILED++))
			else
				echo -ne "✅  "
				((TEST_OK++))
				((THREE++))
			fi
			INPUT=""
			((i++))
			((TEST_COUNT++))
			echo -e "\033[0;90m$1:$tmp_line_count\033[m  "
			if [[ $ONE == 1 && $TWO == 1 && $THREE == 1 ]] ;
			then
				((GOOD_TEST++))
				((ONE--))
				((TWO--))
				((THREE--))
			else
				ONE=0
				TWO=0
				THREE=0
			fi
		fi
	done < "$1"
}

test_leaks() {
	valgrind_ignore_rel_path="norminette"
	valgrind_ignore_abs_path="/bin/* /usr/bin/* /usr/sbin/*"
	valgrind_flags=(
	--errors-for-leak-kinds=all
	--leak-check=full
	--show-error-list=yes
	--show-leak-kinds=all
	--suppressions="$MINISHELL_PATH"/minishell.supp
	--trace-children=yes
	--trace-children-skip=$(echo "$valgrind_ignore_abs_path" $(which "$valgrind_ignore_rel_path") | tr ' ' ',')
	--track-fds=all
	--track-origins=yes
	--log-file="$TMP_OUTDIR/tmp_valgrind_out")
	IFS=''
	i=1
	end_of_file=0
	line_count=0
	dir_name=$(basename $(dirname $1))
	file_name=$(basename --suffix=.sh $1)
	while [[ $end_of_file == 0 ]] ;
	do
		read -r line
		end_of_file=$?
		((line_count++))
		if [[ $line == \#* ]] || [[ $line == "" ]] ; then
			# if [[ $line == "###"[[:blank:]]*[[:blank:]]"###" ]] ; then
			# 	echo -e "\033[1;33m$line\033[m"
			if [[ $line == "#"[[:blank:]]*[[:blank:]]"#" ]] ; then
				echo -e "\033[1;33m		$line\033[m" | tr '\t' '    '
			fi
			continue
		else
			printf "\033[0;35m%-4s\033[m" "  $i:	"
			tmp_line_count=$line_count
			while [[ $end_of_file == 0 ]] && [[ $line != \#* ]] && [[ $line != "" ]] ;
			do
				INPUT+="$line$NL"
				read -r line
				end_of_file=$?
				((line_count++))
			done
			# INPUT=${INPUT%?}
			echo -n "$INPUT" | $MINISHELL_PATH/$EXECUTABLE 2>"$TMP_OUTDIR/tmp_err_minishell" >"$TMP_OUTDIR/tmp_out_minishell"
			exit_minishell=$?
			echo -n "enable -n .$NL$INPUT" | bash --posix 2>"$TMP_OUTDIR/tmp_err_bash" >"$TMP_OUTDIR/tmp_out_bash"
			exit_bash=$?
			echo -ne "\033[1;34mSTD_OUT:\033[m "
			if ! diff -q "$TMP_OUTDIR/tmp_out_minishell" "$TMP_OUTDIR/tmp_out_bash" >/dev/null ;
			then
				echo -ne "❌  " | tr '\n' ' '
				((TEST_KO_OUT++))
				((FAILED++))
			else
				echo -ne "✅  "
				((TEST_OK++))
				((ONE++))
			fi
			echo -ne "\033[1;33mSTD_ERR:\033[m "
			if [[ -s $TMP_OUTDIR/tmp_err_minishell && ! -s $TMP_OUTDIR/tmp_err_bash ]] || [[ ! -s $TMP_OUTDIR/tmp_err_minishell && -s $TMP_OUTDIR/tmp_err_bash ]] ;
			then
				echo -ne "❌  " | tr '\n' ' '
				((TEST_KO_ERR++))
				((FAILED++))
			else
				echo -ne "✅  "
				((TEST_OK++))
				((TWO++))
			fi
			echo -ne "\033[1;36mEXIT_CODE:\033[m "
			if [[ $exit_minishell != $exit_bash ]] ;
			then
				echo -ne "❌\033[1;31m [ minishell($exit_minishell)  bash($exit_bash) ]\033[m  " | tr '\n' ' '
				((TEST_KO_EXIT++))
				((FAILED++))
			else
				echo -ne "✅  "
				((TEST_OK++))
				((THREE++))
			fi
			echo -ne "\033[1;36mLEAKS:\033[m "
			echo -n "$INPUT" | eval "valgrind ${valgrind_flags[@]} $MINISHELL_PATH/$EXECUTABLE" 2>/dev/null >/dev/null
			# Get all error summaries
			error_summaries=$(cat "$TMP_OUTDIR/tmp_valgrind_out" | grep -a "ERROR SUMMARY:" | awk '{print $4}')
			IFS=$'\n' read -rd '' -a error_summaries_array <<<"$error_summaries"
			# Check if any error summary is not 0
			leak_found=0
			for error_summary in "${error_summaries_array[@]}"
			do
				if [ -n "$error_summary" ] && [ "$error_summary" -ne 0 ]
				then
					leak_found=1
					break
				fi
			done
			# Check if there are any open file descriptors not inherited from parent
			open_file_descriptors=$(
				awk '
					# If the line starts with a PID and "Open file descriptor"
					/^==[0-9]+== Open file descriptor/ {
						# Store the PID and the line
						pid=$1
						line=$0

						# Keep reading lines until a line that starts with the same PID gets found
						while (getline && $1 != pid);

						# Check if the line does not contain "<inherited from parent>"
						if ($0 !~ /<inherited from parent>/) {
							print line
						}
					}
				' "$TMP_OUTDIR/tmp_valgrind_out"
			)
			if [ -n "$open_file_descriptors" ]
			then
				leak_found=1
			fi
			if [ "$leak_found" -ne 0 ]
			then
				echo -ne "❌ "
				((LEAKS++))
				mkdir -p "$OUTDIR/$dir_name/$file_name" 2>/dev/null
				mv "$TMP_OUTDIR/tmp_valgrind_out" "$OUTDIR/$dir_name/$file_name/valgrind_out_$i" 2>/dev/null
			else
				echo -ne "✅ "
			fi
			INPUT=""
			((i++))
			((TEST_COUNT++))
			echo -e "\033[0;90m$1:$tmp_line_count\033[m  "
			if [[ $ONE == 1 && $TWO == 1 && $THREE == 1 ]] ;
			then
				((GOOD_TEST++))
				((ONE--))
				((TWO--))
				((THREE--))
			else
				ONE=0
				TWO=0
				THREE=0
			fi
		fi
	done < "$1"
	rm -f "$TMP_OUTDIR/tmp_valgrind_out"
	find "$OUTDIR" -type d -empty -delete 2>/dev/null
}

test_without_env() {
	IFS=''
	i=1
	end_of_file=0
	line_count=0
	dir_name=$(basename $(dirname $1))
	file_name=$(basename --suffix=.sh $1)
	while [[ $end_of_file == 0 ]] ;
	do
		read -r line
		end_of_file=$?
		((line_count++))
		if [[ $line == \#* ]] || [[ $line == "" ]] ; then
			# if [[ $line == "###"[[:blank:]]*[[:blank:]]"###" ]] ; then
			# 	echo -e "\033[1;33m$line\033[m"
			if [[ $line == "#"[[:blank:]]*[[:blank:]]"#" ]] ; then
				echo -e "\033[1;33m		$line\033[m" | tr '\t' '    '
			fi
			continue
		else
			printf "\033[0;35m%-4s\033[m" "  $i:	"
			tmp_line_count=$line_count
			while [[ $end_of_file == 0 ]] && [[ $line != \#* ]] && [[ $line != "" ]] ;
			do
				INPUT+="$line$NL"
				read -r line
				end_of_file=$?
				((line_count++))
			done
			# INPUT=${INPUT%?}
			echo -n "$INPUT" | env -i $MINISHELL_PATH/$EXECUTABLE 2>"$TMP_OUTDIR/tmp_err_minishell" >"$TMP_OUTDIR/tmp_out_minishell"
			exit_minishell=$?
			echo -n "enable -n .$NL$INPUT" | env -i bash --posix 2>"$TMP_OUTDIR/tmp_err_bash" >"$TMP_OUTDIR/tmp_out_bash"
			exit_bash=$?
			echo -ne "\033[1;34mSTD_OUT:\033[m "
			if ! diff -q "$TMP_OUTDIR/tmp_out_minishell" "$TMP_OUTDIR/tmp_out_bash" >/dev/null ;
			then
				echo -ne "❌  " | tr '\n' ' '
				((TEST_KO_OUT++))
				((FAILED++))
				mkdir -p "$OUTDIR/$dir_name/$file_name" 2>/dev/null
				mv "$TMP_OUTDIR/tmp_out_minishell" "$OUTDIR/$dir_name/$file_name/stdout_minishell_$i" 2>/dev/null
				mv "$TMP_OUTDIR/tmp_out_bash" "$OUTDIR/$dir_name/$file_name/stdout_bash_$i" 2>/dev/null
			else
				echo -ne "✅  "
				((TEST_OK++))
				((ONE++))
			fi
			echo -ne "\033[1;33mSTD_ERR:\033[m "
			if [[ -s $TMP_OUTDIR/tmp_err_minishell && ! -s $TMP_OUTDIR/tmp_err_bash ]] || [[ ! -s $TMP_OUTDIR/tmp_err_minishell && -s $TMP_OUTDIR/tmp_err_bash ]] ;
			then
				echo -ne "❌  " | tr '\n' ' '
				((TEST_KO_ERR++))
				((FAILED++))
				mkdir -p "$OUTDIR/$dir_name/$file_name" 2>/dev/null
				mv "$TMP_OUTDIR/tmp_err_minishell" "$OUTDIR/$dir_name/$file_name/stderr_minishell_$i" 2>/dev/null
				mv "$TMP_OUTDIR/tmp_err_bash" "$OUTDIR/$dir_name/$file_name/stderr_bash_$i" 2>/dev/null
			else
				echo -ne "✅  "
				((TEST_OK++))
				((TWO++))
			fi
			echo -ne "\033[1;36mEXIT_CODE:\033[m "
			if [[ $exit_minishell != $exit_bash ]] ;
			then
				echo -ne "❌\033[1;31m [ minishell($exit_minishell)  bash($exit_bash) ]\033[m  " | tr '\n' ' '
				((TEST_KO_EXIT++))
				((FAILED++))
			else
				echo -ne "✅  "
				((TEST_OK++))
				((THREE++))
			fi
			INPUT=""
			((i++))
			((TEST_COUNT++))
			echo -e "\033[0;90m$1:$tmp_line_count\033[m  "
			if [[ $ONE == 1 && $TWO == 1 && $THREE == 1 ]] ;
			then
				((GOOD_TEST++))
				((ONE--))
				((TWO--))
				((THREE--))
			else
				ONE=0
				TWO=0
				THREE=0
			fi
		fi
	done < "$1"
}

# Start the tester
main "$@"

# Clean all tmp files
[[ $1 != "-f" ]] && rm -f tmp_*
