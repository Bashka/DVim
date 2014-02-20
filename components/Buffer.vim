if exists('Buffer')
  finish
endif

Use D/base/Object

  ""
  " Класс представляет буфер.
  ""
let Buffer = Object.expand('Buffer', {'number': 0, 'file': ''})

  ""
  " Конструктор, создающий объект по номеру буфера. Целевой буфер должен быть загружен в память.
  " @param integer number Номер целевого буфера.
  " @throws Выбрасывается в случае, если буфер с указанным номером еще не загружен.
  " @return Buffer Буфер с указанным номером. 
  ""
function! Buffer.num(number)
  let number = bufnr(a:number) 
  if number == -1
    throw 'Буфера с указанным номером ['.number.'] не существует.'
  endif
  let file = bufname(number)

  let obj = self._construct()
  call obj.set('number', number)
  call obj.set('file', file)
  return obj
endfunction

  ""
  " Конструктор, создающий объект для текущего буфера.
  " @return Buffer Текущий буфер. 
  ""
function! Buffer.current()
  return self.num(bufnr('%'))
endfunction

  ""
  " Конструктор, создающий объект для буфера по имени файла. Если буфер еще не загружен, он автоматически загружается.
  " @param string file Имя загружаемого файла буфера.
  " @return Buffer Буфер указанного файла.
  ""
function! Buffer.name(file)
  return self.num(bufnr(a:file, 1))
endfunction

  ""
  " Метод возвращает массив номеров всех доступных буферов.
  " @return integer[] Массив номеров буферов. 
  ""
function! Buffer.ls()
  let result = []
  for num in range(1, bufnr('$'))
    call insert(result, num)
  endfor
  return result
endfunction

  ""
  " Метод удаляет буфер.
  ""
function! Buffer.delete() dict
  exe 'bd '.self.get('number')
endfunction

  ""
  " Метод делает вызываемый буфер текущим.
  ""
function! Buffer.go() dict
  exe 'b '.self.get('number')
endfunction

  ""
  " Метод возвращает поток текущего буфера.
  " @return Content Поток текущего буфера.
  ""
function! Buffer.getContent() dict
  Use D/components/Content
  return g:Content.buff(self)
endfunction
