/* Copyright (c) 2006 - 2022 omobus-zero-db authors, see the included COPYRIGHT file. */

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
execute sp_addtype hstore_t, 'varchar(4096)'
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

create table account_hints (
    account_id 		uid_t 		not null,
    join_code 		code_t 		not null,
    descr0 		descr_t 	not null,
    descr1 		descr_t 	null,
    extra_info 		note_t 		null,
    attention 		bool_t 		null,
    row_no 		int32_t 	null, -- ordering
    primary key (account_id, join_code, descr0)
);

create table account_params (
    distr_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    group_price_id 	uid_t 		null,
    payment_delay 	int32_t 	null,
    payment_method_id 	uid_t 		null,
    wareh_ids 		uids_t 		null,
    locked 		bool_t 		not null default 0,
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
    strict 		bool_t 		not null default 0,
    cookie 		uid_t 		null,
    primary key (account_id, placement_id, posm_id)
);

create table agreements2 (
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    facing 		int32_t 	null check(facing > 0),
    strict 		bool_t 		not null default 0,
    cookie 		uid_t 		null,
    primary key (account_id, prod_id)
);

create table agreements3 (
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    stock 		int32_t 	not null check(stock > 0),
    strict 		bool_t 		not null default 0,
    cookie 		uid_t 		null,
    primary key (account_id, prod_id)
);

create table asp_types (
    asp_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    extra_info 		note_t 		null,
    placement_ids 	uids_t 		null,
    country_ids 	countries_t 	null,
    dep_ids 		uids_t 		null,
    row_no 		int32_t 	null, -- ordering
    props 		hstore_t 	null
);

create table attributes (
    attr_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null,
    dep_ids 		uids_t 		null,
    row_no 		int32_t 	null -- ordering
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
    descr 		descr_t 	not null,
    dep_ids 		uids_t 		null
);

create table cities (
    city_id 		uid_t 		not null primary key,
    pid 		uid_t 		null,
    ftype 		ftype_t 	not null,
    descr 		descr_t 	not null,
    country_id 		uid_t 		not null
);

create table cohorts (
    cohort_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null,
    extra_info 		note_t 		null,
    dep_ids 		uids_t 		null,
    row_no 		int32_t 	null
);

create table comment_types (
    comment_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    min_note_length 	int32_t 	null,
    photo_needed 	bool_t 		null,
    extra_info 		note_t 		null,
    row_no 		int32_t 	null
);

create table confirmation_types (
    confirmation_type_id uid_t 		not null primary key,
    descr 		descr_t 	not null,
    min_note_length 	int32_t 	null,
    photo_needed 	bool_t 		null,
    accomplished 	bool_t 		null,
    succeeded 		varchar(6) 	null check(succeeded in ('yes','no','partly')),
    extra_info 		note_t 		null,
    target_type_ids 	uids_t 		not null,
    row_no 		int32_t 	null, -- ordering
    props 		hstore_t 	null
);

create table contacts (
    contact_id 		uid_t 		not null primary key,
    account_id 		uid_t 		not null,
    name 		descr_t 	not null,
    surname 		descr_t 	not null,
    patronymic 		descr_t 	null,
    job_title_id 	uid_t 		not null,
    mobile 		phone_t 	null,
    email 		email_t 	null,
    spec_id 		uid_t 		null,
    cohort_id 		uid_t 		null,
    loyalty_level_id 	uid_t 		null,
    influence_level_id 	uid_t 		null,
    intensity_level_id 	uid_t 		null,
    start_year 		int32_t 	null,
    locked 		bool_t 		not null default 0,
    extra_info 		note_t 		null,
    consent_data 	blob_t 		null,
    consent_type 	varchar(32) 	null check(consent_type in ('application/pdf')),
    consent_status 	varchar(24) 	null check(consent_status in ('collecting','collecting_and_informing')),
    consent_dt 		datetime_t 	null,
    consent_country 	country_t 	null
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
    descr 		descr_t 	not null,
    country_id 		uid_t 		not null
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

create table influence_levels (
    influence_level_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    extra_info 		note_t 		null,
    dep_ids 		uids_t 		null,
    row_no 		int32_t 	null
);

create table intensity_levels (
    intensity_level_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    dep_ids 		uids_t 		null,
    row_no 		int32_t 	null
);

create table interaction_types (
    interaction_type_id uid_t 		not null primary key,
    descr 		descr_t 	not null,
    extra_info 		note_t 		null,
    dep_ids 		uids_t 		null,
    row_no 		int32_t 	null
);

create table invoice_prices (
    country_id 		country_t 	not null,
    prod_id 		uid_t 		not null,
    pack_id 		uid_t 		not null,
    price 		currency_t 	not null,
    primary key (country_id, prod_id)
);

create table job_titles (
    job_title_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    dep_ids 		uids_t 		null
);

create table kinds (
    kind_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null,
    row_no 		int32_t 	null -- ordering
);

create table loyalty_levels (
    loyalty_level_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    extra_info 		note_t 		null,
    dep_ids 		uids_t 		null,
    row_no 		int32_t 	null
);

create table mailboxes (
    email 		email_t 	not null primary key,
    descr 		descr_t 	not null,
    distr_id 		uid_t 		null
);

create table manufacturers (
    manuf_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null,
    competitor 		bool_t 		null
);

create table matrices (
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
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
    chan_id 		uid_t 		not null default '',
    primary key (user_id, city_id, chan_id)
);

create table my_habitats (
    user_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    primary key (user_id, account_id)
);

create table my_hints (
    user_id 		uid_t 		not null,
    join_code 		code_t 		not null,
    descr0 		descr_t 	not null,
    descr1 		descr_t 	null,
    extra_info 		note_t 		null,
    attention 		bool_t 		null,
    row_no 		int32_t 	null, -- ordering
    primary key (user_id, join_code, descr0)
);

create table my_regions (
    user_id 		uid_t 		not null,
    region_id 		uid_t 		not null,
    chan_id 		uid_t 		not null default '',
    primary key (user_id, region_id, chan_id)
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
    dep_ids 		uids_t 		null,
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

create table outlet_stocks (
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    s_date 		date_t 		not null,
    stock 		int32_t 	not null check( stock > 0 ),
    primary key(account_id, prod_id)
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
    country_ids 	countries_t 	null,
    dep_ids 		uids_t 		null,
    row_no 		int32_t 	null -- ordering,
);

create table photo_types (
    photo_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    extra_info 		note_t 		null,
    placement_ids 	uids_t 		null,
    country_ids 	countries_t 	null,
    dep_ids 		uids_t 		null,
    row_no 		int32_t 	null -- ordering,
);

create table placements (
    placement_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    row_no 		int32_t 	null -- ordering
);

create table plu_codes (
    rc_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    plu_code 		code_t 		not null,
    primary key(account_id, prod_id)
);

create table pmlist (
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    strict 		bool_t 		null,
    primary key(account_id, prod_id)
);

create table pos_materials ( /* Point-of-Sale and Point-of-Purchase materials */
    posm_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null,
    content_blob 	blob_t 		not null,
    content_type 	varchar(32) 	not null,
    brand_ids 		uids_t 		not null,
    placement_ids 	uids_t 		null,
    chan_ids 		uids_t 		null,
    country_id		country_t 	not null,
    dep_ids 		uids_t 		null,
    b_date 		date_t 		null,
    e_date 		date_t 		null,
    shared 		bool_t 		not null default 0
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
    obsolete 		bool_t 		null,
    novelty 		bool_t 		null,
    promo 		bool_t 		null,
    barcodes 		ean13s_t 	null,
    units 		int32_t 	not null default 1 check(units > 0),
    "image" 		image 		null,
    country_ids 	countries_t 	null,
    dep_ids 		uids_t 		null,
    row_no 		int32_t 	null
);

create table quest_items (
    qname_id 		uid_t 		not null,
    qrow_id 		uid_t 		not null,
    qitem_id 		uid_t 		not null,
    descr 		descr_t 	not null,
    row_no 		int32_t 	null, -- ordering
    primary key(qname_id, qrow_id, qitem_id)
);

create table quest_names (
    qname_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null,
    row_no 		int32_t 	null -- ordering
);

create table quest_rows (
    qname_id 		uid_t 		not null,
    qrow_id 		uid_t 		not null,
    pid 		uid_t 		null,
    ftype 		ftype_t 	not null,
    descr 		descr_t 	not null,
    qtype 		varchar(10) 	null /*check(ftype=0 and qtype in ('boolean','triboolean','integer','text','selector') or (ftype<>0 and qtype is null))*/,
    mandatory 		bool_t 		null /*check((ftype=0 and mandatory is not null) or (ftype<>0 and mandatory is null))*/,
    extra_info 		note_t 		null,
    country_ids 	countries_t 	null,
    dep_ids 		uids_t 		null,
    row_no 		int32_t 	null, -- ordering
    primary key(qname_id, qrow_id)
);

create table rating_criterias (
    rating_criteria_id 	uid_t 		not null primary key,
    pid 		uid_t 		null,
    ftype 		bool_t 		not null,
    descr 		descr_t 	not null,
    dep_ids 		uids_t 		null,
    wf 			wf_t 		null /*check((ftype=0 and wf is not null and wf between 0.01 and 1.00) or (ftype<>0 and wf is null))*/,
    mandatory 		bool_t 		null /*check((ftype=0 and mandatory is not null) or (ftype<>0 and mandatory is null))*/,
    extra_info 		note_t 		null,
    row_no 		int32_t 	null
);

create table rating_scores (
    rating_score_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    score 		int32_t 	null check(score >= 0),
    wf 			wf_t 		null check(wf between 0.00 and 1.00),
    extra_info 		note_t 		null,
    rating_criteria_id 	uid_t 		null,
    row_no 		int32_t 	null,
    check((score is not null and wf is not null) or (score is null and wf is null))
);

create table rdd (
    distr_id 		uid_t 		not null,
    obj_code 		code_t 		not null,
    r_date 		date_t 		not null,
    primary key(distr_id, obj_code)
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
    descr 		descr_t 	not null,
    ka_type 		code_t 		null, /* Key Account: NKA, KA, ... */
    country_id 		country_t 	not null
);

create table rules (
    doc_type 		doctype_t 	not null,
    role 		code_t 		not null,
    frequency 		code_t 		not null check(frequency in ('everytime','once_a_week','once_a_month','once_a_quarter')),
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


create table specializations (
    spec_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null,
    dep_ids 		uids_t 		null
);

create table speclist (
    account_id 		uid_t 		not null,
    prod_id 		uid_t 		not null,
    primary key(account_id, prod_id)
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

create table target_types (
    target_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    selectable 		bool_t 		not null,
    row_no 		int32_t 	null -- ordering
);

create table training_types (
    training_type_id 	uid_t 		not null primary key,
    descr 		descr_t 	not null,
    min_contacts 	int32_t 	null check(min_contacts is null or min_contacts > 0),
    max_contacts 	int32_t 	null check(max_contacts is null or max_contacts > 0),
    dep_ids 		uids_t 		null,
    row_no 		int32_t 	null -- ordering
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
    user_id 		uid_t 		not null default '',
    account_id 		uid_t 		not null,
    row_no 		int32_t 	null, -- ordering
    primary key(vf_id, user_id, account_id)
);

create table vf_names (
    vf_id 		uid_t 		not null primary key,
    descr 		descr_t 	not null,
    row_no 		int32_t 	null -- ordering
);

create table vf_products (
    vf_id 		uid_t 		not null,
    account_id 		uid_t 		not null default '',
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
    hidden 		bool_t 		not null default 0,
    inserted_ts 	ts_t 		not null default current_timestamp
);

create table additions (
    doc_id 		uid_t 		not null primary key,
    user_id		uid_t 		not null,
    fix_dt		datetime_t 	not null,
    account 		descr_t 	null,
    address 		address_t 	null,
    tax_number 		code_t 		null,
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
    latitude 		gps_t 		null,
    longitude 		gps_t 		null,
    inserted_ts 	ts_t 		not null default current_timestamp,
    updated_ts 		ts_t 		not null default current_timestamp
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
    inserted_ts 	ts_t 		not null default current_timestamp,
    updated_ts 		ts_t 		not null default current_timestamp
);

create table locations (
    doc_id 		uid_t 		not null primary key,
    fix_dt 		datetime_t 	not null,
    user_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    latitude 		gps_t 		not null,
    longitude 		gps_t 		not null,
    accuracy 		double_t 	not null,
    dist 		double_t 	null,
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

create table profiles (
    doc_id 		uid_t 		not null primary key,
    fix_dt 		datetime_t 	not null,
    user_id 		uid_t 		not null,
    account_id 		uid_t 		not null,
    chan_id 		uid_t 		null,
    poten_id 		uid_t 		null,
    phone 		phone_t 	null,
    workplaces 		int32_t 	null check(workplaces > 0),
    team 		int32_t 	null check(team > 0),
    interaction_type_id uid_t 		null,
    attr_ids 		uids_t 		null,
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

create table wishes (
    account_id  	uid_t 		not null,
    user_id		uid_t 		not null,
    fix_dt		datetime_t 	not null,
    weeks 		char(7) 	not null default '0,0,0,0',
    days 		char(13) 	not null default '0,0,0,0,0,0,0',
    note		note_t		null,
    validator_id 	uid_t		null,
    validated 		bool_t 		not null default 0,
    hidden 		bool_t 		not null default 0,
    inserted_ts 	ts_t 		not null default current_timestamp,
    updated_ts 		ts_t 		not null default current_timestamp,
    primary key(account_id, user_id)
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

create function phone_in(@arg0 phone_t) returns phone_t
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
