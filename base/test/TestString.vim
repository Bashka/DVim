if exists('String')
  unlet String
endif

Use D/dev/Test
Use D/base/String

let s:TestString = Test.expand('TestString', {})

function! s:TestString.beforeTest()
  let self.object = g:String.new('Hello world')
endfunction

  ""
  " Должен возвращать длину строки в байтах.
  " @covers String::length
  ""
function! s:TestString.testShouldReturnLength()
  call self.assertInteger(11, self.object.length())
endfunction

  ""
  " Должен возвращать текущий символ строки.
  " @covers String::getChar
  ""
function! s:TestString.testShouldReturnCurrentChar()
  call self.assertString('H', self.object.getChar()) 
  call self.object.next()
  call self.assertString('e', self.object.getChar()) 
endfunction

  ""
  " Должен смещать внутренний указатель на один символ вправо.
  " @covers String::next
  ""
function! s:TestString.testShouldJumpNextChar()
  call self.object.next()
  call self.assertString('e', self.object.getChar()) 
endfunction

  ""
  " Должен смещать внутренний указатель на один символ влево.
  " @covers String::prev
  ""
function! s:TestString.testShouldJumpPrevChar()
  call self.object.next()
  call self.object.prev()
  call self.assertString('H', self.object.getChar()) 
endfunction

  ""
  " Должен смещать внутренний указатель на указанную позицию.
  " @covers String::jump
  ""
function! s:TestString.testShouldJump()
  call self.object.jump(5)
  call self.assertString(' ', self.object.getChar()) 
endfunction

  ""
  " Должен возвращать позицию первого вхождения подстроки.
  " @covers String::search
  ""
function! s:TestString.testShouldReturnPosSubstring()
  call self.assertInteger(5, self.object.search(' ')) 
  call self.object.jump(5)
  call self.assertInteger(7, self.object.search('o')) 
endfunction

  ""
  " Должен смещать внутренний указатель на искомую подстроку.
  " @covers String::searchAndJump
  ""
function! s:TestString.testShouldJumpToSubstring()
  call self.object.searchAndJump(' ')
  call self.assertString(' ', self.object.getChar()) 
endfunction

  ""
  " Должен возвращать подстроку.
  " @covers String::sub
  ""
function! s:TestString.testShouldReturnSubstring()
  call self.assertString('Hello', self.object.sub(5).get('val')) 
  call self.object.jump(5)
  call self.assertString('Hello', self.object.sub(-5).get('val')) 
  call self.assertString(' world', self.object.sub(0).get('val')) 
endfunction

  ""
  " Должен возвращать подстроку до указанной подстроки.
  " @covers String::subTo
  ""
function! s:TestString.testShouldReturnSubstringToSubstring()
  call self.assertString('Hello', self.object.subTo(' ').get('val')) 
  call self.assertString('w', self.object.getChar()) 
  let o = g:String.new('ab cd ef gh')
  call self.assertString('ab', o.subTo(' ').get('val')) 
  call self.assertString('cd', o.subTo(' ').get('val')) 
  call self.assertString('ef', o.subTo(' ').get('val')) 
  call self.assertString('', o.subTo(' ').get('val')) 
endfunction

  ""
  " Должен удалять все символы пробела с начала строки и до первого вхождения непробельного символа.
  " @covers String::trimLeft
  ""
function! s:TestString.testShouldLeftTrimString()
  let o = g:String.new('Hello')
  call self.assertString('Hello', o.trimLeft().get('val'))
  let o = g:String.new('  Hello')
  call self.assertString('Hello', o.trimLeft().get('val'))
  let o = g:String.new('xxHello')
  call self.assertString('Hello', o.trimLeft('x').get('val'))
endfunction

  ""
  " Должен удалять все символы пробела с конца строки и до первого вхождения непробельного символа.
  " @covers String::trimRight
  ""
function! s:TestString.testShouldRightTrimString()
  let o = g:String.new('Hello')
  call self.assertString('Hello', o.trimRight().get('val'))
  let o = g:String.new('Hello  ')
  call self.assertString('Hello', o.trimRight().get('val'))
  let o = g:String.new('Helloxx')
  call self.assertString('Hello', o.trimRight('x').get('val'))
endfunction

  ""
  " Должен удалять все символы пробела с начала и конца строки.
  " @covers String::trim
  ""
function! s:TestString.testShouldTrimString()
  let o = g:String.new('Hello')
  call self.assertString('Hello', o.trim().get('val'))
  let o = g:String.new('  Hello  ')
  call self.assertString('Hello', o.trim().get('val'))
endfunction

  ""
  " Должен разделять строку на элементы массива по заданному разделителю.
  " @covers String::split
  ""
function! s:TestString.testShouldSplitString()
  let o = g:String.new('ab cd ef gh')
  let a = o.split(' ')
  call self.assertString('ab', a.out(0).get('val'))
  call self.assertString('cd', a.out(1).get('val'))
  call self.assertString('ef', a.out(2).get('val'))
  call self.assertString('gh', a.out(3).get('val'))
endfunction

  ""
  " Должен разделять строку на элементы массива по заданному регулярному выражению.
  " @covers String::splitMatch
  ""
function! s:TestString.testShouldSplitStringOnExpr()
  let res = self.object.splitMatch('\v(Hello)( )(world)')
  call self.assertString('Hello', res[1])
  call self.assertString(' ', res[2])
  call self.assertString('world', res[3])
  let res = self.object.splitMatch('\v(test)')
  call self.assertInteger(0, len(res))
endfunction

  ""
  " Должен выполнять поиск подстроки по регулярному выражению.
  " @covers String::match
  ""
function! s:TestString.testShouldSearchSubstring()
  call self.assertInteger(6, self.object.match('\vwor'))
  call self.assertInteger(-1, self.object.match('\vtest'))
endfunction

  ""
  " Должен выполнять поиск с заменой в строке по регулярному выражению.
  " @covers String::replace
  ""
function! s:TestString.testShouldReplaceString()
  let result = self.object.replace('\v[eo]', ' ', 1)
  call self.assertString('H ll  w rld', result.get('val'))
  let result = self.object.replace('\v[x]', ' ', 1)
  call self.assertString('Hello world', result.get('val'))
endfunction

call s:TestString.run()
