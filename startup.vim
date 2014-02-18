if exists('DVim') == 1
  finish
endif
let DVim = 1

comm! -nargs=1 Use so $HOME/.vim/autoload/<args>.vim
comm! -nargs=1 DPlugin if exists(<args>) == 1 | finish | endif | exe 'let ' . <args> . ' = 1'
