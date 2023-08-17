///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует список шаблонов заданий очереди.
//
// Параметры:
//  ШаблоныЗаданий - Массив - В параметр следует добавить имена предопределенных
//   неразделенных регламентных заданий, которые должны использоваться в качестве
//   шаблонов для заданий очереди.
//
Процедура ПриПолученииСпискаШаблонов(ШаблоныЗаданий) Экспорт
	
	// _Демо начало примера
	ИнтернетПоддержкаПользователей.ПриПолученииСпискаШаблонов(ШаблоныЗаданий);
	// _Демо конец примера
	
КонецПроцедуры

// Заполняет соответствие имен методов их псевдонимам для вызова из очереди заданий.
//
// Параметры:
//  СоответствиеИменПсевдонимам - Соответствие - 
//    * Ключ - Псевдоним метода, например ОчиститьОбластьДанных.
//    * Значение - Имя метода для вызова, например РаботаВМоделиСервиса.ОчиститьОбластьДанных.
//        В качестве значения можно указать Неопределено, в этом случае считается что имя 
//        совпадает с псевдонимом.
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	// _Демо начало примера
	ИнтернетПоддержкаПользователей.ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам);
	// _Демо конец примера
	
КонецПроцедуры

// Заполняет соответствие методов обработчиков ошибок псевдонимам методов, при возникновении
// ошибок в которых они вызываются.
//
// Параметры:
//  ОбработчикиОшибок - Соответствие -
//    * Ключ - Псевдоним метода, например ОчиститьОбластьДанных.
//    * Значение - Имя метода - обработчика ошибок, для вызова при возникновении ошибки. 
//        Обработчик ошибок вызывается в случае завершения выполнения исходного задания
//        с ошибкой. Обработчик ошибок вызывается в той же области данных, что и исходное задание.
//        Метод обработчика ошибок считается разрешенным к вызову механизмами очереди.
//        Параметры обработчика ошибок:
//          ПараметрыЗадания - Структура - параметры задания очереди.
//          Параметры
//          НомерПопытки
//          КоличествоПовторовПриАварийномЗавершении
//          ДатаНачалаПоследнегоЗапуска.
//
Процедура ПриОпределенииОбработчиковОшибок(ОбработчикиОшибок) Экспорт
	
КонецПроцедуры

// Формирует таблицу регламентных заданий с признаком использования в модели сервиса.
//
// Параметры:
//  ТаблицаИспользования - ТаблицаЗначений - таблица значений с колонками:
//    * РегламентноеЗадание - Строка - имя предопределенного регламентного задания,
//    * Использование - Булево - Истина, если регламентное задание должно
//       выполняться в модели сервиса, Ложь - если не должно.
//
Процедура ПриОпределенииИспользованияРегламентныхЗаданий(ТаблицаИспользования) Экспорт
	
КонецПроцедуры

#КонецОбласти
