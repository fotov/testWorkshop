///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// Позволяет открыть внешний отчет или обработку под произвольным пользователем
	// в обычном (не безопасном режиме) для целей тестирования.
	НачатьПомещениеФайла(Новый ОписаниеОповещения("ОбработкаКомандыПослеПомещенияФайла", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаКомандыПослеПомещенияФайла(Результат, Адрес, ВыбранноеИмяФайла, Контекст) Экспорт
	
	Если Не ЗначениеЗаполнено(Адрес) Тогда
		Возврат;
	КонецЕсли;
	
	СвойстваФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ВыбранноеИмяФайла);
	
	Если НРег(СвойстваФайла.Расширение) = НРег(".epf") Тогда
		ЭтоВнешняяОбработка = Истина;
		
	ИначеЕсли НРег(СвойстваФайла.Расширение) = НРег(".erf") Тогда
		ЭтоВнешняяОбработка = Ложь;
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Выбранный файл не является внешним отчетом или обработкой.'"));
		Возврат;
	КонецЕсли;
	
	ИмяВнешнегоОбъекта = СоздатьВнешнийОтчетИлиОбработку(Адрес, ЭтоВнешняяОбработка, СвойстваФайла.Имя);
	
	Если ЭтоВнешняяОбработка Тогда
		ИмяФормы = "ВнешняяОбработка." + ИмяВнешнегоОбъекта + ".Форма";
	Иначе
		ИмяФормы = "ВнешнийОтчет." + ИмяВнешнегоОбъекта + ".Форма";
	КонецЕсли;
	
	ОткрытьФорму(ИмяФормы);
	
КонецПроцедуры

&НаСервере
Функция СоздатьВнешнийОтчетИлиОбработку(Адрес, ЭтоВнешняяОбработка, ИмяФайла)
	
	Если ЭтоВнешняяОбработка Тогда
		Менеджер = ВнешниеОбработки;
	Иначе
		Менеджер = ВнешниеОтчеты;
	КонецЕсли;
	
	ИмяВнешнегоОбъекта = Менеджер.Подключить(Адрес, , Ложь); // Только для целей тестирования.
	Менеджер.Создать(ИмяВнешнегоОбъекта);
	
	Возврат ИмяВнешнегоОбъекта;
	
КонецФункции

#КонецОбласти
