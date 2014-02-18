if exists('Turn')
  finish
endif

Use D/base/Array

  ""
  " Класс представляет множество типа Очередь.
  ""
let Turn = Array.expand('Turn', {'_firstIndex': 0})

  ""
  " Метод выбирает и возвращает элемент с основания множества.
  " @throws Выбрасывается в случае, если очередь пуста.
  " @return mixed Элемент, находящийся в основании очереди.
  ""
function! Turn.pop() dict
  let length = self.length() 
  if length == 0
    throw 'NotFound: Очередь пуста.'
  endif
  let firstIndex = self.get('_firstIndex')
  let el = self.out(firstIndex)
  call self.remove(firstIndex)
  call self.set('_firstIndex', firstIndex + 1)
  return el
endfunction
