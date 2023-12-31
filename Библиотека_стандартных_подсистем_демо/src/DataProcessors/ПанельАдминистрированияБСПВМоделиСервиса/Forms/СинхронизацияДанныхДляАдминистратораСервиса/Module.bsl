///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(Неопределено, Истина, Ложь) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для администрирования синхронизации данных между приложениями.'");
	КонецЕсли;
	
	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Настройки видимости при запуске.
	Элементы.ГруппаПрименитьНастройки.Видимость = РежимРаботы.ЭтоВебКлиент;
	Элементы.АвтономнаяРабота.Видимость = АвтономнаяРаботаСлужебный.АвтономнаяРаботаПоддерживается();
	Элементы.ГруппаВременныеКаталогиКластераСерверов.Видимость = РежимРаботы.КлиентСерверный И РежимРаботы.ЭтоАдминистраторСистемы;
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	#Если Не ВебКлиент Тогда
	ОбновитьИнтерфейсПрограммы();
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КакПрименитьНастройкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОбновитьИнтерфейс = Истина;
	ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура КаталогСообщенийОбменаДаннымиДляWindowsПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КаталогСообщенийОбменаДаннымиДляLinuxПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура МониторСинхронизацииДанных(Команда)
	
	ОткрытьФорму("ОбщаяФорма.МониторСинхронизацииДанныхВМоделиСервиса",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиТранспортаОбмена(Команда)
	
	ИмяРегистраТранспорта = "НастройкиТранспортаОбмена";
	Если ВерсияБСП301() Тогда
		ИмяРегистраТранспорта = "НастройкиТранспортаОбменаСообщениями";
	КонецЕсли;
	
	ИмяФормыТранспорта = "РегистрСведений.[ИмяРегистраТранспорта].ФормаСписка";
	ИмяФормыТранспорта = СтрЗаменить(ИмяФормыТранспорта, "[ИмяРегистраТранспорта]", ИмяРегистраТранспорта);
	
	ОткрытьФорму(ИмяФормыТранспорта, , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиТранспортаОбменаОбластейДанных(Команда)
	
	ОткрытьФорму("РегистрСведений.НастройкиТранспортаОбменаОбластейДанных.ФормаСписка",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаДляОбменаДанными(Команда)
	
	ОткрытьФорму("РегистрСведений.ПравилаДляОбменаДанными.ФормаСписка",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСинхронизациюДанныхПриИзменении(Элемент)
	
	Если НаборКонстант.ИспользоватьСинхронизациюДанных = Ложь Тогда
		НаборКонстант.ИспользоватьАвтономнуюРаботуВМоделиСервиса = Ложь;
		НаборКонстант.ИспользоватьСинхронизациюДанныхВМоделиСервисаСЛокальнойПрограммой = Ложь;
		НаборКонстант.ИспользоватьСинхронизациюДанныхВМоделиСервисаСПриложениемВИнтернете = Ложь;
	КонецЕсли;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАвтономнуюРаботуВМоделиСервисаПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСинхронизациюДанныхВМоделиСервисаСПриложениемВИнтернетеПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСинхронизациюДанныхВМоделиСервисаСЛокальнойПрограммойПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, НеобходимоОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если НеобходимоОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	УстановитьДоступность(РеквизитПутьКДанным);
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВерсияБСП301()
	
	Возврат ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СтандартныеПодсистемыСервер.ВерсияБиблиотеки(), "3.0.1.1") >= 0;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если СтрНачинаетсяС(НРег(РеквизитПутьКДанным), НРег("НаборКонстант.")) Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСинхронизациюДанных" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.СинхронизацияДанныхПодчиненнаяГруппировка.Доступность           = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.ГруппаСинхронизацияДанныхМониторСинхронизацииДанных.Доступность = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.ГруппаВременныеКаталогиКластераСерверов.Доступность             = НаборКонстант.ИспользоватьСинхронизациюДанных;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти
