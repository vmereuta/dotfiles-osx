# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$(/usr/local/bin/brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:/usr/local/sbin:$PATH";

user=*****USER
password=****PASSWORD
px="****PROXYADDR"
# Lots of variations for git/bower/npm etc.
export npm_config_proxy="http://$user:$password@$px"
export http_proxy="http://$user:$password@$px"
export HTTP_PROXY="http://$user:$password@$px"
export https_proxy="http://$user:$password@$px"
export HTTPS_PROXY="http://$user:$password@$px"

export JAVA_OPTS="$JAVA_OPTS -Dhttp.proxyHost=euro-webproxy.drama.man.com -Dhttp.proxyPort=8080 -Dhttp.proxyUser=${USER} -Dhttp.proxyPassword=${password} -Dhttps.proxyHost=euro-webproxy.drama.man.com -Dhttps.proxyPort=8080 -Dhttps.proxyUser=${USER} -Dhttps.proxyPassword=${password}"


export DOTS_DB=trd6
export PY_BACKEND=agg
export PYTHONDONTWRITEBYTECODE=true
export MONGOOSE_CENTAUR_CENTAUR_DB=centaurd
export MONGOOSE_STATARBPE_CENTAUR_DB=centaurd
export MOSEKLM_LICENSE_FILE=/data/app/mosek/mosek.lic


#[[ -z $DISPLAY ]] && export DISPLAY=":0.0"

#export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
#export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
#export CLICOLOR="xterm-color"

export EDITOR="/usr/local/bin/subl"
alias e=${EDITOR}

# MacPorts Installer addition on 2012-10-12_at_11:11:05: adding an appropriate PATH variable for use with MacPorts.
export PATH=${HOME}/bin:/usr/local/bin:/usr/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

export WORKON_HOME=~/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
source /usr/local/bin/virtualenvwrapper.sh


# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Enable extended pattern matching
shopt -s extglob

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew > /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;
