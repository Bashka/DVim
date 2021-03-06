if exists('String')
  finish
endif

Use D/base/Object

  ""
  " Класс представляет сроку.
  ""
let String = Object.expand('String', {'val': '', 'cursor': 0}) 

  ""
  " Метод формирует объект на основании строки.
  " @param string val Обрабатываемая строка.
  " @return String
  ""
function! String.new(val)
  let obj = self._construct()
  call obj.set('val', a:val)
  return obj
endfunction

  ""
  " Метод возвращает длину строки в байтах.
  " @return integer Число байт, занимаемых строкой.
  ""
function! String.length() dict
  return strlen(self.get('val'))
endfunction

  ""
  " Метод возвращает текущий символ.
  " @return string Текущий символ.
  ""
function! String.getChar() dict
  return self.get('val')[self.get('cursor')]
endfunction

  ""
  " Метод смещает внутренний указатель на один символ вправо.
  ""
function! String.next() dict
  let cursor = self.get('cursor')
  let cursor += 1
  call self.set('cursor', cursor)
endfunction

  ""
  " Метод смещает внутренний указатель на один символ влево.
  ""
function! String.prev() dict
  let cursor = self.get('cursor')
  let cursor -= 1
  call self.set('cursor', cursor)
endfunction

  ""
  " Метод смещает внутренний указатель на заданную позицию.
  " @param integer pos Целевая позиция указателя.
  ""
function! String.jump(pos) dict
  call self.set('cursor', a:pos)
endfunction

  ""
  " Метод производит поиск подстроки в строке. Поиск подстроки начинается c указателя.
  " @param string needle Искомая подстрока.
  " @return integer Позиция искомой подстроки или -1, если подстрока не найдена.
  ""
function! String.search(needle) dict
  return stridx(self.get('val'), a:needle, self.get('cursor'))
endfunction

  ""
  " Метод смещает указатель на первое вхождение подстроки. Поиск подстроки начинается c указателя.
  " @param string needle Искомая подстрока.
  " @return integer Позиция смещения или -1 - если искомой подстроки нет в строке.
  ""
function! String.searchAndJump(needle) dict
  let pos = self.search(a:needle)
  if pos == -1
    return -1
  endif
  call self.jump(pos)
  return pos
endfunction

  ""
  " Метод выполняет поиск подстроки по регулярному выражению и возвращет адрес первого вхождения. Метод начинает поиск от указателя.
  " @param string expr Регулярное выражение.
  " @return integer Позиция вхождения искомой подстроки ли -1 - если подстрока не найдена.
  ""
function! String.match(expr) dict
  return match(self.get('val'), a:expr, self.get('cursor'))
endfunction

  ""
  " Метод возвращает подстроку от указателя до указанной длины.
  " @param integer length Число отбираемых байт. Если значение > 0, отбор производится справа от указателя, если < 0 - слева, иначе отбирается вся подстрока от указателя и до конца строки.
  " @return String Отобранная подстрока.
  ""
function! String.sub(length) dict
  if a:length > 0
    let sub = strpart(self.get('val'), self.get('cursor'), a:length)
  elseif a:length < 0
    let sub = strpart(self.get('val'), self.get('cursor') + a:length, -a:length)
  else
    let sub = strpart(self.get('val'), self.get('cursor'))
  endif
  return g:String.new(sub)
endfunction

  ""
  " Метод возвращает подстроку от указателя до искомой подстроки. Указатель смещается за искомую подстроку. Искомая подстрока не входит в возвращаемое значение.
  " @param string needle Строка - ограничитель.
  " @return String Подстрока от указателя до строки-ограничителя или пустая строка в случае, если строка-ограничитель не найдена.
  ""
function! String.subTo(needle) dict
  let pos = self.search(a:needle)
  if pos == -1
    return g:String.new('')
  endif
  let subLength = pos - self.get('cursor')
  let sub = self.sub(subLength)
  call self.jump(pos + strlen(a:needle))
  return sub
endfunction

  ""
  " Метод удаляет все пробелы (или другие символы) с начала строки до первого вхождения отличного от пробела символа.
  " @param string char [optional] Удаляемый символ. По умолчанию пробел.
  " @return String Полученая в результате строка.
  ""
function! String.trimLeft(...) dict
  if exists('a:1')
    let delimeter = a:1
  else
    let delimeter = ' '
  endif
  let val = self.get('val')
  let d = 0
  let char = val[d]
  while char == delimeter
    let d += 1 
    let char = val[d]
  endwhile
  return g:String.new(strpart(val, d))
endfunction

  ""
  " Метод удаляет все пробелы (или другие символы) с конца строки до первого вхождения отличного от пробела символа.
  " @param string char [optional] Удаляемый символ. По умолчанию пробел.
  " @return String Полученая в результате строка.
  ""
function! String.trimRight(...) dict
  if exists('a:1')
    let delimeter = a:1
  else
    let delimeter = ' '
  endif
  let val = self.get('val')
  let d = strlen(val) - 1
  let char = val[d]
  while char == delimeter
    let d -= 1 
    let char = val[d]
  endwhile
  return g:String.new(strpart(val, 0, d + 1))
endfunction

  ""
  " Метод удаляет все пробелы (или другие символы) с начала и конца строки до первого вхождения отличного от пробела символа.
  " @param string char [optional] Удаляемый символ. По умолчанию пробел.
  " @return String Полученая в результате строка.
  ""
function! String.trim(...) dict
  if exists('a:1')
    let delimeter = a:1
  else
    let delimeter = ' '
  endif
  return self.trimLeft(delimeter).trimRight(delimeter)
endfunction

  ""
  " Метод делит строку на элементы массива по указанному разделителю. Метод смещает указатель.
  " @param string separator Разделитель.
  " @return Array[String] Результирующий массив строк.
  ""
function! String.split(separator) dict
  Use D/base/Array
  let result = g:Array.new(g:String)
  call self.jump(0)
  let el = self.subTo(a:separator)
  while el.length() != 0
    call result.push(el)
    let el = self.subTo(a:separator)
  endwhile
  call result.push(self.sub(0))
  return result
endfunction

  ""
  " Метод делит строку на элементы массива по регулярному выражению.
  " @param string expr Регулярное выражение.
  " @return string[] Результирующий массив.
  ""
function! String.splitMatch(expr) dict
  return matchlist(self.get('val'), a:expr)
endfunction

  ""
  " Метод выполняет замену в строке на основе регулярного выражения.
  " @param string expr Регулярное выражение. 
  " @param string replace Замена.
  " @param boolean glocal [optional] true - глобальная замена, иначе - false.
  " @return String Результирующая строка.
  ""
function! String.replace(expr, replace, ...) dict
  if  exists('a:1') && a:1 == 1
    let g = 'g'
  else
    let g = ''
  endif
  return g:String.new(substitute(self.get('val'), a:expr, a:replace, g))
endfunction
