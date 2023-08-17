///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет обработку тела сообщения из канала в соответствии с алгоритмом текущего канала сообщений.
//
// Параметры:
//	КаналСообщений - Строка - идентификатор канала сообщений, из которого получено сообщение.
//	ТелоСообщения - Произвольный - тело сообщения, полученное из канала, которое подлежит обработке.
//	Отправитель - ПланОбменаСсылка.ОбменСообщениями - Конечная точка, которая является отправителем сообщения.
//
Процедура ОбработатьСообщение(КаналСообщений, ТелоСообщения, Отправитель) Экспорт
	
	Если КаналСообщений = "УправлениеПроектами\СозданиеПроекта" Тогда
		
		СоздатьПроект(ТелоСообщения.НазваниеПроекта);
		
	ИначеЕсли КаналСообщений = "УправлениеПроектами\СписокПроектов" Тогда
		
		ЗапроситьСписокПроектов(Отправитель);
		
	ИначеЕсли КаналСообщений = "УправлениеПроектами\Ответ\СписокПроектов" Тогда
		
		АктуализироватьСписокПроектов(ТелоСообщения.СписокПроектов);
		
	ИначеЕсли КаналСообщений = "УправлениеПроектами\Тест" Тогда
		
		Тест(Отправитель);
		
	ИначеЕсли КаналСообщений = "УправлениеПроектами\Ответ\Тест" Тогда
		
		ТестОтвет();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьПроект(Знач НазваниеПроекта)
	
	НовыйПроект = Справочники._ДемоПроекты.СоздатьЭлемент();
	НовыйПроект.Наименование = НазваниеПроекта;
	НовыйПроект.Записать();
	
КонецПроцедуры

Процедура ЗапроситьСписокПроектов(Отправитель)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Проекты.Код КАК Код,
		|	Проекты.Наименование КАК Наименование
		|ИЗ
		|	Справочник._ДемоПроекты КАК Проекты");
		
	СписокПроектов = Запрос.Выполнить().Выгрузить();
	
	НачатьТранзакцию();
	Попытка
		
		ТелоСообщения = Новый Структура("СписокПроектов", СписокПроектов);
		ОбменСообщениями.ОтправитьСообщение("УправлениеПроектами\Ответ\СписокПроектов", ТелоСообщения, Отправитель);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура Тест(Отправитель)
	
	КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Демо.ОбменСообщениями'", КодОсновногоЯзыка),
		УровеньЖурналаРегистрации.Ошибка,,, НСтр("ru = 'Тест'", КодОсновногоЯзыка));
	
	НачатьТранзакцию();
	Попытка
		
		ОбменСообщениями.ОтправитьСообщениеСейчас("УправлениеПроектами\Ответ\Тест",, Отправитель);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	ОбменСообщениями.ДоставитьСообщения();
	
КонецПроцедуры

Процедура ТестОтвет()
	
	КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Демо.ОбменСообщениями'", КодОсновногоЯзыка),
		УровеньЖурналаРегистрации.Ошибка,,, НСтр("ru = 'Тест {Ответ}'", КодОсновногоЯзыка));
	
КонецПроцедуры

Процедура АктуализироватьСписокПроектов(СписокПроектов)
	
	ТекстСообщения = НСтр("ru = 'Список проектов:'");
	ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	Для Каждого Проект Из СписокПроектов Цикл
		ТекстСообщения = Проект.Код + " " + Проект.Наименование;
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
