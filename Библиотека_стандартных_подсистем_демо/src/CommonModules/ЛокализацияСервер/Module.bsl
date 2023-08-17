///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает метаданные по коду языка конфигурации.
//
// Параметры:
//   КодЯзыка - Строка - код языка, например "en" (как задано в свойстве КодЯзыка метаданных ОбъектМетаданных: Язык).
//
// Возвращаемое значение:
//   ОбъектМетаданных: Язык - если найден по переданному коду языка, иначе Неопределено.
//   
Функция ЯзыкПоКоду(Знач КодЯзыка) Экспорт
	Для каждого Язык Из Метаданные.Языки Цикл
		Если Язык.КодЯзыка = КодЯзыка Тогда
			Возврат Язык;
		КонецЕсли;	
	КонецЦикла;
	Возврат Неопределено;
КонецФункции	

// Вызывается из обработчика ПриСозданииНаСервере формы объекта для отображения кнопки открытия для локализуемых элементов,
// нажатие на которую открывает форму ввода значения реквизита на разных языках.
//
// Параметры:
//  ЛокализуемыеЭлементыФормы - ПолеВвода, Массив - Элементы формы, у которых необходимо вывести кнопку открытия.
//
Процедура ПриСозданииНаСервере(ЛокализуемыеЭлементыФормы) Экспорт
	
	Если Метаданные.Языки.Количество() < 2 Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ЛокализуемыеЭлементыФормы) = Тип("Массив") Тогда
		Для каждого ЛокализуемыйЭлемент Из ЛокализуемыеЭлементыФормы Цикл
			ЛокализуемыйЭлемент.КнопкаОткрытия = Истина;
		КонецЦикла;
	Иначе
		ЛокализуемыеЭлементыФормы.КнопкаОткрытия = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Вызывается из обработчика ПриЧтениеНаСервере формы объекта для заполнения значений реквизитов формы
// в зависимости от языка, используемого при работе пользователя.
//
// Параметры:
//  Форма         - УправляемаяФорма - Форма объекта.
//  ТекущийОбъект - Произвольный - Объект, который был получен в обработчике формы ПриЧтенииНаСервере.
//
Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	ТекущийОбъект.ПриЧтенииПредставленийНаСервере();
	Форма.ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	
КонецПроцедуры

// Вызывается из модуля объекта для установки значений у локализуемых реквизитов объекта
// в зависимости от языка, используемого при работе пользователя.
//
// Параметры:
//  Объект - Произвольный - объект данных.
//
Процедура ПриЧтенииПредставленийНаСервере(Объект) Экспорт
	
	Если ТекущийЯзык() = Метаданные.ОсновнойЯзык Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Реквизит Из Объект.Метаданные().ТабличныеЧасти.Представления.Реквизиты Цикл
		
		Если СтрСравнить(Реквизит.Имя, "КодЯзыка") = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяРеквизита = Реквизит.Имя;
		
		Отбор = Новый Структура();
		Отбор.Вставить("КодЯзыка", ОбщегоНазначения.КодОсновногоЯзыка());
		НайденныеСтроки = Объект.Представления.НайтиСтроки(Отбор);
	
		Если НайденныеСтроки.Количество() > 0 Тогда
			Представление = НайденныеСтроки[0];
		Иначе
			Представление = Объект.Представления.Добавить();
			Представление.КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
		КонецЕсли;
		Представление[ИмяРеквизита] = Объект[ИмяРеквизита];
		
		Отбор = Новый Структура();
		Отбор.Вставить("КодЯзыка", ТекущийЯзык().КодЯзыка);
		НайденныеСтроки = Объект.Представления.НайтиСтроки(Отбор);
		
		Если НайденныеСтроки.Количество() > 0 И ЗначениеЗаполнено(НайденныеСтроки[0][ИмяРеквизита]) Тогда
			Объект[ИмяРеквизита] = НайденныеСтроки[0][ИмяРеквизита];
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Вызывается из обработчика ПередЗаписьюНаСервере формы объекта или при программной записи объекта
// для установки значений реквизитов формы в зависимости от языка, используемого при работе пользователя.
//
// Параметры:
//  ТекущийОбъект - Произвольный - Записываемый объект.
//
Процедура ПередЗаписьюНаСервере(ТекущийОбъект) Экспорт
	
	Если ТекущийЯзык() = Метаданные.ОсновнойЯзык Тогда
		Возврат;
	КонецЕсли;
	
	Реквизиты = Новый Массив;
	Для каждого Реквизит Из ТекущийОбъект.Ссылка.Метаданные().ТабличныеЧасти.Представления.Реквизиты Цикл
		Если СтрСравнить(Реквизит.Имя, "КодЯзыка") = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Реквизиты.Добавить(Реквизит.Имя);
	КонецЦикла;
	
	Отбор = Новый Структура();
	Отбор.Вставить("КодЯзыка", ТекущийЯзык().КодЯзыка);
	НайденныеСтроки = ТекущийОбъект.Представления.НайтиСтроки(Отбор);
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		Представление = НайденныеСтроки[0];
	Иначе
		Представление = ТекущийОбъект.Представления.Добавить();
		Представление.КодЯзыка = ТекущийЯзык().КодЯзыка;
	КонецЕсли;
	
	Для каждого ИмяРеквизита Из Реквизиты Цикл
		Представление[ИмяРеквизита] = ТекущийОбъект[ИмяРеквизита];
	КонецЦикла;
	
	Отбор.КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	НайденныеСтроки = ТекущийОбъект.Представления.НайтиСтроки(Отбор);
	Если НайденныеСтроки.Количество() > 0 Тогда
		Для каждого ИмяРеквизита Из Реквизиты Цикл
			ТекущийОбъект[ИмяРеквизита] = НайденныеСтроки[0][ИмяРеквизита];
		КонецЦикла;
		ТекущийОбъект.Представления.Удалить(НайденныеСтроки[0]);
	КонецЕсли;
	
	ТекущийОбъект.Представления.Свернуть("КодЯзыка", СтрСоединить(Реквизиты, ","));
	
КонецПроцедуры

#КонецОбласти