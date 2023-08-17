///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// _Демо начало примера

#Область ОбработчикиСобытий

Процедура ПриНачалеРаботыСистемы()
	
	// Пропустить инициализацию, если обновление информационной базы еще не завершено.
	Если ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьИнформацию(НСтр("ru = 'Демо: Начат сеанс внешнего соединения'"));
	
КонецПроцедуры

Процедура ПриЗавершенииРаботыСистемы()
	
	// Пропустить обработку, если обновление информационной базы еще не завершено.
	Если ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьИнформацию(НСтр("ru = 'Демо: Завершен сеанс внешнего соединения'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьИнформацию(Знач Текст)
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Внешнее соединение'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,,, Текст);
	
КонецПроцедуры

#КонецОбласти

// _Демо конец примера
