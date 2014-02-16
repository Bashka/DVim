if exists('String')
  finish
endif

Use D/base/Object

  " Класс представляет сроку.
let String = Object.expand('String', {'val': '', 'cursor': 0}) 

  " Метод формирует объект на основании строки.
  " @param string val Обрабатываемая строка.
  " @return String
function! String.new(val)
  let obj = self._construct()
  call obj.set('val', a:val)
  return obj
endfunction

  " Метод возвращает длину строки в байтах.
  " @return integer Число байт, занимаемых строкой.
function! String.length() dict
  return strlen(self.get('val'))
endfunction

  " Метод возвращает текущий символ.
  " @return string Текущий символ.
function! String.getChar() dict
  return self.get('val')[self.get('cursor')]
endfunction

  " Метод смещает внутренний указатель на один символ вправо.
function! String.next() dict
  let cursor = self.get('cursor')
  let cursor += 1
  call self.set('cursor', cursor)
endfunction

  " Метод смещает внутренний указатель на один символ влево.
function! String.prev() dict
  let cursor = self.get('cursor')
  let cursor -= 1
  call self.set('cursor', cursor)
endfunction

  " Метод смещает внутренний указатель на заданную позицию.
  " @param integer pos Целевая позиция указателя.
function! String.jump(pos) dict
  call self.set('cursor', a:pos)
endfunction

  " Метод производит поиск подстроки в строке. Поиск подстроки начинается c указателя.
  " @param string needle Искомая подстрока.
  " @return integer Позиция искомой подстроки или -1, если подстрока не найдена.
function! String.search(needle) dict
  return stridx(self.get('val'), a:needle, self.get('cursor'))
endfunction

  " Метод смещает указатель на первое вхождение подстроки. Поиск подстроки начинается c указателя.
  " @param string needle Искомая подстрока.
  " @return intger Позиция смещения или -1 - если искомой подстроки нет в строке.
function! String.searchAndJump(needle) dict
  let pos = self.search(a:needle)
  if pos == -1
    return -1
  endif
  call self.jump(pos)
  return pos
endfunction

  " Метод возвращает подстроку от указателя до указанной длины.
  " @param integer length Число отбираемых байт. Если значение > 0, отбор производится справа от указателя, если < 0 - слева, иначе отбирается вся подстрока от указателя и до конца строки.
  " @return String Отобранная подстрока.
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

  " Метод возвращает подстроку от указателя до искомой подстроки. Указатель смещается за искомую подстроку. Искомая подстрока не входит в возвращаемое значение.
  " @param string needle Строка - ограничитель.
  " @return String Подстрока от указателя под строки - ограничителя.
function! String.subTo(needle) dict
  let pos = self.search(a:needle)
  if pos == -1
    return 0
  endif
  let subLength = self.length() - pos
  let sub = self.sub(subLength)
  call self.jump(pos + strlen(a:needle))
  return sub
endfunction
