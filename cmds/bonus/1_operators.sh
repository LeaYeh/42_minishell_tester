# **************************************************************************** #
#                                   OPERATORS                                  #
# **************************************************************************** #

### SIMPLE OPERATORS ###
/bin/echo 1 && /bin/echo 2
cat file_does_not_exist && /bin/echo 2

/bin/echo 1 || /bin/echo 2
cat file_does_not_exist || /bin/echo 2

/bin/echo 1 && /bin/echo 2 && /bin/echo 3
/bin/echo 1 || /bin/echo 2 || /bin/echo 3

### PIPELINES AFTER OPERATORS ###
/bin/echo 1 && /bin/echo 2 | cat -enT
/bin/echo 1 || /bin/echo 2 | cat -enT

/bin/echo 1 && cat file_does_not_exist | cat -enT
/bin/echo 1 && /bin/echo 3 | cat file_does_not_exist
/bin/echo 1 || cat file_does_not_exist | cat -enT
/bin/echo 1 || /bin/echo 2 | cat file_does_not_exist
cat file_does_not_exist && /bin/echo 2 | cat -enT
cat file_does_not_exist || /bin/echo 2 | cat -enT

### PIPELINES BEFORE OPERATOR ###
/bin/echo 1 | cat -enT && /bin/echo 3
/bin/echo 1 | cat -enT || /bin/echo 3

/bin/echo 1 | cat file_does_not_exist && /bin/echo 3
/bin/echo 1 | cat file_does_not_exist || /bin/echo 3
cat file_does_not_exist | cat -enT && /bin/echo 3
cat file_does_not_exist | cat -enT || /bin/echo 3
/bin/echo 1 | cat -enT && cat file_does_not_exist
/bin/echo 1 | cat -enT || cat file_does_not_exist

### PIPELINES BEFORE AND AFTER OPERATOR ###
/bin/echo 1 | cat -enT && /bin/echo 3 | cat -enT
/bin/echo 1 | cat -enT || /bin/echo 3 | cat -enT

/bin/echo 1 | cat -enT | cat -enT && /bin/echo 4 | cat -enT
/bin/echo 1 | cat -enT | cat -enT || /bin/echo 4 | cat -enT
