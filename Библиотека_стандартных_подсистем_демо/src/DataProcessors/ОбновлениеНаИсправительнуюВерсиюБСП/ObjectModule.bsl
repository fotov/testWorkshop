///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ОбъектыБСП, ДокументDOM, УзелОбъекты;

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Формирует файл настроек сравнения/ объединения для обновления на исправительную версию БСП.
//
// Параметры:
//    ИмяФайлаНастроек - Строка - Имя файла в формате xml, содержащего настройки сравнения/объединения.
//                                Если передана пустая строка, то в параметре вернется имя временного файла,
//                                содержащего настройки.
//    ИмяФайлаЗахвата  - Строка - Имя файла в формате xml, содержащего список объектов для захвата в хранилище.
//                                Если передана пустая строка, то в параметре вернется имя временного файла,
//                                содержащего список объектов.
//
Процедура СформироватьФайлНастроекСравненияОбъединения(ИмяФайлаНастроек = "", ИмяФайлаЗахвата = "") Экспорт
	
	Если ПустаяСтрока(ИмяФайлаНастроек) Тогда
		// Временный файл должен удаляться вызывающим кодом.
		ИмяФайлаНастроек = ПолучитьИмяВременногоФайла("xml");
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяФайлаЗахвата) Тогда
		// Временный файл должен удаляться вызывающим кодом.
		ИмяФайлаЗахвата = ПолучитьИмяВременногоФайла("xml");
	КонецЕсли;
	
	ФайлШаблона = ПолучитьИмяВременногоФайла("xml");
	ЗаписьТекста = Новый ЗаписьТекста(ФайлШаблона);
	ЗаписьТекста.Записать(ПолучитьМакет("ШаблонНастроек").ПолучитьТекст());
	ЗаписьТекста.Закрыть();
	
	// Получаем DOM документ файла шаблона сравнения/объединения.
	ДокументDOM = ДокументDOM(ФайлШаблона);
	УдалитьФайлы(ФайлШаблона);
	
	// Описание файла настроек:
	// http://its.1c.ru/db/v838doc#bookmark:adm:TI000000713.
	
	// Раздел Settings.
	Settings = ДокументDOM.ПолучитьЭлементыПоИмени("Settings")[0];
	// Версия платформы зависит от версии БСП. Задается в файле шаблона.
	
	// Раздел MainConfiguration.
	MainConfiguration = Settings.ПолучитьЭлементыПоИмени("MainConfiguration")[0];
	Name = MainConfiguration.ПолучитьЭлементыПоИмени("Name")[0];
	Name.ТекстовоеСодержимое = Метаданные.Имя;
	Version = MainConfiguration.ПолучитьЭлементыПоИмени("Version")[0];
	Version.ТекстовоеСодержимое = Метаданные.Версия;
	Vendor = MainConfiguration.ПолучитьЭлементыПоИмени("Vendor")[0];
	Vendor.ТекстовоеСодержимое = Метаданные.Поставщик;
	
	// Разделы SupportRules, Parameters, Conformities, Conformities не заполняем - используем значения по-умолчанию.
	
	// Раздел Objects.
	УзелОбъекты = ДокументDOM.ПолучитьЭлементыПоИмени("Objects")[0];
	
	УстановитьФлажкиПодсистем(ИмяФайлаЗахвата);
	УстановитьФлажкиПереопределяемыхМодулей();
	УстановитьФлажкиРолей();
	УстановитьФлажкиРазделителей();
	УстановитьФлажкиКритериевОтбора();
	УстановитьФлажкиОпределяемыхТипов();
	УстановитьФлажкиОбщихКоманд();
	УстановитьФлажкиЯзыков();
	УстановитьФлажкиСправочников();
	УстановитьФлажкиПлановОбмена();
	УстановитьФлажкиПеречислений();
	УстановитьФлажкиПлановВидовХарактеристик();
	УстановитьФлажкиБизнесПроцессов();
	УстановитьФлажкиФункциональныхОпций();
	
	ЗаписатьДокументDOMВФайл(ИмяФайлаНастроек);
	
КонецПроцедуры

// Выполняет сравнение/объединение конфигурации с новой конфигурацией поставщика.
//
// Параметры:
//    ПутьКФайлуОбновления - Строка - Путь к cf файлу новой конфигурации поставщика.
//
Процедура ОбновитьНаИсправительнуюВерсию(ПутьКФайлуОбновления) Экспорт
	
	Если ПользователиИнформационнойБазы.ТекущийПользователь().ПарольУстановлен Тогда
		ВызватьИсключение НСтр("ru = 'Обновление возможно только для пользователя без пароля.'");
	КонецЕсли;
	
	Если ОткрытКонфигуратор() Тогда
		ВызватьИсключение НСтр("ru = 'Для обновления необходимо закрыть конфигуратор.'");
	КонецЕсли;
	
	КаталогПрограммы = ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить("КаталогПрограммы");
	ПутьКФайлуНастроек = "";
	СформироватьФайлНастроекСравненияОбъединения(ПутьКФайлуНастроек);
	
	ИмяФайлаСообщений = ПолучитьИмяВременногоФайла("txt");
	
	КомандаЗапуска = Новый Массив;
	КомандаЗапуска.Добавить(КаталогПрограммы + "1cv8.exe");
	КомандаЗапуска.Добавить("DESIGNER");
	КомандаЗапуска.Добавить("/IBConnectionString");
	КомандаЗапуска.Добавить(СтрокаСоединенияИнформационнойБазы());
	КомандаЗапуска.Добавить("/N");
	КомандаЗапуска.Добавить(ИмяПользователя());
	КомандаЗапуска.Добавить("/P");
	КомандаЗапуска.Добавить();
	КомандаЗапуска.Добавить("/UpdateCfg");
	КомандаЗапуска.Добавить(ПутьКФайлуОбновления);
	КомандаЗапуска.Добавить("-Settings");
	КомандаЗапуска.Добавить(ПутьКФайлуНастроек);
	КомандаЗапуска.Добавить("-force");
	КомандаЗапуска.Добавить("/Out");
	КомандаЗапуска.Добавить(ИмяФайлаСообщений);
	КомандаЗапуска.Добавить("/DisableStartupMessages");
	КомандаЗапуска.Добавить("/DisableStartupDialogs");
	
	ПараметрыЗапускаПрограммы = ФайловаяСистема.ПараметрыЗапускаПрограммы();
	ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Истина;
	
	Результат = ФайловаяСистема.ЗапуститьПрограмму(КомандаЗапуска, ПараметрыЗапускаПрограммы);
		
	Если Результат.КодВозврата <> 0 Тогда
		Попытка
			Текст = Новый ТекстовыйДокумент;
			Текст.Прочитать(ИмяФайлаСообщений);
			Сообщения = Текст.ПолучитьТекст();
			Если ПустаяСтрока(Сообщения) Тогда
				Сообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Код возврата: %1'"), Результат.КодВозврата);
			КонецЕсли;
			УдалитьФайлы(ИмяФайлаСообщений);
		Исключение
			Сообщения = "";
		КонецПопытки;
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось выполнить сравнение/объединение с конфигурацией из файла по причине:
			           |%1'"), Сообщения);
	КонецЕсли;
	УдалитьФайлы(ИмяФайлаСообщений);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедуры заполнения файла настроек.

Процедура УстановитьФлажкиПодсистем(ИмяФайлаЗахвата)
	
	Для Каждого СвойстваПодсистемы Из ВнедренныеПодсистемы(ИмяФайлаЗахвата) Цикл
		УзелОбъект = ДокументDOM.СоздатьЭлемент("Object");
		УзелОбъект.УстановитьАтрибут("fullNameInSecondConfiguration", СвойстваПодсистемы.Ключ);
		
		УзелПравило = ДокументDOM.СоздатьЭлемент("MergeRule");
		УзелПравило.ТекстовоеСодержимое = "GetFromSecondConfiguration";
		УзелОбъект.ДобавитьДочерний(УзелПравило);
		
		УзелПодсистема = ДокументDOM.СоздатьЭлемент("Subsystem");
		УзелПодсистема.УстановитьАтрибут("configuration", "Second");
		УзелПодсистема.УстановитьАтрибут("includeObjectsFromSubordinateSubsystems", "false");
		
		Если СвойстваПодсистемы.Значение Тогда
			УзелПравило = ДокументDOM.СоздатьЭлемент("MergeRule");
			УзелПравило.ТекстовоеСодержимое = "GetFromSecondConfiguration";
			УзелПодсистема.ДобавитьДочерний(УзелПравило);
			УзелОбъект.ДобавитьДочерний(УзелПодсистема);
		Иначе
			УзелОбъект.ДобавитьДочерний(УзелПодсистема);
			УзелСвойства = ДокументDOM.СоздатьЭлемент("Properties");
			УстановитьПравилоДляСвойства(УзелСвойства, "КомандныйИнтерфейс", "MergePrioritizingSecondConfiguration");
			УстановитьПравилоДляСвойства(УзелСвойства, "Состав", "MergePrioritizingSecondConfiguration");
			УзелОбъект.ДобавитьДочерний(УзелСвойства);
		КонецЕсли;
		
		УзелОбъекты.ДобавитьДочерний(УзелОбъект);
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьФлажкиПереопределяемыхМодулей()
	
	Для Каждого ПереопределяемыйМодуль Из ПереопределяемыеМодули() Цикл
		УстановитьПравилоДляОбъектаИСвойств(ПереопределяемыйМодуль,
			Новый Структура("Модуль", "DoNotMerge"));
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьФлажкиРолей()
	
	Роли = Новый Массив;
	Роли.Добавить("Роль.АдминистраторСистемы");
	Роли.Добавить("Роль.ПолныеПрава");
	
	Для Каждого Роль Из Роли Цикл
		УстановитьПравилоДляОбъектаИСвойств(Роль,
			Новый Структура("Права", "MergePrioritizingSecondConfiguration"));
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьФлажкиРазделителей()
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса") Тогда
		Возврат;
	КонецЕсли;
	
	Разделители = Новый Массив;
	Разделители.Добавить("ОбщийРеквизит.ОбластьДанныхВспомогательныеДанные");
	Разделители.Добавить("ОбщийРеквизит.ОбластьДанныхОсновныеДанные");
	
	Для Каждого Разделитель Из Разделители Цикл
		УстановитьПравилоДляОбъектаИСвойств(Разделитель,
			Новый Структура("Состав", "DoNotMerge"));
	КонецЦикла;
КонецПроцедуры

Процедура УстановитьФлажкиКритериевОтбора()
	
	Критерии = Новый Соответствие;
	Критерии.Вставить("КритерийОтбора.СвязанныеДокументы", "СтандартныеПодсистемы.СтруктураПодчиненности");
	
	Для Каждого КритерийОтбора Из Критерии Цикл
		
		Если Не ОбщегоНазначения.ПодсистемаСуществует(КритерийОтбора.Значение) Тогда
			Продолжить;
		КонецЕсли;
		
		СвойстваПравила = Новый Структура;
		СвойстваПравила.Вставить("Тип", "DoNotMerge");
		СвойстваПравила.Вставить("Состав", "DoNotMerge");
		УстановитьПравилоДляОбъектаИСвойств(КритерийОтбора.Ключ, СвойстваПравила);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьФлажкиОпределяемыхТипов()
	
	Для Каждого СвойстваТипа Из ОпределяемыеТипы() Цикл
		УзелОбъект = ДокументDOM.СоздатьЭлемент("Object");
		УзелОбъект.УстановитьАтрибут("fullNameInSecondConfiguration", СвойстваТипа.Ключ);
		
		УзелСвойства = ДокументDOM.СоздатьЭлемент("Properties");
		УзелСвойство = ДокументDOM.СоздатьЭлемент("Property");
		УзелСвойство.УстановитьАтрибут("name", "Тип");
		УзелПравило = ДокументDOM.СоздатьЭлемент("MergeRule");
		Правило = ?(СвойстваТипа.Значение, "MergePrioritizingSecondConfiguration", "DoNotMerge");
		УзелПравило.ТекстовоеСодержимое = Правило;
		
		УзелСвойство.ДобавитьДочерний(УзелПравило);
		УзелСвойства.ДобавитьДочерний(УзелСвойство);
		УзелОбъект.ДобавитьДочерний(УзелСвойства);
		УзелОбъекты.ДобавитьДочерний(УзелОбъект);
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьФлажкиОбщихКоманд()
	
	Команды = Новый Соответствие;
	Подсистема = "СтандартныеПодсистемы.ОбменДанными";
	Команды.Вставить("ОбщаяКоманда.Синхронизировать", Подсистема);
	Команды.Вставить("ОбщаяКоманда.СинхронизироватьСДополнительнымиПараметрами", Подсистема);
	Команды.Вставить("ОбщаяКоманда.НастройкиПодключения", Подсистема);
	Команды.Вставить("ОбщаяКоманда.ЗагрузитьКомплектПравил", Подсистема);
	Команды.Вставить("ОбщаяКоманда.ЗагрузитьПравилаКонвертацииОбъектов", Подсистема);
	Команды.Вставить("ОбщаяКоманда.ЗагрузитьПравилаРегистрацииОбъектов", Подсистема);
	Команды.Вставить("ОбщаяКоманда.ПолучитьНастройкиСинхронизацииДляДругойПрограммы", Подсистема);
	Команды.Вставить("ОбщаяКоманда.СценарииСинхронизации", Подсистема);
	Команды.Вставить("ОбщаяКоманда.СобытияОтправки", Подсистема);
	Команды.Вставить("ОбщаяКоманда.СобытияПолучения", Подсистема);
	Команды.Вставить("ОбщаяКоманда.СоставОтправляемыхДанных", Подсистема);
	Команды.Вставить("ОбщаяКоманда.УдалитьНастройкуСинхронизации", Подсистема);
	Подсистема = "СтандартныеПодсистемы.СтруктураПодчиненности";
	Команды.Вставить("ОбщаяКоманда.СтруктураПодчиненности", Подсистема);
	
	Подсистема = "СтандартныеПодсистемы.УправлениеДоступом";
	Команды.Вставить("ОбщаяКоманда.НастроитьПрава", Подсистема);
	
	Для Каждого Команда Из Команды Цикл
		
		Если Не ОбщегоНазначения.ПодсистемаСуществует(Команда.Значение) Тогда
			Продолжить;
		КонецЕсли;
		
		УстановитьПравилоДляОбъектаИСвойств(Команда.Ключ,
			Новый Структура("ТипПараметраКоманды", "DoNotMerge"));
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьФлажкиЯзыков()
	УстановитьПравилоДляОбъекта("Язык.Русский", "GetFromSecondConfiguration");
КонецПроцедуры

Процедура УстановитьФлажкиСправочников()
	ТаблицаСправочников = Новый ТаблицаЗначений;
	ТаблицаСправочников.Колонки.Добавить("Имя");
	ТаблицаСправочников.Колонки.Добавить("Подсистема");
	ТаблицаСправочников.Колонки.Добавить("Свойство");
	ТаблицаСправочников.Колонки.Добавить("Правило");
	
	НоваяСтрока = ТаблицаСправочников.Добавить();
	НоваяСтрока.Имя = "Справочник.РолиИсполнителей";
	НоваяСтрока.Подсистема = "СтандартныеПодсистемы.БизнесПроцессыИЗадачи";
	НоваяСтрока.Свойство = "Предопределенные";
	НоваяСтрока.Правило = "DoNotMerge";
	
	НоваяСтрока = ТаблицаСправочников.Добавить();
	НоваяСтрока.Имя = "Справочник.ВидыКонтактнойИнформации";
	НоваяСтрока.Подсистема = "СтандартныеПодсистемы.КонтактнаяИнформация";
	НоваяСтрока.Свойство = "Предопределенные";
	НоваяСтрока.Правило = "DoNotMerge";
	
	НоваяСтрока = ТаблицаСправочников.Добавить();
	НоваяСтрока.Имя = "Справочник.ВнешниеПользователи.Команда.ВнешнийДоступ";
	НоваяСтрока.Подсистема = "СтандартныеПодсистемы.Пользователи";
	НоваяСтрока.Свойство = "ТипПараметраКоманды";
	НоваяСтрока.Правило = "DoNotMerge";
	
	НоваяСтрока = ТаблицаСправочников.Добавить();
	НоваяСтрока.Имя = "Справочник.НаборыДополнительныхРеквизитовИСведений";
	НоваяСтрока.Подсистема = "СтандартныеПодсистемы.Свойства";
	НоваяСтрока.Свойство = "Предопределенные";
	НоваяСтрока.Правило = "DoNotMerge";
	
	НоваяСтрока = ТаблицаСправочников.Добавить();
	НоваяСтрока.Имя = "Справочник.ПрофилиГруппДоступа";
	НоваяСтрока.Подсистема = "СтандартныеПодсистемы.УправлениеДоступом";
	НоваяСтрока.Свойство = "Предопределенные";
	НоваяСтрока.Правило = "DoNotMerge";
	
	НоваяСтрока = ТаблицаСправочников.Добавить();
	НоваяСтрока.Имя = "Справочник.ИдентификаторыОбъектовМетаданных";
	НоваяСтрока.Подсистема = "СтандартныеПодсистемы.БазоваяФункциональность";
	НоваяСтрока.Свойство = "Предопределенные";
	НоваяСтрока.Правило = "DoNotMerge";
	
	Для Каждого Справочник Из ТаблицаСправочников Цикл
		
		Если ОбщегоНазначения.ПодсистемаСуществует(Справочник.Подсистема) Тогда
			УстановитьПравилоДляОбъектаИСвойств(Справочник.Имя,
				Новый Структура(Справочник.Свойство, Справочник.Правило));
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьФлажкиПлановОбмена()
	ТаблицаПлановОбмена = Новый ТаблицаЗначений;
	ТаблицаПлановОбмена.Колонки.Добавить("Имя");
	ТаблицаПлановОбмена.Колонки.Добавить("Подсистема");
	ТаблицаПлановОбмена.Колонки.Добавить("Свойство");
	ТаблицаПлановОбмена.Колонки.Добавить("Правило");
	
	НоваяСтрока = ТаблицаПлановОбмена.Добавить();
	НоваяСтрока.Имя = "ПланОбмена.ОбновлениеИнформационнойБазы";
	НоваяСтрока.Подсистема = "СтандартныеПодсистемы.ОбновлениеВерсииИБ";
	НоваяСтрока.Свойство = "Состав";
	НоваяСтрока.Правило = "MergePrioritizingSecondConfiguration";
	
	Для Каждого ПланОбмена Из ТаблицаПлановОбмена Цикл
		
		Если ОбщегоНазначения.ПодсистемаСуществует(ПланОбмена.Подсистема) Тогда
			УстановитьПравилоДляОбъектаИСвойств(ПланОбмена.Имя,
				Новый Структура(ПланОбмена.Свойство, ПланОбмена.Правило));
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьФлажкиПеречислений()
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОтправкаSMS") Тогда
		УстановитьПравилоДляОбъекта("Перечисление.ПровайдерыSMS", "DoNotMerge");
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьФлажкиПлановВидовХарактеристик()
	ТаблицаПВХ = Новый ТаблицаЗначений;
	ТаблицаПВХ.Колонки.Добавить("Имя");
	ТаблицаПВХ.Колонки.Добавить("Подсистема");
	ТаблицаПВХ.Колонки.Добавить("СвойстваПравила");
	
	СвойстваПравила = Новый Структура;
	СвойстваПравила.Вставить("Тип", "MergePrioritizingSecondConfiguration");
	СвойстваПравила.Вставить("Предопределенные", "MergePrioritizingSecondConfiguration");
	
	НоваяСтрока = ТаблицаПВХ.Добавить();
	НоваяСтрока.Имя = "ПланВидовХарактеристик.ВопросыДляАнкетирования";
	НоваяСтрока.Подсистема = "СтандартныеПодсистемы.Анкетирование";
	НоваяСтрока.СвойстваПравила = Новый Структура("Тип", "MergePrioritizingSecondConfiguration");
	
	НоваяСтрока = ТаблицаПВХ.Добавить();
	НоваяСтрока.Имя = "ПланВидовХарактеристик.ОбъектыАдресацииЗадач";
	НоваяСтрока.Подсистема = "СтандартныеПодсистемы.БизнесПроцессыИЗадачи";
	НоваяСтрока.СвойстваПравила = СвойстваПравила;
	
	НоваяСтрока = ТаблицаПВХ.Добавить();
	НоваяСтрока.Имя = "ПланВидовХарактеристик.РазделыДатЗапретаИзменения";
	НоваяСтрока.Подсистема = "СтандартныеПодсистемы.ДатыЗапретаИзменения";
	НоваяСтрока.СвойстваПравила = СвойстваПравила;
	
	НоваяСтрока = ТаблицаПВХ.Добавить();
	НоваяСтрока.Имя = "ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения";
	НоваяСтрока.Подсистема = "СтандартныеПодсистемы.Свойства";
	НоваяСтрока.СвойстваПравила = СвойстваПравила;
	
	Для Каждого ПланВидовХарактеристик Из ТаблицаПВХ Цикл
		
		Если ОбщегоНазначения.ПодсистемаСуществует(ПланВидовХарактеристик.Подсистема) Тогда
			УстановитьПравилоДляОбъектаИСвойств(ПланВидовХарактеристик.Имя, ПланВидовХарактеристик.СвойстваПравила);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьФлажкиБизнесПроцессов()
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.БизнесПроцессыИЗадачи") Тогда
		УстановитьПравилоДляОбъектаИСвойств("БизнесПроцесс.Задание", Новый Структура("ВводитсяНаОсновании", "DoNotMerge"));
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьФлажкиФункциональныхОпций()
	
	ФункциональныеОпции = Новый Массив;
	ФункциональныеОпции.Добавить("ФункциональнаяОпция.РаботаВАвтономномРежиме");
	ФункциональныеОпции.Добавить("ФункциональнаяОпция.РаботаВЛокальномРежиме");
	ФункциональныеОпции.Добавить("ФункциональнаяОпция.РаботаВМоделиСервиса");
	
	Для Каждого ФункциональнаяОпция Из ФункциональныеОпции Цикл
		УстановитьПравилоДляОбъектаИСвойств(ФункциональнаяОпция,
			Новый Структура("Состав", "DoNotMerge"));
	КонецЦикла;
	
КонецПроцедуры

// Вспомогательные процедуры

// Формирует файл для захвата объектов в хранилище.
//
Функция ВнедренныеПодсистемы(ИмяФайлаЗахвата)
	
	// Подсистема СтандартныеПодсистемы должна быть обязательно.
	Если Метаданные.Подсистемы.Найти("СтандартныеПодсистемы") = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Не внедрена БСП'");
	КонецЕсли;
	
	Подсистемы = Новый Соответствие;
	ОбъектыБСП = Новый Соответствие;
	
	Запись = Новый ЗаписьXML;
	Запись.ОткрытьФайл(ИмяФайлаЗахвата);
	Запись.ЗаписатьОбъявлениеXML();
	Запись.ЗаписатьНачалоЭлемента(НСтр("ru = 'Objects'"));
	Запись.ЗаписатьАтрибут("xmlns", "http://v8.1c.ru/8.3/config/objects");
	Запись.ЗаписатьАтрибут("version", "1.0");
	
	ПодсистемаАдминистрирование = Метаданные.Подсистемы.Найти("Администрирование");
	Если ПодсистемаАдминистрирование <> Неопределено Тогда
		ПолноеИмя = ПодсистемаАдминистрирование.ПолноеИмя();
		Подсистемы.Вставить(ПолноеИмя, Ложь);
		Запись.ЗаписатьНачалоЭлемента("Object");
		Запись.ЗаписатьАтрибут("fullName", ПолноеИмя);
		Запись.ЗаписатьАтрибут("includeChildObjects", "false");
		Запись.ЗаписатьКонецЭлемента();
	КонецЕсли;
	
	ПодсистемаПодключаемыеОтчеты = Метаданные.Подсистемы.Найти("ПодключаемыеОтчетыИОбработки");
	Если ПодсистемаПодключаемыеОтчеты <> Неопределено Тогда
		ПолноеИмя = ПодсистемаПодключаемыеОтчеты.ПолноеИмя();
		Подсистемы.Вставить(ПолноеИмя, Ложь);
		Запись.ЗаписатьНачалоЭлемента("Object");
		Запись.ЗаписатьАтрибут("fullName", ПолноеИмя);
		Запись.ЗаписатьАтрибут("includeChildObjects", "false");
		Запись.ЗаписатьКонецЭлемента();
	КонецЕсли;
	
	ДобавитьПодсистемы(Подсистемы, Метаданные.Подсистемы.СтандартныеПодсистемы, Запись);
	
	Запись.ЗаписатьКонецЭлемента();
	Запись.Закрыть();
	
	Возврат Подсистемы;
	
КонецФункции

Функция ПереопределяемыеМодули()
	
	ПереопределяемыеМодули = Новый Массив;
	
	Для Каждого ОбщийМодуль Из Метаданные.ОбщиеМодули Цикл
		Если ЭтоОбъектБСП(ОбщийМодуль) И СтрЗаканчиваетсяНа(ОбщийМодуль.Имя, "Переопределяемый") Тогда
			ПереопределяемыеМодули.Добавить(ОбщийМодуль.ПолноеИмя());
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПереопределяемыеМодули;
	
КонецФункции

Функция ОпределяемыеТипы()
	
	// Эти определяемые типы не заполняются в БСП, поэтому нужно снять с них флажки.
	ПустыеОпределяемыеТипы = Новый Массив;
	ПустыеОпределяемыеТипы.Добавить("Организация");
	ПустыеОпределяемыеТипы.Добавить("Подразделение");
	ПустыеОпределяемыеТипы.Добавить("ФизическоеЛицо");
	
	ОпределяемыеТипы = Новый Соответствие;
	
	Для Каждого ОпределяемыйТип Из Метаданные.ОпределяемыеТипы Цикл
		Если ЭтоОбъектБСП(ОпределяемыйТип) Тогда
			УстановитьФлажок = ПустыеОпределяемыеТипы.Найти(ОпределяемыйТип.Имя) = Неопределено;
			ОпределяемыеТипы.Вставить(ОпределяемыйТип.ПолноеИмя(), УстановитьФлажок);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОпределяемыеТипы;
	
КонецФункции

Процедура ДобавитьПодсистемы(Подсистемы, МетаданныеПодсистемы, Запись)
	
	Для Каждого Подсистема Из МетаданныеПодсистемы.Подсистемы Цикл
		Если Подсистема.Подсистемы.Количество() = 0 Тогда
			ПолноеИмя = Подсистема.ПолноеИмя();
			Подсистемы.Вставить(ПолноеИмя, Истина);
			Запись.ЗаписатьНачалоЭлемента("Object");
			Запись.ЗаписатьАтрибут("fullName", ПолноеИмя);
			Запись.ЗаписатьАтрибут("includeChildObjects", "false");
			Запись.ЗаписатьНачалоЭлемента("Subsystem");
			Запись.ЗаписатьАтрибут("includeObjectsFromSubordinateSubsystems", "true");
			Запись.ЗаписатьКонецЭлемента();
			Запись.ЗаписатьКонецЭлемента();
			Для Каждого ОбъектМетаданных Из Подсистема.Состав Цикл
				ОбъектыБСП.Вставить(ОбъектМетаданных, Истина);
			КонецЦикла;
		Иначе
			ДобавитьПодсистемы(Подсистемы, Подсистема, Запись);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Работа с DOM документом.

Процедура ЗаписатьДокументDOMВФайл(ПутьКФайлу)
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ПутьКФайлу);
	
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьDOM.Записать(ДокументDOM, ЗаписьXML);
	
КонецПроцедуры

Функция ДокументDOM(ПутьКФайлу)
	
	ЧтениеXML = Новый ЧтениеXML;
	ПостроительDOM = Новый ПостроительDOM;
	ЧтениеXML.ОткрытьФайл(ПутьКФайлу);
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
	ЧтениеXML.Закрыть();
	
	Возврат ДокументDOM;
	
КонецФункции

Процедура УстановитьПравилоДляОбъектаИСвойств(ПолноеИмя, СвойстваПравила)
	
	УзелОбъект = ДокументDOM.СоздатьЭлемент("Object");
	УзелОбъект.УстановитьАтрибут("fullNameInSecondConfiguration", ПолноеИмя);
	УзелСвойства = ДокументDOM.СоздатьЭлемент("Properties");
	Для Каждого СвойствоПравила Из СвойстваПравила Цикл
		УстановитьПравилоДляСвойства(УзелСвойства, СвойствоПравила.Ключ, СвойствоПравила.Значение);
	КонецЦикла;
	УзелОбъект.ДобавитьДочерний(УзелСвойства);
	УзелОбъекты.ДобавитьДочерний(УзелОбъект);
КонецПроцедуры

Процедура УстановитьПравилоДляСвойства(УзелСвойства, ИмяСвойства, Правило)
	
	УзелСвойство = ДокументDOM.СоздатьЭлемент("Property");
	УзелСвойство.УстановитьАтрибут("name", ИмяСвойства);
	УзелПравило = ДокументDOM.СоздатьЭлемент("MergeRule");
	УзелПравило.ТекстовоеСодержимое = Правило;
	УзелСвойство.ДобавитьДочерний(УзелПравило);
	УзелСвойства.ДобавитьДочерний(УзелСвойство);
	
КонецПроцедуры

Процедура УстановитьПравилоДляОбъекта(ПолноеИмя, Правило)
	УзелОбъект = ДокументDOM.СоздатьЭлемент("Object");
	УзелОбъект.УстановитьАтрибут("fullNameInSecondConfiguration", ПолноеИмя);
	
	УзелПравило = ДокументDOM.СоздатьЭлемент("MergeRule");
	УзелПравило.ТекстовоеСодержимое = Правило;
	УзелОбъект.ДобавитьДочерний(УзелПравило);
	УзелОбъекты.ДобавитьДочерний(УзелОбъект);
КонецПроцедуры

// Общие процедуры.

Функция ЭтоОбъектБСП(ОбъектМетаданных)
	Возврат ОбъектыБСП.Получить(ОбъектМетаданных) = Истина;
КонецФункции

Функция ОткрытКонфигуратор()
	
	Для Каждого Сеанс Из ПолучитьСеансыИнформационнойБазы() Цикл
		Если ВРег(Сеанс.ИмяПриложения) = ВРег("Designer") Тогда // Конфигуратор
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли