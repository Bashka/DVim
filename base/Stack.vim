if exists('Stack')
  finish
endif

Use D/base/Dictionary

" Класс представляет множество типа Стек.
let Stack = Dictionary.expand('Stack', {'_val': [], '_index': 0})

" Метод добавляет элемент в множество.
" @param mixed el Добавляемый элемент.
function! Stack.push(el) dict
  call insert(self._val, a:el, self._index)
  let self._index += 1
endfunction

" Метод выбирает и возвращает элемент с вершины множества.
" @throws Выбрасывается в случае, если стек пуст.
" @return mixed Элемент, находящийся на вершине стека.
function! Stack.pop() dict
  if self._index == 0
    echoerr 'Стек [Stack] ]пуст.'
    return
  endif
  let self._index -= 1
  let el = self._val[self._index]
  if self._index == 0
    let self._val = []
  else
    let self._val = self._val[0:self._index]
  endif
  return el
endfunction

" Метод возвращает длину множества.
" @return integer Число элементов, находящихся в стеке.
function! Stack.length() dict
  return self._index
endfunction
