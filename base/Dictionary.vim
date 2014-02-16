if exists('Dictionary')
  finish
endif

Use D/base/Object

  " Класс представляет множество типа Словарь.
let Dictionary = Object.expand('Dictionary', {'_val': {}, '_type': ''})

  " @param string|Object type Тип словаря. В качестве элементов словаря могут быть заданы только указанные типы данных. Доступными значениями являются: integer, float, string, array, object, класс Object и его подклассы.
function! Dictionary.new(type)
  let argType = type(a:type)
  let obj = self._construct()
  if argType == 1
    if a:type == 'integer'
      call obj.set('_type', '0')
    elseif a:type == 'float'
      call obj.set('_type', '5')
    elseif a:type == 'string'
      call obj.set('_type', '1')
    elseif a:type == 'array'
      call obj.set('_type', '3')
    elseif a:type == 'object'
      call obj.set('_type', '4')
    else
      echoerr 'Недопустимое значение параметра [Dictionary::new]. Ожидается [integer|float|string|array|object] вместо ['.string(a:type).']'
      return
    endif
  elseif argType == 4
    call obj.set('_type', a:type.class)
  else
    echoerr 'Недопустимый тип параметра [Dictionary::new]. Ожидается [string|Object] вместо ['.argType.']'
    return
  endif
  return obj
endfunction

  " Метод добавляет элемент в словарь.
  " @param string key Ключ элемента.
  " @param mixed val Добавляемый элемент. 
  " @throws Выбрасывается в случае, если добавляемое значение не отвечает типу словаря.
function! Dictionary.in(key, val) dict
  let currentVal = self.get('_val')
  let valType = string(type(a:val))
  let selfType = self.get('_type')
  if valType != '4'
    if valType != selfType
      echoerr 'Недопустимый тип элемента ['.valType.'] для массива ['.selfType.']'
      return 
    endif
  else
    if selfType != '4'
      if has_key(a:val, 'class') == 0
        echoerr 'Недопустимый тип элемента [4] для массива ['.selfType.']'
        return
      endif
      let obj = a:val.instanceup(selfType)
      if has_key(obj, 'class') == 0
        echoerr 'Недопустимый тип элемента ['.a:val.class.class.'] для массива ['.selfType.']'
        return
      endif
      let currentVal[a:key] = obj
      call self.set('_val', currentVal)
      return
    endif
  endif
  let currentVal[a:key] = a:val
  call self.set('_val', currentVal)
endfunction

  " Метод удялет элемент из словаря.
  " @param string key Ключ элемента.
  " @throws Выбрасывается, если целевого ключа нет в словаре.
function! Dictionary.remove(key) dict
  let currentVal = self.get('_val')
  if has_key(currentVal, a:key) == 0
    echoerr 'Ключ ['.a:key.'] отсутствует в словаре.'
    return
  endif
  call remove(currentVal, a:key)
  call self.set('_val', currentVal)
endfunction

  " Метод возвращает элемент из словаря.
  " @param string key Ключ целевого элемента.
  " @throws Выбрасывается, если целевого ключа нет в словаре.
  " @return mixed Элемент.
function! Dictionary.out(key) dict
  let currentVal = self.get('_val')
  if has_key(currentVal, a:key) == 0
    echoerr 'Ключ ['.a:key.'] отсутствует в словаре.'
    return
  endif
  return currentVal[a:key]
endfunction

  " Метод возвращает число элементов в словаре.
  " @return integer Число элементов в словаре.
function! Dictionary.length() dict
  return len(self.get('_val'))
endfunction
