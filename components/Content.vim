"if exists('Content')
"  finish
"endif

Use D/base/Object
Use D/components/Buffer

  " Класс представляет содержимое буфера.
let Content = Object.expand('Content', {'buffer': g:Buffer, '_bufferNum': 0})

  " Конструктор, создающий объект на основании буфера.
  " @buffer Buffer Целевой буфер.
  " @return Content
function! Content.buff(buffer)
  let obj = self._construct()
  call obj.set('buffer', a:buffer)
  call obj.set('_bufferNum', a:buffer.get('number'))
  return obj
endfunction

  " Конструктор, создающий объект для текущего буфера.
  " @return Content
function! Content.current()
  return self.buff(g:Buffer.current())
endfunction

  " Метод возвращает целевую строку.
  " @param integer lnum [optional] Номер целевой строки. Если параметр не передан, метод возвращает текущую строку со смещением указателя на текущий столбец.
  " @return String Целевая строка.
function! Content.getString(...) dict
  Use D/base/String
  if exists('a:1')
    return g:String.new(getbufline(self.get('_bufferNum'), a:1)[0])
  endif
  let str = self.getString(self.getLine('.'))
  call str.jump(self.getColumn('.') - 1)
  return str
endfunction

  " Метод возвращает номер искомой строки.
  " @param string expr [optional] Шаблон поиска. Если параметр не занад, метод возвращает номер текущей строки.
  " @return integer Номер искомой строки.
function! Content.getLine(...) dict
  if exists('a:1')
    return line(a:1)
  endif
  return line('.')
endfunction

  " Метод устанавливает указатель на целевую строку.
  " @param integer nline Номер целевой строки.
function! Content.setLine(nline) dict
  call setpos('.', [self.get('_bufferNum'), a:nline, self.getColumn()])
endfunction

  " Метод возвращает номер искомого символа в строке.
  " @param string expr [optional] Шаблон поиска. Если параметр не занад, метод возвращает номер текущего символа.
  " @return integer Номер искомого символа в строке.
function! Content.getColumn(...) dict
  if exists('a:1')
    return col(a:1)
  endif
  return col('.')
endfunction

  " Метод устанавливает указатель на заданный символ в текущей строке.
  " @param integer col Позиция целевого символа.
function! Content.setColumn(col) dict
  call setpos('.', [self.get('_bufferNum'), self.getLine(), a:col])
endfunction

  " Метод вставляет строку до указанной.
  " @param string str Вставляемая строка.
  " @param integer lnum [optional] Номер строки, до которой необходимо выполнить вставку. Если данный параметр не задан, вставка производится до текущей строки.
function! Content.before(str, ...) dict
  if exists('a:1')
    let currentLine = self.getLine()
    call self.setLine(a:1)
  else
    let currentLine = self.getLine()
  endif
  exe 'normal O'
  call self.insert(a:str)
  call self.setLine(currentLine + 1)
endfunction

  " Метод вставляет строку после указанной.
  " @param string str Вставляемая строка.
  " @param integer lnum [optional] Номер строки, после которой необходимо выполнить вставку. Если данный параметр не задан, вставка производится после текущей строки.
function! Content.after(str, ...) dict
  if  exists('a:1')
    call append(a:1, a:str)
  else
    call append(self.getLine(), a:str)
  endif
endfunction

  " Метод вставляет строку вместо указанной.
  " @param string str Вставляемая строка.
  " @param integer lnum [optional] Номер строки, в которой необходимо выполнить вставку. Если данный параметр не задан, вставка производится в текущей строке.
function! Content.insert(str, ...) dict
  if  exists('a:1')
    call setline(a:1, a:str)
  else
    call setline(self.getLine(), a:str)
  endif
endfunction

  " Метод добавляет символы в текущую строку.
  " @param string str Добавляемая строка.
  " @param integer pos [optional] Метод добавления. Если параметр не задан, используется вставка с текущего символ (i), иначе используется указанный метод.
function! Content.write(str, ...) dict
  if exists('a:1')
    exe 'normal '.a:1.a:str."\<Esc>"
  else
    exe 'normal i'.a:str."\<Esc>"
  endif
endfunction
