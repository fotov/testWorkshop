///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет настройки подсистемы.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы:
//   * ДоступноПолучениеПисем - Булево - показывать настройки получения писем в учетных записях.
//                                       Значение по умолчанию: для базовых версий конфигурации - Ложь,
//                                       для остальных - Истина.
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
КонецПроцедуры

// Позволяет выполнить дополнительные операции после отправки почтового сообщения.
//
// Параметры:
//  ПараметрыПисьма - Структура - содержит всю необходимую информацию о письме:
//   * Кому      - Массив - (обязательный) интернет-адрес получателя письма.
//                 Адрес         - строка - почтовый адрес.
//                 Представление - строка - имя адресата.
//
//   * ПолучателиСообщения - Массив - массив структур, описывающий получателей:
//                            * ИсточникКонтактнойИнформации - СправочникСсылка - владелец контактной информации.
//                            * Адрес - Строка - почтовый адрес получателя сообщения.
//                            * Представление - Строка - представление адресата.
//
//   * Копии      - Массив - коллекция структур адресов:
//                   * Адрес         - строка - почтовый адрес (должно быть обязательно заполнено).
//                   * Представление - строка - имя адресата.
//                  
//                - Строка - интернет-адреса получателей письма, разделитель - ";".
//
//   * СкрытыеКопии - Массив, Строка - см. описание поля Копии.
//
//   * Тема       - Строка - (обязательный) тема почтового сообщения.
//   * Тело       - Строка - (обязательный) текст почтового сообщения (простой текст в кодировке win-1251).
//   * Важность   - ВажностьИнтернетПочтовогоСообщения.
//   * Вложения   - Соответствие - список вложений, где:
//                   * ключ     - Строка - наименование вложения
//                   * значение - ДвоичныеДанные, АдресВоВременномХранилище - данные вложения;
//                              - Структура -    содержащая следующие свойства:
//                                 * ДвоичныеДанные - ДвоичныеДанные - двоичные данные вложения.
//                                 * Идентификатор  - Строка - идентификатор вложения, используется для хранения картинок,
//                                                             отображаемых в теле письма.
//
//   * АдресОтвета - Соответствие - см. описание поля Кому.
//   * Пароль      - Строка - пароль для доступа к учетной записи.
//   * ИдентификаторыОснований - Строка - идентификаторы оснований данного письма.
//   * ОбрабатыватьТексты  - Булево - необходимость обрабатывать тексты письма при отправке.
//   * УведомитьОДоставке  - Булево - необходимость запроса уведомления о доставке.
//   * УведомитьОПрочтении - Булево - необходимость запроса уведомления о прочтении.
//   * ТипТекста   - Строка, Перечисление.ТипыТекстовЭлектронныхПисем, ТипТекстаПочтовогоСообщения - определяет тип
//                  переданного теста допустимые значения:
//                  HTML/ТипыТекстовЭлектронныхПисем.HTML - текст почтового сообщения в формате HTML;
//                  ПростойТекст/ТипыТекстовЭлектронныхПисем.ПростойТекст - простой текст почтового сообщения.
//                                                                          Отображается "как есть" (значение по
//                                                                          умолчанию);
//                  РазмеченныйТекст/ТипыТекстовЭлектронныхПисем.РазмеченныйТекст - текст почтового сообщения в формате
//                                                                                  Rich Text.
//
Процедура ПослеОтправкиПисьма(ПараметрыПисьма) Экспорт
	
	// _Демо начало примера
	
	// Добавление введенного вручную адреса электронной почты в контактную информацию партнера.
	
	Если Не ПараметрыПисьма.Свойство("ПолучателиСообщения") Или Не ПараметрыПисьма.Свойство("Кому") Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыПисьма.ПолучателиСообщения.Количество() <> 1 Тогда
		Возврат;
	КонецЕсли;
	
	Ссылка = ПараметрыПисьма.ПолучателиСообщения[0].ИсточникКонтактнойИнформации;
	Если ТипЗнч(Ссылка) <> Тип("СправочникСсылка._ДемоПартнеры") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("Изменение", Метаданные.Справочники._ДемоПартнеры) Тогда
		Возврат;
	КонецЕсли;
	
	Объект = Ссылка.ПолучитьОбъект();
	ОбъектМодифицирован = Ложь;
	Для Каждого Адресат Из ПараметрыПисьма.Кому Цикл
		ЗначениеЭлектроннойПочты = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(Адресат.Адрес, УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("_ДемоEmailПартнера"));
		УправлениеКонтактнойИнформацией.ЗаписатьКонтактнуюИнформацию(Объект, ЗначениеЭлектроннойПочты,
			УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("_ДемоEmailПартнера"), Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
		ОбъектМодифицирован = Истина;
	КонецЦикла;
	
	Если ОбъектМодифицирован Тогда
		Попытка
			Объект.Записать();
		Исключение
			// Действие не требуется.
		КонецПопытки
	КонецЕсли;
	
	// _Демо конец примера
	
КонецПроцедуры

#КонецОбласти
