if exists('Dictionary')
  unlet Dictionary
endif

Use D/dev/Test
Use D/base/Dictionary

let s:TestDictionary = Test.expand('TestDictionary', {})

function! s:TestDictionary.beforeTest()
  let self.object = g:Dictionary.new('integer')
endfunction

  ""
  " Должен устанавливать значение элемента словаря.
  " @covers Dictionary::in
  ""
function! s:TestDictionary.testShouldSetElement()
  call self.object.in('0', 1)
  call self.assertInteger(1, self.object.out('0'))
  call self.object.in('0', 2)
  call self.assertInteger(2, self.object.out('0'))
endfunction

  ""
  " Должен выбрасывать исключение при попытке записи элемента недопустимого типа. 
  " @covers Dictionary::in
  ""
function! s:TestDictionary.testShouldThrowExceptionIfBadTypeSet()
  try
    call self.object.in('0', '1')
    echo 'Исключение не выброшено'
  catch /InvalidArgument/
  endtry
endfunction

  ""
  " Должен удалять элемент из словаря.
  " @covers Dictionary::remove
  ""
function! s:TestDictionary.testShouldRemoveElement()
  call self.object.in('0', 1)
  call self.object.remove('0')
  call self.assertInteger(0, self.object.length())
endfunction

  ""
  " Должен должен выбрасывать исключение, если элемент отсутствует.
  " @covers Dictionary::remove
  ""
function! s:TestDictionary.testShouldThrowExceptionIfElementNotFound()
  try
    call self.object.remove('0')
    echo 'Исключение не выброшено'
  catch /NotFound/
  endtry
endfunction

  ""
  " Должен возвращать значение элемента.
  " @covers Dictionary::out
  ""
function! s:TestDictionary.testShouldGetElement()
  call self.object.in('0', 1)
  call self.assertInteger(1, self.object.out('0'))
  call self.object.in('1', 2)
  call self.assertInteger(2, self.object.out('1'))
endfunction

  ""
  " Должен должен выбрасывать исключение, если элемент отсутствует.
  " @covers Dictionary::out
  ""
function! s:TestDictionary.testShouldThrowExceptionIfElementNotFound2()
  try
    call self.object.out('0')
    echo 'Исключение не выброшено'
  catch /NotFound/
  endtry
endfunction

  ""
  " Должен возвращать число элементов в словаре.
  " @covers Dictionary::length
  ""
function! s:TestDictionary.testShouldReturnLength()
  call self.object.in('0', 1)
  call self.assertInteger(1, self.object.length())
  call self.object.in('1', 1)
  call self.assertInteger(2, self.object.length())
endfunction

  ""
  " Должен возвращать true, если элемент с данным ключем присутствует в словаре.
  " @covers Dictionary::has
  ""
function! s:TestDictionary.testShouldReturnTrueIfKeyExists()
  call self.assertFalse(self.object.has('0'))
  call self.object.in('0', 1)
  call self.assertTrue(self.object.has('0'))
endfunction

function! s:TestDictionary.eachFun(key, val)
  return a:val * 2
endfunction

  ""
  " Должен вызывать функцию-обработчик для каждого элемента словаря.
  " @covers Dictionary::each
  ""
function! s:TestDictionary.testShouldCallFunFromAllElements()
  call self.object.in('0', 1)
  call self.object.in('1', 2)
  call self.object.in('2', 3)
  call self.object.each(s:TestDictionary, "eachFun")
  call self.assertInteger(2, self.object.out('0'))
  call self.assertInteger(4, self.object.out('1'))
  call self.assertInteger(6, self.object.out('2'))
endfunction

function! s:TestDictionary.filterFun(key, val)
  if a:val == 2
    return 0
  else
    return 1
  endif
endfunction

  ""
  " Должен вызывать функцию-обработчик для каждого элемента словаря.
  " @covers Dictionary::filter
  ""
function! s:TestDictionary.testShouldFilterElements()
  call self.object.in('0', 1)
  call self.object.in('1', 2)
  call self.object.in('2', 3)
  call self.object.filter(s:TestDictionary, "filterFun")
  call self.assertInteger(1, self.object.has('0'))
  call self.assertInteger(0, self.object.has('1'))
  call self.assertInteger(1, self.object.has('2'))
endfunction

call s:TestDictionary.run()
