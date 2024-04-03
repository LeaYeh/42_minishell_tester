# **************************************************************************** #
#                                  SUBSHELL                                    #
# **************************************************************************** #
yes | (head -1 && (head -2 | (head -3 && head -4))) | cat | wc -l

yes | (echo 1 && (echo 2 | (echo 3 && echo 4))) | cat

yes | (echo 1 && (echo 2 | (echo 3 && echo 4))) | cat | wc -l

yes | (head -1 && (head -2 | (head -3 && head -4))) | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | wc -l

(echo 1 | cat > alt) > out
cat out
cat alt

(echo 1 | cat > alt) > out
cat out
cat alt
rm out alt

(echo 1 | cat ) > out
cat out
cat alt
rm out alt

(echo 1 | echo 2 ) > out
cat out
cat alt
rm out alt

(echo 1 && echo 2 ) > out
cat out
cat alt
rm out alt

ls | (ls | ls | echo 1 && (echo 2) > out1) > out2 && ls
cat out1
cat out2
rm out1 out2

(head -1 > file1 | head -1 > file2) < Makefile
cat file1
cat file2
rm file1 file2

(head -1 > file1 && head -1 > file2) < Makefile
cat file1
cat file2
rm file1 file2

(echo hi && (echo hi && (echo hi) && echo hi))
