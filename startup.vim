if exists('DVim') == 1
  finish
endif

comm! -nargs=1 Use so $HOME/.vim/autoload/<args>.vim
comm! -nargs=1 DPlugin exe 'let DVim.plugins.' . <args> . ' = {}'

let DVim = {}
let DVim.plugins = {}

" Добавьте здесь DVim плагины, которые не следует подключать.
" let DVim.plugins.MyPlugin = 0
