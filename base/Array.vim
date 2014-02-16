if exists('Array')
  finish
endif

Use D/base/Dictionary

  " Класс представляет множество типа Массив.
let Array = Dictionary.expand('Array', {'_nextIndex': 0})

  " Метод добавляет элемент массива.
  " @param integer key Индекс элемента.
  " @param mixed val Значение элемента.
function! Array.in(key, val) dict
  if a:key < 0 || type(a:key) != 0
    throw 'InvalidArgument: В качестве индекса элемента массива должно быть целое число, большее или равное нулю.'
  endif
  if a:key > self.get('_nextIndex')
    call self.set('_nextIndex', a:key + 1)
  endif
  call self.instanceup('Dictionary').in(string(a:key), a:val)
endfunction

  " Метод добавляет элемент в следующий свободный индекс.
  " Под следующим свободным индексом понимается индекс, следующий за самым большим использованным индексом.
  " @param mixed val Значение элемента.
function! Array.push(val) dict
  let nextIndex = self.get('_nextIndex')
  call self.instanceup('Dictionary').in(string(nextIndex), a:val)
  call self.set('_nextIndex', nextIndex + 1)
endfunction

  " Метод возвращает элемент массива.
  " @param integer key Индекс целевого элемента.
  " @return mixed Значение элемента массива.
function! Array.out(key) dict
  return self.instanceup('Dictionary').out(string(a:key))
endfunction

  " Метод удаляет элемент массива.
  " @param integer key Индекс целевого элемента.
function! Array.remove(key) dict
  if a:key == self.get('_nextIndex') - 1
    call self.set('_nextIndex', a:key)
  endif
  call self.instanceup('Dictionary').remove(string(a:key))
endfunction

  " Метод определяет, имеет ли заданный элемент массива значение.
  " @param integer key Индекс целевого элемента.
  " @return boolean true - если элементу присвоено значение, иначе - false.
function! Array.has(key) dict
  return self.instanceup('Dictionary').has(string(a:key))
endfunction

  " Метод возвращает содержимое объекта в виде массива.
  " @return array Содержимое объекта.
function! Array.getArr() dict
  let arr = self.get('_val')
  let result = []
  let pos = 0
  for i in keys(arr)
    call insert(result, arr[i], pos)
    let pos += 1
  endfor
  return result
endfunction
