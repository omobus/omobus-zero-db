/* This file is a part of the omobus-zero-db project.
 * Copyright (c) 2006 - 2018 ak-obs, Ltd. <info@omobus.net>.
 * All rights reserved.
 *
 * This program is a free software. Redistribution and use in source
 * and binary forms, with or without modification, are permitted provided
 * that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. The origin of this software must not be misrepresented; you must
 *    not claim that you wrote the original software.
 *
 * 3. Altered source versions must be plainly marked as such, and must
 *    not be misrepresented as being the original software.
 *
 * 4. The name of the author may not be used to endorse or promote
 *    products derived from this software without specific prior written
 *    permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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

delete from receipt_types;
insert into receipt_types(receipt_type_id, descr) values('0', 'Основной платеж');
insert into receipt_types(receipt_type_id, descr) values('1', 'Платеж по второй схеме');

delete from reclamation_types;
insert into reclamation_types(reclamation_type_id, descr) values('0', 'Повреждение упаковки');
insert into reclamation_types(reclamation_type_id, descr) values('1', 'Нарушение комплектации');
insert into reclamation_types(reclamation_type_id, descr) values('2', 'Брак');
insert into reclamation_types(reclamation_type_id, descr) values('3', 'Истек срок годности');

delete from service_types;
insert into service_types(service_type_id, descr) values('0', 'Самообслуживание');
insert into service_types(service_type_id, descr) values('1', 'Через прилавок');

delete from testing_scores;
insert into testing_scores(testing_score_id, descr, score, wf) values('0', '<b>Оценка: 0 баллов</b> (имеются серьезные недостатки)', 0, 0);
insert into testing_scores(testing_score_id, descr, score, wf) values('1', '<b>Оценка: 1 балл</b> (имеются незначительные недостатки)', 1, 0.5);
insert into testing_scores(testing_score_id, descr, score, wf) values('2', '<b>Оценка: 2 балла</b> (недостатки не обнаружены)', 2, 1);

delete from working_hours;
insert into working_hours(working_hours_id, descr) values('00:00-24:00', 'Круглосуточно');
insert into working_hours(working_hours_id, descr) values('07:00-21:00', 'с 7:00 до 21:00');
insert into working_hours(working_hours_id, descr) values('08:00-22:00', 'с 8:00 до 22:00');

go
