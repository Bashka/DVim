Use D/base/Object

let Test = Object.expand('Test', {})

function! Test.assertTrue(actual)
  if type(actual) == 0 && actual == 1
    return 1
  else
    return 0
  endif
endfunction

function! Test.assertFalse(actual)
  if type(actual) == 0 && actual == 0
    return 1
  else
    return 0
  endif
endfunction

function! Test.assertEquals(assert, actual)
endfunction
