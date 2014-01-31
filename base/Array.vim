if exists('Array')
  finish
endif

Use D/base/Dictionary

  " Класс представляет множество типа Массив.
let Array = Dictionary.expand('Dictionary', {'_nextIndex': 0})

  " Метод добавляет элемент массива.
  " @param integer key Индекс элемента.
  " @param mixed val Значение элемента.
function! Array.in(key, val) dict
  if a:key < 0
    echoerr 'В качестве индекса элемента массива должно быть целое число, большее нуля.'
  endif
  if a:key > self.get('_nextIndex')
    call self.set('_nextIndex', a:key + 1)
  endif
  call self.parent.in(string(a:key), a:val)
endfunction

  " Метод добавляет элемент в следующий свободный индекс.
  " Под следующим свободным индексом понимается индекс, следующий за самым большим использованным индексом.
  " @param mixed val Значение элемента.
function! Array.push(val) dict
  let nextIndex = self.get('_nextIndex')
  call self.parent.in(string(nextIndex), a:val)
  call self.set('_nextIndex', nextIndex + 1)
endfunction

  " Метод возвращает элемент массива.
  " @param integer key Индекс целевого элемента.
  " @return mixed Значение элемента массива.
function! Array.out(key) dict
  return self.parent.out(string(a:key))
endfunction

  " Метод удаляет элемент массива.
  " @param integer key Индекс целевого элемента.
function! Array.remove(key) dict
  if a:key == self.get('_nextIndex') - 1
    call self.set('_nextIndex', a:key)
  endif
  call self.parent.remove(string(a:key))
endfunction
