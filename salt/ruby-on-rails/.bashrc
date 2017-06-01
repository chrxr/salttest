if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

export PATH="/usr/local/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
