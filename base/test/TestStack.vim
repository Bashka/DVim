Use D/dev/Test
Use D/base/Stack

let s:TestStack = Test.expand('TestStack', {})

function! s:TestStack.beforeTest()
  let self.object = g:Stack.new('integer')
endfunction

  " Должен возвращать элемент с вершины стека.
  " @covers Stack::pop
function! s:TestStack.testShouldReturnTopElement()
  call self.object.push(1)
  call self.object.push(2)
  call self.object.push(3)
  call self.assertInteger(3, self.object.length())
  call self.assertInteger(3, self.object.pop())
  call self.assertInteger(2, self.object.length())
  call self.assertInteger(2, self.object.pop())
  call self.assertInteger(1, self.object.length())
  call self.assertInteger(1, self.object.pop())
  call self.assertInteger(0, self.object.length())
endfunction

  " Должен выбрасывать исключение, если стек пуст.
  " @covers Stack::pop
function! s:TestStack.testShouldThrowExceptionIfStackEmpty()
  try
    call self.object.pop()
    echo 'Исключение не выброшено'
  catch /NotFound/
  endtry
endfunction

call s:TestStack.run()
