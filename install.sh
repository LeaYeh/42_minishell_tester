#!/bin/bash

cd $HOME
rm -rf 42_minishell_tester

mkdir 42_minishell_tester_tmp

cd 42_minishell_tester_tmp

git clone https://github.com/LeaYeh/42_minishell_tester.git

cp -r 42_minishell_tester $HOME

cd $HOME
rm -rf 42_minishell_tester_tmp

cd $HOME/42_minishell_tester
chmod +x $HOME/42_minishell_tester/tester.sh

# List of rc files to update
RC_FILES=("$HOME/.bashrc" "$HOME/.zshrc")

# Alias to be added
ALIAS_LINE="\nalias mstest=\"bash $HOME/42_minishell_tester/tester.sh\"\n"

# Function to add alias to a file if it doesn't already exist
add_alias_if_not_present() {
    local file=$1
    if ! grep "mstest=" "$file" &> /dev/null; then
        echo "mstest alias not present in $file"
        echo "Adding alias in file: $file"
        echo -e "$ALIAS_LINE" >> "$file"
    fi
}

# Loop through each rc file and add the alias
for rc_file in "${RC_FILES[@]}"; do
    add_alias_if_not_present "$rc_file"
done

exec $SHELL
