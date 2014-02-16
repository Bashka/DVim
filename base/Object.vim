if exists('Object')
  finish
endif

  " Класс является корневым в иерархии наследования классов. Он реализует основные механизмы формирования классов и их экземпляров, а так же методы доступа к свойствам и методам объектов.
let Object = {'class': 'Object'}

  " Метод создает класс путем наследования и уточнения прототипа (вызываемого класса).
  " Дочерний класс включает ссылку на родителя в виде свойства parent.
  " Дочерний класс включает ссылки на все методы родительского класса.
  " Свойства класса представлены в виде ассоциативного массива следующей структуры: {type: тип, value: значениеПоУмолчанию}
  " В качестве свойств класса нельзя указывать свойства со следующими именами: class, parent, child.
  " @param object properties Словарь свойств создаваемого класса, уточняющий имеющиеся в родителе члены.
  " @param object Результирующий класс.
function! Object.expand(className, properties)
  let obj = {'class': a:className}

  " Наследование свойств.
  " Наследование реализуется путем формирования ссылки на родительский объект в свойстве parent.
  let obj.parent = self
  
  " Наследование методов.
  " Наследование реализуется путем формирования ссылок на методы родительского класса в одноименных методах дочернего.
  for k in keys(self)
    let t = type(self[k])
    if t == 2
      let obj[k] = self[k]
    endif
  endfor

  " Формирование свойств.
  " Реализуется путем формирования структуры свойств и копирования в них значений.
  for k in keys(a:properties)
    if k == 'class' || k == 'parent'
      continue
    endif
    let t = type(a:properties[k])
    if t == 0 || t == 1 || t == 5
      let obj[k] = {'value': a:properties[k], 'type': t}
    elseif t == 3
      let obj[k] = {'value': deepcopy(a:properties[k]), 'type': t}
    elseif t == 4
      if has_key(a:properties[k], 'class')
        let obj[k] = {'value': '', 'type': a:properties[k].class}
      else
        let obj[k] = {'value': a:properties[k], 'type': 4}
      endif
    endif
  endfor

  return obj
endfunction

  " Конструктор класса.
  " Данный метод используется внутри класса для формирования экземпляра класса.
  " Метод копирует значения всех свойств класса в создаваемый объект.
  " Метод добавляет следующие системные свойства: class - ссылка на вызваемый класс, parent - ссылка на объект класса родителя, child - ссылка от объекта класса родителя к объекту потомку.
  " Метод создает ссылки на все методы класса, кроме expand, _construct, new.
  " @return self Объект вызываемого класса.
function! Object._construct()
  let obj = {}
  let obj.class = self
  if has_key(self, 'parent')
    let obj.parent = self.parent._construct()
    let obj.parent.child = obj
  endif
  for property in keys(self)
    let type = type(self[property])
    " Создание ссылок на методы класса.
    if type == 2 && property != 'expand' && property != '_construct' && property != 'new'
      let obj[property] = self[property]
    " Создание свойств класса.
    elseif type == 4 && has_key(self[property], 'type')
      let propertyType = self[property].type
      if propertyType == 0 || propertyType == 1 || propertyType == 5
        let obj[property] = self[property].value
      elseif propertyType == 3
        let obj[property] = deepcopy(self[property].value)
      elseif propertyType == 4
        if has_key(self[property].value, 'class')
          let obj[property] = self[property].value._construct()
        else
          let obj[property] = deepcopy(self[property].value)
        endif
      endif
    endif
  endfor
  return obj
endfunction

  " Конструктор класса с параметрами.
  " Данный метод используется для инстанциирования объектов класса пользователем и может быть переопределен в дочерних класса.
  " @return self Экземпляр вызываемого класса.
function! Object.new()
  return self._construct()
endfunction

  " Метод возвращает значение указанного свойства с учетом иерархии наследования.
  " @param string property Имя свойства.
  " @throws Выбрасывается в случае, если запрашиваемое свойство не определено в объекте.
  " @return mixed Значение свойства.
function Object.get(property) dict
  if has_key(self, a:property)
    return self[a:property]
  elseif has_key(self, 'parent')
    return self.parent.get(a:property)
  else
    echoerr 'Запрашиваемое свойство ['.a:property.'] отсутствует в объекте ['.self.class.class.'].'
    return
  endif
endfunction

  " Метод пытается установить значение свойству объекта с учетом иерархии наследования.
  " @param string property Имя целевого свойства.
  " @param mixed value Устанавливаемое значение.
  " @throws Выбрасывается в случае, если целевое свойство не определено в объекте, или значение имеет неверный тип.
  " @return integer 1 - если значение успешно установлено, 0 - если целевое свойство отсутствует в объекте и его родителях, или значение не соответствует типу свойства.
function Object.set(property, value) dict
  " Запись в свойства вызываемого объекта.
  if has_key(self, a:property)
    let propType = self.class[a:property].type
    let actualType = type(a:value)
    " Типизация классов.
    if actualType == 4 && has_key(a:value, 'class')
      let actualType = a:value.class.class
      let actualObj = a:value.instanceup(propType)
      if has_key(actualObj, 'class') == 0
        echoerr 'Недопустимый тип параметра ['.self.class.class.'::'.a:property.']. Ожидается ['.propType.'] вместо ['.actualType.'].'
      else
        let self[a:property] = actualObj
      endif
    " Типизация примитивных типов.
    elseif actualType == propType
      let self[a:property] = a:value
    else
      echoerr 'Недопустимый тип параметра ['.self.class.class.'::'.a:property.']. Ожидается ['.propType.'] вместо ['.actualType.'].'
    endif
  " Запись в свойства родителя.
  elseif has_key(self, 'parent')
    call self.parent.set(a:property, a:value)
  else
    echoerr 'Запрашиваемое свойство ['.a:property.'] отсутствует в объекте ['.self.class.class.'].'
  endif
endfunction

  " Метод определяет, присутствует ли указанное свойство в объекте с учетом иерархии наследования.
  " @param string property Имя свойства.
  " @return integer 1 - если свойство существует, иначе - 0.
function Object.has(property) dict
  if has_key(self, a:property)
    return 1
  elseif has_key(self, 'parent')
    return self.parent.has(a:property)
  else
    return 0
  endif
endfunction

  " Метод приводит вызываемый объект к указанному классу, если он является его родителем.
  " @param string className Имя целевого класса.
  " @return self|object Объект уровня целевого класса или пустой объект - если объект не принадлежит целевому классу.
function! Object.instanceup(className) dict
  if self.class.class == a:className
    return self
  elseif has_key(self, 'parent')
    return self.parent.instanceup(a:className)
  else
    return {}
  endif
endfunction

  " Метод приводит вызываемый объект к указанному классу, если он является его потомком.
  " @param string className Имя целевого класса.
  " @return self|object Объект уровня целевого класса или пустой объект - если объект не принадлежит целевому классу.
function! Object.instancedown(className) dict
  if self.class.class == a:className
    return self
  elseif has_key(self, 'child')
    return self.child.instancedown(a:className)
  else
    return {}
  endif
endfunction

  " Метод определяет, является ли объект экземпляром указанного класса, или его потомком.
  " @param string className Имя целевого класса.
  " @return integer 1 - если вызыавемый объект является экземпляром целевого класса или его потомком, иначе - 0.
function! Object.instanceof(className) dict
  let result = self.instanceup(a:className)
  if has_key(result, 'class')
    return 1
  else
    return 0
  endif
endfunction

" Example
   " Создание класса A путем расширения класса Object
  "let s:A = Object.expand('A', {'x': 1})
   " Определение конструктора класса A с параметрами.
  "function! s:A.new(x)
  "  let obj = self._construct()
  "  call obj.set('x', a:x)
  "  return obj
  "endfunction

   " Создание класса B путем расширения класса A
  "let s:B = s:A.expand('B', {'y': Object})
   " Переопределение конструктора класса B с параметрами.
  "function! s:B.new(x, y)
  "  let obj = self._construct()
  "  call obj.set('x', a:x)
  "  call obj.set('y', a:y)
  "  return obj
  "endfunction

   " Создание объектов
  "let s:a = s:A.new(2)
  "let s:b = s:B.new(3, s:a)
   " Приведение типа объекта
  "echo s:b.get('y').instancedown('A').get('x')
