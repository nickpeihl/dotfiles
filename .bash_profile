#!/bin/bash

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{bash_prompt,aliases,functions,path,dockerfunc,extra,exports};do
    if [[ -r "$file" ]] && [[ -f "$file" ]]; then
        source "$file"
    fi
done

unset file

# Add tab completion for SSH hostnames based on ~/.ssh/config
# ignoring wildcards
[[ -e "$HOME/.ssh/config" ]] && complete -o "default" \
	                                 -o "nospace" \
	                                 -W "$(grep "^Host" ~/.ssh/config | \
	grep -v "[?*]" | cut -d " " -f2 | \
	tr ' ' '\n')" scp sftp ssh
