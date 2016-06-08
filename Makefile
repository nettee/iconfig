all: bash git tmux vim_

bash:
	cat bashrc-tail >> ~/.bashrc
	cat inputrc-tail >> ~/.inputrc

git:
	cp gitconfig ~/.gitconfig

tmux:
	cp tmux.conf ~/.tmux.conf

vim_:
	cp vimrc ~/.vimrc

