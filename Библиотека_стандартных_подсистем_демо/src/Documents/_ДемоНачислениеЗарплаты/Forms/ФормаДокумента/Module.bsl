///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

// СтандартныеПодсистемы.ОценкаПроизводительности
&НаКлиенте
Перем ИдентификаторЗамераПроведение;
// Конец СтандартныеПодсистемы.ОценкаПроизводительности

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнициализироватьВводПериодаРегистрации();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.Дата.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.Номер.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.ЗарплатаНомерСтроки.Видимость = Ложь;
		Элементы.Комментарий.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчета.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
    
    // СтандартныеПодсистемы.ОценкаПроизводительности
	// Пример выполнения замера с автоматической фиксацией ошибки.
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
        
        ИдентификаторЗамераПроведение = ОценкаПроизводительностиКлиент.ЗамерВремени("_ДемоНачислениеЗарплатыПроведение", Истина);
						
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
    
    // СтандартныеПодсистемы.ОценкаПроизводительности
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
        
        ОценкаПроизводительностиКлиент.УстановитьПризнакОшибкиЗамера(ИдентификаторЗамераПроведение, Ложь);
			
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
    
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодРегистрацииМесяцПриИзменении(Элемент)
	
	ОбновитьПериодРегистрации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииМесяцОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииГодПриИзменении(Элемент)
	
	ОбновитьПериодРегистрации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииГодОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьПериодРегистрации()
	
	Объект.ПериодРегистрации = Дата(ПериодРегистрацииГод, ПериодРегистрацииМесяц, 1);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьВводПериодаРегистрации()
	
	ПериодРегистрацииМесяц = Месяц(Объект.ПериодРегистрации);
	ПериодРегистрацииГод   = Год(Объект.ПериодРегистрации);
	
	СписокВыбора = Элементы.ПериодРегистрацииМесяц.СписокВыбора;
	Для Месяц = 1 По 12 Цикл
		СписокВыбора.Добавить(Месяц, Формат(Дата(1917, Месяц, 1), "ДФ=ММММ"));
	КонецЦикла;
	
	// Так как поля периода не связаны с данными напрямую, то управляем их доступностью принудительно.
	Элементы.ПериодРегистрацииМесяц.ТолькоПросмотр = ТолькоПросмотр;
	Элементы.ПериодРегистрацииГод.ТолькоПросмотр   = ТолькоПросмотр;
		
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.КонтрольВеденияУчета

&НаКлиенте
Процедура Подключаемый_ОткрытьОтчетПоПроблемам(ЭлементИлиКоманда, НавигационнаяСсылка, СтандартнаяОбработка)
	КонтрольВеденияУчетаКлиент.ОткрытьОтчетПоПроблемамОбъекта(ЭтотОбъект, Объект.Ссылка, СтандартнаяОбработка);
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтрольВеденияУчета

#КонецОбласти
