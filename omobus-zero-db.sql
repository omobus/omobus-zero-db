/* Copyright (c) 2006 - 2019 omobus-zero-db authors, see the included COPYRIGHT file. */

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
execute sp_addtype ean13_t, 'varchar(13)'
execute sp_addtype ean13s_t, 'varchar(280)'
execute sp_addtype email_t, 'varchar(254)'
execute sp_addtype emails_t, 'varchar(4096)'
execute sp_addtype ftype_t, 'smallint'
execute sp_addtype gps_t, 'numeric(10,6)'
execute sp_addtype hostname_t, 'varchar(255)'
execute sp_addtype hstore_t, 'varchar(1024)'
execute sp_addtype int32_t, 'int'
execute sp_addtype int64_t, 'bigint'
execute sp_addtype message_t, 'varchar(4096)'
execute sp_addtype note_t, 'varchar(1024)'
execute sp_addtype numeric_t, 'numeric(16,4)'
execute sp_addtype percent_t, 'smallint'
execute sp_addtype phone_t, 'varchar(32)'
execute sp_addtype state_t, 'varchar(8)'
execute sp_addtype time_t, 'char(5)'
execute sp_addtype ts_t, 'datetime'
execute sp_addtype uid_t, 'varchar(48)'
execute sp_addtype uids_t, 'varchar(2048)'
execute sp_addtype volume_t, 'numeric(10,6)'
execute sp_addtype weight_t, 'numeric(12,6)'
execute sp_addtype wf_t, 'numeric(3,2)'
go


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
    latitude 		gps_t 		null,
    longitude 		gps_t 		null,
    props 		hstore_t 	null
);

create table account_params (
    distr_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    group_price_id 	uid_t 		null,
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

create table agreements1 (
    account_id 		uid_t 		not null,
    placement_id 	uid_t 		not null,
    posm_id 		uid_t 		not null,
    b_date 		date_t 		not null,
    e_date 		date_t 		not null,
    strict 		bool_t 		not null default 0,
    primary key (account_id, placement_id, posm_id, b_date)
);

create table agreements2 (
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    b_date 		date_t 		not null,
    e_date 		date_t 		not null,
    facing 		int32_t 	not null check(facing > 0),
    strict 		bool_t 		not null default 0,
    primary key (account_id, prod_id, b_date)
);

create table asp_types (
    asp_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    row_no 		int32_t 	null -- ordering
);

create table attributes (
    attr_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null
);

create table audit_criterias (
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
    row_no 		int32_t 	null
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
    manuf_id 		uid_t 		not null,
    dep_id 		uid_t 		null,
    row_no 		int32_t 	null
);

create table canceling_types (
    canceling_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null
);

create table categories (
    categ_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null,
    brand_ids 		uids_t 		null,
    wf 			wf_t 		null check(wf between 0.01 and 1.00),
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
    extra_info 		note_t 		null,
    row_no 		int32_t 	null
);

create table contacts (
    contact_id 		uid_t 		not null primary key,
    account_id 		uid_t 		not null,
    name 		descr_t 	not null,
    surname 		descr_t 	not null,
    patronymic 		descr_t 	null,
    job_title_id 	uid_t 		not null,
    phone 		phone_t 	null,
    mobile 		phone_t 	null,
    email 		email_t 	null,
    locked 		bool_t 		not null default 0,
    extra_info 		note_t 		null
);

create table debts (
    distr_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    debt 		currency_t 	not null,
    primary key(distr_id, account_id)
);

create table delivery_types (
    delivery_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    row_no 		int32_t 	null -- ordering
);

create table departments (
    dep_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null
);

create table discard_types (
    discard_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    row_no 		int32_t 	null -- ordering
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

create table equipment_types (
    equipment_type_id 	uid_t		not null primary key,
    descr 		descr_t		not null,
    row_no 		int32_t 	null -- ordering
);

create table equipments (
    equipment_id 	uid_t 		not null primary key,
    account_id 		uid_t 		not null,
    serial_number 	code_t 		not null,
    equipment_type_id 	uid_t 		not null,
    ownership_type_id 	uid_t 		null,
    extra_info 		note_t 		null
);

create table erp_docs (
    doc_id 		uid_t 		not null,
    erp_id 		uid_t 		not null,
    pid 		uid_t 		null, /* parent erp_id */
    erp_no 		uid_t 		not null,
    erp_dt 		datetime_t 	not null,
    amount 		currency_t 	not null,
    status 		int32_t 	not null default 0 check (status between -1 and 1), -- -1 - delete, 0 - normal, 1 - closed
    doc_type 		doctype_t 	not null, -- order, reclamation, contract
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

create table kinds (
    kind_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null,
    row_no 		int32_t 	null -- ordering
);

create table manufacturers (
    manuf_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null,
    competitor 		bool_t 		null
);

create table matrices (
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    placement_ids 	uids_t 		null,
    row_no 		int32_t 	null, -- ordering
    primary key (account_id, prod_id)
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
    activity_type_id 	uid_t 		not null,
    p_date 		date_t 		not null,
    row_no 		int32_t 	null,
    duration 		int32_t 	null,
    primary key (user_id, account_id, activity_type_id, p_date)
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
    row_no 		int32_t 	null -- ordering
);

create table ownership_types (
    ownership_type_id 	uid_t		not null primary key,
    descr 		descr_t		not null,
    row_no 		int32_t 	null -- ordering
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
    encashment 		bool_t 		null,
    row_no 		int32_t 	null -- ordering,
);

create table pending_types (
    pending_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    row_no 		int32_t 	null -- ordering
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

create table photo_params (
    photo_param_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    placement_ids 	uids_t 		null,
    row_no 		int32_t 	null -- ordering,
);

create table photo_types (
    photo_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    placement_ids 	uids_t 		null,
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
    plu_code 		code_t 		not null,
    primary key(account_id, prod_id)
);

create table pmlist (
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    b_date 		date_t 		not null,
    e_date 		date_t 		not null,
    primary key(account_id, prod_id, b_date)
);

create table pos_materials ( /* Point-of-Sale and Point-of-Purchase materials */
    posm_id 		uid_t 		not null primary key default man_id(),
    descr 		descr_t 	not null,
    "image" 		blob_t 		not null,
    brand_ids 		uids_t 		null,
    placement_ids 	uids_t 		null,
    chan_ids 		uids_t 		null,
    dep_id 		uid_t 		null,
    country_id		country_t 	null,
    b_date 		date_t 		null,
    e_date 		date_t 		null
);

create table priorities (
    brand_id 		uid_t 		not null,
    b_date 		date_t 		not null,
    e_date 		date_t 		not null,
    country_id 		uid_t 		not null,
    primary key (brand_id, b_date, country_id)
);

create table products (
    prod_id 		uid_t 		not null primary key,
    pid 		uid_t 		null,
    ftype 		ftype_t 	not null,
    code 		code_t 		null,
    descr 		descr_t 	not null,
    kind_id 		uid_t 		null,
    brand_id 		uid_t 		null,
    categ_id 		uid_t 		null,
    shelf_life_id 	uid_t 		null,
    art 		art_t 		null,
    obsolete 		bool_t 		null,
    novelty 		bool_t 		null,
    promo 		bool_t 		null,
    barcodes 		ean13s_t 	null,
    "image" 		image 		null,
    country_ids 	countries_t 	null,
    row_no 		int32_t 	null
);

create table quest_names (
    qname_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null
);

create table quest_rows (
    qname_id 		uid_t 		not null,
    qrow_id 		uid_t 		not null default man_id(),
    pid 		uid_t 		null,
    ftype 		ftype_t 	not null,
    descr 		descr_t 	not null,
    qtype 		varchar(7) 	null check(ftype=0 and qtype in ('boolean','integer') or (ftype<>0 and qtype is null)),
    extra_info 		note_t 		null,
    country_ids 	countries_t 	null,
    row_no 		int32_t 	null, -- ordering
    primary key(qname_id, qrow_id)
);

create table rating_criterias (
    rating_criteria_id 	uid_t 		not null primary key,
    pid 		uid_t 		null,
    ftype 		bool_t 		not null,
    descr 		descr_t 	not null,
    wf 			wf_t 		null check((ftype=0 and wf is not null and wf between 0.01 and 1.00) or (ftype<>0 and wf is null)),
    mandatory 		bool_t 		null check((ftype=0 and mandatory is not null) or (ftype<>0 and mandatory is null)),
    extra_info 		note_t 		null,
    row_no 		int32_t 	null
);

create table rating_scores (
    rating_score_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    score 		int32_t 	not null,
    wf 			wf_t 		not null check(wf between 0.00 and 1.00),
    row_no 		int32_t 	null
);

create table rdd (
    distr_id 		uid_t 		not null,
    obj_code 		code_t 		not null,
    r_date 		datetimetz_t 	not null,
    primary key(distr_id, obj_code)
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

create table recom_retail_prices (
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    rrp 		currency_t 	not null,
    primary key(account_id, prod_id)
);

create table recom_shares (
    account_id 		uid_t 		not null,
    categ_id 		uid_t 		not null,
    sos 		wf_t 		null check(sos between 0.01 and 1.00),
    soa 		wf_t 		null check(soa between 0.01 and 1.00),
    primary key(account_id, categ_id)
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

create table remark_types (
    remark_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    row_no 		int32_t 	null -- ordering
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

create table rules (
    doc_type 		doctype_t 	not null,
    role 		code_t 		not null,
    frequency 		code_t 		not null check(frequency in ('everytime','once_a_week','once_a_month')),
    account_ids 	uids_t 		null,
    region_ids 		uids_t		null,
    city_ids 		uids_t		null,
    rc_ids 		uids_t		null, /* -> retail_chains */
    chan_ids		uids_t 		null,
    poten_ids 		uids_t 		null,
    primary key(doc_type, role)
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
    color 		int32_t 	null,
    bgcolor 		int32_t 	null,
    extra_info 		note_t 		null,
    primary key (account_id, prod_id, s_date)
);

create table shelf_lifes (
    shelf_life_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    days 		int32_t 	null
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

create table targets (
    target_id 		uid_t 		not null primary key,
    target_type_id 	uid_t 		not null,
    subject 		descr_t 	not null,
    body 		varchar(2048) 	not null,
    b_date 		date_t 		not null,
    e_date 		date_t 		not null,
    dep_id 		uid_t 		null,
    account_ids 	uids_t 		null,
    rc_ids 		uids_t 		null,
    chan_ids 		uids_t 		null,
    poten_ids 		uids_t 		null,
    region_ids 		uids_t 		null,
    city_ids 		uids_t 		null,
    renewable 		bool_t 		not null default 0,
    props 		hstore_t 	null
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
    country_id 		country_t 	not null default 'RU'
    dep_ids 		uids_t 		null,
    distr_ids 		uids_t 		null,
    agency_id 		uid_t 		null,
    mobile 		phone_t 	null,
    email 		email_t 	null,
    area 		descr_t 	null,
    props 		hstore_t 	null
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

go


create table activity_types (
    activity_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    strict 		bool_t 		not null default 0, /* sets to 1 (true) for direct visits to the accounts */
    hidden 		bool_t 		not null default 0
);

create table additions (
    doc_id 		uid_t 		not null primary key,
    user_id		uid_t 		not null,
    fix_dt		datetime_t 	not null,
    account 		descr_t 	null,
    address 		address_t 	null,
    legal_address 	address_t 	null,
    number 		code_t 		null,
    addition_type_id 	uid_t 		null,
    note 		note_t 		null,
    chan_id 		uid_t 		null,
    photos 		uids_t 		null,
    attr_ids 		uids_t 		null,
    account_id 		uid_t 		not null,
    validator_id 	uid_t		null,
    validated 		bool_t 		not null default 0,
    hidden 		bool_t 		not null default 0,
    geo_address 	address_t 	null,
    inserted_ts 	ts_t 		not null default current_timestamp
);

create table cancellations (
    user_id		uid_t 		not null,
    route_date		date_t 		not null,
    canceling_type_id	uid_t 		null,
    note 		note_t 		null,
    hidden		bool_t 		not null default 0,
    inserted_ts 	ts_t 		not null default current_timestamp
    primary key (user_id, route_date)
);

create table comments (
    doc_id 		uid_t 		not null primary key,
    fix_dt 		datetime_t 	not null,
    user_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    comment_type_id 	uid_t 		not null,
    doc_note 		note_t 		null,
    photo		uid_t		null,
    inserted_ts 	ts_t 		not null default current_timestamp
);

create table deletions (
    account_id  	uid_t 		not null primary key,
    user_id		uid_t 		not null,
    fix_dt		datetime_t 	not null,
    note		note_t		null,
    photo		uid_t		null,
    validator_id 	uid_t		null,
    validated 		bool_t 		not null default 0,
    hidden 		bool_t 		not null default 0,
    inserted_ts 	ts_t 		not null default current_timestamp
);

create table discards (
    account_id  	uid_t 		not null,
    user_id		uid_t 		not null,
    fix_dt		datetime_t 	not null,
    activity_type_id 	uid_t 		not null,
    discard_type_id 	uid_t 		null,
    route_date 		date_t 		not null,
    note		note_t		null,
    validator_id 	uid_t		null,
    validated 		bool_t 		not null default 0,
    hidden 		bool_t 		not null default 0,
    inserted_ts 	ts_t 		not null default current_timestamp,
    primary key(account_id, user_id, activity_type_id, route_date)
);

create table dyn_advt (
    fix_date		date_t 		not null,
    account_id 		uid_t 		not null,
    placement_id 	uid_t 		not null,
    posm_id 		uid_t 		not null,
    qty 		int32_t 	not null check (qty >= 0),
    fix_dt		datetime_t 	not null,
    user_id 		uid_t 		not null,
    inserted_ts 	ts_t 		not null default current_timestamp,
    primary key(fix_date, account_id, placement_id, posm_id)
);

create table dyn_audits (
    fix_date		date_t 		not null,
    account_id 		uid_t 		not null,
    categ_id 		uid_t 		not null,
    audit_criteria_id 	uid_t 		not null,
    audit_score_id 	uid_t 		null,
    criteria_wf 	wf_t 		not null check(criteria_wf between 0.01 and 1.00),
    score_wf 		wf_t 		null check(score_wf between 0.00 and 1.00),
    score 		int32_t 	null check (score >= 0),
    note 		note_t 		null,
    wf 			wf_t 		not null check(wf between 0.01 and 1.00),
    sla 		numeric(6,5) 	not null check(sla between 0.0 and 1.0),
    photos		uids_t		null,
    fix_dt 		datetime_t 	not null,
    user_id 		uid_t 		not null,
    inserted_ts 	ts_t 		not null default current_timestamp,
    primary key(fix_date, account_id, categ_id, audit_criteria_id)
);

create table dyn_checkups (
    fix_date		date_t 		not null,
    account_id 		uid_t 		not null,
    placement_id 	uid_t 		not null,
    prod_id 		uid_t 		not null,
    exist 		int32_t 	not null,
    fix_dt		datetime_t 	not null,
    user_id 		uid_t 		not null,
    inserted_ts 	ts_t 		not null default current_timestamp,
    primary key(fix_date, account_id, placement_id, prod_id)
);

create table dyn_oos (
    fix_date		date_t 		not null,
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    oos_type_id 	uid_t 		not null,
    note 		note_t 		null,
    fix_dt		datetime_t 	not null,
    user_id 		uid_t 		not null,
    inserted_ts 	ts_t 		not null default current_timestamp,
    primary key(fix_date, account_id, prod_id)
);

create table dyn_presences (
    fix_date		date_t 		not null,
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    facing 		int32_t 	not null,
    stock 		int32_t 	not null,
    fix_dt		datetime_t 	not null,
    user_id 		uid_t 		not null,
    inserted_ts 	ts_t 		not null default current_timestamp,
    primary key(fix_date, account_id, prod_id)
);

create table dyn_prices (
    fix_date		date_t 		not null,
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    price 		currency_t 	not null,
    promo 		bool_t 		not null,
    rrp 		currency_t 	null,
    fix_dt		datetime_t 	not null,
    user_id 		uid_t 		not null,
    inserted_ts 	ts_t 		not null default current_timestamp,
    primary key(fix_date, account_id, prod_id)
);

create table dyn_quests (
    fix_date		date_t 		not null,
    account_id 		uid_t 		not null,
    qname_id 		uid_t 		not null,
    qrow_id 		uid_t		not null,
    "value" 		varchar(64) 	not null,
    fix_dt 		datetime_t 	not null,
    user_id 		uid_t 		not null,
    inserted_ts 	ts_t 		not null default current_timestamp,
    primary key(fix_date, account_id, qname_id, qrow_id)
);

create table dyn_ratings (
    fix_date		date_t 		not null,
    account_id 		uid_t 		not null,
    employee_id 	uid_t 		not null,
    rating_criteria_id 	uid_t 		not null,
    rating_score_id 	uid_t 		null,
    criteria_wf 	wf_t 		not null check(criteria_wf between 0.01 and 1.00),
    score_wf 		wf_t 		null check(score_wf between 0.00 and 1.00),
    score 		int32_t 	null check (score >= 0),
    note 		note_t 		null,
    fix_dt		datetime_t 	not null,
    user_id 		uid_t 		not null,
    inserted_ts 	ts_t 		not null default current_timestamp,
    primary key(fix_date, account_id, employee_id, rating_criteria_id)
);

create table dyn_reviews (
    fix_date		date_t 		not null,
    employee_id 	uid_t 		not null,
    sla 		numeric(6,5)	not null check(sla between 0.0 and 1.0),
    assessment 		numeric(5,3)    not null check(assessment >= 0),
    note0 		note_t 		null,
    note1 		note_t 		null,
    note2 		note_t 		null,
    fix_dt		datetime_t 	not null,
    user_id 		uid_t 		not null,
    inserted_ts 	ts_t 		not null default current_timestamp,
    primary key(fix_date, employee_id)
);

create table dyn_shelfs (
    fix_date		date_t 		not null,
    account_id 		uid_t 		not null,
    categ_id 		uid_t 		not null,
    brand_id 		uid_t 		not null,
    facing 		int32_t 	null check (facing >= 0),
    assortment 		int32_t 	null check (assortment >= 0),
    sos 		numeric(6,5) 	null check(sos between 0.0 and 1.0),
    soa 		numeric(6,5) 	null check(soa between 0.0 and 1.0),
    photos		uids_t		null,
    sos_target 		wf_t 		null check(sos_target between 0.01 and 1.00),
    soa_target 		wf_t 		null check(soa_target between 0.01 and 1.00),
    fix_dt 		datetime_t 	not null,
    user_id 		uid_t 		not null,
    inserted_ts 	ts_t 		not null default current_timestamp,
    primary key(fix_date, account_id, categ_id, brand_id)
);

create table dyn_stocks (
    fix_date		date_t 		not null,
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    stock 		int32_t 	not null,
    fix_dt 		datetime_t 	not null,
    user_id 		uid_t 		not null,
    inserted_ts 	ts_t 		not null default current_timestamp,
    primary key(fix_date, account_id, prod_id)
);

create table dyn_testings (
    fix_date		date_t 		not null,
    account_id 		uid_t 		not null,
    contact_id 		uid_t 		not null,
    testing_criteria_id uid_t 		not null,
    testing_score_id 	uid_t 		null,
    criteria_wf 	wf_t 		not null check(criteria_wf between 0.01 and 1.00),
    score_wf 		wf_t 		null check(score_wf between 0.00 and 1.00),
    score 		int32_t 	null check (score >= 0),
    note 		note_t 		null,
    sla 		numeric(6,5) 	not null check(sla between 0.0 and 1.0),
    fix_dt		datetime_t 	not null,
    user_id 		uid_t 		not null,
    inserted_ts 	ts_t 		not null default current_timestamp,
    primary key(fix_date, account_id, contact_id, testing_criteria_id)
);

create table locations (
    doc_id 		uid_t 		not null primary key,
    fix_dt 		datetime_t 	not null,
    user_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    latitude 		gps_t 		not null,
    longitude 		gps_t 		not null,
    accuracy 		double_t 	not null,
    distr 		double_t 	null
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

create table photos (
    doc_id		uid_t		not null primary key,
    fix_dt		datetime_t	not null,
    user_id		uid_t		not null,
    account_id		uid_t		not null,
    placement_id	uid_t		not null,
    brand_id		uid_t		null,
    photo_type_id	uid_t		null,
    photo		uid_t		not null,
    doc_note		note_t		null,
    photo_param_ids	uids_t		null,
    inserted_ts 	ts_t 		not null default current_timestamp
);

create table presentations (
    doc_id 		uid_t 		not null primary key,
    fix_dt 		datetime_t 	not null,
    user_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    participants 	int32_t 	not null,
    tm_ids 		uids_t 		null,
    doc_note 		note_t 		null,
    photos		uids_t		null,
    inserted_ts 	ts_t 		not null default current_timestamp
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

create table revocations (
    doc_id 		uid_t 		not null primary key,
    doc_type 		doctype_t 	not null,
    hidden		bool_t 		not null default 0,
    inserted_ts 	ts_t 		not null default current_timestamp
);

create table target_types (
    target_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    hidden 		bool_t 		not null default 0
);

create table trainings (
    doc_id 		uid_t 		not null primary key,
    user_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    fix_dt 		datetime_t 	not null,
    doc_note 		note_t 		null,
    training_type_id	uid_t		null,
    contact_ids 	uids_t 		not null,
    tm_ids 		uids_t 		not null,
    photos		uids_t		null,
    inserted_ts 	ts_t 		not null default current_timestamp
);

create table unsched (
    doc_id 		uid_t 		not null primary key,
    fix_dt 		datetime_t 	not null,
    user_id 		uid_t 		not null,
    unsched_type_id 	uid_t 		null,
    doc_note 		note_t 		null,
    inserted_ts 	ts_t 		not null default current_timestamp
);

create table user_activities (
    user_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    w_cookie 		uid_t 		not null,
    a_cookie 		uid_t 		not null,
    activity_type_id 	uid_t 		not null,
    fix_date 		date_t 		not null,
    route_date 		date_t 		null,
    b_dt 		datetime_t 	not null,
    b_la 		gps_t 		null,
    b_lo 		gps_t 		null,
    b_sat_dt 		datetime_t 	null,
    e_dt 		datetime_t 	null,
    e_la 		gps_t 		null,
    e_lo 		gps_t 		null,
    e_sat_dt 		datetime_t 	null,
    employee_id 	uid_t 		null,
    extra_info 		note_t 		null,
    docs 		int32_t 	null,
    inserted_ts 	ts_t 		not null default current_timestamp,
    primary key (user_id, account_id, activity_type_id, w_cookie, a_cookie)
);

create table user_documents (
    act_id 		uid_t 		not null primary key,
    user_id 		uid_t 		not null,
    w_cookie 		uid_t 		null,
    fix_date 		date_t 		not null,
    doc_type 		doctype_t 	not null,
    doc_id 		uid_t 		null,
    doc_no 		uid_t 		not null,
    duration 		int32_t 	not null,
    rows 		int32_t 	null,
    fix_dt 		datetime_t 	not null,
    latitude 		gps_t 		null,
    longitude 		gps_t 		null,
    satellite_dt 	datetime_t 	null,
    /* activity to the account: */
    a_cookie 		uid_t 		null,
    account_id 		uid_t 		null,
    activity_type_id 	uid_t 		null,
    employee_id 	uid_t 		null,
    /* */
    inserted_ts 	ts_t 		not null default current_timestamp
);

create table user_locations (
    act_id 		uid_t 		not null,
    row_no 		int32_t 	not null,
    user_id 		uid_t 		not null,
    fix_date 		date_t 		not null,
    latitude 		gps_t 		not null,
    longitude 		gps_t 		not null,
    satellite_dt 	datetime_t 	not null,
    fix_dt 		datetime_t 	not null,
    accuracy 		double_t 	not null,
    altitude 		double_t 	not null,
    bearing 		double_t 	not null,
    speed 		double_t 	not null,
    seconds 		int32_t 	null,
    provider 		varchar(8) 	null check (provider in ('gps','network') and provider = lower(provider)),
    satellites 		int32_t 	null,
    inserted_ts 	ts_t 		not null default current_timestamp,
    primary key(act_id, row_no)
);

create table user_reports (
    act_id 		uid_t 		not null primary key,
    user_id 		uid_t 		not null,
    w_cookie 		uid_t 		null,
    fix_date 		date_t 		not null,
    doc_type 		doctype_t 	not null,
    duration 		int32_t 	not null,
    fix_dt 		datetime_t 	not null,
    latitude 		gps_t 		null,
    longitude 		gps_t 		null,
    satellite_dt 	datetime_t 	null,
    /* activity to the account: */
    a_cookie 		uid_t 		null,
    account_id 		uid_t 		null,
    activity_type_id 	uid_t 		null,
    employee_id 	uid_t 		null,
    /* */
    inserted_ts 	ts_t 		not null default current_timestamp
);

create table user_works (
    user_id 		uid_t 		not null,
    w_cookie 		uid_t 		not null,
    fix_date 		date_t 		not null,
    b_dt 		datetime_t 	not null,
    b_la 		gps_t 		null,
    b_lo 		gps_t 		null,
    b_sat_dt 		datetime_t 	null,
    e_dt 		datetime_t 	null,
    e_la 		gps_t 		null,
    e_lo 		gps_t 		null,
    e_sat_dt 		datetime_t 	null,
    inserted_ts 	ts_t 		not null default current_timestamp,
    primary key (user_id, w_cookie)
);

go


create function bool_in(@arg0 varchar(1)) returns bool_t
as
begin
    return case when @arg0 = '' then null else @arg0 end
end
go

create function currency_in(@arg0 varchar(20)) returns currency_t
as
begin
    return case when @arg0 = '' then null else @arg0 end
end
go

create function date_in(@arg0 varchar(10)) returns date_t
as
begin
    return case when @arg0 = '' then null else @arg0 end
end
go

create function datetime_in(@arg0 varchar(19)) returns datetime_t
as
begin
    return case when @arg0 = '' then null else @arg0 end
end
go

create function descr_in(@arg0 varchar(1024)) returns descr_t
as
begin
    return case when @arg0 = '' then null else @arg0 end
end
go

create function double_in(@arg0 varchar(20)) returns double_t
as
begin
    return case when @arg0 = '' then null else @arg0 end
end
go

create function gps_in(@arg0 varchar(12)) returns gps_t
as
begin
    return case when @arg0 = '' then null else @arg0 end
end
go

create function hstore_in(@arg0 varchar(1024)) returns hstore_t
as
begin
    return case when @arg0 = '' then null else @arg0 end
end
go

create function int32_in(@arg0 varchar(11)) returns int32_t
as
begin
    return case when @arg0 = '' then null else @arg0 end
end
go

create function note_in(@arg0 uid_t) returns note_t
as
begin
    return case when @arg0 = '' then null else @arg0 end
end
go

create function uid_in(@arg0 uid_t) returns uid_t
as
begin
    return case when @arg0 = '' then null else @arg0 end
end
go

create function uids_in(@arg0 varchar(2048)) returns uids_t
as
begin
    return case when @arg0 = '' then null else @arg0 end
end
go

create function wf_in(@arg0 varchar(5)) returns wf_t
as
begin
    return case when @arg0 = '' then null else @arg0 end
end
go


create table sysparams (
    param_id 		uid_t 		not null primary key,
    param_value 	uid_t 		not null,
    descr 		descr_t 	null
);

insert into sysparams values('db:id', 'L0', 'omobus-zero-db internal code.');
insert into sysparams values('gc:keep_alive', '30', 'How many days the data will be hold from cleaning.');
insert into sysparams values('db:vstamp', '', 'Database version number.');
go
