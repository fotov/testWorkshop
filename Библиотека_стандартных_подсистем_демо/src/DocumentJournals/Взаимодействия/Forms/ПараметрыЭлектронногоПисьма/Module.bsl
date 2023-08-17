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
	
	ЗаполнитьРеквизитыФормыИзПараметров(Параметры);
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Папка <> ТекущаяПапка Тогда
		ВзаимодействияВызовСервера.УстановитьПапкуЭлектронногоПисьма(Письмо,Папка);
	КонецЕсли;
	
	Если ТипПисьма = "ЭлектронноеПисьмоИсходящее" И ОтправленоПолучено = Дата(1,1,1) И Модифицированность Тогда
		
		РезультатВыбора = Новый Структура;
		РезультатВыбора.Вставить("УведомитьОДоставке", УведомитьОДоставке);
		РезультатВыбора.Вставить("УведомитьОПрочтении", УведомитьОПрочтении);
		РезультатВыбора.Вставить("ВключатьТелоИсходногоПисьма", ВключатьТелоИсходногоПисьма);
		РезультатВыбора.Вставить("Папка", Неопределено);
		
	Иначе
		
		РезультатВыбора = Неопределено;
		
	КонецЕсли;
	
	Модифицированность = Ложь;
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,ИмяПараметра,ИмяРеквизита = "")

	Если ПереданныеПараметры.Свойство(ИмяПараметра) Тогда
		
		ЭтотОбъект[?(ПустаяСтрока(ИмяРеквизита),ИмяПараметра,ИмяРеквизита)] = ПереданныеПараметры[ИмяПараметра];
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыФормыИзПараметров(ПереданныеПараметры)

	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"ВнутреннийНомер");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"Создано");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"Получено","ОтправленоПолучено");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"Отправлено","ОтправленоПолучено");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"УведомитьОДоставке");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"УведомитьОПрочтении");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"Письмо");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"ТипПисьма");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"ВключатьТелоИсходногоПисьма");
	ЗаполнитьРеквизитФормыИзПараметра(ПереданныеПараметры,"УчетнаяЗапись");
	
	ЗаголовкиИнтернета.ДобавитьСтроку(ПереданныеПараметры.ЗаголовкиИнтернета);
	
	Папка = Взаимодействия.ПолучитьПапкуЭлектронногоПисьма(Письмо);
	ТекущаяПапка = Папка;

КонецПроцедуры

&НаСервере
Процедура УправлениеДоступностью()

	Если ТипПисьма = "ЭлектронноеПисьмоИсходящее" Тогда
		Элементы.Заголовки.Заголовок = НСтр("ru='Идентификаторы'");
		Если ОтправленоПолучено = Дата(1,1,1) Тогда
			Элементы.УведомитьОДоставке.ТолькоПросмотр          = Ложь;
			Элементы.УведомитьОПрочтении.ТолькоПросмотр         = Ложь;
			Элементы.ВключатьТелоИсходногоПисьма.ТолькоПросмотр = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ОтправленоПолучено.Заголовок = НСтр("ru='Получено'");
		Элементы.ВключатьТелоИсходногоПисьма.Видимость =Ложь;
	КонецЕсли;
	
	Элементы.Папка.Доступность = ЗначениеЗаполнено(УчетнаяЗапись);
	
КонецПроцедуры

#КонецОбласти
