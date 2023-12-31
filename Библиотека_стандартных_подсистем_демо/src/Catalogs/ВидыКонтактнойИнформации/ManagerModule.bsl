///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("*");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

// См. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами.
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	
	БлокируемыеРеквизиты.Добавить("Тип;Тип");
	БлокируемыеРеквизиты.Добавить("Родитель");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	ЛокализацияКлиентСервер.ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Регистрирует к обработке виды контактной информации другое у которых необходимо заполнить поле ВидПоляДругое
// и исправить Наименования на разных языках.
//
Процедура ЗаполнитьВидыКонтактнойИнформацииКОбработке(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
		|	ВидыКонтактнойИнформации.Ссылка,
		|	ВидыКонтактнойИнформации.УдалитьМногострочноеПоле
		|ИЗ
		|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации";
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры,
		РезультатЗапроса.ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьВидыКонтактнойИнформации(Параметры) Экспорт
	
	ВидКонтактнойИнформацииСсылка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.ВидыКонтактнойИнформации");
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	
	ЯзыковБольшеОдного = Метаданные.Языки.Количество() > 1;
	Наименования = УправлениеКонтактнойИнформациейСлужебныйПовтИсп.НаименованияВидовКонтактнойИнформации();
	
	Пока ВидКонтактнойИнформацииСсылка.Следующий() Цикл
		Попытка
			ВидКонтактнойИнформации = ВидКонтактнойИнформацииСсылка.Ссылка.ПолучитьОбъект();
			
			// Исправление наименований на разных языках
			Если ЯзыковБольшеОдного Тогда
				ИмяВида = ?(ЗначениеЗаполнено(ВидКонтактнойИнформации.ИмяПредопределенногоВида),
					ВидКонтактнойИнформации.ИмяПредопределенногоВида, ВидКонтактнойИнформации.ИмяПредопределенныхДанных);
				
				Если ЗначениеЗаполнено(ИмяВида) Тогда
					УстановитьНаименованияВидовКонтактнойИнформации(ВидКонтактнойИнформации, ИмяВида, Наименования);
				КонецЕсли;
			КонецЕсли;
			
			// Обработчик изменения вида контактной информации Другое.
			Если ВидКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Другое
				И ПустаяСтрока(ВидКонтактнойИнформации.ВидПоляДругое) Тогда
				
					Если ВидКонтактнойИнформации.УдалитьМногострочноеПоле Тогда
						ВидКонтактнойИнформации.ВидПоляДругое = "МногострочноеШирокое";
					Иначе
						ВидКонтактнойИнформации.ВидПоляДругое = "ОднострочноеШирокое";
					КонецЕсли;
				
			КонецЕсли;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ВидКонтактнойИнформации);
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
		Исключение
			// Если не удалось обработать какой-либо вид контактной информации, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обработать вид контактной информации: %1 по причине: %2'"),
			ВидКонтактнойИнформацииСсылка.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
			Метаданные.Справочники.ВидыКонтактнойИнформации, ВидКонтактнойИнформацииСсылка.Ссылка, ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.ВидыКонтактнойИнформации");
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Процедуре ЗаполнитьВидыКонтактнойИнформации не удалось обработать некоторые виды контактной информации (пропущены): %1'"), 
		ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
		Метаданные.Справочники.ВидыКонтактнойИнформации,,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Процедура ЗаполнитьВидыКонтактнойИнформации обработала очередную порцию видов контактной информации: %1'"),
		ОбъектовОбработано));
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьНаименованияВидовКонтактнойИнформации(ВидКонтактнойИнформации, ИмяВида, Наименования)
	
	Для Каждого Язык Из Метаданные.Языки Цикл
		
		Представление = Наименования[Язык.КодЯзыка][ИмяВида];
		Если ЗначениеЗаполнено(Представление) Тогда
			
			Если Язык = Метаданные.ОсновнойЯзык Тогда
				ВидКонтактнойИнформации.Наименование = Представление;
			Иначе
				
				Если Наименования[Язык.КодЯзыка][ИмяВида] <> Неопределено Тогда
					
					Отбор = Новый Структура;
					Отбор.Вставить("КодЯзыка",     Язык.КодЯзыка);
					Отбор.Вставить("Наименование", Представление);
					НайденныеСтроки = ВидКонтактнойИнформации.Представления.НайтиСтроки(Отбор);
					Если НайденныеСтроки.Количество() > 0 Тогда
						НоваяСтрока = НайденныеСтроки[0];
					Иначе
						НоваяСтрока = ВидКонтактнойИнформации.Представления.Добавить();
					КонецЕсли;
					НоваяСтрока.КодЯзыка     = Язык.КодЯзыка;
					НоваяСтрока.Наименование = Представление;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецЕсли