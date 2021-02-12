/* Copyright (c) 2006 - 2021 omobus-zero-db authors, see the included COPYRIGHT file. */

delete from addition_types;
insert into addition_types(addition_type_id, descr) values('0', 'Готов подписать договор');
insert into addition_types(addition_type_id, descr) values('1', 'Договор подписан');
insert into addition_types(addition_type_id, descr) values('2', 'Только устная договоренность');
insert into addition_types(addition_type_id, descr) values('3', 'Оставил ПРАЙС');
insert into addition_types(addition_type_id, descr) values('4', 'Отказался');
insert into addition_types(addition_type_id, descr) values('5', 'Зайти позже');

delete from audit_scores;
insert into audit_scores(audit_score_id, descr, score, wf) values('0', '<b>Оценка: 0 баллов</b> (имеются серьезные недостатки)', 0, 0);
insert into audit_scores(audit_score_id, descr, score, wf) values('1', '<b>Оценка: 1 балл</b> (имеются незначительные недостатки)', 1, 0.5);
insert into audit_scores(audit_score_id, descr, score, wf) values('2', '<b>Оценка: 2 балла</b> (недостатки не обнаружены)', 2, 1);

delete from canceling_types;
insert into canceling_types(canceling_type_id, descr) values('0', 'Болезнь');
insert into canceling_types(canceling_type_id, descr) values('1', 'Отпуск');

delete from comment_types;
insert into comment_types(comment_type_id, descr, min_note_length, row_no) values('0', 'Объяснение (не менее 5 символов)', 5, 0);
--insert into comment_types(comment_type_id, descr, photo_needed, row_no) values('1', 'Подтверждение факта посещения (требуется фото)', 1, 1);
insert into comment_types(comment_type_id, descr, photo_needed) values('2', 'Торговая точка закрыта на учет (требуется фото)', 1);
insert into comment_types(comment_type_id, descr, photo_needed) values('3', 'Торговая точка закрыта на ремонт (требуется фото)', 1);
insert into comment_types(comment_type_id, descr) values('4', 'Дебиторская задолженность');
insert into comment_types(comment_type_id, descr) values('5', 'Ответственное лицо отсутствует');

delete from delivery_types;
insert into delivery_types(delivery_type_id, descr) values('0', 'Доставка поставщиком');
insert into delivery_types(delivery_type_id, descr) values('1', 'Самовывоз заказчиком');

delete from discard_types;
insert into discard_types(discard_type_id, descr) values('0', 'Дебиторская задолженность');
insert into discard_types(discard_type_id, descr) values('1', 'Торговая точка закрыта на ремонт');
insert into discard_types(discard_type_id, descr) values('2', 'Больше не работает с дистрибутором');

delete from job_titles;
insert into job_titles(job_title_id, descr) values('0', 'Заведующий');
insert into job_titles(job_title_id, descr) values('1', 'Фармацевт');

delete from oos_types;
insert into oos_types(oos_type_id, descr, row_no) values('0', 'Мало продукции в наличии (1-2 шт)', 0);
insert into oos_types(oos_type_id, descr, row_no) values('1', 'Продукт заблокирован для заказа', 1);
insert into oos_types(oos_type_id, descr, row_no) values('2', 'Виртуальные остатки, а именно товара нет в наличии, но по базе они присутствуют', 2);
insert into oos_types(oos_type_id, descr, row_no) values('3', 'Продукn заказан или ожидается поставка', 3);
insert into oos_types(oos_type_id, descr, row_no) values('4', 'Продукт на складе, требуется мерчендайзинг', 4);
insert into oos_types(oos_type_id, descr, row_no) values('5', 'Не выяснил(-а) причину Out-of-Stock', 5);
insert into oos_types(oos_type_id, descr) values('9', 'ДРУГОЕ');

delete from order_types;
insert into order_types(order_type_id, descr, row_no) values('0', 'Основной');
insert into order_types(order_type_id, descr) values('1', 'Бонусный');

delete from payment_methods;
insert into payment_methods(payment_method_id, descr, row_no) values('0', 'Безналичная оплата', 0);
insert into payment_methods(payment_method_id, descr, row_no) values('1', 'Оплата наличными', 1);
insert into payment_methods(payment_method_id, descr, row_no, encashment) values('2', 'Оплата наличными (фиксированная сумма)', 2, 1);
insert into payment_methods(payment_method_id, descr, row_no) values('3', 'Оплата наличными (точно по сумме документа)', 3);

delete from pending_types;
insert into pending_types(pending_type_id, descr) values('0', 'Отсутствует контактное лицо');
insert into pending_types(pending_type_id, descr) values('1', 'Торговая точка закрыта на ремонт');
insert into pending_types(pending_type_id, descr) values('2', 'Ревизия в торговой точке');

delete from photo_types;
insert into photo_types(photo_type_id, descr, row_no) values('0', 'Основное фото', 0);
insert into photo_types(photo_type_id, descr, row_no) values('b', 'ДО', 1);
insert into photo_types(photo_type_id, descr, row_no) values('a', 'ПОСЛЕ', 2);
insert into photo_types(photo_type_id, descr, row_no) values('1', 'Конкуренты', 90);

delete from placements;
insert into placements(placement_id, descr, row_no) values('0', 'ПОЛКА (основная выкладка)', 0);
insert into placements(placement_id, descr, row_no) values('1', 'Полка на торце', 1);
insert into placements(placement_id, descr, row_no) values('2', 'Бренд-полка', 2);
insert into placements(placement_id, descr, row_no) values('3', 'Паллета', 3);
insert into placements(placement_id, descr) values('4', 'Горячая (прикассовая) зона');

delete from rating_scores;
insert into rating_scores(rating_score_id, descr, score, wf) values('0', '<b>Оценка: 0 баллов</b> (имеются серьезные недостатки)', 0, 0);
insert into rating_scores(rating_score_id, descr, score, wf) values('1', '<b>Оценка: 1 балл</b> (имеются незначительные недостатки)', 1, 0.5);
insert into rating_scores(rating_score_id, descr, score, wf) values('2', '<b>Оценка: 2 балла</b> (недостатки не обнаружены)', 2, 1);

delete from reclamation_types;
insert into reclamation_types(reclamation_type_id, descr) values('0', 'Повреждение упаковки');
insert into reclamation_types(reclamation_type_id, descr) values('1', 'Нарушение комплектации');
insert into reclamation_types(reclamation_type_id, descr) values('2', 'Брак');
insert into reclamation_types(reclamation_type_id, descr) values('3', 'Истек срок годности');

go
