///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ДанныеЗаполнения <> Неопределено Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия")
			И ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее") Тогда
				ЗаполнитьНаОснованииЭлектронноеПисьмоИсходящее(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
		ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда 
				ЗаполнитьНаОснованииСтруктуры(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНаОснованииЭлектронноеПисьмоИсходящее(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТемаПисьма                             = ДанныеЗаполнения.Тема;
	ТекстШаблонаПисьмаHTML                 = ДанныеЗаполнения.ТекстHTML;
	ТекстШаблонаПисьма                     = ДанныеЗаполнения.Текст;
	ТемаПисьма                             = ДанныеЗаполнения.Тема;
	Наименование                           = ДанныеЗаполнения.Тема;
	ПредназначенДляЭлектронныхПисем        = Истина;
	ПредназначенДляSMS                     = Ложь;
	ПолноеИмяТипаПараметраВводаНаОсновании = НСтр("ru='Общий'");
	ТипТекстаПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.ОбычныйТекст;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		МодульРаботаСПочтовымиСообщениямиСлужебный = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениямиСлужебный");
		ТипыТекстовЭлектронныхПисемHTML = МодульРаботаСПочтовымиСообщениямиСлужебный.ТипТекстовЭлектронныхПисем("HTML");
		ТипыТекстовЭлектронныхПисемHTMLСКартинками = МодульРаботаСПочтовымиСообщениямиСлужебный.ТипТекстовЭлектронныхПисем("HTMLСКартинками");
		
		Если ДанныеЗаполнения.ТипТекста = ТипыТекстовЭлектронныхПисемHTML
			ИЛИ ДанныеЗаполнения.ТипТекста = ТипыТекстовЭлектронныхПисемHTMLСКартинками Тогда
			ТипТекстаПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML;
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииСтруктуры(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ПараметрыШаблона = ШаблоныСообщений.ОписаниеПараметровШаблона();
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ПараметрыШаблона, ДанныеЗаполнения, Истина);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыШаблона);
	ФорматВложений = Новый ХранилищеЗначения(ПараметрыШаблона.ФорматыВложений);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ПредназначенДляSMS")
		И ДанныеЗаполнения.ПредназначенДляSMS Тогда
			ПараметрыШаблона.ТипШаблона = "SMS";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыШаблона.ВнешняяОбработка) Тогда
		ШаблонПоВнешнейОбработке = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыШаблона.ПолноеИмяТипаНазначения) Тогда
		МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ПараметрыШаблона.ПолноеИмяТипаНазначения);
		ПолноеИмяТипаПараметраВводаНаОсновании = ПараметрыШаблона.ПолноеИмяТипаНазначения;
		Назначение= МетаданныеОбъекта.Представление();
		ПредназначенДляВводаНаОсновании = Истина;
	КонецЕсли;
	
	Если ПараметрыШаблона.ТипШаблона = "Письмо" Тогда
		
		ПредназначенДляSMS              = Ложь;
		ПредназначенДляЭлектронныхПисем = Истина;
		ТемаПисьма                      = ПараметрыШаблона.Тема;
		
		Если ПараметрыШаблона.ФорматПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML Тогда
			ТекстШаблонаПисьмаHTML = СтрЗаменить(ПараметрыШаблона.Текст, Символы.ПС, "<BR>");
			ТипТекстаПисьма        = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML;
		Иначе
			ТекстШаблонаПисьма = СтрЗаменить(ПараметрыШаблона.Текст, "<BR>", Символы.ПС);
			ТипТекстаПисьма    = Перечисления.СпособыРедактированияЭлектронныхПисем.ОбычныйТекст;
		КонецЕсли;
		
	ИначеЕсли ПараметрыШаблона.ТипШаблона = "SMS" Тогда
		
		ПредназначенДляSMS              = Истина;
		ПредназначенДляЭлектронныхПисем = Ложь;
		ТекстШаблонаSMS                 = ПараметрыШаблона.Текст;
		ОтправлятьВТранслите            = ПараметрыШаблона.ПеревестиВТранслит;
		
	ИначеЕсли ПараметрыШаблона.ТипШаблона = "Общий" Тогда
		
		ПредназначенДляSMS              = Ложь;
		ПредназначенДляЭлектронныхПисем = Ложь;
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли