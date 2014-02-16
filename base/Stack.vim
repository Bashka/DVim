if exists('Stack')
  finish
endif

Use D/base/Array

  " Класс представляет множество типа Стек.
let Stack = Array.expand('Stack', {})

" Метод выбирает и возвращает элемент с вершины множества.
" @throws Выбрасывается в случае, если стек пуст.
" @return mixed Элемент, находящийся на вершине стека.
function! Stack.pop() dict
  let length = self.length()
  if length == 0
    throw 'NotFound: Стек пуст.'
    return
  endif
  let el = self.out(length - 1)
  call self.remove(length - 1)
  return el
endfunction
