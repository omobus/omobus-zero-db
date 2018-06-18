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

/* ** omobus-zero-db database schema.
 * **
 */

set QUOTED_IDENTIFIER on
go
create login omobus with password = '0'
go
create user omobus for login omobus
go
create database "omobus-zero-db"
go
use "omobus-zero-db"
go
sp_changedbowner 'omobus'
go
alter database "omobus-zero-db" set ANSI_NULL_DEFAULT on
alter database "omobus-zero-db" set ANSI_NULLS on
alter database "omobus-zero-db" set ANSI_PADDING on
alter database "omobus-zero-db" set QUOTED_IDENTIFIER on
alter database "omobus-zero-db" set concat_null_yields_null on
go
alter database "omobus-zero-db" set RECOVERY SIMPLE
go
-- **** mssql 2005 and higher ****
alter database "omobus-zero-db" set ALLOW_SNAPSHOT_ISOLATION on
go

-- **** domains ****

execute sp_addtype address_t, 'varchar(256)'
execute sp_addtype art_t, 'varchar(24)'
execute sp_addtype blob_t, 'varchar(32)'
execute sp_addtype blobs_t, 'varchar(2048)'
execute sp_addtype bool_t, 'smallint'
execute sp_addtype code_t, 'varchar(24)'
execute sp_addtype codes_t, 'varchar(2048)'
execute sp_addtype color_t, 'int'
execute sp_addtype country_t, 'varchar(2)'
execute sp_addtype countries_t, 'varchar(256)'
execute sp_addtype currency_t, 'numeric(18,4)'
execute sp_addtype date_t, 'varchar(10)'
execute sp_addtype datetime_t, 'varchar(19)'
execute sp_addtype datetimetz_t, 'varchar(32)'
execute sp_addtype descr_t, 'varchar(256)'
execute sp_addtype doctype_t, 'varchar(24)'
execute sp_addtype double_t, 'float'
execute sp_addtype discount_t, 'numeric(5,2)'
execute sp_addtype email_t, 'varchar(254)'
execute sp_addtype emails_t, 'varchar(4096)'
execute sp_addtype ftype_t, 'smallint'
execute sp_addtype gps_t, 'numeric(10,6)'
execute sp_addtype hostname_t, 'varchar(255)'
execute sp_addtype int32_t, 'int'
execute sp_addtype int64_t, 'bigint'
execute sp_addtype message_t, 'varchar(4096)'
execute sp_addtype note_t, 'varchar(1024)'
execute sp_addtype numeric_t, 'numeric(16,4)'
execute sp_addtype percent_t, 'smallint'
execute sp_addtype phone_t, 'varchar(32)'
execute sp_addtype state_t, 'varchar(8)'
execute sp_addtype time_t, 'char(5)'
execute sp_addtype ts_auto_t, 'datetime'
execute sp_addtype ts_t, 'datetime'
execute sp_addtype uid_t, 'varchar(48)'
execute sp_addtype uids_t, 'varchar(2048)'
execute sp_addtype volume_t, 'numeric(10,6)'
execute sp_addtype weight_t, 'numeric(12,6)'
execute sp_addtype wf_t, 'numeric(3,2)'
go

-- **** ERP -> OMOBUS streams ****

create table accounts (
    account_id 		uid_t 		not null primary key,
    pid 		uid_t 		null,
    code 		code_t 		null,
    ftype 		ftype_t 	not null,
    descr 		descr_t 	not null,
    address 		address_t 	not null,
    chan_id 		uid_t 		null,
    poten_id 		uid_t 		null,
    rc_id 		uid_t 		null, /* -> retail_chains */
    region_id 		uid_t 		null,
    city_id 		uid_t 		null,
    class 		varchar(10) 	null check (class in ('outlet','pharmacy','hospital','conference') and class=lower(class))
    --locked 		bool_t 		null
);

create table account_params (
    distr_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    group_price_id 	uid_t 		null,
    locked 		bool_t 		null,
    payment_delay 	int32_t 	null,
    payment_method_id 	uid_t 		null,
    wareh_ids 		uids_t 		null,
    primary key (distr_id, account_id)
);

create table account_prices (
    distr_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    pack_id 		uid_t 		not null,
    price 		currency_t 	not null,
    primary key (distr_id, account_id, prod_id)
);

create table addition_types (
    addition_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null
);

create table agencies (
    agency_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null
);

create table agreements (
    account_id 		uid_t 		not null,
    placement_id 	uid_t 		not null,
    posm_id 		uid_t 		not null,
    b_date 		date_t 		not null,
    e_date 		date_t 		not null,
    strict 		bool_t 		null,
    primary key (account_id, placement_id, posm_id, b_date)
);

create table attributes (
    attr_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null
);

create table audit_criterias ( /* Service-Level-Agreement criterias for the audit document */
    audit_criteria_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    wf 			wf_t 		not null check(wf between 0.01 and 1.00),
    mandatory 		bool_t 		not null,
    extra_info 		note_t 		null,
    row_no 		int32_t 	null -- ordering
);

create table audit_scores (
    audit_score_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    score 		int32_t 	not null,
    wf 			wf_t 		not null check(wf between 0.00 and 1.00),
    mandatory 		bool_t 		not null,
    row_no 		int32_t 	null
);

create table auto_orders (
    distr_id 		uid_t 		not null,
    erp_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    delivery_date 	date_t 		not null,
    prod_id 		uid_t 		not null,
    pack_id 		uid_t 		not null,
    qty 		numeric_t 	not null,
    min_qty 		numeric_t 	not null,
    max_qty 		numeric_t 	not null,
    primary key (distr_id, erp_id, prod_id)
);

create table blacklist (
    distr_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    locked 		bool_t 		null,
    primary key (distr_id, account_id, prod_id)
);

create table brands (
    brand_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null,
    dep_id 		uid_t 		null,
    multi 		uids_t 		null, /* for compound brands: [multi] should contains [brand_id] array */
    competitor 		bool_t 		null,
    row_no 		int32_t 	null
);

create table canceling_types (
    canceling_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null
);

create table categories (
    categ_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null,
    wf 			wf_t 		null check(wf between 0.01 and 1.00), /* Service-Level-Agreement weight for the audit document */
    row_no 		int32_t 	null -- ordering
);

create table channels (
    chan_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null
);

create table cities (
    city_id 		uid_t 		not null primary key,
    pid 		uid_t 		null,
    ftype 		ftype_t 	not null,
    descr 		descr_t 	not null,
    country_id 		uid_t 		not null
);

create table comment_types (
    comment_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    min_note_length 	int32_t 	null,
    photo_needed 	bool_t 		null,
    row_no 		int32_t 	null
);

create table conference_themes (
    ctheme_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null
);

create table confirmation_types (
    confirm_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null,
    target_type_ids 	uids_t 		not null,
    min_note_length 	int32_t 	null,
    photo_needed 	bool_t 		null,
    accomplished 	bool_t 		null
);

create table constants (
    distr_id 		uid_t 		not null,
    const_id 		uid_t 		not null, -- mutuals:date, debts:date, wareh_stocks:date
    value 		varchar(64) 	not null,
    primary key(distr_id, const_id)
);

create table debts (
    distr_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    debt 		currency_t 	not null,
    primary key(distr_id, account_id)
);

create table delivery_types (
    delivery_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null
);

create table departments (
    dep_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null
);

create table discard_types (
    discard_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null
);

create table discounts (
    distr_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    discount 		discount_t 	not null default 0,
    min_discount 	discount_t 	not null,
    max_discount 	discount_t 	not null,
    primary key (distr_id, account_id, prod_id)
);

create table distributors (
    distr_id 		uid_t 		not null primary key,
    pid 		uid_t 		null,
    descr 		descr_t 	not null,
    country_id 		uid_t 		null
);

create table erp_docs (
    doc_id 		uid_t 		not null,
    erp_id 		uid_t 		not null,
    pid 		uid_t 		null, /* parent erp_id */
    erp_no 		uid_t 		not null,
    erp_dt 		datetime_t 	not null,
    amount 		currency_t 	not null,
    status 		int32_t 	not null default 0 check (status between -1 and 1), -- -1 - delete, 0 - normal, 1 - closed
    doc_type 		doctype_t 	not null, -- order, reclamation, contract, shipment, return, movement
    primary key (doc_id, erp_id)
);

create table erp_products (
    doc_id 		uid_t 		not null,
    erp_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    pack_id 		uid_t 		not null,
    qty 		numeric_t 	not null,
    discount 		discount_t 	not null,
    amount 		currency_t 	not null,
    primary key (doc_id, erp_id, prod_id)
);

create table floating_prices (
    distr_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    pack_id 		uid_t 		not null,
    price 		currency_t 	not null,
    b_date 		date_t 		not null,
    e_date 		date_t 		not null,
    promo 		bool_t 		null,
    primary key (distr_id, account_id, prod_id, b_date)
);

create table group_prices (
    distr_id 		uid_t 		not null,
    group_price_id 	uid_t 		not null,
    prod_id 		uid_t 		not null,
    pack_id 		uid_t 		not null,
    price 		currency_t 	not null,
    primary key (distr_id, group_price_id, prod_id)
);

create table highlights (
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    color 		color_t 	null,
    bgcolor 		color_t 	null,
    remark 		descr_t 	null,
    primary key (account_id, prod_id)
);


create table job_titles (
    job_title_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null
);
create table manufacturers (
    manuf_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null,
    competitor 		bool_t 		null
);

create table matrix_types (
    matrix_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    mandatory 		bool_t 		null
);

create table matrices (
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    matrix_type_id 	uid_t 		not null,
    row_no 		int32_t 	null, -- ordering
    primary key (account_id, prod_id, matrix_type_id)
);

create table my_accounts (
    user_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    primary key (user_id, account_id)
);

create table my_cities (
    user_id 		uid_t 		not null,
    city_id 		uid_t 		not null,
    primary key (user_id, city_id)
);

create table my_regions (
    user_id 		uid_t 		not null,
    region_id 		uid_t 		not null,
    primary key (user_id, region_id)
);

create table my_retail_chains (
    user_id 		uid_t 		not null,
    rc_id 		uid_t 		not null,
    region_id 		uid_t 		not null,
    primary key (user_id, rc_id, region_id)
);

create table my_routes (
    user_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    p_date 		date_t 		not null,
    row_no 		int32_t 	null,
    duration 		int32_t 	null,
    primary key (user_id, account_id, p_date)
);

create table mutuals (
    distr_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    mutual 		currency_t 	not null,
    primary key(distr_id, account_id)
);

create table mutuals_history (
    distr_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    erp_id 		uid_t 		not null,
    erp_no 		uid_t 		not null,
    erp_dt 		datetime_t 	not null,
    amount 		currency_t 	not null,
    incoming 		bool_t 		not null,
    unpaid 		currency_t 	null,
    extra_info 		note_t 		null,
    primary key (distr_id, account_id, erp_id)
);

create table mutuals_history_products (
    distr_id 		uid_t 		not null,
    erp_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    pack_id 		uid_t 		not null,
    qty 		numeric_t 	not null,
    discount 		discount_t 	null,
    amount 		currency_t 	not null,
    primary key (distr_id, erp_id, prod_id)
);

create table oos_types (
    oos_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    row_no 		int32_t 	null -- ordering
);

create table order_params (
    distr_id 		uid_t 		not null,
    order_param_id 	uid_t 		not null,
    descr 		descr_t 	not null,
    primary key (distr_id, order_param_id)
);

create table order_types (
    order_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    redirect_method 	varchar(16) 	null
);

create table packs (
    pack_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    descr 		descr_t 	not null,
    pack 		numeric_t 	not null default 1.0 check (pack >= 0.01),
    weight 		weight_t 	null,
    volume 		volume_t 	null,
    precision 		int32_t 	null check (precision is null or (precision >= 0)),
    primary key (pack_id, prod_id)
);

create table payment_methods (
    payment_method_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    encashment 		bool_t 		null
);

create table pending_types (
    pending_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null
);

create table permitted_returns ( /* products allowed for the [reclamation] document */
    distr_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    pack_id 		uid_t 		not null,
    price 		currency_t 	not null check (price >= 0),
    max_qty 		numeric_t 	null check (max_qty is null or (max_qty >= 0)),
    locked 		bool_t 		null default 0,
    primary key (distr_id, account_id, prod_id)
);

create table potentials (
    poten_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null
);

create table photo_types (
    photo_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    row_no 		int32_t 	null -- ordering,
);

create table placements (
    placement_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    row_no 		int32_t 	null -- ordering
);

create table plu_codes (
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    plu 		code_t 		not null,
    primary key(account_id, prod_id)
);

create table pmlist (
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    rrp 		currency_t 	null,
    primary key(account_id, prod_id)
);

create table products (
    prod_id 		uid_t 		not null primary key,
    pid 		uid_t 		null,
    ftype 		ftype_t 	not null,
    manuf_id 		uid_t 		null,
    brand_id 		uid_t 		null,
    categ_id 		uid_t 		null,
    shelf_life_id 	uid_t 		null,
    code 		code_t 		null,
    descr 		descr_t 	not null,
    art 		art_t 		null,
    obsolete 		bool_t 		null,
    novelty 		bool_t 		null,
    promo 		bool_t 		null,
    country_ids 	countries_t 	null
);

create table rating_criterias (
    rating_criteria_id 	uid_t 		not null primary key,
    pid 		uid_t 		null,
    ftype 		bool_t 		not null,
    descr 		descr_t 	not null,
    wf 			wf_t 		not null check(wf between 0.01 and 1.00),
    mandatory 		bool_t 		not null,
    extra_info 		note_t 		null,
    row_no 		int32_t 	null
);

create table rating_scores (
    rating_score_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    score 		int32_t 	not null,
    wf 			wf_t 		not null check(wf between 0.00 and 1.00),
    mandatory 		bool_t 		not null,
    row_no 		int32_t 	null
);

create table receipt_types (
    receipt_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null
);

create table reclamation_types (
    reclamation_type_id uid_t 		not null primary key,
    descr 		descr_t 	not null
);

create table recom_orders (
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    pack_id 		uid_t 		null,
    qty 		int32_t 	null,
    stock_wf 		wf_t 		null,
    primary key (account_id, prod_id)
);

create table refunds ( /* total account returns percentage */
    account_id 		uid_t 		not null primary key,
    percentage 		numeric(7,1) 	not null check(percentage >=0),
    attention 		bool_t 		null
);

create table refunds_products ( /* details account returns percentage */
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    percentage 		numeric(7,1) 	not null check(percentage >=0),
    primary key (account_id, prod_id)
);

create table regions (
    region_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null,
    country_id 		country_t 	null
);

create table restrictions (
    distr_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    pack_id 		uid_t 		not null,
    min_qty 		numeric_t 	null check (min_qty is null or min_qty >= 0),
    max_qty 		numeric_t 	null check (max_qty is null or max_qty >= 0),
    quantum 		numeric_t 	null check (quantum is null or quantum > 0),
    primary key (distr_id, account_id, prod_id)
);

create table retail_chains (
    rc_id 		uid_t 		not null primary key,
    pid 		uid_t 		null,
    descr 		descr_t 	not null,
    ka_code 		code_t 		null, /* Key Account: NKA, KA, ... */
    country_id 		country_t 	null
);

create table sales_history (
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    s_date 		date_t 		not null,
    amount_c 		currency_t 	null,
    pack_c_id 		uid_t 		null,
    qty_c 		int32_t 	null,
    amount_r 		currency_t 	null,
    pack_r_id 		uid_t 		null,
    qty_r 		int32_t 	null,
    extra_info 		note_t 		null,
    primary key (account_id, prod_id, s_date)
);

create table sales_targets (
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    year 		int32_t 	not null,
    month 		int32_t 	not null,
    pack_id 		uid_t 		null,
    qty 		int32_t 	null,
    amount 		currency_t 	null,
    primary key (account_id, prod_id, year, month)
);

create table service_types (
    service_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null
);

create table shelf_lifes (
    shelf_life_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    days 		int32_t 	null
);

create table shelfs ( /* distribution of brands on the shelf in the category */
    account_id 		uid_t 		not null,
    categ_id 		uid_t 		not null,
    brand_ids 		uids_t 		not null,
    target 		wf_t 		null check(target between 0.01 and 1.00), /* Share-of-Shelf recomendations */
    primary key(account_id, categ_id)
);

create table shipments (
    distr_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    d_date 		date_t 		not null,
    primary key (distr_id, account_id, d_date)
);

create table std_prices (
    distr_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    pack_id 		uid_t 		not null,
    price 		currency_t 	not null,
    primary key (distr_id, prod_id)
);

create table symlinks ( /* distribution of brands on the shelf in the category */
    distr_id 		uid_t 		not null,
    obj_code 		code_t 		not null,
    f_id 		uid_t 		not null,
    t_id 		uid_t 		not null,
    extra_info 		note_t 		null,
    primary key(distr_id, obj_code, f_id)
);

create table target_types (
    target_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    row_no 		int32_t 	null -- ordering,
);

create table targets (
    target_id 		uid_t 		not null primary key,
    target_type_id 	uid_t 		not null,
    subject 		descr_t 	not null,
    body 		varchar(48) 	not null,
    b_date 		date_t 		not null,
    e_date 		date_t 		not null,
    dep_id 		uid_t 		null,
    account_ids 	uids_t 		not null
);

create table testing_criterias (
    testing_criteria_id uid_t 		not null primary key,
    pid 		uid_t 		null,
    ftype 		bool_t 		not null,
    descr 		descr_t 	not null,
    wf 			wf_t 		not null check(wf between 0.01 and 1.00),
    mandatory 		bool_t 		not null,
    extra_info 		note_t 		null,
    row_no 		int32_t 	null
);

create table testing_scores (
    testing_score_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    score 		int32_t 	not null,
    wf 			wf_t 		not null check(wf between 0.00 and 1.00),
    mandatory 		bool_t 		not null,
    row_no 		int32_t 	null
);

create table unsched_types (
    unsched_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    row_no 		int32_t 	null -- ordering,
);

create table users (
    user_id 		uid_t 		not null primary key,
    pids 		uids_t 		null,
    descr 		descr_t 	not null,
    role 		code_t 		null, -- check (role in ('merch','sr','mr','sv','ise','cde','asm','rsm') and role = lower(role)),
    country_ids 	countries_t 	null,
    dep_ids 		uids_t 		null,
    distr_ids 		uids_t 		null,
    agency_id 		uid_t 		null,
    shared 		bool_t 		not null default 0,
    mobile 		phone_t 	null,
    email 		email_t 	null,
    area 		descr_t 	null
);

create table vf_accounts (
    vf_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    row_no 		int32_t 	null, -- ordering
    primary key(vf_id, account_id)
);

create table vf_names (
    vf_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null,
    row_no 		int32_t 	null -- ordering
);

create table vf_products (
    vf_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    row_no 		int32_t 	null, -- ordering
    primary key(vf_id, account_id, prod_id)
);

create table warehouses (
    distr_id 		uid_t 		not null,
    wareh_id 		uid_t 		not null,
    descr 		descr_t 	not null,
    primary key(distr_id, wareh_id)
);

create table wareh_stocks (
    distr_id 		uid_t 		not null,
    wareh_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    qty 		int32_t 	not null,
    primary key (distr_id, wareh_id, prod_id)
);

create table working_hours (
    working_hours_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null
);

go


-- **** OMOBUS -> ERP streams ****

create table additions (
    doc_id 		uid_t 		not null primary key,
    fix_dt 		datetime_t 	not null,
    doc_no 		uid_t 		not null,
    user_id 		uid_t 		not null,
    dev_login 		uid_t 		not null,
    addition_type_id 	uid_t 		null,
    doc_note 		note_t 		null,
    account 		descr_t 	not null,
    legal_address 	address_t 	null,
    address 		address_t 	null,
    number 		code_t 		null,
    attr_ids 		uids_t 		null,
    account_id 		uid_t 		not null,
    inserted_ts 	ts_t 		not null default current_timestamp
);

create table adjustments (
    doc_id 		uid_t 		not null primary key,
    fix_dt 		datetime_t 	not null,
    doc_no 		uid_t 		not null,
    user_id 		uid_t 		not null,
    dev_login 		uid_t 		not null,
    account_id 		uid_t 		not null,
    erp_id 		uid_t 		not null,
    delivery_date 	date_t 		not null,
    rows 		int32_t 	not null,
    prod_id 		uid_t 		not null,
    row_no 		int32_t 	not null check (row_no >= 0),
    pack_id 		uid_t 		not null,
    pack 		numeric_t 	not null,
    qty 		numeric_t 	not null,
    inserted_ts 	ts_t 		not null default current_timestamp
);

create table orders (
    doc_id 		uid_t 		not null,
    fix_dt 		datetime_t 	not null,
    doc_no 		uid_t 		not null,
    user_id 		uid_t 		not null,
    dev_login 		uid_t 		not null,
    account_id 		uid_t 		not null,
    distr_id 		uid_t 		not null,
    order_type_id 	uid_t 		null,
    group_price_id 	uid_t 		null,
    wareh_id 		uid_t 		null,
    delivery_date 	date_t 		not null,
    delivery_type_id 	uid_t 		null,
    delivery_note 	note_t 		null,
    doc_note 		note_t 		null,
    payment_method_id 	uid_t 		null,
    payment_delay 	int32_t 	null check (payment_delay is null or (payment_delay >= 0)),
    bonus 		currency_t 	null check (bonus is null or (bonus >= 0)),
    encashment 		currency_t 	null check (encashment is null or (encashment >= 0)),
    order_param_ids 	uids_t 		null, /* order_params array; delimiter ',' */
    rows 		int32_t 	not null,
    prod_id 		uid_t 		not null,
    row_no 		int32_t 	not null check (row_no >= 0),
    pack_id 		uid_t 		not null,
    pack 		numeric_t 	not null,
    qty 		numeric_t 	not null,
    unit_price 		currency_t 	not null check (unit_price >= 0),
    discount 		discount_t 	not null,
    amount 		currency_t 	not null,
    weight 		weight_t 	not null,
    volume 		volume_t 	not null,
    inserted_ts 	ts_t 		not null default current_timestamp,
    primary key (doc_id, prod_id)
);

create table receipts (
    doc_id 		uid_t 		not null primary key,
    fix_dt 		datetime_t 	not null,
    doc_no 		uid_t 		not null,
    user_id 		uid_t 		not null,
    dev_login 		uid_t 		not null,
    account_id 		uid_t 		not null,
    distr_id 		uid_t 		not null,
    receipt_type_id 	uid_t 		null,
    doc_note 		note_t 		null,
    amount 		numeric_t 	not null,
    inserted_ts 	ts_t 		not null default current_timestamp
);

create table reclamations (
    doc_id 		uid_t 		not null,
    fix_dt 		datetime_t 	not null,
    doc_no 		uid_t 		not null,
    user_id 		uid_t 		not null,
    dev_login 		uid_t 		not null,
    account_id 		uid_t 		not null,
    distr_id 		uid_t 		not null,
    return_date 	date_t 		not null,
    doc_note 		note_t 		null,
    rows 		int32_t 	not null,
    prod_id 		uid_t 		not null,
    row_no 		int32_t 	not null check (row_no >= 0),
    reclamation_type_id uid_t 		null,
    pack_id 		uid_t 		not null,
    pack 		numeric_t 	not null,
    qty 		numeric_t 	not null,
    unit_price 		currency_t 	not null check (unit_price >= 0),
    amount 		currency_t 	not null,
    weight 		weight_t 	not null,
    volume 		volume_t 	not null,
    inserted_ts 	ts_t 		not null default current_timestamp,
    primary key (doc_id, prod_id)
);

go



-- **** System tables and procedures ****

create table sysparams (
    param_id 		uid_t 		not null primary key,
    param_value 	uid_t 		not null,
    descr 		descr_t 	null
);

insert into sysparams values('db:id', 'L0', 'omobus-zero-db internal code.');
insert into sysparams values('gc:keep_alive', '30', 'How many days the data will be hold from cleaning.');

go
