if exists('Array')
  unlet Array
endif

Use D/dev/Test
Use D/base/Array

let s:TestArray = Test.expand('TestArray', {})

function! s:TestArray.beforeTest()
  let self.object = g:Array.new('integer')
endfunction

  ""
  " Должен устанавливать значение элемента массива.
  " @covers Array::in
  ""
function! s:TestArray.testShouldSetElement()
  call self.object.in(0, 1)
  call self.assertInteger(1, self.object.out(0))
  call self.object.in(1, 2)
  call self.assertInteger(2, self.object.out(1))
endfunction

  ""
  " В качестве ключа должно быть целое число большее нуля.
  " @covers Array::in
  ""
function! s:TestArray.testKeyShouldBeInteger()
  try
    call self.object.in('0', 1)
    echo 'Исключение не выброшено.'
  catch /InvalidArgument/
  endtry
  try
    call self.object.in(-1, 1)
    echo 'Исключение не выброшено.'
  catch /InvalidArgument/
  endtry
endfunction

  ""
  " Должен добавлять элемент в следующий свободный индекс.
  " @covers Array::push
  ""
function! s:TestArray.testShouldAddElement()
  call self.assertInteger(0, self.object.get('_nextIndex'))
  call self.object.push(1)
  call self.assertInteger(1, self.object.get('_nextIndex'))
  call self.object.push(2)
  call self.assertInteger(2, self.object.get('_nextIndex'))
  call self.assertInteger(2, self.object.length())
  call self.assertInteger(1, self.object.out(0))
  call self.assertInteger(2, self.object.out(1))
endfunction

  ""
  " Должен возвращать значение элемента массива.
  " @covers Array::out
  ""
function! s:TestArray.testShouldGetElement()
  call self.object.in(0, 1)
  call self.assertInteger(1, self.object.out(0))
endfunction

  ""
  " Должен выбрасывать исключение, если элемент не существует.
  " @covers Array::out
  ""
function! s:TestArray.testShouldThrowExceptionIfElementNotFound()
  try
    call self.object.out(0)
    echo 'Исключение не выброшено'
  catch /NotFound/
  endtry
endfunction

  ""
  " Должен удалять элемент массива.
  " @covers Array::remove
  ""
function! s:TestArray.testShouldRemoveElement()
  call self.object.in(0, 1)
  call self.object.remove(0)
  call self.assertInteger(0, self.object.length())
endfunction

  ""
  " Должен выбрасывать исключение, если элемент не существует.
  " @covers Array::remove
  ""
function! s:TestArray.testShouldThrowExceptionIfElementNotFound2()
  try
    call self.object.remove(0)
    echo 'Исключение не выброшено'
  catch /NotFound/
  endtry
endfunction

  ""
  " Должен возвращать true, если элемент с данным ключем присутствует в массиве.
  " @covers Array::has
  ""
function! s:TestArray.testShouldReturnTrueIfKeyExists()
  call self.assertFalse(self.object.has(0))
  call self.object.push(1)
  call self.assertTrue(self.object.has(0))
endfunction

  ""
  " Должен возвращать массив элементов.
  " @covers Array::getArr
  ""
function! s:TestArray.testShouldReturnArray()
  call self.object.push(1)
  call self.object.push(2)
  call self.object.in(4, 3)
  let arr = self.object.getArr()
  call self.assertInteger(3, type(arr))
  call self.assertInteger(1, arr[0])
  call self.assertInteger(2, arr[1])
  call self.assertInteger(3, arr[2])
endfunction

call s:TestArray.run()
