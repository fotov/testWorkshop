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
	
	ПроверитьВерсиюИРежимСовместимостиПлатформы();
	
	РежимРаботыНаКлиенте = (РежимРаботыНаКлиентеИлиНаСервере = 0);
	
	Элементы.ИмяФайлаВыгрузки.Доступность = Не РежимРаботыНаКлиенте;
	Элементы.ИмяФайлаЗагрузки.Доступность = Не РежимРаботыНаКлиенте;
	
	ОбъектНаСервере = РеквизитФормыВЗначение("Объект");
	ОбъектНаСервере.Инициализация();
	ЗначениеВРеквизитФормы(ОбъектНаСервере.ДеревоМетаданных, "Объект.ДеревоМетаданных");
	
	Файл = Новый Файл(ИмяФайлаВыгрузки);
	Объект.ИспользоватьФорматFastInfoSet = (Файл.Расширение = ".fi");
	
	РежимВыгрузки = (Элементы.ГруппаРежим.ТекущаяСтраница = Элементы.ГруппаРежим.ПодчиненныеЭлементы.ГруппаВыгрузка);
	ВариантИспользованияКонсолиЗапросов = "Встроенная";
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	РежимРаботыНаКлиенте = (РежимРаботыНаКлиентеИлиНаСервере = 0);
	
	Элементы.ИмяФайлаВыгрузки.Доступность = Не РежимРаботыНаКлиенте;
	Элементы.ИмяФайлаЗагрузки.Доступность = Не РежимРаботыНаКлиенте;
	
	Файл = Новый Файл(ИмяФайлаВыгрузки);
	Объект.ИспользоватьФорматFastInfoSet = (Файл.Расширение = ".fi");
	
	РежимВыгрузки = (Элементы.ГруппаРежим.ТекущаяСтраница = Элементы.ГруппаРежим.ПодчиненныеЭлементы.ГруппаВыгрузка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ОбработкаВыбораНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяФайлаВыгрузкиПриИзменении(Элемент)
	
	Файл = Новый Файл(ИмяФайлаВыгрузки);
	Объект.ИспользоватьФорматFastInfoSet = (Файл.Расширение = ".fi");
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаВыгрузкиОткрытие(Элемент, СтандартнаяОбработка)
	
	ОткрытьВПриложении(Элемент, "ИмяФайлаВыгрузки", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработатьНачалоВыбораФайла(СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьФорматFastInfoSetПриИзменении(Элемент)
	
	Если Объект.ИспользоватьФорматFastInfoSet Тогда
		ИмяФайлаВыгрузки = СтрЗаменить(ИмяФайлаВыгрузки, ".xml", ".fi");
	Иначе
		ИмяФайлаВыгрузки = СтрЗаменить(ИмяФайлаВыгрузки, ".fi", ".xml");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаРежимПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	РежимВыгрузки = (Элементы.ГруппаРежим.ТекущаяСтраница = Элементы.ГруппаРежим.ПодчиненныеЭлементы.ГруппаВыгрузка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеОбъектыДляВыгрузкиПриИзменении(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Объект) Тогда
		
		Элемент.ТекущиеДанные.ИмяОбъектаДляЗапроса = ИмяОбъектаПоТипуДляЗапроса(Элемент.ТекущиеДанные.Объект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаЗагрузкиОткрытие(Элемент, СтандартнаяОбработка)
	
	ОткрытьВПриложении(Элемент, "ИмяФайлаЗагрузки", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаЗагрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработатьНачалоВыбораФайла(СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоМетаданных

&НаКлиенте
Процедура ДеревоМетаданныхВыгружатьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоМетаданных.ТекущиеДанные;
	
	Если ТекущиеДанные.Выгружать = 2 Тогда
		ТекущиеДанные.Выгружать = 0;
	КонецЕсли;
	
	УстановитьПометкиПодчиненных(ТекущиеДанные, "Выгружать");
	УстановитьПометкиРодителей(ТекущиеДанные, "Выгружать");
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоМетаданныхВыгружатьПриНеобходимостиПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоМетаданных.ТекущиеДанные;
	
	Если ТекущиеДанные.ВыгружатьПриНеобходимости = 2 Тогда
		ТекущиеДанные.ВыгружатьПриНеобходимости = 0;
	КонецЕсли;
	
	УстановитьПометкиПодчиненных(ТекущиеДанные, "ВыгружатьПриНеобходимости");
	УстановитьПометкиРодителей(ТекущиеДанные, "ВыгружатьПриНеобходимости");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДополнительныеОбъектыДляВыгрузки

&НаКлиенте
Процедура ДополнительныеОбъектыДляВыгрузкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Элемент.ТекущийЭлемент.ОграничениеТипа = ТипОбъектовДляВыгрузки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьИзЗапроса(Команда)
	
	ОткрытьФорму(ИмяФормыКонсолиЗапросов(),ПараметрыКонсолиЗапросов(),ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьДополнительныеОбъектыВыгрузки(Команда)
	
	Объект.ДополнительныеОбъектыДляВыгрузки.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьДанные(Команда)
	
	Объект.ДатаНачала = ПериодВыгрузки.ДатаНачала;
	Объект.ДатаОкончания = ПериодВыгрузки.ДатаОкончания;
	
	ОчиститьСообщения();
	
	Если Не РежимРаботыНаКлиенте Тогда
		
		Если ПустаяСтрока(ИмяФайлаВыгрузки) Тогда
			
			ТекстСообщения = НСтр("ru = 'Поле ""Имя файла"" не заполнено'");
			СообщитьПользователю(ТекстСообщения, "ИмяФайлаВыгрузки");
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	АдресФайлаВоВременномХранилище = "";
	ВыгрузитьДанныеНаСервере(АдресФайлаВоВременномХранилище);
	
	Если РежимРаботыНаКлиенте И Не ПустаяСтрока(АдресФайлаВоВременномХранилище) Тогда
		
		ИмяФайла = ?(Объект.ИспользоватьФорматFastInfoSet, НСтр("ru = 'Файл выгрузки.fi'"), НСтр("ru = 'Файл выгрузки.xml'"));
		ПолучитьФайл(АдресФайлаВоВременномХранилище, ИмяФайла);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
	
	ОчиститьСообщения();
	АдресФайлаВоВременномХранилище = "";
	
	Если РежимРаботыНаКлиенте Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьДанныеЗавершение", ЭтотОбъект);
		НачатьПомещениеФайла(ОписаниеОповещения, АдресФайлаВоВременномХранилище, НСтр("ru = 'Файл выгрузки'"), , УникальныйИдентификатор);
		
	Иначе
		
		Если ПустаяСтрока(ИмяФайлаЗагрузки) Тогда
			
			ТекстСообщения = НСтр("ru = 'Поле ""Имя файла"" не заполнено'");
			СообщитьПользователю(ТекстСообщения, "ИмяФайлаЗагрузки");
			Возврат;
			
		КонецЕсли;
		
		Файл = Новый Файл(ИмяФайлаЗагрузки);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("АдресФайлаВоВременномХранилище", АдресФайлаВоВременномХранилище);
		ДополнительныеПараметры.Вставить("РасширениеФайла" ,               Файл.Расширение);
		
		Оповещение = Новый ОписаниеОповещения("ПроверкаСуществованияФайлаДанныхЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		Файл.НачатьПроверкуСуществования(Оповещение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиКонсолиЗапросов(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВариантИспользованияКонсолиЗапросов", ВариантИспользованияКонсолиЗапросов);
	ПараметрыФормы.Вставить("ПутьКВнешнейКонсолиЗапросов", ПутьКВнешнейКонсолиЗапросов);
	
	ОповещениеОЗакрытииНастроек = Новый ОписаниеОповещения("ЗакрытаФормаНастройкиКонсолиЗапросов", ЭтотОбъект);
	ОткрытьФорму(ИмяФормыНастроекКонсолиЗапросов(), ПараметрыФормы, ЭтотОбъект,,,,
		ОповещениеОЗакрытииНастроек,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьВыгружаемыеПоСсылке(Команда)
	
	СохранитьОтображениеДерева(Объект.ДеревоМетаданных.ПолучитьЭлементы());
	ПересчитатьВыгружаемыеПоСсылкеНаСервере();
	ВосстановитьОтображениеДерева(Объект.ДеревоМетаданных.ПолучитьЭлементы());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверкаСуществованияФайлаДанныхЗавершение(Существует, ДополнительныеПараметры) Экспорт
	
	Если Не Существует Тогда
		СообщитьПользователю(НСтр("ru = 'Файл не существует'"), "ИмяФайлаЗагрузки");
		Возврат;
	КонецЕсли;
	
	ЗагрузитьДанныеНаСервере(ДополнительныеПараметры.АдресФайлаВоВременномХранилище,
		ДополнительныеПараметры.РасширениеФайла);
	
КонецПроцедуры

&НаСервере
Функция ИмяФормыКонсолиЗапросов()
	
	Если ВариантИспользованияКонсолиЗапросов = "Встроенная" Тогда
		
		Обработка = РеквизитФормыВЗначение("Объект");
		ИдентификаторФормы = ".Форма.ВыборИзЗапроса";
		
	Иначе //ВариантИспользованияКонсолиЗапросов = Внешняя
		
		Обработка = ВнешниеОбработки.Создать(ПутьКВнешнейКонсолиЗапросов);
		ИдентификаторФормы = ".ФормаОбъекта";
		
	КонецЕсли;
	
	Возврат Обработка.Метаданные().ПолноеИмя() + ИдентификаторФормы;
	
КонецФункции

&НаСервере
Функция ИмяФормыНастроекКонсолиЗапросов()
	
	Обработка = РеквизитФормыВЗначение("Объект");
	ИмяФормыНастроек = Обработка.Метаданные().ПолноеИмя() + ".Форма.НастройкиКонсолиЗапросов";
	
	Возврат ИмяФормыНастроек;
	
КонецФункции

&НаКлиенте
Функция ПараметрыКонсолиЗапросов()
	
	ПараметрыФормы = Новый Структура;
	
	Если ВариантИспользованияКонсолиЗапросов = "Внешняя" Тогда
		
		ПараметрыФормы.Вставить("ВариантИспользованияКонсолиЗапросов", ВариантИспользованияКонсолиЗапросов);
		ПараметрыФормы.Вставить("ПутьКВнешнейКонсолиЗапросов", ПутьКВнешнейКонсолиЗапросов);
		
	Иначе
		
		ПараметрыФормы.Вставить("Заголовок", НСтр("ru='Выбор данных для выгрузки'"));
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
		
	КонецЕсли;
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаКлиенте
Процедура ЗакрытаФормаНастройкиКонсолиЗапросов(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(РезультатЗакрытия) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РезультатЗакрытия);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВПриложении(Элемент, ПутьКДанным, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ИмяФайла", Элемент.ТекстРедактирования);
	ДополнительныеПараметры.Вставить("ОписаниеОповещения", Новый ОписаниеОповещения);
	ДополнительныеПараметры.Вставить("ПутьКДанным", ПутьКДанным);
	
	Файл = Новый Файл();
	Файл.НачатьИнициализацию(Новый ОписаниеОповещения("ПроверитьСуществованиеФайла", ЭтотОбъект, ДополнительныеПараметры), Элемент.ТекстРедактирования);
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
&НаКлиенте
Процедура ПроверитьСуществованиеФайла(Файл, ДополнительныеПараметры) Экспорт
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеОпределенияСуществованияФайла", ЭтотОбъект, ДополнительныеПараметры);
	Файл.НачатьПроверкуСуществования(ОписаниеОповещения);
КонецПроцедуры

// Продолжение процедуры (см. выше).
&НаКлиенте
Процедура ПослеОпределенияСуществованияФайла(Существует, ДополнительныеПараметры) Экспорт
	
	Если Существует Тогда
		НачатьЗапускПриложения(ДополнительныеПараметры.ОписаниеОповещения, ДополнительныеПараметры.ИмяФайла);
	Иначе
		ТекстПредупреждения = НСтр("ru = 'Файл ""%1"" не существует или к нему нет доступа.'");
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%1", ДополнительныеПараметры.ПутьКДанным);
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРежимаРаботы()
	
	РежимРаботыНаКлиенте = (РежимРаботыНаКлиентеИлиНаСервере = 0);
	
	Элементы.ИмяФайлаВыгрузки.Доступность = Не РежимРаботыНаКлиенте;
	Элементы.ИмяФайлаЗагрузки.Доступность = Не РежимРаботыНаКлиенте;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СообщитьПользователю(Текст, ПутьКДанным = "")
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Текст;
	Сообщение.ПутьКДанным = ПутьКДанным;
	Сообщение.Сообщить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНачалоВыбораФайла(СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РежимДиалога = ?(РежимВыгрузки, РежимДиалогаВыбораФайла.Сохранение, РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалога);
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла = Не РежимВыгрузки;
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;
	ДиалогВыбораФайла.Заголовок = НСтр("ru = 'Задайте имя файла выгрузки'");
	ДиалогВыбораФайла.ПолноеИмяФайла = ?(РежимВыгрузки, ИмяФайлаВыгрузки, ИмяФайлаЗагрузки);
	
	ДиалогВыбораФайла.Фильтр = "Формат выгрузки(*.xml)|*.xml|FastInfoSet (*.fi)|*.fi|Все файлы (*.*)|*.*";
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяСвойства", ?(РежимВыгрузки, "ИмяФайлаВыгрузки", "ИмяФайлаЗагрузки"));
	
	Оповещение = Новый ОписаниеОповещения("НачалоВыбораФайлаОбработкаВыбора", ЭтотОбъект, ДополнительныеПараметры);
	ДиалогВыбораФайла.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораФайлаОбработкаВыбора(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект[ДополнительныеПараметры.ИмяСвойства] = ВыбранныеФайлы[0];
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкиПодчиненных(ТекСтрока, ИмяФлажка)
	
	Подчиненные = ТекСтрока.ПолучитьЭлементы();
	
	Если Подчиненные.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из Подчиненные Цикл
		
		Строка[ИмяФлажка] = ТекСтрока[ИмяФлажка];
		
		УстановитьПометкиПодчиненных(Строка, ИмяФлажка);
		
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкиРодителей(ТекСтрока, ИмяФлажка)
	
	Родитель = ТекСтрока.ПолучитьРодителя();
	Если Родитель = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ТекСостояние = Родитель[ИмяФлажка];
	
	НайденыВключенные  = Ложь;
	НайденыВыключенные = Ложь;
	
	Для Каждого Строка Из Родитель.ПолучитьЭлементы() Цикл
		Если Строка[ИмяФлажка] = 0 Тогда
			НайденыВыключенные = Истина;
		ИначеЕсли Строка[ИмяФлажка] = 1
			ИЛИ Строка[ИмяФлажка] = 2 Тогда
			НайденыВключенные  = Истина;
		КонецЕсли; 
		Если НайденыВключенные И НайденыВыключенные Тогда
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	
	Если НайденыВключенные И НайденыВыключенные Тогда
		Включить = 2;
	ИначеЕсли НайденыВключенные И (Не НайденыВыключенные) Тогда
		Включить = 1;
	ИначеЕсли (Не НайденыВключенные) И НайденыВыключенные Тогда
		Включить = 0;
	ИначеЕсли (Не НайденыВключенные) И (Не НайденыВыключенные) Тогда
		Включить = 2;
	КонецЕсли;
	
	Если Включить = ТекСостояние Тогда
		Возврат;
	Иначе
		Родитель[ИмяФлажка] = Включить;
		УстановитьПометкиРодителей(Родитель, ИмяФлажка);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьДанныеНаСервере(АдресФайлаВоВременномХранилище)
	
	Если РежимРаботыНаКлиенте Тогда
		
		Расширение = ?(Объект.ИспользоватьФорматFastInfoSet, ".fi", ".xml");
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Расширение);
		
	Иначе
		
		ИмяВременногоФайла = ИмяФайлаВыгрузки;
		
	КонецЕсли;
	
	ОбъектНаСервере = РеквизитФормыВЗначение("Объект");
	ЗаполнитьДеревоМетаданныхНаСервере(ОбъектНаСервере);
	
	ОбъектНаСервере.ВыполнитьВыгрузку(ИмяВременногоФайла);
	
	Если РежимРаботыНаКлиенте Тогда
		
		Файл = Новый Файл(ИмяВременногоФайла);
		
		Если Файл.Существует() Тогда
			
			ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВременногоФайла);
			АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
			УдалитьФайлы(ИмяВременногоФайла);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроставитьПометкиВыгружаемыхДанных(СтрокиИсходногоДерева, СтрокиЗаменяемогоДерева)
	
	КолонкаВыгружать = СтрокиЗаменяемогоДерева.ВыгрузитьКолонку("Выгружать");
	СтрокиИсходногоДерева.ЗагрузитьКолонку(КолонкаВыгружать, "Выгружать");
	
	КолонкаВыгружатьПриНеобходимости = СтрокиЗаменяемогоДерева.ВыгрузитьКолонку("ВыгружатьПриНеобходимости");
	СтрокиИсходногоДерева.ЗагрузитьКолонку(КолонкаВыгружатьПриНеобходимости, "ВыгружатьПриНеобходимости");
	
	КолонкаРазвернут = СтрокиЗаменяемогоДерева.ВыгрузитьКолонку("Развернут");
	СтрокиИсходногоДерева.ЗагрузитьКолонку(КолонкаРазвернут, "Развернут");
	
	Для Каждого СтрокаИсходногоДерева Из СтрокиИсходногоДерева Цикл
		
		ИндексСтроки = СтрокиИсходногоДерева.Индекс(СтрокаИсходногоДерева);
		СтрокаИзменяемогоДерева = СтрокиЗаменяемогоДерева.Получить(ИндексСтроки);
		
		ПроставитьПометкиВыгружаемыхДанных(СтрокаИсходногоДерева.Строки, СтрокаИзменяемогоДерева.Строки);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		
		Файл = Новый Файл(ВыбранноеИмяФайла);
		ЗагрузитьДанныеНаСервере(Адрес, Файл.Расширение);
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеНаСервере(АдресФайлаВоВременномХранилище, Расширение)
	
	Если РежимРаботыНаКлиенте Тогда
		
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайлаВоВременномХранилище);
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Расширение);
		ДвоичныеДанные.Записать(ИмяВременногоФайла);
		
	Иначе
		
		ИмяВременногоФайла = ИмяФайлаЗагрузки;
		
	КонецЕсли;
	
	РеквизитФормыВЗначение("Объект").ВыполнитьЗагрузку(ИмяВременногоФайла);
	
	Если РежимРаботыНаКлиенте Тогда
		
		Файл = Новый Файл(ИмяВременногоФайла);
		
		Если Файл.Существует() Тогда
			
			УдалитьФайлы(ИмяВременногоФайла);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьВыгружаемыеПоСсылкеНаСервере()
	
	ОбъектНаСервере = РеквизитФормыВЗначение("Объект");
	ЗаполнитьДеревоМетаданныхНаСервере(ОбъектНаСервере);
	ОбъектНаСервере.СоставВыгрузки(Истина);
	ЗначениеВРеквизитФормы(ОбъектНаСервере.ДеревоМетаданных, "Объект.ДеревоМетаданных");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоМетаданныхНаСервере(ОбъектНаСервере)
	
	ДеревоМетаданных = РеквизитФормыВЗначение("Объект.ДеревоМетаданных");
	
	ОбъектНаСервере.Инициализация();
	
	ПроставитьПометкиВыгружаемыхДанных(ОбъектНаСервере.ДеревоМетаданных.Строки, ДеревоМетаданных.Строки);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьОтображениеДерева(СтрокиДерева)
	
	Для Каждого Строка Из СтрокиДерева Цикл
		
		ИдентификаторСтроки=Строка.ПолучитьИдентификатор();
		Строка.Развернут = Элементы.ДеревоМетаданных.Развернут(ИдентификаторСтроки);
		
		СохранитьОтображениеДерева(Строка.ПолучитьЭлементы());
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьОтображениеДерева(СтрокиДерева)
	
	Для Каждого Строка Из СтрокиДерева Цикл
		
		ИдентификаторСтроки=Строка.ПолучитьИдентификатор();
		Если Строка.Развернут Тогда
			Элементы.ДеревоМетаданных.Развернуть(ИдентификаторСтроки);
		КонецЕсли;
		
		ВосстановитьОтображениеДерева(Строка.ПолучитьЭлементы());
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяОбъектаПоТипуДляЗапроса(Ссылка)
	
	МетаданныеОбъекта = Ссылка.Метаданные();
	ИмяМетаданных = МетаданныеОбъекта.Имя;
	
	ИмяДляЗапроса = "";
	
	Если Метаданные.Справочники.Содержит(МетаданныеОбъекта) Тогда
		ИмяДляЗапроса = "Справочник";
	ИначеЕсли Метаданные.Документы.Содержит(МетаданныеОбъекта) Тогда
		ИмяДляЗапроса = "Документ";
	ИначеЕсли Метаданные.ПланыВидовХарактеристик.Содержит(МетаданныеОбъекта) Тогда
		ИмяДляЗапроса = "ПланВидовХарактеристик";
	ИначеЕсли Метаданные.ПланыСчетов.Содержит(МетаданныеОбъекта) Тогда
		ИмяДляЗапроса = "ПланСчетов";
	ИначеЕсли Метаданные.ПланыВидовРасчета.Содержит(МетаданныеОбъекта) Тогда
		ИмяДляЗапроса = "ПланВидовРасчета";
	ИначеЕсли Метаданные.ПланыОбмена.Содержит(МетаданныеОбъекта) Тогда
		ИмяДляЗапроса = "ПланОбмена";
	ИначеЕсли Метаданные.БизнесПроцессы.Содержит(МетаданныеОбъекта) Тогда
		ИмяДляЗапроса = "БизнесПроцесс";
	ИначеЕсли Метаданные.Задачи.Содержит(МетаданныеОбъекта) Тогда
		ИмяДляЗапроса = "Задача";
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяДляЗапроса) Тогда
		Возврат "";
	Иначе
		Возврат ИмяДляЗапроса + "." + ИмяМетаданных;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОбработкаВыбораНаСервере(ВыбранныеЗначения)
	
	Если ТипЗнч(ВыбранныеЗначения) = Тип("Структура") Тогда
		
		РезультатЗапроса = ПолучитьИзВременногоХранилища(ВыбранныеЗначения.ДанныеВыбора);
		
		Если ТипЗнч(РезультатЗапроса)=Тип("Массив") Тогда
			
			РезультатЗапроса = РезультатЗапроса[РезультатЗапроса.ВГраница()];
			
			Если РезультатЗапроса.Колонки.Найти("Ссылка") <> Неопределено Тогда
				ВыбранныеСсылки = РезультатЗапроса.Выгрузить();
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		ВыбранныеСсылки = ВыбранныеЗначения;
		
	КонецЕсли;
	
	Для Каждого Значение Из ВыбранныеСсылки Цикл
		
		НоваяСтрока = Объект.ДополнительныеОбъектыДляВыгрузки.Добавить();
		НоваяСтрока.Объект = Значение.Ссылка;
		НоваяСтрока.ИмяОбъектаДляЗапроса = ИмяОбъектаПоТипуДляЗапроса(Значение.Ссылка);
		
	КонецЦикла
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузкаНаКлиентеИлиНаСервереПриИзменении(Элемент)
	
	ПриИзмененииРежимаРаботы();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаНаКлиентеИлиНаСервереПриИзменении(Элемент)
	
	ПриИзмененииРежимаРаботы();
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьВерсиюИРежимСовместимостиПлатформы()
	
	Информация = Новый СистемнаяИнформация;
	Если Не (Лев(Информация.ВерсияПриложения, 3) = "8.3"
		И (Метаданные.РежимСовместимости = Метаданные.СвойстваОбъектов.РежимСовместимости.НеИспользовать
		Или (Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости.Версия8_1
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости.Версия8_2_13
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости["Версия8_2_16"]
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости["Версия8_3_1"]
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости["Версия8_3_2"]))) Тогда
		
		ВызватьИсключение НСтр("ru = 'Обработка предназначена для запуска на версии платформы
			|1С:Предприятие 8.3 с отключенным режимом совместимости или выше'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
