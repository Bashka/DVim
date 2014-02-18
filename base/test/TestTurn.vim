if exists('Turn')
  unlet Turn
endif

Use D/dev/Test
Use D/base/Turn

let s:TestTurn = Test.expand('TestTurn', {})

function! s:TestTurn.beforeTest()
  let self.object = g:Turn.new('integer')
endfunction

  " Должен возвращать элемент с основания стека.
  " @covers Turn::pop
function! s:TestTurn.testShouldReturnBottomElement()
  call self.object.push(1)
  call self.object.push(2)
  call self.object.push(3)
  call self.assertInteger(3, self.object.length())
  call self.assertInteger(1, self.object.pop())
  call self.assertInteger(2, self.object.length())
  call self.assertInteger(2, self.object.pop())
  call self.assertInteger(1, self.object.length())
  call self.assertInteger(3, self.object.pop())
  call self.assertInteger(0, self.object.length())
endfunction

  " Должен выбрасывать исключение, если очередь пуста.
  " @covers Turn::pop
function! s:TestTurn.testShouldThrowExceptionIfStackEmpty()
  try
    call self.object.pop()
    echo 'Исключение не выброшено'
  catch /NotFound/
  endtry
endfunction

call s:TestTurn.run()
