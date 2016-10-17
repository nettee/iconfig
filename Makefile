all: bash git ibus tmux vim
.PHONY: all bash git ibus tmux vim

bash:
	cat bashrc-tail >> ~/.bashrc
	cat inputrc-tail >> ~/.inputrc

git:
	cp gitconfig ~/.gitconfig

ibus:
	cp ibus-phrases-xiaohe.txt ~/.config/ibus/pinyin/phrases.txt
	ibus-daemon -drx # restart ibus

tmux:
	cp tmux.conf ~/.tmux.conf

vim:
	cp vimrc ~/.vimrc

