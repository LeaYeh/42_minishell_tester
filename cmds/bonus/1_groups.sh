# **************************************************************************** #
#                                    GROUPS                                    #
# **************************************************************************** #

((echo 1) | (echo 2) | (echo 3 | (echo 4)))

echo 1 | (echo 2 || echo 3 && echo 4) || echo 5 | cat -enT

echo 1 | (grep 1) | cat | (wc -l)

(/bin/echo 1 | cat -enT && ( (/bin/echo 3 | cat -enT) | (rev |  cat -enT) ))

(exit 4)

(sleep 0 && (exit 4))

(echo 1 | cat -enT) | (exit 2)

