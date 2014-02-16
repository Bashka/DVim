if exists('Test')
  finish
endif

Use D/base/Object

  " Класс служит основой для unit-test.
let Test = Object.expand('Test', {})

  " Метод выполняет сверку данных и сообщает о несоответствии.
  " @param string fun Имя проверяемой функции.
  " @param integer type Ожидаемый тип.
  " @param mixed assert Ожидаемое значение.
  " @param mixed actual Реальное значение.
function! Test._compare(fun, type, assert, actual)
  if type(a:actual) != a:type || a:actual != a:assert
    echo a:fun . ': ожидается ' . string(a:assert) . ' вместо ' . string(a:actual)
  endif
endfunction

function! Test.beforeRun()
endfunction

function! Test.afterRun()
endfunction

function! Test.beforeTest()
endfunction

function! Test.afterTest()
endfunction

  " Метод ожидает true.
  " @param boolean actual Проверяемое значение.
function! Test.assertTrue(actual)
  call self._compare('assertTrue', 0, 1, a:actual)
endfunction

  " Метод ожидает false.
  " @param boolean actual Проверяемое значение.
function! Test.assertFalse(actual)
  call self._compare('assertFalse', 0, 0, a:actual)
endfunction

  " Метод ожидает целое число.
  " @param integer actual Проверяемое значение.
function! Test.assertInteger(assert, actual)
  call self._compare('assertInteger', 0, a:assert, a:actual)
endfunction

  " Метод ожидает дробное число.
  " @param float actual Проверяемое значение.
function! Test.assertFloat(assert, actual)
  call self._compare('assertFloat', 5, a:assert, a:actual)
endfunction

  " Метод ожидает строку.
  " @param string actual Проверяемое значение.
function! Test.assertString(assert, actual)
  call self._compare('assertString', 1, a:assert, a:actual)
endfunction

  " Метод выполняет тестирование.
function! Test.run(...)
  echo '===' . self.class . '==='
  call self.beforeRun()
  if exists('a:1')
    call self.beforeTest()
    echo '---' . a:1 . '---'
    call self[a:1]()
    call self.afterTest()
  else
    for i in keys(self)
      " Обработка методов с тестами.
      if type(self[i]) == 2 && strpart(i, 0, 4) == 'test'
        call self.beforeTest()
        echo '---' . i . '---'
        call self[i]()
        call self.afterTest()
      endif
    endfor
  endif
  call self.afterRun()
endfunction
