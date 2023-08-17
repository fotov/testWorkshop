///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ПодключениеСервисовСопровожденияКлиент.
//
// Клиентские процедуры и функции подключения тестовых периодов:
//  - открытие формы подключения тестовых периодов;
//  - обработка результатов подключения.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму подключения тестового периода, предварительно
// проверяя возможность подключения. Подключение может быть не доступно если:
//   - у пользователя нет прав для подключения тестового периода,
//     считается, что все сервисы не доступны;
//   - существуют необработанные запросы на подключение,
//     невозможно определить доступные тарифы;
//   - конфигурация работает в модели сервиса
//   - доступные тестовые периоды отсутствуют.
// Функцию следует использовать, если однозначно определено, что целевой сервис не подключен.
//
// Параметры:
//  Идентификатор         - Строка - идентификатор сервиса в системе Портал 1С:ИТС;
//  Форма                 - УправляемаяФорма - форма из которой производится подключение;
//  ОповещениеПриЗакрытии - ОписаниеОповещения - описание обработчика, который необходимо выполнить
//                          по завершению подключения. В качестве результата будет передан статус подключения:
//                          СостояниеПодключения - Перечисление.СостоянияЗаявкиПодключения - 
//                          описывает состояние подключения тестового периода. Для определения статуса
//                          необходимо использовать функции программного интерфейса:
//                            - Перечисление.СостоянияПодключенияСервисов.Подключен - подключение
//                              тестового периода выполнено без ошибок;
//                            - Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения - тестовый
//                              период не подключен;
//                            - Перечисление.СостоянияПодключенияСервисов.НеПодключен - пользователь
//                              не дождался обработки заявки на подключение;
//                            - Перечисление.СостоянияПодключенияСервисов.ПодключениеНедоступно - подключение
//                              не доступно, форма не была открыта;
//                            - Перечисление.СостоянияПодключенияСервисов.Подключение - выполняется подключение
//                              тестового периода.
//
Процедура ПодключитьТестовыйПериод(
		Идентификатор,
		Форма,
		ОповещениеПриЗакрытии = Неопределено) Экспорт
	
	Состояние(, , НСтр("ru = 'Получение информации о доступных тестовых периодах'"));
	ОписательПодключения = ПодключениеСервисовСопровожденияВызовСервера.ТестовыеПериодыСервисаСопровождения(Идентификатор);
	Состояние();
	
	Если ОписательПодключения.Ошибка Тогда
		ПараметрыФормы = ПодключениеСервисовСопровожденияКлиентСервер.НовыйПараметрыФормыОтобразитьРезультат(
			"",
			"",
			Идентификатор,
			"",
			ОписательПодключения.ИнформацияОбОшибке,
			ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения"));
	ИначеЕсли Не ОписательПодключения.ПодключениеДоступно Тогда
		ВыполнитьОбработкуОповещения(
			ОповещениеПриЗакрытии,
			ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ПодключениеНедоступно"));
		Возврат;
	ИначеЕсли ОписательПодключения.ПодключениеСервиса Тогда
		ДанныеОтображения = ОписательПодключения.ДанныеОтображения;
		ПараметрыФормы    = ПодключениеСервисовСопровожденияКлиентСервер.НовыйПараметрыФормыОтобразитьРезультат(
			ДанныеОтображения.ИдентификаторТестовогоПериода,
			ДанныеОтображения.НаименованиеПодключаемого,
			Идентификатор,
			ДанныеОтображения.ИдентификаторЗапроса,
			"",
			ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключение"),
			ДанныеОтображения.РежимРегламентногоЗадания);
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Идентификатор",        Идентификатор);
		ПараметрыФормы.Вставить("ОписательПодключения", ОписательПодключения);
	КонецЕсли;
	
	УникальныйИдентификатор = Неопределено;
	Если ТипЗнч(Форма) = Тип("УправляемаяФорма") Тогда
		УникальныйИдентификатор = Форма.УникальныйИдентификатор;
	КонецЕсли;
	
	ОткрытьФорму(
		"Обработка.ПодключениеСервисовСопровождения.Форма.ПодключениеТестовогоПериода",
		ПараметрыФормы,
		Форма,
		УникальныйИдентификатор,
		,
		,
		ОповещениеПриЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Вызывается при начале работы системы из
// ИнтернетПоддержкаПользователейКлиент.ПриНачалеРаботыСистемы().
//
Процедура ПриНачалеРаботыСистемы() Экспорт
	
	Если Не ИспользоватьОповещения() Тогда
		Возврат;
	КонецЕсли;
	
	// Вызвать автоматическую проверку обработки запросов на подключение
	// тестовых периодов через 1 секунду после начала работы программы.
	ПодключитьОбработчикОжидания("ПодключениеТестовыхПериодов_ПроверитьСостояниеЗапроса", 1, Истина);
	
КонецПроцедуры

// Выполняет обработку закрытия форму. При необходимости создает регламентное
// задание для проверки результатов подключения тестовых периодов, подключает
// обработчик ожидания и закрывает форму.
//
// Параметры:
//  Форма - УправляемаяФорма - форма подключения тестовых периодов.
//
Процедура ЗакрытьФормуПодключенияТестовыхПериодов(Форма) Экспорт
	
	ДанныеПодключения = Форма.ДанныеПодключения;
	Если Форма.СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключение")
		И Не ДанныеПодключения.РежимРегламентногоЗадания Тогда
		
		НаименованиеТестовогоПериода = ДанныеПодключения.ТестовыеПериоды.Получить(
			Форма.ИдентификаторТестовогоПериода);
		
		ПодключениеСервисовСопровожденияВызовСервера.СоздатьРегламентноеЗаданиеПроверкиПодключения(
			ДанныеПодключения.ОписательСервиса.СервисСопровождения,
			ДанныеПодключения.ИдентификаторЗапроса,
			Форма.ИдентификаторТестовогоПериода,
			НаименованиеТестовогоПериода);
		
		ПодключитьОбработчикПроверкиСостоянияЗапросов();
		
	КонецЕсли;
	
	Форма.ОтказПриЗакрытии = Ложь;
	Форма.Закрыть(Форма.СостояниеПодключения);
	
КонецПроцедуры

// Проверка обработки запросов на подключение тестовых периодов.
//
Процедура ПроверитьСостояниеЗапроса() Экспорт
	
	Если Не ИспользоватьОповещения() Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОповещений = ПодключениеСервисовСопровожденияВызовСервера.ДанныеОповещенийОбОбработкеЗапросов();
	
	Для Каждого ОписательОповещения Из ДанныеОповещений.Оповещения Цикл
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ПараметрыФормы", ОписательОповещения.ПараметрыФормы);
		
		ОписаниеОповещенияПриНажатии = Новый ОписаниеОповещения(
			"ПроверитьСостояниеЗапросаПриНажатии",
			ЭтотОбъект,
			ДополнительныеПараметры);
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Подключение тестового периода'"),
			ОписаниеОповещенияПриНажатии,
			ОписательОповещения.Представление,
			БиблиотекаКартинок.ИнтернетПоддержкаПользователей,
			СтатусОповещенияПользователя.Важное);
		
	КонецЦикла;
	
	Если ДанныеОповещений.ЕстьНеОбработанныеЗапросы Тогда
		ПодключитьОбработчикПроверкиСостоянияЗапросов();
	КонецЕсли;
	
КонецПроцедуры

// Обработчик нажатия на оповещение. Открывает форму подключения тестовых
// периодов и отображает состояние подключения.
//
// Параметры:
//  ДополнительныеПараметры - Структура - дополнительные параметры оповещения.
//
Процедура ПроверитьСостояниеЗапросаПриНажатии(ДополнительныеПараметры) Экспорт
	
	ОткрытьФорму(
		"Обработка.ПодключениеСервисовСопровождения.Форма.ПодключениеТестовогоПериода",
		ДополнительныеПараметры.ПараметрыФормы);
	
КонецПроцедуры

// Подключает обработчик ожидания, который выполняет проверку состояния запросов
// на подключение тестовых периодов. Если ранее уже был подключен обработчик
// ожидания, необходимо его отключить,т.к. одновременно должен работать
// только один обработчик.
//
Процедура ПодключитьОбработчикПроверкиСостоянияЗапросов()
	
	ОтключитьОбработчикОжидания("ПодключениеТестовыхПериодов_ПроверитьСостояниеЗапроса");
	ПодключитьОбработчикОжидания(
		"ПодключениеТестовыхПериодов_ПроверитьСостояниеЗапроса",
		3600,
		Истина);
	
КонецПроцедуры

// Определяет необходимость использования пользовательских оповещений.
//
// Возвращаемое значение:
//  Булево - если истина, необходимо выводить оповещения пользователю.
//
Функция ИспользоватьОповещения()
	
	Возврат Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ТекущиеДела");
	
КонецФункции

#КонецОбласти
