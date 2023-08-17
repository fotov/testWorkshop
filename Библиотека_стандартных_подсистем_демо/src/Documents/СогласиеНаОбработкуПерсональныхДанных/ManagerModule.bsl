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

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СогласиеНаОбработкуПерсональныхДанных";
	КомандаПечати.Представление = НСтр("ru = 'Согласие на обработку ПДн (табличный документ 1С:Предприятия)'");
	
	// В формате Microsoft Word.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СогласиеНаОбработкуПерсональныхДанных(OfficeOpenXML)";
	КомандаПечати.Представление = НСтр("ru = 'Согласие на обработку ПДн (документ Office Open XML)'");
	КомандаПечати.Картинка = БиблиотекаКартинок.ФорматWord2007;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;

КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр).
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной
//                                                            параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной
//                                            параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Печать согласия
 	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "СогласиеНаОбработкуПерсональныхДанных");
	Если ПечатнаяФорма <> Неопределено Тогда
		// имена файлов
		ИменаФайлов = Новый Соответствие;
		Шаблон = НСтр("ru = 'Согласие на обработку ПДн [Субъект] - [Организация] (№[Номер] получено [ДатаПолучения])'");
		ЗначенияРеквизитовДокументов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивОбъектов, "Организация,Субъект,Номер,ДатаПолучения,Ссылка");
		Для Каждого Ссылка Из МассивОбъектов Цикл
			ЗначенияРеквизитовДокумента = ЗначенияРеквизитовДокументов[Ссылка];
			ЗначенияРеквизитовДокумента.ДатаПолучения = Формат(ЗначенияРеквизитовДокумента.ДатаПолучения, "ДЛФ=D");
			ЗначенияРеквизитовДокумента.Номер = ЗначенияРеквизитовДокумента.Номер;
			Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрефиксацияОбъектов") Тогда
				МодульПрефиксацияОбъектовКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ПрефиксацияОбъектовКлиентСервер");
				ЗначенияРеквизитовДокумента.Номер = МодульПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ЗначенияРеквизитовДокумента.Номер);
			КонецЕсли;
			ИмяФайла = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(Шаблон, ЗначенияРеквизитовДокументов[Ссылка]);
			ИменаФайлов.Вставить(Ссылка, ИмяФайла);
		КонецЦикла;
		
		// описание печатной формы
		ПечатнаяФорма.ТабличныйДокумент = ПечатьСогласияНаОбработкуПДн(МассивОбъектов, ОбъектыПечати);
		ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Согласие на обработку ПДн'");
		ПечатнаяФорма.ПолныйПутьКМакету = "Документ.СогласиеНаОбработкуПерсональныхДанных.ПФ_MXL_СогласиеНаОбработкуПерсональныхДанных";
		ПечатнаяФорма.ИмяФайлаПечатнойФормы = ИменаФайлов;
	КонецЕсли;
		
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "СогласиеНаОбработкуПерсональныхДанных(OfficeOpenXML)");
	Если ПечатнаяФорма <> Неопределено Тогда
		
		ИмяМакета = "СогласиеНаОбработкуПерсональныхДанных(OfficeOpenXML)";
		МакетИДанныеОбъекта = УправлениеПечатьюВызовСервера.МакетыИДанныеОбъектовДляПечати("Документ.СогласиеНаОбработкуПерсональныхДанных", ИмяМакета, МассивОбъектов);
		
		ОфисныеДокументы = Новый Соответствие;
		
		Шаблон = НСтр("ru = 'Согласие на обработку ПДн [Субъект] - [Организация] (№[Номер] получено [ДатаПолучения])'");
		ЗначенияРеквизитовДокументов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивОбъектов, "Организация,Субъект,Номер,ДатаПолучения,Ссылка");
		Для Каждого Ссылка Из МассивОбъектов Цикл
			
			ЗначенияРеквизитовДокумента = ЗначенияРеквизитовДокументов[Ссылка];
			ЗначенияРеквизитовДокумента.ДатаПолучения = Формат(ЗначенияРеквизитовДокумента.ДатаПолучения, "ДЛФ=D");
			Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрефиксацияОбъектов") Тогда
				МодульПрефиксацияОбъектовКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ПрефиксацияОбъектовКлиентСервер");
				ЗначенияРеквизитовДокумента.Номер = МодульПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ЗначенияРеквизитовДокумента.Номер);
			КонецЕсли;
			ИмяДокумента = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(Шаблон, ЗначенияРеквизитовДокументов[Ссылка]);
			
			АдресХранилищаОфисныйДокумент = НапечататьСогласиеНаОбработкуПерсональныхДанныхСубъекта(Ссылка, МакетИДанныеОбъекта, ИмяМакета);
			
			ОфисныеДокументы.Вставить(АдресХранилищаОфисныйДокумент, ИмяДокумента);
			
		КонецЦикла;
		
		ПечатнаяФорма.СинонимМакета    = НСтр("ru = 'Согласие на обработку персональных данных (документ Microsoft Word)'");
		ПечатнаяФорма.ОфисныеДокументы = ОфисныеДокументы;
		
	КонецЕсли;
		
КонецПроцедуры

// Подготавливает данные объекта к выводу на печать.
// 
// Параметры:
//  Согласия - Массив - ссылки на документы, для которых запрашиваются данные для печати;
//  МассивИменМакетов - Массив - имена макетов (Строка), в которые подставляются данные для печати.
//
// Возвращаемое значение:
//  Соответствие - коллекция ссылок на объекты и их данные:
//   * Ключ - ЛюбаяСсылка - ссылка на объект информационной базы;
//   * Значение - Структура - макет и данные:
//    ** Ключ - Строка - имя макета,
//    ** Значение - Структура - данные объекта.
//
Функция ПолучитьДанныеПечати(Знач Согласия, Знач МассивИменМакетов) Экспорт
	
	ДанныеПоВсемОбъектам = Новый Соответствие;
	
	СоответствиеПоСогласиям = СоответствиеДанныхДляПечатиСогласий(Согласия);
	
	Для Каждого ОбъектСсылка Из Согласия Цикл
		ДанныеОбъектаПоМакетам = Новый Соответствие;
		Для Каждого ИмяМакета Из МассивИменМакетов Цикл
			ДанныеОбъектаПоМакетам.Вставить(ИмяМакета, СоответствиеПоСогласиям[ОбъектСсылка]);
		КонецЦикла;
		ДанныеПоВсемОбъектам.Вставить(ОбъектСсылка, ДанныеОбъектаПоМакетам);
	КонецЦикла;
	
	ОписаниеОбластей = Новый Соответствие;
	ДвоичныеДанныеМакетов = Новый Соответствие;
	
	Для Каждого ИмяМакета Из МассивИменМакетов Цикл
		Если ИмяМакета = "СогласиеНаОбработкуПерсональныхДанных(OfficeOpenXML)" Тогда
			ДвоичныеДанныеМакетов.Вставить(ИмяМакета, УправлениеПечатью.МакетПечатнойФормы("Документ.СогласиеНаОбработкуПерсональныхДанных.ПФ_DOC_СогласиеНаОбработкуПерсональныхДанных_ru"));
		КонецЕсли;
		ОписаниеОбластей.Вставить(ИмяМакета, ОписаниеОбластейМакетаОфисногоДокумента());
	КонецЦикла;
	
	Макеты = Новый Структура("ОписаниеОбластей, ДвоичныеДанныеМакетов");
	Макеты.ОписаниеОбластей = ОписаниеОбластей;
	Макеты.ДвоичныеДанныеМакетов = ДвоичныеДанныеМакетов;
	
	ДанныеПечати = Новый Структура("Данные, Макеты");
	ДанныеПечати.Данные = ДанныеПоВсемОбъектам;
	ДанныеПечати.Макеты = Макеты;
	
	Возврат ДанныеПечати;
	
КонецФункции

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура печати согласия на обработку персональных данных.
//
Функция ПечатьСогласияНаОбработкуПДн(Согласия, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_СогласиеНаОбработкуПерсональныхДанных";
	
	ОбластиМакета = Новый Структура;
	ОбластиМакета.Вставить("Заголовок");
	ОбластиМакета.Вставить("НомерДата");
	ОбластиМакета.Вставить("Преамбула");
	ОбластиМакета.Вставить("П1_ЦелиОбработкиПДн");
	ОбластиМакета.Вставить("П2_СоставПДн");
	ОбластиМакета.Вставить("П3_ДействияСПДн");
	ОбластиМакета.Вставить("П4_ПравоПолученияИнформации");
	ОбластиМакета.Вставить("П5_СрокДействия");
	ОбластиМакета.Вставить("П6_ПравоОтзыва");
	ОбластиМакета.Вставить("РеквизитыОператора");
	ОбластиМакета.Вставить("РеквизитыСубъекта");
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.СогласиеНаОбработкуПерсональныхДанных.ПФ_MXL_СогласиеНаОбработкуПерсональныхДанных");
	
	ДанныеДляПечати = ДанныеДляПечатиСогласий(Согласия);
	
	// Вывод форм для субъектов.
	ПервыйДокумент = Истина;
	Для Каждого ОписаниеСогласия Из ДанныеДляПечати Цикл
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();	
		КонецЕсли;
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		// Формируем печатную форму согласия.
		СогласиеФорма = Новый ТабличныйДокумент;
		Для Каждого КлючИЗначение Из ОбластиМакета Цикл
			ИмяОбласти = КлючИЗначение.Ключ;
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			ОбластьМакета.Параметры.Заполнить(ОписаниеСогласия);
			СогласиеФорма.Вывести(ОбластьМакета);
		КонецЦикла;
		ТабличныйДокумент.Вывести(СогласиеФорма);
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ОписаниеСогласия.ДокументОснование);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Структура данных для подготовки печатных форм.
//
// Параметры:
//	Согласия - массив документов типа ДокументСсылка.СогласиеНаОбработкуПерсональныхДанных.
//
// Возвращаемое значение - массив структур, см. ОписаниеСогласия().
//
Функция ДанныеДляПечатиСогласий(Согласия)
	
	ДанныеДляПечати = Новый Массив;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Согласия.Ссылка КАК ДокументОснование,
		|	Согласия.Номер КАК Номер,
		|	Согласия.Организация КАК Организация,
		|	Согласия.НаименованиеОрганизации КАК НаименованиеОрганизации,
		|	Согласия.ЮридическийАдресОрганизации КАК АдресОрганизации,
		|	Согласия.ОтветственныйЗаОбработкуПерсональныхДанных КАК ОтветственныйЗаОбработкуПерсональныхДанных,
		|	Согласия.ФИООтветственногоЗаОбработкуПДн КАК ФИООтветственногоЗаОбработкуПДн,
		|	Согласия.Субъект КАК Субъект,
		|	Согласия.ФИОСубъекта КАК ФИО,
		|	Согласия.АдресСубъекта КАК Адрес,
		|	Согласия.ПаспортныеДанные КАК ПаспортныеДанные,
		|	Согласия.ДатаПолучения КАК ДатаСогласия,
		|	Согласия.СрокДействия КАК СрокДействия,
		|	Согласия.Ответственный КАК Ответственный,
		|	Согласия.Комментарий КАК Комментарий
		|ИЗ
		|	Документ.СогласиеНаОбработкуПерсональныхДанных КАК Согласия
		|ГДЕ
		|	Согласия.Ссылка В(&Согласия)");
		
	Запрос.УстановитьПараметр("Согласия", Согласия);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Описание = ОписаниеСогласия();
		ЗаполнитьЗначенияСвойств(Описание, Выборка);
		Если Не ПустаяСтрока(Выборка.НаименованиеОрганизации) Тогда
			Описание.Организация = Выборка.НаименованиеОрганизации;
		КонецЕсли;
		ЗаполнитьОрганизациюВДательномПадеже(Описание, Выборка.НаименованиеОрганизации);
		Если Не ПустаяСтрока(Выборка.ФИООтветственногоЗаОбработкуПДн) Тогда
			Описание.ОтветственныйЗаОбработкуПерсональныхДанных = Выборка.ФИООтветственногоЗаОбработкуПДн;
		КонецЕсли;
		ЗаполнитьОтветственногоВРодительномПадеже(Описание, Выборка.ФИООтветственногоЗаОбработкуПДн);
		Описание.ДатаСогласия = Формат(Выборка.ДатаСогласия, "ДЛФ=D");
		Если ЗначениеЗаполнено(Выборка.СрокДействия) Тогда
			Описание.ПериодДействия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'с %1 по %2.'"), Формат(Выборка.ДатаСогласия, "ДЛФ=D"), Формат(Выборка.СрокДействия, "ДЛФ=D"));
		Иначе
			Описание.ПериодДействия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'с %1 бессрочно.'"), Формат(Выборка.ДатаСогласия, "ДЛФ=D"));
		КонецЕсли;
		ДанныеДляПечати.Добавить(Описание);
	КонецЦикла;
	
	Возврат ДанныеДляПечати;
	
КонецФункции

// Структура данных для подготовки печатных форм.
//
// Параметры:
//	Согласия - массив документов типа ДокументСсылка.СогласиеНаОбработкуПерсональныхДанных.
//
// Возвращаемое значение - соответствие, в котором ключом является ссылкой, а значением описание, см. ОписаниеСогласия().
//
Функция СоответствиеДанныхДляПечатиСогласий(Согласия)
	
	Соответствие = Новый Соответствие;
	
	ДанныеДляПечати = ДанныеДляПечатиСогласий(Согласия);
	
	Для Каждого ОписаниеСогласия Из ДанныеДляПечати Цикл
		Соответствие.Вставить(ОписаниеСогласия.ДокументОснование, ОписаниеСогласия);
	КонецЦикла;
	
	Возврат Соответствие;
	
КонецФункции

Функция ОписаниеСогласия()
	
	ОписаниеСогласия = Новый Структура(
		"ДатаСогласия,
		|ДокументОснование, 
		|Организация, 
		|ОрганизацияВДательномПадеже, 
		|АдресОрганизации, 
		|ОтветственныйЗаОбработкуПерсональныхДанных, 
		|ОтветственныйЗаОбработкуПерсональныхДанныхВРодительномПадеже, 
		|ПериодДействия, 
		|ФИО, 
		|Адрес, 
		|ПаспортныеДанные");
		
	ОписаниеСогласия.ДатаСогласия = НСтр("ru = '«____»_______________20___г.'");
	ОписаниеСогласия.Организация = НСтр("ru = '<Организация>'");
	ОписаниеСогласия.ОрганизацияВДательномПадеже = ОписаниеСогласия.Организация;
	ОписаниеСогласия.АдресОрганизации = НСтр("ru = '<Адрес организации>'");
	ОписаниеСогласия.ОтветственныйЗаОбработкуПерсональныхДанных = НСтр("ru = '<ФИО ответственного лица>'");
	ОписаниеСогласия.ОтветственныйЗаОбработкуПерсональныхДанныхВРодительномПадеже = ОписаниеСогласия.ОтветственныйЗаОбработкуПерсональныхДанных;

	Возврат ОписаниеСогласия;
	
КонецФункции

Процедура ЗаполнитьОрганизациюВДательномПадеже(ОписаниеСогласия, НаименованиеОрганизации)
	
	Если ПустаяСтрока(НаименованиеОрганизации) Тогда
		ОписаниеСогласия.ОрганизацияВДательномПадеже = ОписаниеСогласия.Организация;
		Возврат;
	КонецЕсли;
	
	ОписаниеСогласия.ОрганизацияВДательномПадеже = НаименованиеОрганизации;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.СклонениеПредставленийОбъектов") Тогда
		МодульСклонениеПредставленийОбъектов = ОбщегоНазначения.ОбщийМодуль("СклонениеПредставленийОбъектов");
		ОписаниеСогласия.ОрганизацияВДательномПадеже = МодульСклонениеПредставленийОбъектов.ПросклонятьПредставление(НаименованиеОрганизации, 3);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьОтветственногоВРодительномПадеже(ОписаниеСогласия, ФИООтветственного)
	
	Если ПустаяСтрока(ФИООтветственного) Тогда
		ОписаниеСогласия.ОтветственныйЗаОбработкуПерсональныхДанныхВРодительномПадеже = ОписаниеСогласия.ОтветственныйЗаОбработкуПерсональныхДанных;
		Возврат;
	КонецЕсли;
	
	ОписаниеСогласия.ОтветственныйЗаОбработкуПерсональныхДанныхВРодительномПадеже = ФИООтветственного;
	
	СклонениеФИО = "";
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.СклонениеПредставленийОбъектов") Тогда
		МодульСклонениеПредставленийОбъектов = ОбщегоНазначения.ОбщийМодуль("СклонениеПредставленийОбъектов");
		СклонениеФИО = МодульСклонениеПредставленийОбъектов.ПросклонятьФИО(ФИООтветственного, 2);
	КонецЕсли;
	
	Если Не ПустаяСтрока(СклонениеФИО) Тогда
		ОписаниеСогласия.ОтветственныйЗаОбработкуПерсональныхДанныхВРодительномПадеже = СклонениеФИО;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с макетами офисных документов.

// Формирует печатную форму документа Согласие на обработку персональных данных с использованием макета
// в формате офисного документа Office Open XML.
//
// Параметры:
//  ДокументСсылка      - Ссылка - объект, по которому требуется сформировать печатную форму.
//  МакетИДанныеОбъекта - Соответствие - коллекция ссылок на объекты и их данные.
//  ИмяМакета           - Строка - наименование макета для печати.
//
// Возвращаемое значение:
//   АдресХранилищаПечатнойФормы - Строка - адрес хранилища, куда помещается сформированный файл.
//
Функция НапечататьСогласиеНаОбработкуПерсональныхДанныхСубъекта(ДокументСсылка, МакетИДанныеОбъекта, ИмяМакета)
	
	ТипМакета				= МакетИДанныеОбъекта.Макеты.ТипыМакетов[ИмяМакета];
	ДвоичныеДанныеМакетов	= МакетИДанныеОбъекта.Макеты.ДвоичныеДанныеМакетов;
	Области					= МакетИДанныеОбъекта.Макеты.ОписаниеОбластей;
	ДанныеОбъекта			= МакетИДанныеОбъекта.Данные[ДокументСсылка][ИмяМакета];
	
	Макет = УправлениеПечатью.ИнициализироватьМакетОфисногоДокумента(ДвоичныеДанныеМакетов[ИмяМакета], ТипМакета, ИмяМакета);
	Если Макет = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	ЗакрытьОкноПечатнойФормы = Ложь;
	Попытка
		ПечатнаяФорма = УправлениеПечатью.ИнициализироватьПечатнуюФорму(ТипМакета, Макет.НастройкиСтраницыМакета, Макет);
		АдресХранилищаПечатнойФормы = "";
		Если ПечатнаяФорма = Неопределено Тогда
			УправлениеПечатью.ОчиститьСсылки(Макет);
			Возврат "";
		КонецЕсли;
		
		// Вывод обычных областей с параметрами.
		Область = УправлениеПечатью.ОбластьМакета(Макет, Области[ИмяМакета]["Заголовок"]);
		УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
		Область = УправлениеПечатью.ОбластьМакета(Макет, Области[ИмяМакета]["НомерДата"]);
		УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
		Область = УправлениеПечатью.ОбластьМакета(Макет, Области[ИмяМакета]["Преамбула"]);
		УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
		Область = УправлениеПечатью.ОбластьМакета(Макет, Области[ИмяМакета]["ОсновнойТекст"]);
		УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
		Область = УправлениеПечатью.ОбластьМакета(Макет, Области[ИмяМакета]["РеквизитыОператора"]);
		УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
		Область = УправлениеПечатью.ОбластьМакета(Макет, Области[ИмяМакета]["РеквизитыСубъекта"]);
		УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
		Область = УправлениеПечатью.ОбластьМакета(Макет, Области[ИмяМакета]["Подпись"]);
		УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
					
		АдресХранилищаПечатнойФормы = УправлениеПечатью.СформироватьДокумент(ПечатнаяФорма);
	Исключение
		ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗакрытьОкноПечатнойФормы = Истина;
		Возврат "";
	КонецПопытки;
	
	УправлениеПечатью.ОчиститьСсылки(ПечатнаяФорма, ЗакрытьОкноПечатнойФормы);
	УправлениеПечатью.ОчиститьСсылки(Макет);
	
	Возврат АдресХранилищаПечатнойФормы;
	
КонецФункции

Функция ОписаниеОбластейМакетаОфисногоДокумента()
	
	ОписаниеОбластей = Новый Структура;
	
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "Заголовок",			"Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "НомерДата",			"Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "Преамбула",			"Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "ОсновнойТекст",		"Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "РеквизитыОператора",	"Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "РеквизитыСубъекта",	"Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "Подпись",				"Общая");
	
	Возврат ОписаниеОбластей;
	
КонецФункции

#КонецОбласти

#КонецЕсли