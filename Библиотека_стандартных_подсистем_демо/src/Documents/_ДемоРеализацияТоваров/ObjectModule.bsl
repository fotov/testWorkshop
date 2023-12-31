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
	Если ДанныеЗаполнения = Неопределено Тогда // Ввод нового.
		_ДемоСтандартныеПодсистемы.ПриВводеНовогоЗаполнитьОрганизацию(ЭтотОбъект, "ГоловнаяОрганизация");
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	СформироватьДвиженияПоМестамХранения();
	
	СформироватьБухгалтерскиеДвижения();
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	Префикс = "А";
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
//

Процедура СформироватьДвиженияПоМестамХранения()
	
	Движения._ДемоОстаткиТоваровВМестахХранения.Записывать = Истина;
	
	Для Каждого СтрокаТовары Из Товары Цикл
		
		Движение = Движения._ДемоОстаткиТоваровВМестахХранения.Добавить();
		
		Движение.Период        = Дата;
		Движение.ВидДвижения   = ВидДвиженияНакопления.Расход;
		
		Движение.Организация   = ГоловнаяОрганизация;
		Движение.МестоХранения = МестоХранения;
		
		Движение.Номенклатура  = СтрокаТовары.Номенклатура;
		Движение.Количество    = СтрокаТовары.Количество;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СформироватьБухгалтерскиеДвижения()
	
	ВалютныйДокумент = Валюта.Код <> "643";
	Если Валюта.Пустая() Тогда
		ВалютаДокумента  = Новый Структура("Курс, Кратность", 1, 1,);
	Иначе
		ВалютаДокумента  = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Валюта, Дата);
	КонецЕсли;
	
	ОбрабатыватьНДС = ПолучитьФункциональнуюОпцию("_ДемоУчитыватьНДС") И Не ВалютныйДокумент;
	
	Движения._ДемоОсновной.Записывать = Истина;
	
	Для Каждого СтрокаТовара Из Товары Цикл
		
		ДвижениеРеализацииТовара(СтрокаТовара, ВалютныйДокумент, ВалютаДокумента);
		
		Если ОбрабатыватьНДС Тогда
			ДвижениеУчетаНачисленногоНДС(СтрокаТовара);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДвижениеРеализацииТовара(Знач СтрокаТовара, Знач ВалютныйУчет, Знач ВалютаДокумента)
	
	ВалютнаяСумма = СтрокаТовара.Цена * СтрокаТовара.Количество;
	РублеваяСумма = ВалютнаяСумма * ВалютаДокумента.Курс / ВалютаДокумента.Кратность;
	
	НоменклатурнаяГруппа = СтрокаТовара.Номенклатура.ВидНоменклатуры;
	
	// ---
	Движение = Движения._ДемоОсновной.Добавить();
	Движение.Период      = Дата;
	Движение.Организация = ГоловнаяОрганизация;
	Движение.Содержание  = НСтр("ru = 'Реализация товаров'");
	Движение.Сумма       = РублеваяСумма;
	
	Если ВалютныйУчет Тогда
		Движение.СчетДт          = ПланыСчетов._ДемоОсновной.РасчетыСПокупателямиВал;
		Движение.ВалютаДт        = Валюта;
		Движение.ВалютнаяСуммаДт = ВалютнаяСумма;
	Иначе
		Движение.СчетДт = ПланыСчетов._ДемоОсновной.РасчетыСПокупателями;
	КонецЕсли;
	
	Движение.СубконтоДт.Контрагенты = Контрагент;
	Движение.СубконтоДт.Договоры    = Договор;
	
	Движение.СчетКт = ПланыСчетов._ДемоОсновной.Выручка;
	Движение.СубконтоКт.НоменклатурныеГруппы = НоменклатурнаяГруппа;
	
	Если Не ВалютныйУчет Тогда
		Движение.СубконтоКт.СтавкиНДС = СтавкаНДС;
	КонецЕсли;
	
	// ---
	Движение = Движения._ДемоОсновной.Добавить();
	Движение.Период      = Дата;
	Движение.Организация = ГоловнаяОрганизация;
	Движение.Содержание  = НСтр("ru = 'Реализация товаров'");
	Движение.Сумма       = РублеваяСумма;
	
	Движение.СчетДт = ПланыСчетов._ДемоОсновной.СебестоимостьПродаж;
	Движение.СубконтоДт.НоменклатурныеГруппы = НоменклатурнаяГруппа;
	
	Движение.СчетКт = ПланыСчетов._ДемоОсновной.ТоварыНаСкладах;
	
	Движение.СубконтоКт.Контрагенты  = Контрагент;
	Движение.СубконтоКт.Номенклатура = СтрокаТовара.Номенклатура;
	Движение.СубконтоКт.Склады       = МестоХранения;
	
	Движение.КоличествоКт = СтрокаТовара.Количество;
	
КонецПроцедуры

Процедура ДвижениеУчетаНачисленногоНДС(Знач СтрокаТовара)
	
	РублеваяСумма = СтрокаТовара.Цена * СтрокаТовара.Количество;
	СуммаНДС = РублеваяСумма / 100 * СтавкаНДС.Ставка;
	
	НоменклатурнаяГруппа = СтрокаТовара.Номенклатура.ВидНоменклатуры;	
	
	Движение = Движения._ДемоОсновной.Добавить();
	Движение.Период      = Дата;
	Движение.Организация = ГоловнаяОрганизация;
	Движение.Содержание  = НСтр("ru = 'Реализация товаров'");
	Движение.Сумма       = СуммаНДС;
	
	Движение.СчетДт = ПланыСчетов._ДемоОсновной.Продажи_НДС;
	Движение.СубконтоДт.НоменклатурныеГруппы = НоменклатурнаяГруппа;
	
	Движение.СчетКт = ПланыСчетов._ДемоОсновной.НДС;
	Движение.СубконтоКт.ВидыПлатежейВБюджет = Перечисления._ДемоВидыПлатежейВБюджет.Налог;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли