///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
	// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	ЗащитаПерсональныхДанных.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, Элементы.Список);
	// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	ЗащитаПерсональныхДанныхКлиент.ОбработкаОповещенияФормыСписка(Элементы.Список, ИмяСобытия);
	// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)

	// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	ЗащитаПерсональныхДанных.ПриПолученииДанныхНаСервере(Настройки, Строки);
	// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПоискИУдалениеДублей

&НаКлиенте
Процедура ОбъединитьВыделенные(Команда)
	
	ПоискИУдалениеДублейКлиент.ОбъединитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьМестаИспользования(Команда)
	
	ПоискИУдалениеДублейКлиент.ПоказатьМестаИспользования(Элементы.Список);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПоискИУдалениеДублей

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.ЗащитаПерсональныхДанных

&НаКлиенте
Процедура Подключаемый_ПоказыватьСоСкрытымиПДн(Команда)
	ЗащитаПерсональныхДанныхКлиент.ПоказыватьСоСкрытымиПДн(ЭтотОбъект, Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных

#КонецОбласти

