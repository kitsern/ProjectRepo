

/*

TODO: 
	1. SACCO administrative positions and members titles assignment
	2. SACCO portal notes, alerts and batch communications 
		such as reminders etc
	3. 


*/

/* Enabling UUID generation via functions: uuid_generate_v4() , uuid_generate_v1(), */
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


/*  
Global parameter types e.g: district, region, language etc.
Are used to make system types for global parameters
Can be generic and are system wide. Will assist in adhoc upgrades and extensions
*/
create table sacco.global_param_type(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	param_type_id character varying(50) PRIMARY KEY, /*  uuid system own generated */ 
	param_type character varying(4000) UNIQUE NOT NULL,		
	status character varying(50), 
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone
);

CREATE INDEX global_param_type_ind1 ON sacco.global_param_type(param_type);

insert into sacco.global_param_type(param_type_id,param_type,status) values 
 (uuid_generate_v4(),'country','active'),
 (uuid_generate_v4(),'city','active'),
 (uuid_generate_v4(),'subcounty','active'),
 (uuid_generate_v4(),'county','active'),
 (uuid_generate_v4(),'region','active'),
 (uuid_generate_v4(),'currency','active'),
 (uuid_generate_v4(),'district','active'),
 (uuid_generate_v4(),'nationality','active'),
 (uuid_generate_v4(),'account_type','active'),
  (uuid_generate_v4(),'account_category','active'),
   (uuid_generate_v4(),'account_sub_category','active'),
    (uuid_generate_v4(),'bank_account_type','active'),
	 (uuid_generate_v4(),'license_metric_type','active'),
	  (uuid_generate_v4(),'license_metric_category','active'),
	   (uuid_generate_v4(),'bank','active');

/*
 global param category can Be: location etc very generic and are used to categorise global system parameters
*/
create table sacco.global_param_category(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	param_category_id character varying(50) PRIMARY KEY, /*  uuid system own generated */ 
	param_category character varying(4000) UNIQUE NOT NULL,
	status character varying(50), 
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,	
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone
);

CREATE INDEX global_param_category_ind1 ON sacco.global_param_category(param_category);

insert into sacco.global_param_category(param_category_id,param_category,status) values 
 (uuid_generate_v4(),'regions','active'),
 (uuid_generate_v4(),'financials','active'),
 (uuid_generate_v4(),'districts','active'),
 (uuid_generate_v4(),'biodata','active'),
 (uuid_generate_v4(),'license','active');
/*
 Actual global parameter values.
 for example:
    param_type = district
	param_category = location
	param_code = KAMPALA
	param_value = KAMPALA
	param_title = KAMPALA DISTRICT
	------------------------------------
	param_type = country
	param_category = location
	param_code = UGANDA
	param_value = UGANDA
	param_title = UGANDA
	
	
This table can be used to manage lots of global information for the system, and also supports
parent-child relationships. Think departments and programs etc
*/
create table sacco.global_static_params(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	param_id character varying(50) PRIMARY KEY,
	param_code character varying(50) NOT NULL,
	param_value character varying(4000) NOT NULL,
	param_title character varying(4000) NOT NULL,	
	param_type_id character varying(50) NOT NULL references sacco.global_param_type(param_type_id),
	param_category_id character varying(50) NOT NULL references sacco.global_param_category(param_category_id),
	has_parent_param character varying(1) DEFAULT 'F' check (has_parent_param in ('T','F')),
	parent_param_id character varying(50) references sacco.global_static_params(param_id),
	status character varying(50), 
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,	
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (param_type_id,param_code),
	UNIQUE (param_type_id,param_value)
);

CREATE INDEX global_static_params_ind1 ON sacco.global_static_params(param_type_id);
CREATE INDEX global_static_params_ind2 ON sacco.global_static_params(param_category_id);

/----- These queries generate sql which u may need to ran manually -----------------------------------------------
/* populating countries */
select distinct 'insert into sacco.global_static_params(param_id,param_code,param_value,param_title,param_type_id,param_category_id,status) values (uuid_generate_v4(),''' || m.a || ''',''' || m.a || ''',''' || m.a || ''',''' || m.param_type_id  || ''',''' || m.param_category_id ||  ''',''active'');' as stmt from 
 (with cid as (select param_type_id from sacco.global_param_type where param_type = 'country'  ),
  rid as (select param_category_id from sacco.global_param_category where param_category = 'regions' ) 
( select distinct n.*, p.param_type_id as param_type_id,
  r.param_category_id  from cid p, rid r, (select a
from (
    values 
('Afghanistan'), ('Albania'), ('Algeria'), ('American Samoa'), ('Andorra'), ('Angola'), ('Anguilla'), ('Antarctica'), ('Antigua and Barbuda'), ('Argentina'), ('Armenia'), ('Aruba'), ('Australia'), ('Austria'), ('Azerbaijan'), ('Bahamas'), ('Bahrain'), ('Bangladesh'), ('Barbados'), ('Belarus'), ('Belgium'), ('Belize'), ('Benin'), ('Bermuda'), ('Bhutan'), ('Bolivia (Plurinational State of)'), ('Bonaire Sint Eustatius and Saba'), ('Bosnia and Herzegovina'), ('Botswana'), ('Bouvet Island'), ('Brazil'), ('British Indian Ocean Territory'), ('Brunei Darussalam'), ('Bulgaria'), ('Burkina Faso'), ('Burundi'), ('Cabo Verde'), ('Cambodia'), ('Cameroon'), ('Canada'), ('Cayman Islands'), ('Central African Republic'), ('Chad'), ('Chile'), ('China'), ('Christmas Island'), ('Cocos (Keeling) Islands'), ('Colombia'), ('Comoros'), ('Congo (Republic of the)'), ('Congo (Democratic Republic of the)'), ('Cook Islands'), ('Costa Rica'), ('Cote dIvoire (Ivory Coast)'), ('Croatia'), ('Cuba'),  ('Cyprus'), ('Czech Republic'), ('Denmark'), ('Djibouti'), ('Dominica'), ('Dominican Republic'), ('Ecuador'), ('Egypt'), ('El Salvador'), ('Equatorial Guinea'), ('Eritrea'), ('Estonia'), ('Ethiopia'), ('Falkland Islands (Malvinas)'), ('Faroe Islands'), ('Fiji'), ('Finland'), ('France'), ('French Guiana'), ('French Polynesia'), ('French Southern Territories'), ('Gabon'), ('Gambia'), ('Georgia'), ('Germany'), ('Ghana'), ('Gibraltar'), ('Greece'), ('Greenland'), ('Grenada'), ('Guadeloupe'), ('Guam'), ('Guatemala'), ('Guernsey'), ('Guinea'), ('Guinea-Bissau'), ('Guyana'), ('Haiti'), ('Heard Island and McDonald Islands'), ('Vatican City State'), ('Honduras'), ('Hong Kong'), ('Hungary'), ('Iceland'), ('India'), ('Indonesia'), ('Iran'), ('Iraq'), ('Ireland'), ('Isle of Man'), ('Israel'), ('Italy'), ('Jamaica'), ('Japan'), ('Jersey'), ('Jordan'), ('Kazakhstan'), ('Kenya'), ('Kiribati'), ('Korea (Democratic People''s Republic of)'), ('Korea (Republic of)'), ('Kuwait'), ('Kyrgyzstan'), ('Lao People''s Democratic Republic'), ('Latvia'), ('Lebanon'), ('Lesotho'), ('Liberia'), ('Libya'), ('Liechtenstein'), ('Lithuania'), ('Luxembourg'), ('Macao'), ('Macedonia (the former Yugoslav Republic of)'), ('Madagascar'), ('Malawi'), ('Malaysia'), ('Maldives'), ('Mali'), ('Malta'), ('Marshall Islands'), ('Martinique'), ('Mauritania'), ('Mauritius'), ('Mayotte'), ('Mexico'), ('Micronesia (Federated States of)'), ('Moldova (Republic of)'), ('Monaco'), ('Mongolia'), ('Montenegro'), ('Montserrat'), ('Morocco'), ('Mozambique'), ('Myanmar'), ('Namibia'), ('Nauru'), ('Nepal'), ('Netherlands'), ('New Caledonia'), ('New Zealand'), ('Nicaragua'), ('Niger'), ('Nigeria'), ('Niue'), ('Norfolk Island'), ('Northern Mariana Islands'), ('Norway'), ('Oman'), ('Pakistan'), ('Palau'), ('Palestine, State of'), ('Panama'), ('Papua New Guinea'), ('Paraguay'), ('Peru'), ('Philippines'), ('Pitcairn'), ('Poland'), ('Portugal'), ('Puerto Rico'), ('Qatar'), ('Raunion'), ('Romania'), ('Russian Federation'), ('Rwanda'), ('Saint Bartholemy'), ('Saint Helena, Ascension and Tristan da Cunha'), ('Saint Kitts and Nevis'), ('Saint Lucia'), ('Saint Martin (French part)'), ('Saint Pierre and Miquelon'), ('Saint Vincent and the Grenadines'), ('Samoa'), ('San Marino'), ('Sao Tome and Principe'), ('Saudi Arabia'), ('Senegal'), ('Serbia'), ('Seychelles'), ('Sierra Leone'), ('Singapore'), ('Sint Maarten (Dutch part)'), ('Slovakia'), ('Slovenia'), ('Solomon Islands'), ('Somalia'), ('South Africa'), ('South Georgia and the South Sandwich Islands'), ('South Sudan'), ('Spain'), ('Sri Lanka'), ('Sudan'), ('Suriname'), ('Svalbard and Jan Mayen'), ('Swaziland'), ('Sweden'), ('Switzerland'), ('Syrian Arab Republic'), ('Taiwan, Province of China'), ('Tajikistan'), ('Tanzania, United Republic of'), ('Thailand'), ('Timor-Leste'), ('Togo'), ('Tokelau'), ('Tonga'), ('Trinidad and Tobago'), ('Tunisia'), ('Turkey'), ('Turkmenistan'), ('Turks and Caicos Islands'), ('Tuvalu'), ('Uganda'), ('Ukraine'), ('United Arab Emirates'), ('United Kingdom of Great Britain and Northern Ireland'), ('United States Minor Outlying Islands'), ('United States of America'), ('Uruguay'), ('Uzbekistan'), ('Vanuatu'), ('Venezuela Bolivarian Republic'), ('Vietnam'), ('Virgin Islands (British)'), ('Virgin Islands (U.S.)'), ('Wallis and Futuna'), ('Western Sahara'), ('Yemen'), ('Zambia'),
 ('Zimbabwe') 
 ) s(a)) n  )) m;
 
 /* populating nationalities */
 select distinct 'insert into sacco.global_static_params(param_id,param_code,param_value,param_title,param_type_id,param_category_id,status) values (uuid_generate_v4(),''' || m.a || ''',''' || m.a || ''',''' || m.a || ''',''' || m.param_type_id  || ''',''' || m.param_category_id ||  ''',''active'');' as stmt from 
 (with cid as (select param_type_id from sacco.global_param_type where param_type = 'nationality'  ),
  rid as (select param_category_id from sacco.global_param_category where param_category = 'biodata' ) 
( select distinct n.*, p.param_type_id as param_type_id,
  r.param_category_id  from cid p, rid r, (select a 
from (
    values 
('Afghan'), ('Albanian'), ('Algerian'), ('American Samoan'), ('Andorran'), ('Angolan'), ('Anguillan'), ('Antarctic'), ('Antiguan'), ('Barbudan'), ('Argentine'), ('Armenian'), ('Aruban'), ('Australian'), ('Austrian'), ('Azerbaijani'), ('Azeri'), ('Bahamian'), ('Bahraini'), ('Bangladeshi'), ('Barbadian'), ('Belarusian'), ('Belgian'), ('Belizean'), ('Beninese'), ('Beninois'), ('Bermudian'), ('Bermudan'), ('Bhutanese'), ('Bolivian'), ('Bonaire'), ('Bosnian'), ('Herzegovinian'), ('Motswana'), ('Botswanan'), ('Bouvet Island'), ('Brazilian'), ('Biot'), ('Bruneian'), ('Bulgarian'), ('Burkinabe'), ('Burundian'), ('Cabo Verdean'), ('Cambodian'), ('Cameroonian'), ('Canadian'), ('Caymanian'), ('Central African'), ('Chadian'), ('Chilean'), ('Chinese'), ('Christmas Island'), ('Cocos Island'), ('Colombian'), ('Comoran'), ('Comorian'), ('Congolese'), ('Cook Island'), ('Costa Rican'), ('Ivorian'), ('Croatian'), ('Cuban'), ('Cypriot'), ('Czech'), ('Danish'), ('Djiboutian'), ('Dominican'), ('Dominican'), ('Ecuadorian'), ('Egyptian'), ('Salvadoran'), ('Equatorial Guinean'), ('Equatoguinean'), ('Eritrean'), ('Estonian'), ('Ethiopian'), ('Falkland Island'), ('Faroese'), ('Fijian'), ('Finnish'), ('French'), ('French Guianese'), ('French Polynesian'), ('French Southern Territories'), ('Gabonese'), ('Gambian'), ('Georgian'), ('German'), ('Ghanaian'), ('Gibraltar'), ('Greek'), ('Hellenic'), ('Greenlandic'), ('Grenadian'), ('Guadeloupe'), ('Guamanian'), ('Guambat'), ('Guatemalan'), ('Channel Island'), ('Guinean'), ('Bissau-Guinean'), ('Guyanese'), ('Haitian'), ('Heard Island'), ('McDonald Islands'), ('Vatican'), ('Honduran'), ('Hong Kong'), ('Hong Kongese'), ('Hungarian'), ('Magyar'), ('Icelandic'), ('Indian'), ('Indonesian'), ('Iranian'), ('Persian'), ('Iraqi'), ('Irish'), ('Manx'), ('Israeli'), ('Italian'), ('Jamaican'), ('Japanese'), ('Channel Island'), ('Jordanian'), ('Kazakhstani'), ('Kazakh'), ('Kenyan'), ('I-Kiribati'), ('North Korean'), ('South Korean'), ('Kuwaiti'), ('Kyrgyzstani'), ('Kyrgyz'), ('Kirgiz'), ('Kirghiz'), ('Lao'), ('Laotian'), ('Latvian'), ('Lebanese'), ('Basotho'), ('Liberian'), ('Libyan'), ('Liechtenstein'), ('Lithuanian'), ('Luxembourg'), ('Luxembourgish'), ('Macanese'), ('Chinese'), ('Macedonian'), ('Malagasy'), ('Malawian'), ('Malaysian'), ('Maldivian'), ('Malian'), ('Malinese'), ('Maltese'), ('Marshallese'), ('Martiniquais'), ('Martinican'), ('Mauritanian'), ('Mauritian'), ('Mahoran'), ('Mexican'), ('Micronesian'), ('Moldovan'), ('Monegasque'), ('Monacan'), ('Mongolian'), ('Montenegrin'), ('Montserratian'), ('Moroccan'), ('Mozambican'), ('Burmese'), ('Namibian'), ('Nauruan'), ('Nepali'), ('Nepalese'), ('Dutch'), ('Netherlandic'), ('New Caledonian'), ('New Zealand'), ('Nicaraguan'), ('Nigerien'), ('Nigerian'), ('Niuean'), ('Norfolk Island'), ('Northern Marianan'), ('Norwegian'), ('Omani'), ('Pakistani'), ('Palauan'), ('Palestinian'), ('Panamanian'), ('Papua New Guinean'), ('Papuan'), ('Paraguayan'), ('Peruvian'), ('Philippine'), ('Filipino'), ('Pitcairn Island'), ('Polish'), ('Portuguese'), ('Puerto Rican'), ('Qatari'), ('Reunionese'), ('Reunionnais'), ('Romanian'), ('Russian'), ('Rwandan'), ('Barthelemois'), ('Saint Helenian'), ('Kittitian'), ('Nevisian'), ('Saint Lucian'), ('Saint-Martinoise'), ('Saint-Pierrais'), ('Miquelonnais'), ('Saint Vincentian'), ('Vincentian'), ('Samoan'), ('Sammarinese'), ('Sao Tomean'), ('Saudi'), ('Saudi Arabian'), ('Senegalese'), ('Serbian'), ('Seychellois'), ('Sierra Leonean'), ('Singaporean'), ('Sint Maarten'), ('Slovak'), ('Slovenian'), ('Slovene'), ('Solomon Island'), ('Somali'), ('Somalian'), ('South African'), ('South Georgia'), ('South Sandwich Islands'), ('South Sudanese'), ('Spanish'), ('Sri Lankan'), ('Sudanese'), ('Surinamese'), ('Svalbard'), ('Swazi'), ('Swedish'), ('Swiss'), ('Syrian'), ('Chinese'), ('Taiwanese'), ('Tajikistani'), ('Tanzanian'), ('Thai'), ('Timorese'), ('Togolese'), ('Tokelauan'), ('Tongan'), ('Trinidadian'), ('Tobagonian'), ('Tunisian'), ('Turkish'), ('Turkmen'), ('Turks and Caicos Island'), ('Tuvaluan'), ('Ugandan'), ('Ukrainian'), ('Emirati'), ('Emirian'), ('Emiri'), ('British'), ('American'), ('American'), ('Uruguayan'), ('Uzbekistani'), ('Uzbek'), ('Ni-Vanuatu'), ('Vanuatuan'), ('Venezuelan'), ('Vietnamese'), ('British Virgin Island'), ('U.S. Virgin Island'), ('Wallis and Futuna'), ('Wallisian'), ('Futunan'), ('Sahrawi'), ('Sahrawian'), ('Sahraouian'), ('Yemeni'), ('Zambian'),
 ('Zimbabwean') 
 ) s(a)) n  )) m;
 
 /*  populating districts */
 
 select distinct 'insert into sacco.global_static_params(param_id,param_code,param_value,param_title,param_type_id,param_category_id,status) values (uuid_generate_v4(),''' || m.a || ''',''' || m.a || ''',''' || m.a || ''',''' || m.param_type_id  || ''',''' || m.param_category_id ||  ''',''active'');' as stmt from 
 (with cid as (select param_type_id from sacco.global_param_type where param_type = 'district'  ),
  rid as (select param_category_id from sacco.global_param_category where param_category = 'regions' ) 
( select distinct n.*, p.param_type_id as param_type_id,
  r.param_category_id  from cid p, rid r, (select a
from (
    values 
('MITOOMA'), ('RUKIGA'), ('MUBENDE'), ('BUNYANGABU'), ('LYANTONDE'), ('HOIMA CITY'), ('PALLISA'), ('OBONGI'), ('BUDUDA'), ('AMURIA'), ('NAKAPIRIPIRIT'), ('BUTAMBALA'), ('AMUDAT'), ('NEBBI'), ('BUIKWE'), ('KAZO'), ('MARACHA'), ('ARUA'), ('KWANIA'), ('IGANGA'), ('PADER'), ('KAGADI'), ('NABILATUK'), ('GULU'), ('NGORA'), ('BUHWEJU'), ('BULAMBULI'), ('BUDAKA'), ('PAKWACH'), ('KAPELEBYONG'), ('OYAM'), ('KAPCHORWA'), ('NAPAK'), ('TEREGO'), ('RUBANDA'), ('AMOLATAR'), ('KUMI'), ('RAKAI'), ('ADJUMANI'), ('BUNDIBUGYO'), ('NTOROKO'), ('LIRA'), ('MBALE CITY'), ('KASESE'), ('NWOYA'), ('MBARARA CITY'), ('KITAGWENDA'), ('KYOTERA'), ('GULU CITY'), ('SERERE'), ('KISORO'), ('KANUNGU'), ('BUGIRI'), ('MUKONO'), ('BUSHENYI'), ('ABIM'), ('ISINGIRO'), ('KARENGA'), ('BUKOMANSIMBI'), ('NAMUTUMBA'), ('KYANKWANZI'), ('RWAMPARA'), ('SOROTI CITY'), ('NAMAYINGO'), ('FORT PORTAL CITY'), ('SOROTI'), ('KABAROLE'), ('MASAKA'), ('KATAKWI'), ('AMURU'), ('KOTIDO'), ('HOIMA'), ('KALANGALA'), ('KALIRO'), ('KABALE'), ('KAMULI'), ('RUKUNGIRI'), ('KWEEN'), ('TORORO'), ('KASSANDA'), ('MASAKA CITY'), ('OMORO'), ('AGAGO'), ('BUSIA'), ('NAKASONGOLA'), ('RUBIRIZI'), ('MBARARA'), ('BUTALEJA'), ('KOBOKO'), ('LUWEERO'), ('BUVUMA'), ('BUYENDE'), ('NAKASEKE'), ('KIBOGA'), ('KABERAMAIDO'), ('NAMISINDWA'), ('NTUNGAMO'), ('MOYO'), ('JINJA'), ('SSEMBABULE'), ('KAYUNGA'), ('KYEGEGWA'), ('WAKISO'), ('MANAFWA'), ('KITGUM'), ('SIRONKO'), ('LIRA CITY'), ('JINJA CITY'), ('BUKWO'), ('KIBAALE'), ('KAMPALA'), ('YUMBE'), ('KIBUKU'), ('ARUA CITY'), ('IBANDA'), ('BUGWERI'), ('MAYUGE'), ('LWENGO'), ('MPIGI'), ('GOMBA'), ('KAKUMIRO'), ('KALAKI'), ('BULIISA'), ('MADI-OKOLLO'), ('KIRYANDONGO'), ('APAC'), ('KALUNGU'), ('KOLE'), ('SHEEMA'), ('LUUKA'), ('KAABONG'), ('DOKOLO'), ('OTUKE'), ('KYENJOJO'), ('KIKUUBE'), ('BUTEBO'), ('MBALE'), ('MASINDI'), ('KIRUHURA'), ('BUKEDEA'), ('KAMWENGE'), ('LAMWO'), ('ALEBTONG'), ('MITYANA'), ('MOROTO'),
 ('ZOMBO') 
 ) s(a)) n  )) m;
 
 
 /*  subcounties */
 
 select distinct 'insert into sacco.global_static_params(param_id,param_code,param_value,param_title,param_type_id,param_category_id,status) values (uuid_generate_v4(),''' || m.a || ''',''' || m.a || ''',''' || m.a || ''',''' || m.param_type_id  || ''',''' || m.param_category_id ||  ''',''active'');' as stmt from 
 (with cid as (select param_type_id from sacco.global_param_type where param_type = 'subcounty'  ),
  rid as (select param_category_id from sacco.global_param_category where param_category = 'regions' ) 
( select distinct n.*, p.param_type_id as param_type_id,
  r.param_category_id  from cid p, rid r, (select a 
from (
    values 
('ABAKO'), ('ABANGA'), ('ABARILELA'), ('ABEJA'), ('ABER'), ('ABIA'), ('ABILIYEP'), ('ABIM'), ('ABIM TOWN COUNCIL'), ('ABINDU DIVISION'), ('ABOK'), ('ABOKE'), ('ABOKE TOWN COUNCIL'), ('ABONGOMOLA'), ('ABUGA'), ('ABUK TOWN COUNCIL'), ('ABUKU'), ('ACANA'), ('ACEBA'), ('ACET TOWN COUNCIL'), ('ACHABA'), ('ACHOLI-BUR'), ('ACHOLI_BUR TOWN COUNCIL'), ('ACHORICHOR'), ('ACII'), ('ACINGA'), ('ACOWA'), ('ACOWA TOWN COUNCIL'), ('ADEKNINO'), ('ADEKOKWOK'), ('ADILANG'), ('ADILANG TOWN COUNCIL'), ('ADJUMANI TOWN COUNCIL'), ('ADOK'), ('ADROPI'), ('ADUKU'), ('ADUKU TOWN COUNCIL'), ('ADUMI'), ('ADWARI'), ('ADWARI TOWN COUNCIL'), ('ADWIR'), ('ADYEL'), ('AGAGO TOWN COUNCIL'), ('AGAII TOWN COUNCIL'), ('AGALI'), ('AGENGO'), ('AGIKDAK'), ('AGIRIGIROI'), ('AGORO'), ('AGULE'), ('AGULE TOWN COUNCIL'), ('AGULLU DIVISION'), ('AGWATA TOWN COUNCIL'), ('AGWATTA'), ('AGWENG'), ('AGWENG TOWN COUNCIL'), ('AGWINGIRI'), ('AII-VU/AJIVU'), ('AJALI'), ('AJAN'), ('AJIA'), ('AJIRA'), ('AKAA'), ('AKADOT'), ('AKALI'), ('AKALO'), ('AKALO TOWN COUNCIL'), ('AKAYANJA'), ('AKERE DIVISION'), ('AKERIAU'), ('AKIDI'), ('AKISIM'), ('AKOBOI'), ('AKOKORO'), ('AKOKORO TOWN COUNCIL'), ('AKORE TOWN COUNCIL'), ('AKOROMIT'), ('AKURA'), ('AKWANG'), ('AKWON'), ('AKWORO'), ('ALALA'), ('ALANGI'), ('ALANGO'), ('ALEBTONG TOWN COUNCIL'), ('ALEKA'), ('ALEREK'), ('ALEREK TOWN COUNCIL'), ('ALERO'), ('ALIBA'), ('ALIGOI'), ('ALIKUA'), ('ALITO'), ('ALITO TOWN COUNCIL'), ('ALOI'), ('ALOI TOWN COUNCIL'), ('ALURU'), ('ALWA'), ('ALWI'), ('AMACH'), ('AMACH TOWN COUNCIL'), ('AMANANG'), ('AMINIT'), ('AMOLATAR TOWN COUNCIL'), ('AMOLO'), ('AMUDAT'), ('AMUDAT TOWN COUNCIL'), ('AMUGU'), ('AMUGU TOWN COUNCIL'), ('AMUKOL'), ('AMURIA TOWN COUNCIL'), ('AMURU'), ('AMURU TOWN COUNCIL'), ('AMUSIA'), ('AMWOMA'), ('ANAKA (PAYIRA'), ('ANAKA (PAYIRA)'), ('ANAKA TOWN COUNCIL'), ('ANGAGURA'), ('ANGETTA'), ('ANGODINGOD'), ('ANYARA'), ('ANYIRIBU'), ('APAC'), ('APAC TOWN COUNCIL'), ('APALA'), ('APALA TOWN COUNCIL'), ('APAPAI'), ('APEDURU'), ('APEITOLIM'), ('APERIKIRA'), ('APETAI'), ('APO'), ('APOI'), ('APOKORI TOWN COUNCIL'), ('APOPONG'), ('APUTI'), ('ARAFA'), ('ARAPAI'), ('AREMO'), ('ARIA'), ('ARILO'), ('ARINYAPI'), ('ARIVU'), ('ARIWA'), ('AROCHA DIVISION'), ('AROI'), ('AROMO'), ('ARUA CENTRAL DIVISION'), ('ARUA HILL'), ('ARUM'), ('ARWOTCEK'), ('ASAMUK'), ('ASAMUK TOWN COUNCIL'), ('ASURET'), ('ATANGA'), ('ATANGA TOWN COUNCIL'), ('ATEGO'), ('ATHUMA'), ('ATIAK'), ('ATIAK TOWN COUNCIL'), ('ATIIRA'), ('ATIK DIVISION'), ('ATONGTIDI'), ('ATOOT'), ('ATUNGA'), ('ATUTUR'), ('ATYAK'), ('AUKOT'), ('AWACH'), ('AWALIWAL'), ('AWEI'), ('AWELLO'), ('AWERE'), ('AWIZIRU'), ('AYABI'), ('AYABI TOWN COUNCIL'), ('AYAMI'), ('AYER'), ('AYIVU DIVISION'), ('AYIVUNI'), ('BAGEZZA'), ('BAITAMBOGWE'), ('BALA'), ('BALA TOWN COUNCIL'), ('BALAWOLI'), ('BALAWOLI TOWN COUNCIL'), ('BALLA'), ('BAMUNANIKA'), ('BANANYWA'), ('BANDA'), ('BANDA TOWN COUNCIL'), ('BARAKALA TOWN COUNCIL'), ('BAR-DEGE'), ('BARDEGE-LAYIBI DIVISION'), ('BARJOBI'), ('BARJOBI TOWN COUNCIL'), ('BARR'), ('BATALIKA'), ('BATA TOWN COUNCIL'), ('BATTA'), ('BBAALE'), ('BBANDA'), ('BBANDA TOWN COUNCIL'), ('BELEAFE'), ('BENET'), ('BIGASA'), ('BIGODI TOWN COUNCIL'), ('BIGULI'), ('BIGULI TOWN COUNCIL'), ('BIHANGA'), ('BIHARWE'), ('BIISO'), ('BIISO TOWN COUNCIL'), ('BIJO'), ('BIKONZI'), ('BIKURUNGU TOWN COUNCIL'), ('BINYINY'), ('BINYINYI TOWN COUNCIL'), ('BINYINY TOWN COUNCIL'), ('BIREMBO'), ('BIRERE'), ('BISHESHE'), ('BISHESHE DIVISION'), ('BITEREKO'), ('BITOOMA'), ('BITOOMA TOWN COUNCIL'), ('BITSYA'), ('BOBI'), ('BOLISO I'), ('BOMBO'), ('BOMBO TOWN COUNCIL'), ('BONGTIKO'), ('BRIM'), ('BUBAARE'), ('BUBAARE TOWN COUNCIL'), ('BUBANDI'), ('BUBANGO'), ('BUBARE'), ('BUBBEZA'), ('BUBEKE'), ('BUBIITA'), ('BUBUKWANGA'), ('BUBUTU'), ('BUBUTU TOWN COUNCIL'), ('BUBYANGU'), ('BUDADIRI TOWN COUNCIL'), ('BUDAKA'), ('BUDAKA TOWN COUNCIL'), ('BUDDE'), ('BUDHAYA'), ('BUDOMERO'), ('BUDONDO'), ('BUDONGO'), ('BUDUDA'), ('BUDUDA TOWN COUNCIL'), ('BUDUMBA'), ('BUDWALE'), ('BUFUJJA-KACHONGA TOWN COUNCIL'), ('BUFUMA'), ('BUFUMBO'), ('BUFUMIRA'), ('BUFUNDA DIVISION'), ('BUFUNDI'), ('BUFUNJO'), ('BUGAAKI'), ('BUGADDE TOWN COUNCIL'), ('BUGAMBA'), ('BUGAMBE'), ('BUGAMBI'), ('BUGANGARI'), ('BUGANGO TOWN COUNCIL'), ('BUGANIKERE TOWN COUNCIL'), ('BUGAYA'), ('BUGEMBE TOWN COUNCIL'), ('BUGINYANYA'), ('BUGIRI TOWN COUNCIL'), ('BUGITIMWA'), ('BUGOBERO'), ('BUGOBERO TOWN COUNCIL'), ('BUGOBI'), ('BUGOBI TOWN COUNCIL'), ('BUGOGO TOWN COUNCIL'), ('BUGONDO'), ('BUGONGI'), ('BUGONGI TOWN COUNCIL'), ('BUGOYE'), ('BUGULUMBYA'), ('BUGUSEGE TOWN COUNCIL'), ('BUHANDA'), ('BUHANIKA'), ('BUHARA'), ('BUHEESI'), ('BUHEESI TOWN COUNCIL'), ('BUHEHE'), ('BUHEMBA'), ('BUHIMBA'), ('BUHIMBA TOWN COUNCIL'), ('BUHOMA TOWN COUNCIL'), ('BUHUGU'), ('BUHUHIRA'), ('BUHUMULIRO'), ('BUHUNGA'), ('BUIKWE'), ('BUIKWE TOWN COUNCIL'), ('BUJUMBA'), ('BUJUMBURA DIVISION'), ('BUKABOOLI'), ('BUKAKATA'), ('BUKALASI'), ('BUKAMBA'), ('BUKANA'), ('BUKANGA'), ('BUKANGO'), ('BUKASAKYA'), ('BUKATUBE'), ('BUKEDEA'), ('BUKEDEA TOWN COUNCIL'), ('BUKEWA'), ('BUKHABUSI'), ('BUKHADALA'), ('BUKHALU'), ('BUKHAWEKA'), ('BUKHIENDE'), ('BUKHOFU'), ('BUKHULO'), ('BUKIABI'), ('BUKIBINO'), ('BUKIBOKOLO'), ('BUKIGAI'), ('BUKIGAI TOWN COUNCIL'), ('BUKIIRO'), ('BUKIIRO TOWN COUNCIL'), ('BUKIISE'), ('BUKIITI TOWN COUNCIL'), ('BUKIMBIRI'), ('BUKINDA'), ('BUKIYI'), ('BUKOHO'), ('BUKOKHO'), ('BUKOMA'), ('BUKOMANSIMBI TOWN COUNCIL'), ('BUKOMERO'), ('BUKOMERO TOWN COUNCIL'), ('BUKONDE'), ('BUKONZO'), ('BUKOOMA'), ('BUKOOVA TOWN COUNCIL'), ('BUKULULA'), ('BUKUNGU TOWN COUNCIL'), ('BUKURUNGO TOWN COUNCIL'), ('BUKUSU'), ('BUKUUKU'), ('BUKUYA'), ('BUKUYA TOWN COUNCIL'), ('BUKWA'), ('BUKWHAWEKA TOWN COUNCIL'), ('BUKWO TOWN COUNCIL'), ('BUKYABO'), ('BUKYAMBI'), ('BULAGO'), ('BULAMAGI'), ('BULAMBULI TOWN COUNCIL'), ('BULANGA TOWN COUNCIL'), ('BULANGE'), ('BULANGIRA'), ('BULANGIRA TOWN COUNCIL'), ('BULEGENI'), ('BULEGENI TOWN COUNCIL'), ('BULEMBIA DIVISION'), ('BULERA'), ('BULESA'), ('BULIDHA'), ('BULIISA'), ('BULIISA TOWN COUNCIL'), ('BULIMA TOWN COUNCIL'), ('BULINDI TOWN COUNCIL'), ('BULO'), ('BULONGO'), ('BULOPA'), ('BULUCHEKE'), ('BULUGANYA'), ('BULUGUYI'), ('BULULU'), ('BULUMBA TOWN COUNCIL'), ('BULUMBI'), ('BUMALIMBA'), ('BUMANYA'), ('BUMASHETI'), ('BUMASIFWA'), ('BUMASIKYE'), ('BUMASOBO'), ('BUMAYOKA'), ('BUMBAIRE'), ('BUMBO'), ('BUMBOBI'), ('BUMBO TOWN COUNCIL'), ('BUMITYERO'), ('BUMUFUNI'), ('BUMUGIBOLE'), ('BUMULISHA'), ('BUMUMALI'), ('BUMWALUKANI'), ('BUMWONI'), ('BUNABUTITI'), ('BUNABUTSALE'), ('BUNABWANA'), ('BUNAGANA TOWN COUNCIL'), ('BUNALWERE'), ('BUNAMBUTYE'), ('BUNAMWAYA DIVISION'), ('BUNATSAMI'), ('BUNDESI'), ('BUNDIBUGYO TOWN COUNCIL'), ('BUNDINGOMA'), ('BUNGATI'), ('BUNGATIRA'), ('BUNGOKHO'), ('BUNYAFWA'), ('BUPOTO'), ('BURARU'), ('BUREMBA'), ('BUREMBA TOWN COUNCIL'), ('BURERE'), ('BURONDO'), ('BURORA'), ('BURUNGA'), ('BUSAANA'), ('BUSAANA TOWN COUNCIL'), ('BUSABA'), ('BUSABA TOWN COUNCIL'), ('BUSABI'), ('BUSAKIRA'), ('BUSALAMU TOWN COUNCIL'), ('BUSAMAGA'), ('BUSAMUZI'), ('BUSANO'), ('BUSANZA'), ('BUSARU'), ('BUSEDDE'), ('BUSEMBATIA TOWN COUNCIL'), ('BUSERUKA'), ('BUSETA'), ('BUSHIKA'), ('BUSHIRIBO'), ('BUSHIYI'), ('BUSIIKA TOWN COUNCIL'), ('BUSIISI DIVISION'), ('BUSIITA'), ('BUSIMBI'), ('BUSIMBI DIVISION'), ('BUSIME'), ('BUSIRIBA'), ('BUSIRIWA'), ('BUSITEMA'), ('BUSIU'), ('BUSIU TOWN COUNCIL'), ('BUSOBA'), ('BUSOLWE'), ('BUSOLWE TOWN COUNCIL'), ('BUSORO'), ('BUSOWA TOWN COUNCIL'), ('BUSSI'), ('BUSUKUMA DIVISION'), ('BUSUKUYA'), ('BUSULANI'), ('BUSUNGA TOWN COUNCIL'), ('BUSUNJU TOWN COUNCIL'), ('BUSWALE'), ('BUTAGAYA'), ('BUTALEJA'), ('BUTALEJA TOWN COUNCIL'), ('BUTAMA-MITUNDA TOWN COUNCIL'), ('BUTANDA'), ('BUTANDIGA'), ('BUTANDIGA TOWN COUNCIL'), ('BUTANSI'), ('BUTARE-KATOJO TOWN COUNCIL'), ('BUTAYUNJA'), ('BUTEBA'), ('BUTEBO'), ('BUTEBO TOWN COUNCIL'), ('BUTEMBA'), ('BUTEMBA TOWN COUNCIL'), ('BUTENGA'), ('BUTENGA TOWN COUNCIL'), ('BUTERANIRO-NYEIHANGA TOWN COUNCIL'), ('BUTEZA'), ('BUTEZA TOWN COUNCIL'), ('BUTIABA'), ('BUTIABA TOWN COUNCIL'), ('BUTIITI'), ('BUTIITI TOWN COUNCIL'), ('BUTIRU'), ('BUTIRU TOWN COUNCIL'), ('BUTOGOTA TOWN COUNCIL'), ('BUTOLOOGO'), ('BUTOOTO'), ('BUTTA'), ('BUTUNDUZI'), ('BUTUNDUZI TOWN COUNCIL'), ('BUTUNGAMA'), ('BUTUNTUMULA'), ('BUVUMA TOWN COUNCIL'), ('BUWAAYA'), ('BUWABWALA'), ('BUWAGOGO'), ('BUWALASI'), ('BUWALI'), ('BUWAMA'), ('BUWAMA TOWN COUNCIL'), ('BUWAMBWA'), ('BUWANGANI TOWN COUNCIL'), ('BUWANYANGA'), ('BUWASA'), ('BUWATUWA'), ('BUWAYA TOWN COUNCIL'), ('BUWENGE'), ('BUWENGE TOWN COUNCIL'), ('BUWERI TOWN COUNCIL'), ('BUWOOYA'), ('BUWUNGA'), ('BUWUNI TOWN COUNCIL'), ('BUYAGA TOWN COUNCIL'), ('BUYANGA'), ('BUYANJA'), ('BUYANJA TOWN COUNCIL'), ('BUYENDE'), ('BUYENDE TOWN COUNCIL'), ('BUYENGO'), ('BUYENGO TOWN COUNCIL'), ('BUYINDA'), ('BUYINJA'), ('BUYINZA TOWN COUNCIL'), ('BUYOBO'), ('BWAMBARA'), ('BWAMIRAMIRA'), ('BWANSWA'), ('BWEEMA'), ('BWERA'), ('BWERAMULE'), ('BWESUMBU'), ('BWEYALE TOWN COUNCIL'), ('BWEYOGERERE DIVISION'), ('BWIJANGA'), ('BWIKARA'), ('BWIKHONGE'), ('BWIZI'), ('BWIZIBWERA-RUTOOMA TOWN COUNCIL'), ('BWONDHA TOWN COUNCIL'), ('BWONGERA'), ('BWONGYERA'), ('BYAKABANDA'), ('BYERIMA'), ('CAMKOK'), ('CAWENTE'), ('CENTRAL DIVISION'), ('CHAHAFI TOWN COUNCIL'), ('CHAHI'), ('CHEGERE'), ('CHELEKURA'), ('CHEMA'), ('CHEPKWASTA'), ('CHEPSUKUNYA TOWN COUNCIL'), ('CHEPTERECH'), ('CHESOWER'), ('CIFORO'), ('CYANIKA TOWN COUNCIL'), ('DABANI'), ('DADAMU'), ('DAHAMI'), ('DDWANIRO'), ('DEI'), ('DIIMA'), ('DIVISION A'), ('DIVISION B'), ('DOKOLO'), ('DOKOLO TOWN COUNCIL'), ('DRAJINI/ARAJIM'), ('DRAMBU'), ('DRANYA'), ('DUFILE'), ('DYANGO TOWN COUNCIL'), ('DZAIPI'), ('EAST DIVISION'), ('EASTERN'), ('EASTERN DIVISION'), ('ELEGU TOWN COUNCIL'), ('ELGON'), ('ENDIINZI TOWN COUNCIL'), ('ENDINZI'), ('ENGAJU'), ('ENGARI'), ('ERUSSI'), ('ETAM'), ('ETAM TOWN COUNCIL'), ('EWAFA'), ('EWANGA'), ('FORT PORTAL CENTRAL DIVISION'), ('FORT PORTAL NORTH DIVISION'), ('GADUMIRE'), ('GALIBOLEKA'), ('GALIRAYA'), ('GAMOGO'), ('GAYAZA'), ('GEREGERE'), ('GETOM'), ('GIMARA'), ('GOGONYO'), ('GOLI-GOLI'), ('GOMA DIVISION'), ('GOMBE'), ('GOMBE DIVISION'), ('GOMBE GASAWA TOWN COUNCIL'), ('GOMBE TOWN COUNCIL'), ('GOT APWOYO'), ('GREEK RIVER'), ('GUMPI'), ('GURU GURU'), ('GUYAGUYA'), ('GWERI'), ('HABUHUTU-MUGYERA TOWN COUNCIL'), ('HAKIBALE'), ('HAMUHAMBO TOWN COUNCIL'), ('HAMURWA'), ('HAMURWA TOWN COUNCIL'), ('HAPUUYO'), ('HAPUUYO TOWN COUNCIL'), ('HARUGALI'), ('HARUGONGO'), ('HIMA TOWN COUNCIL'), ('HIMUTU'), ('HOIMA EAST DIVISION'), ('HOIMA WEST DIVISION'), ('IBAARE'), ('IBANDA-KYANYA TOWN COUNCIL'), ('IBANDA TOWN COUNCIL'), ('IBUJE'), ('IBUJE TOWN COUNCIL'), ('IBULANKU'), ('ICHEME'), ('ICHEME TOWN COUNCIL'), ('IDUDI TOWN COUNCIL'), ('IGAYAZA TOWN COUNCIL'), ('IGOMBE'), ('IGORORA TOWN COUNCIL'), ('IHANDIRO'), ('IHUNGA'), ('IKI-IKI'), ('IKI-IKI TOWN COUNCIL'), ('IKUMBA'), ('IKUMBYA'), ('IMANYIRO'), ('INDE TOWN COUNCIL'), ('INDUSTRIAL BOROUGH'), ('INDUSTRIAL DIVISION'), ('INOMO'), ('INOMO TOWN COUNCIL'), ('IRIIRI'), ('IRONGO'), ('IRUNDU'), ('IRUNDU TOWN COUNCIL'), ('ISANGO'), ('ISHAKA DIVISION'), ('ISHONGORORO'), ('ISHONGORORO TOWN COUNCIL'), ('ISINGIRO TOWN COUNCIL'), ('ISUNGA'), ('ITEK'), ('ITIRIKWA'), ('ITOJO'), ('ITULA'), ('IVUKULA'), ('IVUKULA TOWN COUNCIL'), ('IWEMBA'), ('IYOLWA'), ('IYOLWA TOWN COUNCIL'), ('JAGUZI'), ('JANGOKORO'), ('JEWA TOWN COUNCIL'), ('JINJA CENTRAL'), ('JINJA NORTH DIVISION'), ('JINJA SOUTH DIVISION'), ('JUPANGIRA'), ('KAABONG EAST'), ('KAABONG TOWN COUNCIL'), ('KAABONG WEST'), ('KAASANGOMBE'), ('KAATO'), ('KAAWACH'), ('KABAALE'), ('KABALE CENTRAL'), ('KABALE NORTHERN'), ('KABALE SOUTHERN'), ('KABAMBA'), ('KABAMBIRO'), ('KABANGO TOWN COUNCIL'), ('KABARWA'), ('KABASEKENDE'), ('KABATUNDA-KIRABAHO TOWN COUNCIL'), ('KABEI'), ('KABELAI'), ('KABENDE'), ('KABERAMAIDO'), ('KABERAMAIDO TOWN COUNCIL'), ('KABEREBERE TOWN COUNCIL'), ('KABEYWA'), ('KABINGO'), ('KABIRA'), ('KABIRA TOWN COUNCIL'), ('KABONERA'), ('KABONERO'), ('KABUGA TOWN COUNCIL'), ('KABUJOGERA TOWN COUNCIL'), ('KABULASOKE'), ('KABUNA'), ('KABURA TOWN COUNCIL'), ('KABUYANDA'), ('KABUYANDA TOWN COUNCIL'), ('KABWANGASI'), ('KABWANGASI TOWN COUNCIL'), ('KABWERI'), ('KABWOHE DIVISION'), ('KABWOHE/ITENDERO TOWN COUNCIL'), ('KABWOYA'), ('KACERERE TOWN COUNCIL'), ('KACHEERA'), ('KACHERI'), ('KACHERI TOWN COUNCIL'), ('KACHOMO'), ('KACHOMO TOWN COUNCIL'), ('KACHONGA'), ('KACHUMBALA'), ('KACHURU'), ('KADAMA'), ('KADAMA TOWN COUNCIL'), ('KADAMI'), ('KADERUNA'), ('KADIMUKOLI'), ('KADOKOLENE'), ('KADUNGULU'), ('KADUNGULU TOWN COUNCIL'), ('KAFUNJO-MIRAMA TOWN COUNCIL'), ('KAGADI'), ('KAGADI TOWN COUNCIL'), ('KAGAMBA'), ('KAGAMBA (BUYAMBA)'), ('KAGANGO'), ('KAGANGO DIVISION'), ('KAGARAMA'), ('KAGARAMA TOWN COUNCIL'), ('KAGHEMA TOWN COUNCIL'), ('KAGOLOGOLO TOWN COUNCIL'), ('KAGONGI'), ('KAGONGO DIVISION'), ('KAGUGU'), ('KAGULU'), ('KAGUMBA'), ('KAGUMU'), ('KAGWARA TOWN COUNCIL'), ('KAHARO'), ('KAHOKYA'), ('KAHOORA DIVISION'), ('KAHUNGE'), ('KAHUNGE TOWN COUNCIL'), ('KAHUNGYE'), ('KAJJANSI TOWN COUNCIL'), ('KAKABARA'), ('KAKABARA TOWN COUNCIL'), ('KAKAMAR'), ('KAKAMBA'), ('KAKANJU'), ('KAKASI'), ('KAKIIKA'), ('KAKINDO'), ('KAKINDO TOWN COUNCIL'), ('KAKINDU'), ('KAKINGA TOWN COUNCIL'), ('KAKIRA TOWN COUNCIL'), ('KAKIRI'), ('KAKIRI TOWN COUNCIL'), ('KAKOBA'), ('KAKOLI'), ('KAKOMONGOLE'), ('KAKOOGE'), ('KAKOOGE TOWN COUNCIL'), ('KAKORO'), ('KAKORO TOWN COUNCIL'), ('KAKUKURU-RWENANURA TOWN COUNCIL'), ('KAKULE'), ('KAKUMIRO TOWN COUNCIL'), ('KAKURE'), ('KAKURES'), ('KAKUTU'), ('KAKUUTO'), ('KAKWANGA'), ('KALAGALA'), ('KALAIT'), ('KALAKI'), ('KALAKI TOWN COUNCIL'), ('KALAMBA'), ('KALAMBA TOWN COUNCIL'), ('KALANGAALO'), ('KALANGALA TOWN COUNCIL'), ('KALAPATA'), ('KALAPATA TOWN COUNCIL'), ('KALIIRO'), ('KALIIRO TOWN COUNCIL'), ('KALIRO'), ('KALIRO TOWN COUNCIL'), ('KALISIZO'), ('KALISIZO TOWN COUNCIL'), ('KALONGA'), ('KALONGO'), ('KALONGO TOWN COUNCIL'), ('KALUNGI'), ('KALUNGU'), ('KALUNGU TOWN COUNCIL'), ('KALWANA'), ('KAMACA'), ('KAMA TOWN COUNCIL'), ('KAMBUGA'), ('KAMBUGA TOWN COUNCIL'), ('KAMDINI'), ('KAMDINI TOWN COUNCIL'), ('KAMEKE'), ('KAMERUKA'), ('KAMET'), ('KAMION'), ('KAMIRA'), ('KAMIRA TOWN COUNCIL'), ('KAMMENGO'), ('KAMONKOLI'), ('KAMONKOLI TOWN COUNCIL'), ('KAMOR'), ('KAMPALA CENTRAL'), ('KAMU'), ('KAMUBEIZI'), ('KAMUBEIZI TOWN COUNCIL'), ('KAMUDA'), ('KAMUGANGUZI'), ('KAMUGE'), ('KAMUGE TOWN COUNCIL'), ('KAMUKUZI'), ('KAMULI'), ('KAMULI TOWN COUNCIL'), ('KAMUROZA'), ('KAMUTUR'), ('KAMWENGE'), ('KAMWENGE TOWN COUNCIL'), ('KAMWEZI'), ('KANABA'), ('KANAIR'), ('KANAPA'), ('KANARA'), ('KANARA TOWN COUNCIL'), ('KANGAI'), ('KANGAI TOWN COUNCIL'), ('KANGINIMA'), ('KANGINIMA TOWN COUNCIL'), ('KANGO'), ('KANGOLE'), ('KANGOLE TOWN COUNCIL'), ('KANGULUMIRA'), ('KANGULUMIRA TOWN COUNCIL'), ('KANONI'), ('KANONI TOWN COUNCIL'), ('KANUNGU TOWN COUNCIL'), ('KANYABEEBE'), ('KANYABWANGA'), ('KANYANTOROGO'), ('KANYANTOROGO TOWN COUNCIL'), ('KANYARUGIRI TOWN COUNCIL'), ('KANYARYERU'), ('KANYEGARAMIRE'), ('KANYUM'), ('KANYUM TOWN COUNCIL'), ('KAPAAPI'), ('KAPCHESOMBE'), ('KAPCHORWA TOWN COUNCIL'), ('KAPEDO'), ('KAPEDO TOWN COUNCIL'), ('KAPEEKA'), ('KAPEKE'), ('KAPELEBYONG'), ('KAPELEBYOUNG TOWN COUNCIL'), ('KAPETA'), ('KAPIR'), ('KAPKOROS'), ('KAPKWATA'), ('KAPNANDI TOWN COUNCIL'), ('KAPNARKUT TOWN COUNCIL'), ('KAPRORON'), ('KAPRORON TOWN COUNCIL'), ('KAPSARUR'), ('KAPSINDA'), ('KAPTANYA'), ('KAPTERERWO'), ('KAPTERET'), ('KAPTOYOY'), ('KAPTUM'), ('KAPUJAN'), ('KAPUNYASI'), ('KAPYANGA'), ('KARAMA'), ('KARAMBI'), ('KARANGURA'), ('KARENGA'), ('KARENGA(NAPORE)'), ('KARENGA TOWN COUNCIL'), ('KARITA'), ('KARITA TOWN COUNCIL'), ('KARUGUTU'), ('KARUGUTU TOWN COUNCIL'), ('KARUJUBU DIVISION'), ('KARUMA TOWN COUNCIL'), ('KARUNGU'), ('KARUSANDARA'), ('KASAALI'), ('KASAALI TOWN COUNCIL'), ('KASAANA'), ('KASAGAMA'), ('KASAMBIRA TOWN COUNCIL'), ('KASAMBYA'), ('KASAMBYA TOWN COUNCIL'), ('KASANGATI TOWN COUNCIL'), ('KASANJE'), ('KASANJE TOWN COUNCIL'), ('KASANKALA'), ('KASASA'), ('KASASIRA'), ('KASASIRA TOWN COUNCIL'), ('KASAWO'), ('KASAWO TOWN COUNCIL'), ('KASEKO'), ('KASENDA'), ('KASENDA TOWN COUNCIL'), ('KASENSERO TOWN COUNCIL'), ('KASEREM'), ('KASHAMBYA'), ('KASHANGURA'), ('KASHARE'), ('KASHASHA TOWN COUNCIL'), ('KASHENSHERO'), ('KASHENSHERO TOWN COUNCIL'), ('KASHENYI-KAJANI TOWN COUNCIL'), ('KASHONGI'), ('KASHOZI DIVISION'), ('KASHUMBA'), ('KASILO TOWN COUNCIL'), ('KASIMBI'), ('KASITU'), ('KASODO'), ('KASOKWE'), ('KASSANDA'), ('KASSANDA TOWN COUNCIL'), ('KASULE'), ('KATABI'), ('KATABI TOWN COUNCIL'), ('KATABOK'), ('KATAJULA'), ('KATAKWI'), ('KATAKWI TOWN COUNCIL'), ('KATANDA'), ('KATEEBWA'), ('KATENGA'), ('KATERERA'), ('KATERERA TOWN'), ('KATERERA TOWN COUNCIL'), ('KATETA'), ('KATETE'), ('KATHILE'), ('KATHILE SOUTH'), ('KATHILE TOWN COUNCIL'), ('KATIKAMU'), ('KATIKARA'), ('KATIKEKILE'), ('KATIMAKU'), ('KATINE'), ('KATIRA'), ('KATOOKE'), ('KATOOKE TOWN COUNCIL'), ('KATOSI TOWN COUNCIL'), ('KATOVU TOWN COUNCIL'), ('KATRINI'), ('KATUM'), ('KATUNA TOWN COUNCIL'), ('KATUNGURU'), ('KATUUGO TOWN COUNCIL'), ('KATWE'), ('KATWE/BUTEGO'), ('KAUKURA'), ('KAWALAKOL'), ('KAWANDA'), ('KAWEMPE DIVISION'), ('KAWOLO'), ('KAWOLO DIVISION'), ('KAWOWO'), ('KAYABWE TOWN COUNCIL'), ('KAYANJA'), ('KAYEBE'), ('KAYERA'), ('KAYONZA'), ('KAYORO'), ('KAYUNGA'), ('KAYUNGA TOWN COUNCIL'), ('KAZINGA TOWN COUNCIL'), ('KAZO'), ('KAZO TOWN COUNCIL'), ('KAZWAMA TOWN COUNCIL'), ('KEBISONI'), ('KEBISONI TOWN COUNCIL'), ('KEI'), ('KEIHANGARA'), ('KENKEBU'), ('KENSHUNGA'), ('KERI TOWN COUNCIL'), ('KERWA'), ('KHABUTOOLA'), ('KIBAALE'), ('KIBAALE TOWN COUNCIL'), ('KIBALE'), ('KIBALE TOWN COUNCIL'), ('KIBALINGA'), ('KIBANDA'), ('KIBASI TOWN COUNCIL'), ('KIBATSI'), ('KIBIBI'), ('KIBIBI TOWN COUNCIL'), ('KIBIGA'), ('KIBIITO'), ('KIBIITO TOWN COUNCIL'), ('KIBIJJO'), ('KIBINGE'), ('KIBINGO TOWN COUNCIL'), ('KIBOGA TOWN COUNCIL'), ('KIBUGA'), ('KIBUKU'), ('KIBUKU TOWN COUNCIL'), ('KIBUUKU TOWN COUNCIL'), ('KICHECHE'), ('KICHWABUGINGO'), ('KICHWAMBA'), ('KICUCURA'), ('KICUZI'), ('KICWAMBA'), ('KIDAAGO'), ('KIDEPO TOWN COUNCIL'), ('KIDERA'), ('KIDERA TOWN COUNCIL'), ('KIDETOK TOWN COUNCIL'), ('KIDONGOLE'), ('KIFAMBA'), ('KIFAMPA'), ('KIFUKA TOWN COUNCIL'), ('KIGAMBO'), ('KIGANDA'), ('KIGANDALO'), ('KIGANDA TOWN COUNCIL'), ('KIGANDO'), ('KIGANGAZZI TOWN COUNCIL'), ('KIGANJA'), ('KIGARAALE'), ('KIGARAMA'), ('KIGOROBYA'), ('KIGOROBYA TOWN COUNCIL'), ('KIGOYERA'), ('KIGULYA DIVISION'), ('KIGUMBA'), ('KIGUMBA TOWN COUNCIL'), ('KIGWERA'), ('KIGYENDE'), ('KIHANDA'), ('KIHIIHI'), ('KIHIIHI TOWN COUNCIL'), ('KIHUNGYA'), ('KIHUURA'), ('KIJANGI'), ('KIJJUNA'), ('KIJOMORO'), ('KIJONGO'), ('KIJUNJUBWA'), ('KIJUNJUBWA TOWN COUNCIL'), ('KIJURA TOWN COUNCIL'), ('KIKAGATE'), ('KIKAGATE TOWN COUNCIL'), ('KIKAMULO'), ('KIKANDWA'), ('KIKATSI'), ('KIKHOLO TOWN COUNCIL'), ('KIKOBERO'), ('KIKOORA'), ('KIKO TOWN COUNCIL'), ('KIKUUBE TOWN COUNCIL'), ('KIKWAYA'), ('KIKYENKYE'), ('KIKYUSA'), ('KIKYUSA TOWN COUNCIL'), ('KILEMBE'), ('KIMAANYA-KABONERA DIVISION'), ('KIMAANYA/KYABAKUZA'), ('KIMAKA /MPUMUDDE'), ('KIMALULI'), ('KIMENGO'), ('KIMENYEDDE'), ('KINAABA'), ('KINGO'), ('KINONI'), ('KINONI TOWN COUNCIL'), ('KINUUKA'), ('KINYAMESEKE TOWN COUNCIL'), ('KINYARUGONJO'), ('KINYOGOGA'), ('KIRA DIVISION'), ('KIRA TOWN COUNCIL'), ('KIREWA'), ('KIRIKA'), ('KIRIMA'), ('KIRINGENTE'), ('KIRUGU'), ('KIRUHURA TOWN COUNCIL'), ('KIRULI'), ('KIRUMBA'), ('KIRUMYA'), ('KIRUNDO'), ('KIRU TOWN COUNCIL'), ('KIRUUMA'), ('KIRYANDONGO'), ('KIRYANDONGO TOWN COUNCIL'), ('KIRYANGA'), ('KIRYANNONGO'), ('KISALA'), ('KISEKKA'), ('KISENGWE'), ('KISIITA'), ('KISIITA TOWN COUNCIL'), ('KISINDA'), ('KISINGA'), ('KISINGA TOWN COUNCIL'), ('KISOJO'), ('KISOJO TOWN COUNCIL'), ('KISOKO'), ('KISOMORO'), ('KISORO TOWN COUNCIL'), ('KISOZI'), ('KISOZI TOWN COUNCIL'), ('KISUBBA'), ('KISUKUMA'), ('KITABONA'), ('KITABU'), ('KITAGATA'), ('KITAGATA TOWN COUNCIL'), ('KITAGWENDA TOWN COUNCIL'), ('KITAIHUKA'), ('KITANDA'), ('KITAWOI'), ('KITAYUNJWA'), ('KITEGA'), ('KITENGA'), ('KITENY'), ('KITGUM MATIDI'), ('KITGUM MATIDI TOWN COUNCIL'), ('KITGUM TOWN COUNCIL'), ('KITHOLU'), ('KITHOMA-KANYATSI TOWN COUNCIL'), ('KITIMBWA'), ('KITIMBWA TOWN COUNCIL'), ('KITOBA'), ('KITSWAMBA'), ('KITSWAMBA TOWN COUNCIL'), ('KITTO'), ('KITUMBA'), ('KITUMBI'), ('KITUNTU'), ('KITURA'), ('KITUTI'), ('KITWE TOWN COUNCIL'), ('KITYERERA'), ('KIWANYI'), ('KIWOKO TOWN COUNCIL'), ('KIYANGA'), ('KIYINDI TOWN COUNCIL'), ('KIYOMBYA'), ('KIYUNI'), ('KIYUUNI'), ('KIZIBA'), ('KIZIBA (MASULIITA)'), ('KIZIBA TOWN COUNCIL'), ('KIZINDA TOWN COUNCIL'), ('KIZIRANFUMBI'), ('KIZUBA'), ('KOBOKO TOWN COUNCIL'), ('KOBULUBULU'), ('KOBWIN'), ('KOCHEKA'), ('KOCH-GOMA'), ('KOCH GOMA TOWN COUNCIL'), ('KOCHI'), ('KOENA'), ('KOLE TOWN COUNCIL'), ('KOLIR'), ('KOMUGE'), ('KONGOROK'), ('KONGUNGA TOWN COUNCIL'), ('KOOME ISLANDS'), ('KORO'), ('KORTEK'), ('KOSIKE'), ('KOTIDO'), ('KOTIDO TOWN COUNCIL'), ('KOTOMOR'), ('KUCWINY'), ('KUJU'), ('KULIKULINGA TOWN COUNCIL'), ('KULUBA'), ('KULULU'), ('KUMI'), ('KUMI TOWN COUNCIL'), ('KURU'), ('KURU TOWN COUNCIL'), ('KUUSHU TOWN COUNCIL'), ('KUYWEE'), ('KWANYIY'), ('KWAPA'), ('KWAPA TOWN COUNCIL'), ('KWARIKWAR'), ('KWERA'), ('KWOSIR'), ('KYABAKARA'), ('KYABARUNGIRA'), ('KYABASAIJA'), ('KYABIGAMBIRE'), ('KYABUGIMBI'), ('KYABUGIMBI TOWN COUNCIL'), ('KYAHENDA'), ('KYAITAMBA TOWN COUNCIL'), ('KYAKABADIIMA'), ('KYAKATWIRE TOWN COUNCIL'), ('KYAKAZIHIRE'), ('KYALULANGIRA'), ('KYAMBOGO/BUSUKUMA'), ('KYAMPANGARA'), ('KYAMPISI'), ('KYAMUHUNGA'), ('KYAMUHUNGA TOWN COUNCIL'), ('KYAMUKUBE TOWN COUNCIL'), ('KYAMULIBWA'), ('KYAMULIBWA TOWN COUNCIL'), ('KYAMUSWA'), ('KYAMUTUNZI TOWN COUNCIL'), ('KYANAISOKE'), ('KYANAMIRA'), ('KYANAMUKAKA'), ('KYANGWALI'), ('KYANGYENYI'), ('KYANKENDE'), ('KYANKWANZI'), ('KYANKWANZI TOWN COUNCIL'), ('KYANVUMA TOWN COUNCIL'), ('KYARUMBA'), ('KYARUMBA TOWN COUNCIL'), ('KYARUSOZI'), ('KYARUSOZI TOWN COUNCIL'), ('KYATEGA'), ('KYATEREKERA'), ('KYATEREKERA TOWN COUNCIL'), ('KYATIRI TOWN COUNCIL'), ('KYAYI'), ('KYAZANGA'), ('KYAZANGA TOWN COUNCIL'), ('KYEBANDO'), ('KYEBE'), ('KYEERA'), ('KYEGEGWA'), ('KYEGEGWA TOWN COUNCIL'), ('KYEGONZA'), ('KYEIZOBA'), ('KYEIZOOBA'), ('KYEKUMBYA'), ('KYEMBOGO'), ('KYENDA TOWN COUNCIL'), ('KYENGERA TOWN COUNCIL'), ('KYENJOJO TOWN COUNCIL'), ('KYENZIGE'), ('KYENZIGE TOWN COUNCIL'), ('KYERE'), ('KYERE TOWN COUNCIL'), ('KYESHERO'), ('KYESIIGA'), ('KYOMYA'), ('KYONDO'), ('KYOTERA TOWN COUNCIL'), ('LABONGO'), ('LABONGO-AMIDA'), ('LABONGO-AMIDA WEST'), ('LABONGO-LAYAMO'), ('LABOR'), ('LABORA'), ('LAGORO'), ('LAGUTI'), ('LAI-MUTTO TOWN COUNCIL'), ('LAKANG'), ('LAKE KABATORO TOWN COUNCIL'), ('LAKE KATWE'), ('LAKWANA'), ('LAKWAYA'), ('LALANO'), ('LALLE'), ('LALOGI'), ('LAMIYO'), ('LAMOGI'), ('LAMWO TOWN COUNCIL'), ('LAPEREBONG'), ('LAPONO'), ('LAPUL'), ('LAROO'), ('LAROO-PECE DIVISION'), ('LAROPI'), ('LAROPI TOWN COUNCIL'), ('LATANYA'), ('LAYIBI'), ('LAYIMA'), ('LEFORI'), ('LEFORI TOWN COUNCIL'), ('LEGENYA'), ('LEJU TOWN COUNCIL'), ('LEMUSUI'), ('LII'), ('LIRA'), ('LIRA CENTRAL'), ('LIRA EAST DIVISION'), ('LIRA KATO'), ('LIRA-PALWO'), ('LIRA-PALWO TOWN COUNCIL'), ('LIRA WEST DIVISION'), ('LOBALANGIT'), ('LOBE TOWN COUNCIL'), ('LOBONGIA'), ('LOBULE'), ('LODIKO'), ('LODONGA'), ('LODONGA TOWN COUNCIL'), ('LOGIRI'), ('LOKALES'), ('LOKITEDED TOWN COUNCIL'), ('LOKITELAEBU TOWN COUNCIL'), ('LOKOLE'), ('LOKOPO'), ('LOKORI'), ('LOKUNG'), ('LOKUNG EAST'), ('LOKWAKIAL'), ('LOLACHAT'), ('LOLELIA'), ('LOLELIA SOUTH'), ('LOLETIO'), ('LOLWE'), ('LONGAROE'), ('LOPEI'), ('LOPUTUK'), ('LOREGAE'), ('LORENG'), ('LORENGECORA'), ('LORENGEDWAT'), ('LORI'), ('LORO'), ('LOROO'), ('LORO TOWN COUNCIL'), ('LOSIDOK'), ('LOTIM'), ('LOTISAN'), ('LOTOME'), ('LOTUKEI'), ('LOYORO'), ('LUBIMBIRI'), ('LUBYA TOWN COUNCIL'), ('LUDARA'), ('LUGAZI TOWN COUNCIL'), ('LUGUSULU'), ('LUKAYA TOWN COUNCIL'), ('LUKHONGE'), ('LULENA'), ('LUMINO'), ('LUMINO-MAJANJI TOWN COUNCIL'), ('LUNGULU'), ('LUNYIRI'), ('LUNYO'), ('LUSHA'), ('LUUKA TOWN COUNCIL'), ('LUWA TOWN COUNCIL'), ('LUWEERO TOWN COUNCIL'), ('LUWERO'), ('LWABENGE'), ('LWAJE'), ('LWAKHAKHA TOWN COUNCIL'), ('LWAMAGGWA'), ('LWAMAGGWA TOWN COUNCIL'), ('LWAMATA'), ('LWAMATA TOWN COUNCIL'), ('LWAMPANGA'), ('LWAMPANGA TOWN COUNCIL'), ('LWANDA'), ('LWANJUSI'), ('LWANKONI'), ('LWASSO'), ('LWATAMA'), ('LWEBITAKULI'), ('LWEMIYAGA'), ('LWENGO'), ('LWENGO TOWN COUNCIL'), ('LWENTULEGE TOWN COUNCIL'), ('LWONGON'), ('LYABAANA TOWN COUNCIL'), ('LYAKAHUNGU TOWN COUNCIL'), ('LYAKAJURA'), ('LYAMA'), ('LYAMA TOWN COUNCIL'), ('LYANTONDE'), ('LYANTONDE TOWN COUNCIL'), ('MAANYI'), ('MAARU'), ('MABAALE'), ('MABAALE TOWN COUNCIL'), ('MABERE'), ('MABINDO'), ('MABIRA TOWN COUNCIL'), ('MABONO'), ('MADDU'), ('MADDU TOWN COUNCIL'), ('MADI-OPEI'), ('MADI-OPEI TOWN COUNCIL'), ('MADUDU'), ('MAEFE'), ('MAFUBIRA'), ('MAFUDU'), ('MAGADA'), ('MAGALE'), ('MAGALE TOWN COUNCIL'), ('MAGAMAGA'), ('MAGAMAGA TOWN COUNCIL'), ('MAGAMBO'), ('MAGODES TOWN COUNCIL'), ('MAGOGO'), ('MAGOLA'), ('MAGORO'), ('MAGORO TOWN COUNCIL'), ('MAHANGO'), ('MAHYORO'), ('MAHYORO TOWN COUNCIL'), ('MAIRIRWE'), ('MAIZIMASA'), ('MAJANJI'), ('MAKENYA'), ('MAKERERE UNIVERSITY'), ('MAKINDYE'), ('MAKINDYE DIVISION'), ('MAKOKOTO'), ('MAKULUBITA'), ('MAKUUTU'), ('MALABA TOWN COUNCIL'), ('MALANGALA'), ('MALERA'), ('MALIBA'), ('MALIBA TOWN COUNCIL'), ('MALONGO'), ('MANAFWA TOWN COUNCIL'), ('MANIBE'), ('MANYOGASEKA'), ('MARACHA TOWN COUNCIL'), ('MASABA'), ('MASAFU'), ('MASAFU TOWN COUNCIL'), ('MASAJJA DIVISION'), ('MASAKA TOWN COUNCIL'), ('MASHA'), ('MASHERUKA'), ('MASHERUKA TOWN COUNCIL'), ('MASINDI PORT'), ('MASINYA'), ('MASIRA'), ('MASODDE-KALAGI TOWN COUNCIL'), ('MASULIITA'), ('MASULIITA TOWN COUNCIL'), ('MATALE'), ('MATANY'), ('MATANY TOWN COUNCIL'), ('MATEETE'), ('MATEETE TOWN COUNCIL'), ('MAYANGA'), ('MAYANZA'), ('MAYIRIKITI TOWN COUNCIL'), ('MAYUGE TOWN COUNCIL'), ('MAZIBA'), ('MAZIMASA'), ('MAZINGA'), ('MAZUBA'), ('MBAARE'), ('MBALE TOWN COUNCIL'), ('MBARARA NORTH DIVISION'), ('MBARARA SOUTH DIVISION'), ('MBATYA'), ('MBIRIZI'), ('MBOIRA'), ('MBULAMUTI'), ('MBULAMUTI TOWN COUNCIL'), ('MBUNGA'), ('MELLA'), ('MENDE'), ('MERIKIT'), ('MERIKIT TOWN COUNCIL'), ('METU'), ('MIDIA'), ('MIDIGO'), ('MIDIGO TOWN COUNCIL'), ('MIGAMBA'), ('MIGINA'), ('MIGONGWE'), ('MIGYERA TOWN COUNCIL'), ('MIIRYA'), ('MIJWALA'), ('MINAKULU'), ('MINAKULU TOWN COUNCIL'), ('MIRAMBI'), ('MITETE'), ('MITIMA'), ('MITOOMA'), ('MITOOMA TOWN COUNCIL'), ('MITYANA TOWN COUNCIL'), ('MOLO'), ('MORUITA'), ('MORUKAKISE'), ('MORUKATIPE'), ('MORULEM'), ('MORULEM TOWN COUNCIL'), ('MORUNGATUNY'), ('MORUNGOLE'), ('MOYO'), ('MOYOK'), ('MOYO TOWN COUNCIL'), ('MPARA'), ('MPARA TOWN COUNCIL'), ('MPARO DIVISION'), ('MPARO TOWN COUNCIL'), ('MPASAANA'), ('MPASAANA TOWN COUNCIL'), ('MPATTA'), ('MPEEFU'), ('MPEEFU YA SANDE TOWN COUNCIL'), ('MPENJA'), ('MPIGI TOWN COUNCIL'), ('MPONDWE/LHUBIRIHA TOWN COUNCIL'), ('MPUMUDDE'), ('MPUNGE'), ('MPUNGU'), ('MPUNGWE'), ('MUBENDE TOWN COUNCIL'), ('MUBUKU TOWN COUNCIL'), ('MUCHWINI'), ('MUCHWINI EAST'), ('MUCHWINI WEST'), ('MUDUMA'), ('MUGARAMA'), ('MUGITI'), ('MUGOYE'), ('MUGUSU'), ('MUGUSU TOWN COUNCIL'), ('MUHANGA TOWN COUNCIL'), ('MUHOKYA'), ('MUHOKYA TOWN COUNCIL'), ('MUHORRO'), ('MUHORRO TOWN COUNCIL'), ('MUKHUYU'), ('MUKO'), ('MUKONGORO'), ('MUKONGORO TOWN COUNCIL'), ('MUKONO CENTRAL DIVISION'), ('MUKONO DIVISION'), ('MUKOTO'), ('MUKUJU'), ('MUKUNGWE'), ('MUKURA'), ('MUKURA TOWN COUNCIL'), ('MULAGI'), ('MULANDA'), ('MUNARYA'), ('MUNKUNYU'), ('MUNTU'), ('MUPAKA TOWN COUNCIL'), ('MURAMBA'), ('MURORA'), ('MUTARA'), ('MUTARA TOWN COUNCIL'), ('MUTELELE TOWN COUNCIL'), ('MUTERERE'), ('MUTUFU TOWN COUNCIL'), ('MUTUKULA TOWN COUNCIL'), ('MUTUMBA'), ('MUTUMBA TOWN COUNCIL'), ('MUTUNDA'), ('MUTUSHET'), ('MUWANGA'), ('MUWANGI'), ('MUWAYO TOWN COUNCIL'), ('MUYEMBE'), ('MUYEMBE TOWN COUNCIL'), ('MWELLO'), ('MWERUKA TOWN COUNCIL'), ('MWITANZIGE'), ('MWIZI'), ('MYANZI'), ('MYENE'), ('NABBALE'), ('NABBONGO'), ('NABIGANDA TOWN COUNCIL'), ('NABIGASA'), ('NABILATUK'), ('NABILATUK TOWN COUNCIL'), ('NABINGOOLA'), ('NABINGOOLA TOWN COUNCIL'), ('NABISWA'), ('NABISWERA'), ('NABITANGA'), ('NABITENDE'), ('NABITSIKHI'), ('NABIWUTULU'), ('NABOA'), ('NABOA TOWN COUNCIL'), ('NABUKALU'), ('NABUKALU TOWN COUNCIL'), ('NABUMALI TOWN COUNCIL'), ('NABUYOGA'), ('NABUYOGA TOWN COUNCIL'), ('NABWAL'), ('NABWERU'), ('NABWERU DIVISION'), ('NABWEYA'), ('NABWEYO'), ('NABWIGULU'), ('NADUNGET'), ('NADUNGET TOWN COUNCIL'), ('NAGOJJE'), ('NAGONGERA'), ('NAGONGERA TOWN COUNCIL'), ('NAIRAMBI'), ('NAJJA'), ('NAJJEMBE'), ('NAJJEMBE DIVISION'), ('NAKALAMA'), ('NAKALOKE'), ('NAKAPELIMORU'), ('NAKAPIRIPIRIT TOWN COUNCIL'), ('NAKASEKE'), ('NAKASEKE BUTALANGU TOWN COUNCI'), ('NAKASEKE BUTALANGU TOWN COUNCIL'), ('NAKASEKE TOWN COUNCIL'), ('NAKASENYI'), ('NAKASONGOLA TOWN COUNCIL'), ('NAKASOZI'), ('NAKATSI'), ('NAKAWA DIVISION'), ('NAKIFUMA-NAGGALAMA TOWN COUNCIL'), ('NAKIGO'), ('NAKISUNGA'), ('NAKITOMA'), ('NALONDO'), ('NALUBWOYO'), ('NALUSALA'), ('NALUTUNTU'), ('NALWANZA'), ('NALWEYO'), ('NAMA'), ('NAMABYA'), ('NAMAGERA TOWN COUNCIL'), ('NAMAGULI'), ('NAMALEMBA'), ('NAMALU'), ('NAMANYONYI'), ('NAMASAGALI'), ('NAMASALE'), ('NAMASALE TOWN COUNCIL'), ('NAMATABA TOWN COUNCIL'), ('NAMAYEMBA TOWN COUNCIL'), ('NAMAYINGO TOWN COUNCIL'), ('NAMAYUMBA'), ('NAMAYUMBA TOWN COUNCIL'), ('NAMBALE'), ('NAMBIESO'), ('NAMBOKO'), ('NAMISINDWA TOWN COUNCIL'), ('NAMISUNI'), ('NAMITSA'), ('NAM-OKORA'), ('NAM-OKORA NORTH'), ('NAMOKORA TOWN COUNCIL'), ('NAMUGABWE'), ('NAMUGANGA'), ('NAMUGONGO'), ('NAMUGONGO DIVISION'), ('NAMUNGALWE'), ('NAMUNGALWE TOWN COUNCIL'), ('NAMUNGO'), ('NAMUNGODI TOWN COUNCIL'), ('NAMUTUMBA'), ('NAMUTUMBA TOWN COUNCIL'), ('NAMWENDWA'), ('NAMWENDWA TOWN COUNCIL'), ('NAMWIWA'), ('NAMWIWA TOWN COUNCIL'), ('NANDERE'), ('NANGABO'), ('NANGAKO TOWN COUNCIL'), ('NANGALWE'), ('NANGOMA'), ('NANGONDE'), ('NANGONDE TOWN COUNCIL'), ('NANKODO'), ('NANKOMA'), ('NANKOMA TOWN COUNCIL'), ('NANSANA DIVISION'), ('NANSANA TOWN COUNCIL'), ('NANSANGA'), ('NANSOLOLO'), ('NAPAK TOWN COUNCIL'), ('NAPUMPUM'), ('NARWEYO'), ('NATIRAE'), ('NAWAIKOKE'), ('NAWAIKOKE TOWN COUNCIL'), ('NAWAIKONA'), ('NAWAMPITI'), ('NAWANDALA'), ('NAWANJOFU'), ('NAWANYAGO'), ('NAWANYAGO TOWN COUNCIL'), ('NAWANYINGI'), ('NAWEYO'), ('NAWIRE'), ('NAZIGO'), ('NAZIGO TOWN COUNCIL'), ('NDAGWE'), ('NDAIGA'), ('NDEIJA'), ('NDEJJE DIVISION'), ('NDEJJE TOWN COUNCIL'), ('NDHEW'), ('NDOLWA'), ('NDUGUTU'), ('NEBBI'), ('NEBBI TOWN COUNCIL'), ('NGAI'), ('NGAMBA'), ('NGANDHO'), ('NGANDO'), ('NGARAMA'), ('NGARIAM'), ('NGENGE'), ('NGETTA'), ('NGITE'), ('NGOGWE'), ('NGOLERIET'), ('NGOMA'), ('NGOMA TOWN COUNCIL'), ('NGORA'), ('NGORA TOWN COUNCIL'), ('NGWEDO'), ('NJERU DIVISION'), ('NJERU TOWN COUNCIL'), ('NKAAKWA'), ('NKANDWA'), ('NKANGA'), ('NKANJA'), ('NKOKONJERU TOWN COUNCIL'), ('NKOMA'), ('NKOMA-KATALYEBA TOWN COUNCIL'), ('NKONDO'), ('NKOOKO'), ('NKOOKO TOWN COUNCIL'), ('NKOZI'), ('NKUNGU'), ('NKURINGO TOWN COUNCIL'), ('NOMBE'), ('NORTH DIVISION'), ('NORTHERN'), ('NORTHERN BOROUGH'), ('NORTHERN DIVISION'), ('NSAMBYA'), ('NSANGI(MUKONO)'), ('NSASI'), ('NSHANJARE TOWN COUNCIL'), ('NSIIKA TOWN COUNCIL'), ('NSINZE'), ('NSINZE TOWN COUNCIL'), ('NTANDI TOWN COUNCIL'), ('NTANTAMUKI TOWN COUNCIL'), ('NTARA'), ('NTENJERU'), ('NTENJERU-KISOGA TOWN COUNCIL'), ('NTOTORO'), ('NTUNDA'), ('NTUNDA TOWN COUNCIL'), ('NTUNGAMO'), ('NTUNGU'), ('NTUUSI'), ('NTUUSI TOWN COUNCIL'), ('NTWETWE'), ('NTWETWE TOWN COUNCIL'), ('NWOYA TOWN COUNCIL'), ('NYABBANI'), ('NYABIHOKO'), ('NYABIRONGO'), ('NYABISIRIRA TOWN COUNCIL'), ('NYABUBARE'), ('NYABUHARWA'), ('NYABUHIKYE'), ('NYABUSHENYI'), ('NYABUTANZI'), ('NYABWISHENYA'), ('NYADRI'), ('NYADRI SOUTH'), ('NYAHUKA TOWN COUNCIL'), ('NYAKABANDE'), ('NYAKABINGO'), ('NYAKABIRIZI DIVISION'), ('NYAKABUNGO TOWN COUNCIL'), ('NYAKAGYEME'), ('NYAKARONGO'), ('NYAKASHAKA TOWN COUNCIL'), ('NYAKASHASHARA'), ('NYAKATONZI'), ('NYAKAYOJO'), ('NYAKAZIBA TOWN COUNCIL'), ('NYAKIGUMBA TOWN COUNCIL'), ('NYAKINAMA'), ('NYAKINONI'), ('NYAKISHANA'), ('NYAKISHENYI'), ('NYAKISI'), ('NYAKITUNDA'), ('NYAKIYUMBU'), ('NYAKIZINGA'), ('NYAKWAE'), ('NYAKYERA'), ('NYAKYERA TOWN COUNCIL'), ('NYAMAHASA'), ('NYAMAREBE'), ('NYAMARUNDA'), ('NYAMARUNDA TOWN COUNCIL'), ('NYAMARWA'), ('NYAMIRAMA'), ('NYAMIRAMA TOWN COUNCIL'), ('NYAMITANGA'), ('NYAMUKANA TOWN COUNCIL'), ('NYAMUNUKA TOWN COUNCIL'), ('NYAMUYANJA'), ('NYAMWAMBA DIVISION'), ('NYAMWEERU'), ('NYANAMO TOWN COUNCIL'), ('NYANGA'), ('NYANGAHYA DIVISION'), ('NYANGOLE'), ('NYANKWANZI'), ('NYANTONZI'), ('NYANTUNGO'), ('NYAPEA'), ('NYARAVUR'), ('NYARAVUR TOWN COUNCIL'), ('NYARUBUYE'), ('NYARUSHANJE'), ('NYARUSIZA'), ('NYARUTUNTU'), ('NYARWEYO TOWN COUNCIL'), ('NYENDO-MUKUNGWE DIVISION'), ('NYENDO/SENYANGE'), ('NYENGA'), ('NYENGA DIVISION'), ('NYERO'), ('NYERO TOWN COUNCIL'), ('NYIMBWA'), ('NYONDO'), ('NYUNDO'), ('OBALANGA'), ('OBALANGA TOWN COUNCIL'), ('OBIBA'), ('OBOLISO'), ('OBONGI TOWN COUNCIL'), ('OBUTET'), ('OCAAPA TOWN COUNCIL'), ('OCELAKUR'), ('OCHERO'), ('OCHERO TOWN COUNCIL'), ('OCOKICAN'), ('OCULOI'), ('ODEK'), ('ODRAVU'), ('ODRAVU WEST'), ('ODUPI'), ('ODWARAT'), ('OFFAKA'), ('OFUA'), ('OGILI'), ('OGOKO'), ('OGOLAI'), ('OGOM'), ('OGONGORA'), ('OGOOMA'), ('OGOR'), ('OGUR'), ('OGWETTE'), ('OGWOLO'), ('OJILAI'), ('OJWINA'), ('OKILE'), ('OKOKORO TOWN COUNCIL'), ('OKOLLO'), ('OKOLLO TOWN COUNCIL'), ('OKORE'), ('OKULONYO'), ('OKUNGUR'), ('OKWALONGWEN'), ('OKWANG'), ('OKWANG TOWN COUNCIL'), ('OKWERODOT'), ('OKWONGODUL'), ('OKWONGO TOWN COUNCIL'), ('OLEBA'), ('OLEBA TOWN COUNCIL'), ('OLILIM'), ('OLILIM TOWN COUNCIL'), ('OLI RIVER'), ('OLOK'), ('OLUFE'), ('OLUKO'), ('OLUVU'), ('OLWA'), ('OMEL'), ('OMIYA-ANYIMA'), ('OMIYA-ANYIMA WEST'), ('OMIYA PACWA'), ('OMODOI'), ('OMORO'), ('OMORO TOWN COUNCIL'), ('OMOT'), ('OMUGO'), ('ONGAKO'), ('ONGINO'), ('ONGINO TOWN COUNCIL'), ('ONGONGOJA'), ('OPALI'), ('OPARA'), ('OPOPONGO'), ('OPOT TOWN COUNCIL'), ('OPWATETA'), ('ORABA TOWN COUNCIL'), ('ORAPWOYO'), ('ORIAMO'), ('OROM'), ('OROM EAST'), ('ORUM'), ('ORUNGO'), ('ORUNGO TOWN COUNCIL'), ('ORWAMUGE TOWN COUNCIL'), ('OSIA'), ('OSUKURU'), ('OSUKURU TOWN COUCIL'), ('OTCE'), ('OTUBOI'), ('OTUBOI TOWN COUNCIL'), ('OTUKE TOWN COUNCIL'), ('OTWAL'), ('OVUJO TOWN COUNCIL'), ('OWALO'), ('OWOO'), ('OYAM TOWN COUNCIL'), ('PABBO'), ('PABBO TOWN COUNCIL'), ('PACHARA'), ('PACHWA'), ('PACHWA TOWN COUNCIL'), ('PADEA TOWN COUNCIL'), ('PADER'), ('PADER TOWN COUNCIL'), ('PADIBE EAST'), ('PADIBE TOWN COUNCIL'), ('PADIBE WEST'), ('PADWOT'), ('PAGER DIVISION'), ('PAIBONA'), ('PAICHO'), ('PAIDHA'), ('PAIDHA TOWN COUNCIL'), ('PAIMOL'), ('PAIULA'), ('PAJULE'), ('PAJULE TOWN COUNCIL'), ('PAJULU'), ('PAJWENDA TOWN COUNCIL'), ('PAKANYI'), ('PAKELE'), ('PAKELE TOWN COUNCIL'), ('PAKWACH'), ('PAKWACH TOWN COUNCIL'), ('PALABEK ABERA'), ('PALABEK-GEM'), ('PALABEK-KAL'), ('PALABEK KAL TOWN COUNCIL'), ('PALABEK NYIMUR'), ('PALAM'), ('PALARO'), ('PALENGA TOWN COUNCIL'), ('PALLISA'), ('PALLISA TOWN COUNCIL'), ('PALOGA'), ('PALORINYA'), ('PAMINYAI'), ('PANDWONG DIVISION'), ('PANYANGARA'), ('PANYANGO'), ('PANYIMUR'), ('PANYIMUR TOWN COUNCIL'), ('PARABONGO'), ('PARANGA'), ('PAROMBO'), ('PAROMBO TOWN COUNCIL'), ('PATIKO'), ('PATONGO'), ('PATONGO TOWN COUNCIL'), ('PAWOR'), ('PAYA'), ('PECE'), ('PETETE'), ('PETETE TOWN COUNCIL'), ('PETTA'), ('PINGIRE'), ('POGO'), ('POKWERO'), ('POROGALI'), ('PORON'), ('POTIKA'), ('PUKONY'), ('PUKOR'), ('PURANGA'), ('PURANGA TOWN COUNCIL'), ('PURONGO'), ('PURONGO TOWN COUNCIL'), ('PUTI-PUTI'), ('PUTTI'), ('RAGEM'), ('RAILWAYS'), ('RAKAI TOWN COUNCIL'), ('RENGEN'), ('RHINO CAMP'), ('RHINO CAMP TOWN COUNCIL'), ('RIGBO'), ('RIWO'), ('RIWO TOWN COUNCIL'), ('ROMOGI'), ('RUBAARE'), ('RUBAARE TOWN COUNCIL'), ('RUBAGA DIVISION'), ('RUBANDA TOWN COUNCIL'), ('RUBAYA'), ('RUBENGYE'), ('RUBINDI'), ('RUBINDI-RUHUMBA TOWN COUNCIL'), ('RUBIRIZI TOWN COUNCIL'), ('RUBONA TOWN COUNCIL'), ('RUBONGI'), ('RUBOROGOTA'), ('RUBUGURI TOWN COUNCIL'), ('RUGAAGA'), ('RUGAAGA TOWN COUNCIL'), ('RUGANDO'), ('RUGARAMA'), ('RUGARAMA NORTH'), ('RUGASHARI'), ('RUGASHARI TOWN COUNCIL'), ('RUGENDABARA-KIKONGO TOWN COUNCIL'), ('RUGOMBE TOWN COUNCIL'), ('RUGYEYO'), ('RUHAAMA'), ('RUHAAMA EAST'), ('RUHIIRA TOWN COUNCIL'), ('RUHIJA'), ('RUHIJA TOWN COUNCIL'), ('RUHINDA'), ('RUHUMURO'), ('RUHUNGA'), ('RUKIRI'), ('RUKOKI'), ('RUKONI EAST'), ('RUKONI WEST'), ('RUKUNDO TOWN COUNCIL'), ('RUKUNYU TOWN COUNCIL'), ('RUPA'), ('RUREHE'), ('RUSHANGO TOWN COUNCIL'), ('RUSHASHA'), ('RUSHERE TOWN COUNCIL'), ('RUTEETE'), ('RUTENGA'), ('RUTENGA TOWN COUNCIL'), ('RUTETE TOWN COUNCIL'), ('RUTOOKYE TOWN COUNCIL'), ('RUTOTO'), ('RUYANGA'), ('RUYONZA'), ('RWABYATA'), ('RWAMABONDO TOWN COUNCIL'), ('RWAMUCUCU'), ('RWANJOGYERA'), ('RWANYAMAHEMBE'), ('RWANYAMAHEMBE TOWN COUNCIL'), ('RWASHAMEIRE TOWN COUNCIL'), ('RWEBISENGO'), ('RWEBISENGO TOWN COUNCIL'), ('RWEIBOGO-KIBINGO TOWN COUNCIL'), ('RWEIKINIRO'), ('RWEMIKOMA'), ('RWENGAJU'), ('RWENGWE'), ('RWENJAZA'), ('RWENKOBWA TOWN COUNCIL'), ('RWENSHANDE'), ('RWENTOBO-RWAHI TOWN COUNCIL'), ('RWENTUHA'), ('RWENTUHA TOWN COUNCIL'), ('RWERERE TOWN COUNCIL'), ('RWETAMU'), ('RWETANGO'), ('RWIMI'), ('RWIMI TOWN COUNCIL'), ('RWOBURUNGA'), ('RWOHO TOWN COUNCIL'), ('RYAKARIMIRA TOWN COUNCIL'), ('RYERU'), ('SANGA'), ('SANGAR'), ('SANGA TOWN COUNCIL'), ('SEMUTO'), ('SEMUTO TOWN COUNCIL'), ('SENENDET'), ('SERE'), ('SERERE/OLIO'), ('SERERE TOWN COUNCIL'), ('SHEEMA CENTRAL DIVISION'), ('SHUUKU'), ('SHUUKU TOWN COUNCIL'), ('SIBANGA'), ('SIDOK (KAPOTH)'), ('SIDOK (KOPOTH)'), ('SIGULU ISLANDS'), ('SIKUDA'), ('SIMU'), ('SINDILA'), ('SIPI'), ('SIPI TOWN COUNCIL'), ('SIRONKO TOWN COUNCIL'), ('SISIYI'), ('SISUNI'), ('SIWA'), ('SONI'), ('SOPSOP'), ('SOROTI'), ('SOROTI EAST DIVISION'), ('SOROTI WEST DIVISION'), ('SOTTI'), ('SOUTH DIVISION'), ('SOUTHERN DIVISION'), ('SSEKANYONYI'), ('SSEKANYONYI TOWN COUNCIL'), ('SSEMBABULE TOWN COUNCIL'), ('SSI'), ('SSISA'), ('SUAM'), ('SUAM TOWN COUNCIL'), ('SUNDET'), ('TADEMERI'), ('TAPAC'), ('TARA'), ('TE-BOKE'), ('TEGERES'), ('TE-NAM'), ('THATHA DIVISION'), ('TIIRA TOWN COUNCIL'), ('TIMU'), ('TIRINYI'), ('TIRINYI TOWN COUNCIL'), ('TISAI'), ('TOKORA'), ('TOKWE'), ('TOROMA'), ('TOROMA TOWN COUNCIL'), ('TORORO EASTERN'), ('TORORO WESTERN'), ('TSEKULULU'), ('TTABA-BBINZI'), ('TTAMU DIVISION'), ('TUBUR'), ('TUBUR TOWN COUNCIL'), ('TUIKAT'), ('TULEL'), ('UKUSIJONI'), ('ULEPPI'), ('UNYAMA'), ('URIAMA'), ('USUK'), ('USUK TOWN COUNCIL'), ('VURRA'), ('WABINYONYI'), ('WADELAI'), ('WAIBUGA'), ('WAIRASA'), ('WAKISI'), ('WAKISI DIVISION'), ('WAKISO'), ('WAKISO TOWN COUNCIL'), ('WAKYATO'), ('WALUKUBA/MASESE'), ('WANALE'), ('WANALE BOROUGH'), ('WANDI'), ('WANKOLE'), ('WARR'), ('WARR TOWN COUNCIL'), ('WATTUBA'), ('WATTUBA TOWN COUNCIL'), ('WERA'), ('WERA TOWN COUNCIL'), ('WEST DIVISION'), ('WESTERN'), ('WESTERN DIVISION'), ('WESWA'), ('WILLA'), ('WIODYEK'), ('WOBULENZI TOWN COUNCIL'), ('WOL'), ('WOL TOWN COUNCIL'), ('YIVU'), ('YUMBE TOWN COUNCIL'), ('ZESUI'), ('ZEU'), ('ZIGOTI TOWN COUNCIL'), ('ZIROBWE'), ('ZIROBWE TOWN COUNCIL'),
 ('ZOMBO TOWN COUNCIL') 
 ) s(a)) n  )) m; 
 
 /* banks   */
 
  select distinct 'insert into sacco.global_static_params(param_id,param_code,param_value,param_title,param_type_id,param_category_id,status) values (uuid_generate_v4(),''' || m.a || ''',''' || m.a || ''',''' || m.a || ''',''' || m.param_type_id  || ''',''' || m.param_category_id ||  ''',''active'');' as stmt from 
 (with cid as (select param_type_id from sacco.global_param_type where param_type = 'bank'  ),
  rid as (select param_category_id from sacco.global_param_category where param_category = 'financials' ) 
( select distinct n.*, p.param_type_id as param_type_id,
  r.param_category_id  from cid p, rid r, (select a 
from (
    values 
		('ABC Capital Bank Uganda Limited'), ('Afriland First Bank Uganda Limited'), ('Bank of Africa Uganda Limited'), ('Bank of Baroda Uganda Limited'), ('Bank of India Uganda Limited'), ('Absa Bank Uganda Limited)'), ('Cairo International Bank limited'), ('Centenary Rural Development Bank Limited'), ('Citibank Uganda Limited'), ('Commercial Bank of Africa Uganda Limited'), ('DFCU Bank Limited'), ('Diamond Trust Bank Uganda Limited'), ('Ecobank Uganda Limited'), ('Equity Bank Uganda Limited'), ('Exim Bank Uganda Limited'), ('Finance Trust Bank Uganda'), ('Guaranty Trust Bank Uganda Limited'), ('Housing Finance Bank'), ('KCB Uganda Limited'), ('NC Bank Uganda Limited'), ('Opportunity Bank Uganda Limited'), ('Orient Bank Limited'), ('Stanbic Bank Uganda Limited'), ('Standard Chartered Bank Uganda Limited'), ('Tropical Bank Limited'),
 ('United Bank for Africa Uganda Limited')
 ) s(a)) n  )) m; 
 
 
 







/*
 We can have multiple saccos registered. Contact persons, addresses of admins etc.
 Register the sacco and configure its licenses. license can based on number of members, 
 plus any other fixed software license as service
*/


CREATE TABLE sacco.sacco 
(  
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) PRIMARY KEY,	/*  uuid system own generated */ 
    sacco_code character varying(50) UNIQUE NOT NULL, /*  e.g. muk, mubs, etc */
    sacco_name character varying(200) UNIQUE NOT NULL,  /*  */ 
    telno character varying(20) UNIQUE,
    email character varying(50) UNIQUE,
    fax character varying(200),
	kycs jsonb default '{}'::jsonb,	
	enable_one_time_entrance_fee  character varying(1) DEFAULT 'F' check (enable_one_time_entrance_fee in ('T','F')),	
	max_no_members numeric default 0,
	enable_group_savers  character varying(1) DEFAULT 'F' check (enable_group_savers in ('T','F')),
	max_group_sizes numeric,
	min_group_sizes numeric default 2 check (min_group_sizes >= 2),	
	has_fixed_saving_amount character varying(1) DEFAULT 'F' check (has_fixed_saving_amount in ('T','F')),
	fixed_saving_amount numeric,		
	has_min_saving_amount character varying(1) DEFAULT 'T' check (has_min_saving_amount in ('T','F')),
	min_saving_amount numeric,
	has_max_saving_amount character varying(1) DEFAULT 'F' check (has_max_saving_amount in ('T','F')),	
	max_saving_amount numeric,	
	enable_installment_txns  character varying(1) DEFAULT 'F' check (has_max_saving_amount in ('T','F')),	
	min_percent_installment_amount numeric,	
	enable_share_purchase character varying(1) DEFAULT 'F' check (enable_share_purchase in ('T','F')),
	total_shares numeric,
	max_no_shares_per_user numeric,
	min_no_shares_per_user numeric,	
	no_of_conc_loans_per_member numeric default 1,	
    disabled_features jsonb default '{}'::jsonb,
	license jsonb default '{}'::jsonb, 
	status character varying(50), 
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,	
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone 
);

insert into sacco.sacco(sacco_id,sacco_name, sacco_code, telno, email,enable_one_time_entrance_fee,enable_group_savers,max_group_sizes,min_group_sizes,has_fixed_saving_amount,
 fixed_saving_amount,has_min_saving_amount, min_saving_amount, has_max_saving_amount, max_saving_amount, enable_installment_txns, min_percent_installment_amount, 
 enable_share_purchase, total_shares, max_no_shares_per_user, min_no_shares_per_user,status) 
 ) values 
  (uuid_generate_v4(), 'Wazalendo Saving and Credit Co-operative Society','WSACCO','+256414668650','info@wazalendo.co.ug','T','T',50,10,'F','T',50000000000, 1000,1,'active'),
  (uuid_generate_v4(), 'Uganda Revenue Staff Sacco','URASACCO','+256417442228','info@urasacco.com','T','T',50,10,'F','T',10000000000, 100000,20,'active');

/*

All money must end up on an account for accounting/tracking purposes.
Even Taxes, share purchases, interest earned by either  a member or the sacco from loans
all must be accounted/journalised.

Do not confuse a chart of account "account" with an account type such as "savings","toto", "business", "platinum " etc
 */
create table sacco.chart_of_accounts(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	account_id character varying(50) PRIMARY KEY,
	account_code character varying(12) NOT NULL,
	account_name character varying(100) NOT NULL,
	account_desc character varying(200),
	account_type character varying(50) NOT NULL references sacco.global_static_params(param_id),
	account_category character varying(50) NOT NULL references sacco.global_static_params(param_id),
	account_sub_category character varying(50) NOT NULL references sacco.global_static_params(param_id),
	account_class character varying(50) NOT NULL references sacco.global_static_params(param_id),
	bank_account_type character varying(50) NOT NULL references sacco.global_static_params(param_id),
	is_balance_sheet_acc character varying(1) NOT NULL check (is_balance_sheet_acc in ('T','F')),
	is_income_statement_acc character varying(1) NOT NULL check (is_income_statement_acc in ('T','F')),
	is_system_acc character varying(1) NOT NULL check (is_system_acc in ('T','F')),	
	bank_account_no character varying(50),	
	show_in_expense_claims character varying(1) default 'T' check (show_in_expense_claims in ('T','F')),
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_id,account_code),
	UNIQUE (sacco_id,account_class),
	UNIQUE (sacco_id,account_name)
);

CREATE INDEX chart_of_accounts_ind1 ON sacco.chart_of_accounts(sacco_id);

/*
 A Sacco may require users to purchase shares, or make it optional as in the table sacco.sacco(enable_share_purchase)
 The sacco share price changes over time so this table keeps the history of that
 The system will use the latest THEN price, when a new member comes in
 
 Every share purchase will be recorded so that the percentage shares owned by any member is known
 In the savers table, a shares opening balance exists coz at the time of this set up, a sacco may already have users with shares.
 
*/
create table sacco.share_value(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	effective_date date NOT NULL,
	per_share_price numeric NOT NULL,
	account_id character varying(50) REFERENCES sacco.chart_of_accounts(account_id),
	status character varying(50), 
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,	
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	primary key (sacco_id,effective_date)	
);

CREATE INDEX share_value_ind1 ON sacco.share_value(sacco_id);


/*  One Time Entrance fee. This may be taxable if the account_id it depends on has a configured tax */
create table sacco.one_time_entrance_fee(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	effective_date date NOT NULL,
	one_time_entrance_fee numeric NOT NULL,	
	account_id character varying(50) REFERENCES sacco.chart_of_accounts(account_id),
	status character varying(50), 
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,	
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	primary key (sacco_id,effective_date)	
);

CREATE INDEX one_time_entrance_fee_ind1 ON sacco.one_time_entrance_fee(sacco_id);
	
create table sacco.global_static_params_excludes( 
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	param_id character varying(50) NOT NULL REFERENCES sacco.global_static_params(param_id),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	PRIMARY KEY (param_id,sacco_id)
);
   
 
create table sacco.sacco_namespaces(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(100) NOT NULL references sacco.sacco(sacco_id),
	sacco_namespace_id  character varying(100) PRIMARY KEY,
	sacco_namespace_code character varying(10) UNIQUE NOT NULL,
	sacco_namespace_name character varying(200) UNIQUE NOT NULL,	
	disabled_features  jsonb default '{}'::jsonb,
	broadcast_msg jsonb default '{}'::jsonb, 
    base_domain jsonb UNIQUE NOT NULL,
	on_premise_ip_adds jsonb default '[]',
	oauth_settings jsonb default '{}'::jsonb,
	openid_settings jsonb default '{}'::jsonb,
	ldap_settings jsonb default '{}'::jsonb,
	admin_settings jsonb default '{}'::jsonb,
	account_creation_settings jsonb default '{}'::jsonb, 
    default_theme_settings jsonb default '{}'::jsonb,
	display_settings jsonb default '{}'::jsonb,
    global_no character varying(3) UNIQUE NOT NULL,
	authy_settings jsonb default '{}'::jsonb,
	zeecom_settings jsonb default '{}'::jsonb,
	license jsonb default '{}'::jsonb,
	status character varying(50), 
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,	
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone 
);

CREATE INDEX sacco_namespaces_ind1 ON sacco.sacco_namespaces(sacco_id);

create table sacco.sacco_licenses(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	license_code character varying(100) PRIMARY KEY,	
	license_type character varying(50),
	license_key character varying(100),
	license_start_date date,
	license_end_date date,
	license_details jsonb default '{}'::jsonb,
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),	 
	status character varying(50), 
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,	
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone 
);

CREATE INDEX sacco_licenses_ind1 ON sacco.sacco_licenses(sacco_namespace_id);
	
create table sacco.sacco_license_config(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	license_code character varying(100) NOT NULL REFERENCES sacco.sacco_licenses(license_code),
	metric_param character varying(500) NOT NULL ,
	metric_value jsonb NOT NULL,
	metric_comments character varying(200),
	metric_category character varying(50) references sacco.global_static_params(param_id),
	metric_type character varying(50) references sacco.global_static_params(param_id),
	status character varying(50), 
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,	
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	PRIMARY KEY (license_code,metric_param)
);

CREATE TABLE sacco.auth_users 
(
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
	username character varying(50) PRIMARY KEY, 
	external_user_id character varying(100) NOT NULL, 
    surname character varying(100),
    first_name character varying(100),
    other_names character varying(100),	
    sex character varying(1) NOT NULL check (sex in ('M','F')),
	salutations jsonb default '[]'::jsonb,
	sms_telno character varying(15) CHECK (sms_telno ~* '^\+[1-9]\d{1,14}$'),
	sms_telno_verified  character varying(1) DEFAULT 'F' check (sms_telno_verified in ('T','F')),
	sms_telno_verification jsonb default '{}'::jsonb,
	whatsapp_no  character varying(15) CHECK (whatsapp_no ~* '^\+[1-9]\d{1,14}$'),
	whatsapp_no_verified  character varying(1) DEFAULT 'F' check (whatsapp_no_verified in ('T','F')),
	whatsapp_no_verification jsonb default '{}'::jsonb,
	email character varying(100) CHECK (
							(email ~* '(?:[a-z0-9!#$%&''*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])') AND 
							(email ~* '(?:[a-z0-9!#$%&''*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])') AND  
							(email ~* '([-!#-''*+/-9=?A-Z^-~]+(\.[-!#-''*+/-9=?A-Z^-~]+)*|"([]!#-[^-~ \t]|(\\[\t -~]))+")@[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?(\.[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?)+') AND 
							(email ~* '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$')
	),
	email_verified  character varying(1) DEFAULT 'F' check (email_verified in ('T','F')),
	email_verification jsonb default '{}'::jsonb, 	
	bound_settings jsonb default '{}'::jsonb,
	read_only  character varying(1) DEFAULT 'F',   
	allow_roles jsonb default '[]'::jsonb,
	deny_roles jsonb default '[]'::jsonb,
	allow_profiles jsonb default '{}'::jsonb,
	deny_profiles jsonb default '{}'::jsonb,	
	display_preferences jsonb default '{}'::jsonb,	
	tfa_settings jsonb default '{}'::jsonb,
	device_settings jsonb default '{}'::jsonb,
	account_type character varying(20) default 'normal' check (account_type in ('audit','normal','vendor','support','admin','root','virtual')),
	account_by_signup character varying(1) default 'F'  check (account_by_signup in ('T','F')),
	account_status jsonb default '{}'::jsonb,	
	account_settings jsonb default '{}'::jsonb,	
    notification_settings jsonb default '{}'::jsonb,
    is_temporary character varying(1) DEFAULT 'F' check (is_temporary in ('T','F')),
    access_till_date date,
	access_till_time TIMESTAMP WITH TIME ZONE,
    password_last_change_date timestamp with time zone,
	last_logged_in_date  timestamp with time zone,	
	def_password jsonb default '{}'::jsonb,
    forgot_password jsonb default '{}'::jsonb,
    change_psd jsonb default '{}'::jsonb,
	login_param character varying(50) default 'all' check (login_param in ('all','email','sms_telno','whatsapp_no','user_id')),
    account_state jsonb default '{}'::jsonb,
    account_init  character varying(1) DEFAULT 'F' check (account_init in ('T','F')),
	account_setup jsonb default '{}'::jsonb,
	oauth_settings  jsonb default '{}'::jsonb,
	openid_settings  jsonb default '{}'::jsonb,
	ldap_settings  jsonb default '{}'::jsonb,
	api_settings jsonb default '{}'::jsonb,
	blacklists jsonb default '{}'::jsonb,
	access_restrictions jsonb default '{}'::jsonb,
	subscriptions jsonb default '{}'::jsonb,
	security_qns_ans jsonb default '[]'::jsonb,
	security_flags jsonb default '{}'::jsonb,
	session_alert character varying(1) default 'F' check (session_alert in ('T','F')),
	session_alert_config jsonb default '{}'::jsonb ,
	login_msg jsonb default '{}'::jsonb,	
	terminated  character varying(1) DEFAULT 'F'  check (terminated in ('T','F')), 
	termination_details jsonb default '{}'::jsonb,
	terminated_by character varying(100) references sacco.auth_users(username),
	terminated_date date,
    supervisor character varying(100) references sacco.auth_users(username),
    reports_to  character varying(100) references sacco.auth_users(username),
    section_head  character varying(100) references sacco.auth_users(username),
	status character varying(50), 
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,    
	UNIQUE (sms_telno,sacco_namespace_id),
	UNIQUE (whatsapp_no,sacco_namespace_id),
	UNIQUE (email,sacco_namespace_id),
	UNIQUE (external_user_id,sacco_namespace_id),	
	check (supervisor <> username),
	check (reports_to <> username)
);

CREATE INDEX sacco_users_ind1 ON sacco.auth_users(sacco_namespace_id);
 

/*  Illegal passwords or illegal patterns in passwords.
 If these patters or whole pattern are detected, 
 the password being created is impermissible   */
 
CREATE TABLE sacco.auth_illegal_keys 
(
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
	check_condition character varying(100) default 'contains' check (check_condition in ('contains','eq','begins','ends')),
	case_sensitive character varying(1) default 'F' check (case_sensitive in ('T','F')),
	key_pattern character varying(100),
	object_vsn numeric default 2.0,
	archived character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100) NOT NULL references sacco.auth_users(username),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F'  check (deleted in ('T','F')),
	deleted_by character varying(100) references sacco.auth_users(username),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_namespace_id,key_pattern,case_sensitive,check_condition)
);

CREATE INDEX illegal_keys_ind1 ON sacco.auth_illegal_keys(sacco_namespace_id);

/* 
	Actual current password table 
	https://webauthn.guide/
*/
CREATE TABLE sacco.auth_current_psd
(
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	username character varying(100) PRIMARY KEY,
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
	cpsd_key_vsn character varying(10),
	cpsd_key_hash text,
	cpsd_key text,
	status character varying(50), 
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	constraint sacco_authkey_akfk_1 foreign key (username) references sacco.auth_users(username),
	unique	(sacco_namespace_id,username)
);

CREATE INDEX cpsds_ind1 ON sacco.auth_current_psd(sacco_namespace_id);

	
/* Old passwords storage. No unique key so the table can spread out as much. 
	Using the sdate when it became old, we can have a policy on how we can allow to 
	repeat password usage if ever
 */
CREATE TABLE sacco.auth_old_psd 
(
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
	username character varying(100)  NOT NULL references sacco.auth_users(username),
	opsd_hash text,
	opsd text 
);

CREATE INDEX opsds_ind1 ON sacco.auth_old_psd(sacco_namespace_id);
   
  /*   static param types */
create table sacco.sacco_static_param_types( 
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	param_type_id character varying(50) PRIMARY KEY,
	param_type character varying(200) NOT NULL,
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),	
	status character varying(50), 
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_namespace_id,param_type)
);

CREATE INDEX spts_ind1 ON sacco.sacco_static_param_types(sacco_namespace_id);


/* Static Parameter Category */ 
/* 
	insert into sacco.sacco_static_param_types(param_category_id,param_category,param_category_title,status,status_details,)
*/
create table sacco.sacco_static_param_category(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	param_category_id character varying(50) PRIMARY KEY,
	param_category character varying(200) NOT NULL,
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
	status character varying(50), 
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_namespace_id,param_category)
);

CREATE INDEX spcs_ind1 ON sacco.sacco_static_param_category(sacco_namespace_id);


/* static params */
create table sacco.sacco_static_params(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	param_id character varying(50) PRIMARY KEY,
	param_code character varying(50) NOT NULL,
	param_value character varying(100) NOT NULL,
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
	exclusion_settings jsonb default '{}'::jsonb , 
	param_type_id character varying(50) NOT NULL references sacco.sacco_static_param_types(param_type_id),
	param_category_id character varying(50) NOT NULL references sacco.sacco_static_param_category(param_category_id),
	has_parent_param  character varying(1) DEFAULT 'F'  check (has_parent_param in ('T','F')),
	parent_param_id character varying(50) references sacco.sacco_static_params(param_id),
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_namespace_id,param_type_id,param_code),
	UNIQUE (sacco_namespace_id,param_type_id,param_value)
);

CREATE INDEX spms_ind1 ON sacco.sacco_static_params(sacco_namespace_id);
 
create table sacco.sacco_attachments(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	attachment_id character varying(100) PRIMARY KEY,
	attachment_name character varying(100) NOT NULL,
	attachment_type character varying(50),
	attachment_category character varying(50),
	attachment_namespace character varying(50) NOT NULL,
	owner_id character varying(100) NOT NULL,
	digest_type character varying(10)  DEFAULT 'sha256sum' check (digest_type in ('sha256sum','md5')),
	file_digest jsonb,
	file_type character varying(50),
	file_extension character varying(10) NOT NULL,
	original_file_name character varying(100),	
	storage_type character varying(20) default 'couchdb' check (storage_type in ('couchdb','file_system','local')),
	file_content text,
	file_content_type character varying(50),
	image_type character varying(20),
	application_metadata jsonb default '{}'::jsonb,
	couchdb_settings jsonb default '{"domain":"","db": "","doc_id": "","attachment_name": ""}'::jsonb,
	filesystem_settings jsonb default '{"new_file_name":"","file_path": "","file_link": ""}'::jsonb,
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone
);

CREATE INDEX attachments_ind1 ON sacco.sacco_attachments(sacco_id);

CREATE TABLE sacco.auth_apps   
( 
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	app_id character varying(50) PRIMARY KEY,
    app_code character varying(50) NOT NULL,
    app_title character varying(100)  NOT NULL,
	app_vsn character varying(20) NOT NULL,
    app_url jsonb NOT NULL,
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
	read_only character varying(1) default 'F' check (read_only in ('T','F')),
    all_access character varying(1) default 'F' check (all_access in ('T','F')),
    enabled character varying(20)  DEFAULT 'T' check (enabled in ('T','F')),   
	app_desc jsonb,
	api_settings jsonb default '{}'::jsonb,
	access_restrictions jsonb default '{}'::jsonb,
	public_key jsonb,
	license jsonb default '{}'::jsonb,
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_namespace_id,app_code),
	UNIQUE (sacco_namespace_id,app_title)
);

CREATE INDEX apps_ind1 ON sacco.auth_apps(sacco_namespace_id);

CREATE TABLE sacco.auth_functions 
(
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	app_id character varying(50) NOT NULL REFERENCES sacco.auth_apps(app_id),
	function_id character varying(50) PRIMARY KEY,
	function_code character varying(50) NOT NULL,    	
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
	function_title character varying(100) NOT NULL,	
	all_access character varying(1) default 'F' CHECK (all_access in ('T','F')),
	function_nature character varying(20) DEFAULT 'read' check (function_nature in ('authenticate','create','read','update','delete','authorize','vendor')),	
	risk_level character varying(20) DEFAULT 'low' check (risk_level in ('low','moderate','high','critical')),
	function_desc character varying(1000),
	technical_doc jsonb,
	no_of_args INTEGER CHECK (no_of_args >= 0),
	access_restrictions jsonb default '{}'::jsonb,	
	function_category character varying(100),
	profiles jsonb default '[]'::jsonb,
	roles jsonb default '[]'::jsonb,
	sprofiles jsonb default '[]'::jsonb,
	blocked_profiles  jsonb default '[]'::jsonb,
	blocked_roles   jsonb default '[]'::jsonb,
	blocked_groups   jsonb default '[]'::jsonb,
	blocked_users   jsonb default '[]'::jsonb,	
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_namespace_id,app_id,function_code),
	UNIQUE (sacco_namespace_id,app_id,function_title)
);

CREATE INDEX functions_ind1 ON sacco.auth_functions(sacco_namespace_id);

CREATE TABLE sacco.auth_profiles
(
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	profile_id character varying(50) PRIMARY KEY, 
    profile_title character varying(100) NOT NULL,
	profile_type character varying(10) default 'simple' check (profile_type in ('simple','composite')),
    profile_desc jsonb,
	is_application_profile character varying(1) default 'F' check (is_application_profile in ('F','T')),
	app_id character varying(50) REFERENCES sacco.auth_apps(app_id),
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
    read_only character varying(1) default 'F' check (read_only in ('T','F')),
	roles jsonb default '[]'::jsonb,
	access_restrictions jsonb default '{}'::jsonb ,
	profile_settings jsonb default '{}'::jsonb,
    status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_namespace_id, profile_title) 
);

CREATE INDEX profiles_ind1 ON sacco.auth_profiles(sacco_namespace_id);
	
CREATE TABLE sacco.auth_profile_tree 
(
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	parent_profile_id character varying(50) NOT NULL REFERENCES sacco.auth_profiles(profile_id), 
	child_profile_id character varying(50) NOT NULL REFERENCES sacco.auth_profiles(profile_id),
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),	
	composite_desc jsonb,
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
    PRIMARY KEY (sacco_namespace_id,parent_profile_id,child_profile_id)
);

CREATE INDEX profile_tree_ind1 ON sacco.auth_profile_tree(sacco_namespace_id);

CREATE TABLE sacco.auth_profile_functions 
(
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	pfunction_id character varying(50) PRIMARY KEY, 
    profile_id character varying(200) NOT NULL REFERENCES sacco.auth_profiles(profile_id),   
    function_id character varying(200) NOT NULL REFERENCES sacco.auth_functions(function_id),
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),	
	is_temporary character varying(1) default 'F' check (is_temporary in ('T','F')), 
	expiry_date DATE,
	access_restrictions jsonb default '{}'::jsonb,
	settings jsonb default '{}'::jsonb, 	
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_namespace_id,profile_id,function_id)
);

CREATE INDEX pfunctions_ind1 ON sacco.auth_profile_functions(sacco_namespace_id);
   
 /* User Security Profiles */

CREATE TABLE sacco.auth_security_profile 
( 
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sprofile_id character varying(50) PRIMARY KEY, 
    sprofile_title character varying(100) NOT NULL,
    sprofile_desc jsonb,
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
	settings jsonb default '{}'::jsonb,
	scopes jsonb default '{}'::jsonb,
	access_restrictions jsonb default '{}'::jsonb,
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_namespace_id,sprofile_title)
);

CREATE INDEX sprofile_ind1 ON sacco.auth_security_profile(sacco_namespace_id);

/*
 convert: 41.202.241.11 to decimal format
 
	math:pow(256,3) * 41 + math:pow(256,2) * 202 + math:pow(256,1) * 241 + math:pow(256,0) * 11.
701165835.0


	SameSite=None for cookies  
	https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#SameSite_cookies
	https://en.wikipedia.org/wiki/List_of_the_most_common_passwords
	https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html
	
	http://www.geoplugin.com/webservices/csv
	http://www.geoplugin.com/ --- free
	
	https://ip-api.com/docs/ --- free
	
	https://members.ip-api.com/ -- cheap
	
	https://ipstack.com/ { api_key = 16b392cdd113c77720cb5d13ffb855fa, http://api.ipstack.com/41.210.145.204?access_key=16b392cdd113c77720cb5d13ffb855fa}
*/

CREATE TABLE sacco.auth_security_profile_def  
(
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sprofile_id character varying(50) PRIMARY KEY references sacco.auth_security_profile(sprofile_id), 
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
	psd_min_length integer default 8  check (psd_min_length >= 8 ),
	psd_max_length integer default 30 check (psd_max_length >= 50 ),
	password_username_rship character varying(1) default 'F' check (password_username_rship in ('T','F')),
	psd_format_min_chars integer default 1 check (psd_format_min_chars >= 1),
	psd_format_min_uppercase integer  default 1 check (psd_format_min_uppercase >= 1),
	psd_format_min_lowercase integer default 1 check (psd_format_min_lowercase >= 1),
	psd_format_min_digits integer default 1 check (psd_format_min_digits >= 1),
	routine_psd_change  character varying(1) DEFAULT 'F' check (routine_psd_change in ('T','F')),
	psd_change_freq_days integer default 90 check (psd_change_freq_days >= 5),
	psd_history_size  integer default 5  check (psd_history_size >= 3),
	account_idle_lock_days integer default 30 check (account_idle_lock_days >= 7),
	failed_login_attempts_lock integer default 4 check (failed_login_attempts_lock >= 3),
	warn_failed_login_attempt character varying(1) default 'T' check (warn_failed_login_attempt in ('T','F')),
	ip_address_check character varying(1) DEFAULT 'F' check (ip_address_check in ('T','F')),
	allowed_ips jsonb default '[]'::jsonb, 
	blocked_ips jsonb default '[]'::jsonb,
	login_hour character varying(1) DEFAULT 'F' check (login_hour in ('T','F')),
	login_hour_brutal character varying(1) DEFAULT 'F' check (login_hour_brutal in ('T','F')),
	login_hour_min integer check (login_hour_min >= 0),
	login_hour_max integer  check (login_hour_max >= 23),
	ask_sq_at_login character varying(1) DEFAULT 'F' check (ask_sq_at_login in ('T','F')),
	tfa_login  character varying(1) DEFAULT 'F' check (tfa_login in ('T','F')),
	tfa_method character varying(10) default 'sms' check (tfa_method in ('email','sms','whatsapp')),
	max_concurrent_sessions integer default 1 check (max_concurrent_sessions >= 1),
	warn_additional_session character varying(1) default 'T' check (warn_additional_session in ('T','F')),
	warn_blocked_session character varying(1) default 'T' check (warn_blocked_session in ('T','F')),
	session_timeout_mins integer default 30 check (session_timeout_mins >= 0),
	idle_timeout_mins integer default 5 check (idle_timeout_mins >= 0),
	account_inactivity_days integer default 14 check ( account_inactivity_days >= 0),
	lock_session_to_location  character varying(1) DEFAULT 'F' check (lock_session_to_location in ('T','F')),
	on_premise_apps jsonb default '{}'::jsonb,
	monitoring jsonb default '{}'::jsonb,
	api_settings jsonb default '{}'::jsonb,
	access_restrictions jsonb default '{}'::jsonb,
	data_masking character varying(1) DEFAULT 'F' check (data_masking in ('T','F')),
	data_masking_settings  jsonb default '{}'::jsonb,
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone 
);

CREATE INDEX sprofile_def_ind1 ON sacco.auth_security_profile_def(sacco_namespace_id);

CREATE TABLE sacco.auth_roles 
(
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	role_id character varying(50) PRIMARY KEY,
    role_title character varying(200) NOT NULL,
	role_type character varying(10) default 'simple' check (role_type in ('simple','composite')),
	is_application_role character varying(1) default 'F' check (is_application_role in ('F','T')),
	app_id character varying(50) REFERENCES sacco.auth_apps(app_id),
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
	sprofile_id character varying(100) NOT NULL references sacco.auth_security_profile(sprofile_id),
	role_desc character varying(100),
	settings jsonb default '{}'::jsonb,
	scopes jsonb default '{}'::jsonb,
	access_restrictions jsonb default '{}'::jsonb,
	is_default character varying(1) default 'F' check (is_default in ('T','F')),
    max_users numeric DEFAULT 0,
    is_active character varying(1) DEFAULT 'T' check (is_active in ('T','F')),
    status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_namespace_id,role_title) 
);

CREATE INDEX roles_ind1 ON sacco.auth_roles(sacco_namespace_id);

/*   ---------------------------------------- */
CREATE TABLE sacco.auth_role_tree 
(
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	parent_role_id character varying(50) NOT NULL REFERENCES sacco.auth_roles(role_id),
	child_role_id character varying(50) NOT NULL REFERENCES sacco.auth_roles(role_id),
	is_temporary character varying(1) default 'F' check (is_temporary in ('T','F')), 
	expiry_date DATE,
	composite_desc character varying(100),
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
    PRIMARY KEY (sacco_namespace_id,parent_role_id,child_role_id)
);

CREATE INDEX role_tree_ind1 ON sacco.auth_role_tree(sacco_namespace_id);

CREATE TABLE sacco.auth_role_profiles 
(
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	rprofile_id character varying(50) PRIMARY KEY,
    role_id character varying(50) NOT NULL REFERENCES sacco.auth_roles(role_id),
    profile_id character varying(200) NOT NULL REFERENCES sacco.auth_profiles(profile_id),
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
	is_temporary character varying(1) default 'F' check (is_temporary in ('T','F')),
	expiry_date DATE,
	scopes jsonb default '{}'::jsonb,
	access_restrictions jsonb default '{}'::jsonb,
	settings jsonb default '{}'::jsonb,
    status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
    UNIQUE (sacco_namespace_id,role_id,profile_id) 
);

CREATE INDEX role_profiles_ind1 ON sacco.auth_role_profiles(sacco_namespace_id);

CREATE TABLE sacco.auth_user_roles 
( 
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	username character varying(100) NOT NULL references sacco.auth_users(username),
	role_id character varying(50) NOT NULL REFERENCES sacco.auth_roles(role_id),
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
	is_temporary character varying(1) default 'F' check (is_temporary in ('T','F')),	
	expiry_date DATE,
	scopes jsonb default '{}'::jsonb,
	access_restrictions jsonb default '{}'::jsonb,
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	PRIMARY KEY (sacco_namespace_id,username,role_id)
);

CREATE INDEX user_roles_ind1 ON sacco.auth_user_roles(sacco_namespace_id);

/*
for communication purposes
*/
CREATE TABLE sacco.auth_groups 
(
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	group_id character varying(50) PRIMARY KEY,
    group_title character varying(200) NOT NULL,
    group_desc jsonb,
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
	role_id character varying(50) NOT NULL REFERENCES sacco.auth_roles(role_id),
    role_enforcement_level character varying(20) default 'inclusive' check (role_enforcement_level in ('inclusive','exclusive')),
	scopes jsonb default '{}'::jsonb,
	email character varying(100) CHECK (
							(email ~* '(?:[a-z0-9!#$%&''*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])') AND 
							(email ~* '(?:[a-z0-9!#$%&''*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])') AND  
							(email ~* '([-!#-''*+/-9=?A-Z^-~]+(\.[-!#-''*+/-9=?A-Z^-~]+)*|"([]!#-[^-~ \t]|(\\[\t -~]))+")@[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?(\.[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?)+') AND 
							(email ~* '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$')
	),
	blacklists jsonb default '{}'::jsonb,
	access_restrictions jsonb default '{}'::jsonb,
	subscriptions jsonb default '{}'::jsonb,
    max_users integer DEFAULT 0,
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_namespace_id,group_title) 
);

CREATE INDEX auth_groups_ind1 ON sacco.auth_groups(sacco_namespace_id);
	
CREATE TABLE sacco.user_auth_groups  
(
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	username character varying(100) NOT NULL references sacco.auth_users(username),
	group_id character varying(50) NOT NULL REFERENCES sacco.auth_groups(group_id),
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
	is_temporary character varying(1) default 'F' check (is_temporary in ('T','F')), 
	expiry_date DATE,
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	PRIMARY KEY (sacco_namespace_id,username,group_id)
);	

CREATE INDEX user_auth_groups_ind1 ON sacco.user_auth_groups(sacco_namespace_id);

CREATE TABLE sacco.auth_failed_logins
(
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	username character varying(100) NOT NULL references sacco.auth_users(username),
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
	login_as character varying(100),
	provided_psd jsonb,
	client_station jsonb default '{}'::jsonb,
	initiating_middleware jsonb default '{}'::jsonb,
	device_print jsonb default '{}'::jsonb,
	browser character varying(200),
	proxy_ip_address character varying(50) NOT NULL,
	forwarded_ip_address character varying(50) NOT NULL,
	geo_location jsonb default '{}'::jsonb ,
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone
);

CREATE INDEX failed_logins_ind1 ON sacco.auth_failed_logins(sacco_namespace_id);

CREATE TABLE sacco.auth_session 
( 
    sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	edate timestamp with time zone,
	session_id character varying(100) PRIMARY KEY,	
	username character varying(100) NOT NULL references sacco.auth_users(username),	
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),	
    logged_in_as character varying(100),
	electron_license_id character varying(200),
	client_station jsonb default '{}'::jsonb,
	initiating_middleware jsonb default '{}'::jsonb,
    session_management jsonb default '{}'::jsonb,
	app_auth_settings jsonb default '{}'::jsonb,  
    device_print jsonb default '{}'::jsonb,
	browser text,
	session_token text NOT NULL,
    proxy_ip_address character varying(50) NOT NULL,
	forwarded_ip_address character varying(50) NOT NULL,
	geo_location jsonb default '{}'::jsonb,
	session_metadata jsonb default '{}'::jsonb,
    session_opaque jsonb default '{}'::jsonb,
	is_oauth_session  character varying(1) default 'F' check (is_oauth_session in ('T','F')),
	oauth jsonb default '{}'::jsonb,
	logged_out character varying(1) default 'F' check (logged_out in ('T','F')),
	session_terminated  character varying(1) default 'F' check (session_terminated in ('T','F')),
	session_termination jsonb default '{}'::jsonb,
	is_session_active character varying(1) default 'T' check (is_session_active in ('T','F')),
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone
);

CREATE INDEX auth_session_ind1 ON sacco.auth_session(sacco_namespace_id);

create table sacco.system_logs( 
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_namespace_id character varying(50) NOT NULL references sacco.sacco_namespaces(sacco_namespace_id),
	username character varying(100)  NOT NULL references sacco.auth_users(username),
	session_id character varying(100) REFERENCES sacco.auth_session(session_id),
	application character varying(200),
	functionality character varying(500) ,
	action_summary character varying(1000) NOT NULL,	
	action_details jsonb default '{}'::jsonb,
	source_interfaces jsonb default '[]'::jsonb,
	middleware_node character varying(100),
	affected_entity_id character varying(100),
	affected_entity_type character varying(100),
	change_matrix jsonb default '{}'::jsonb,
	metadata jsonb default '{}'::jsonb,
	action_result jsonb default '{}'::jsonb,
	settings jsonb default '{}'::jsonb,
	tags jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb 
);

CREATE INDEX logs_ind1 ON sacco.system_logs(sacco_namespace_id);

CREATE TABLE sacco.sacco_policy_params
(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	policy character varying(50) NOT NULL references sacco.sacco_static_params(param_id),
	policy_details jsonb default '{}'::jsonb,
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	PRIMARY KEY (sacco_id,policy)
);

CREATE INDEX policy_params_ind1 ON sacco.sacco_policy_params(sacco_id);

/*  By Regulation, taxation is becoming part or sacco   */

create table sacco.sacco_tax( 
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	tax_id character varying(100) PRIMARY KEY,
	tax_name character varying(100) NOT NULL,
	tax_code character varying(20) NOT NULL ,
	account_id character varying(50) NOT NULL references sacco.chart_of_accounts(account_id),
	tax_desc character varying(4000),
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,	
	UNIQUE (sacco_id,tax_name),
	UNIQUE (sacco_id,tax_code)
);

CREATE INDEX tax_ind1 ON sacco.sacco_tax(sacco_id);

/* Tax changes over time */
create table sacco.sacco_tax_amount(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	tax_id character varying(100) NOT NULL references sacco.sacco_tax(tax_id) ,
	tax_percentage numeric default 0 check (tax_percentage >= 0 and tax_percentage <= 100),
	effective_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	PRIMARY KEY(sacco_id,tax_id,effective_date)
);

CREATE INDEX tax_amount_ind1 ON sacco.sacco_tax_amount(sacco_id);

create table sacco.sacco_account_tax(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	account_id character varying(50) not null REFERENCES sacco.chart_of_accounts(account_id),
	tax_id character varying(100) NOT NULL references sacco.sacco_tax(tax_id),
	effective_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	PRIMARY KEY (sacco_id,account_id, tax_id)	
);

CREATE INDEX account_tax_ind1 ON sacco.sacco_account_tax(sacco_id);

/* TOTO account, fixed deposit account, business account, corperate etc  */
CREATE TABLE sacco.sacco_savers_account_types 
( 
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	account_type_id character varying(50) PRIMARY KEY,
	account_type_name character varying(100),
	account_type_account_id character varying(50) REFERENCES sacco.chart_of_accounts(account_id),
	enable_interest_to_savers character varying(1) default 'T' check (enable_interest_to_savers in ('T','F')),
	savers_interest_acccount_id character varying(50) REFERENCES sacco.chart_of_accounts(account_id),
	enable_monthly_charge character varying(1) default 'T' check (enable_monthly_charge in ('T','F')),
	monthly_charge_account_id character varying(50) REFERENCES sacco.chart_of_accounts(account_id),	
	enable_surcharge character varying(1) default 'T' check (enable_surcharge in ('T','F')),
	surcharge_account_id character varying(50)  REFERENCES sacco.chart_of_accounts(account_id),
	is_fixed_monthly_deposit character varying(1) NOT NULL default 'T' check (is_fixed_monthly_deposit in ('T','F')),
	monthly_deposit_includes_monthly_charge character varying(1) NOT NULL default 'T' check (monthly_deposit_includes_monthly_charge in ('T','F')),
	monthly_deposit numeric,
	max_monthly_deposit numeric,
	min_monthly_deposit numeric,
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_id,account_type_name)
);

CREATE INDEX savers_account_types_ind1 ON sacco.sacco_savers_account_types(sacco_id);

/*  Interest rate, monthly charges and surcharges can change over time. 
The interest rate paid by the sacco to its savers depending on the account they hold 
table is able to keep the historical values via window functions since interest may be calculated in views */

create table sacco.sacco_savings_interest_rate(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	account_type_id character varying(50) NOT NULL references sacco.sacco_savers_account_types(account_type_id),
	effective_date date NOT NULL,
	interest_rate_percent_pa numeric NOT NULL check (interest_rate_percent_pa <= 100),	/* per annum  */
	status character varying(50), 
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,	
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	primary key (sacco_id,account_type_id,effective_date)	
);

CREATE INDEX savings_interest_rate_ind1 ON sacco.sacco_savings_interest_rate(sacco_id);

create table sacco.sacco_monthly_charge(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	account_type_id character varying(50) NOT NULL references sacco.sacco_savers_account_types(account_type_id),
	effective_date date NOT NULL,
	monthly_charge numeric NOT NULL,
	status character varying(50), 
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,	
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	primary key (sacco_id,account_type_id,effective_date)	
);

CREATE INDEX monthly_charge_ind1 ON sacco.sacco_monthly_charge(sacco_id);

create table sacco.sacco_surcharge(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	account_type_id character varying(50) NOT NULL references sacco.sacco_savers_account_types(account_type_id),
	effective_date date NOT NULL,
	surcharge numeric NOT NULL,
	status character varying(50), 
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,	
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	primary key (sacco_id,account_type_id,effective_date)	
);

CREATE INDEX surcharge_ind1 ON sacco.sacco_surcharge(sacco_id);

/*
 A saver may be linked to a username account or not, or a single userame can have multiple savers under it.
 A username accesses and manages its own savers account(s)
 A savers account will always be under one username at a time
*/
CREATE TABLE sacco.sacco_savers
( 
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	username character varying(100) NOT NULL references sacco.auth_users(username),	
	savers_account_id character varying(50) PRIMARY KEY,
	savers_account_no character varying(12),	
	account_type_id character varying(50) NOT NULL REFERENCES sacco.sacco_savers_account_types(account_type_id),
	savers_joined_date date,
	savers_income numeric,
	monthly_deposit numeric, /*   take note of the monthly account admin charge */
	is_individual character varying(1) default 'T' check (is_individual in ('T','F')),
	is_group character varying(1) default 'T' check (is_group in ('T','F')),
	group_name character varying(100),
	email character varying(50) CHECK (
							(email ~* '(?:[a-z0-9!#$%&''*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])') AND 
							(email ~* '(?:[a-z0-9!#$%&''*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])') AND  
							(email ~* '([-!#-''*+/-9=?A-Z^-~]+(\.[-!#-''*+/-9=?A-Z^-~]+)*|"([]!#-[^-~ \t]|(\\[\t -~]))+")@[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?(\.[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?)+') AND 
							(email ~* '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$')
	),
	group_representative character varying(50) NOT NULL references sacco.sacco_savers(savers_account_id),
	surname character varying(100),
    first_name character varying(100),
    other_names character varying(100),
	sex character varying(1) check (sex in ('M','F')),
	date_of_birth date,
	nin character varying(100) NOT NULL,
	marital_status character varying(20) default 'single' check (marital_status in ('single','married','widowed', 'divorced', 'separated','N/A')),
	passport_no character varying(100),
	drv_license_no character varying(100),
	ssn_no character varying(100),
	social_media jsonb default '{}'::jsonb, 
	biodata jsonb default '{}'::jsonb,
	contact_info jsonb default '{}'::jsonb,
	office_info jsonb default '{}'::jsonb,
	job_info jsonb default '{}'::jsonb, 
	shares_opening_balance numeric, /* number of shares owned by the person in the sacco  */
	bank_account_no character varying(50),
	bank_name character varying(50) references sacco.global_static_params(param_id),
	bank_branch character varying(100),
	passport_photo character varying(50) references sacco.sacco_attachments(attachment_id),
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_id, nin),
	UNIQUE (sacco_id, savers_account_no), 	
	UNIQUE (sacco_id, savers_account_no, username), 	
	UNIQUE (sacco_id, passport_no),
	UNIQUE (sacco_id, drv_license_no), 	
	UNIQUE (sacco_id, ssn_no)
);

CREATE INDEX savers_ind1 ON sacco.sacco_savers(sacco_id);	

/*
Savings Group  Members. The Group itself has a single account as a saver, but all members must first be members of the sacco
*/
create table sacco.sacco_savers_group_members(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	group_savers_account_id character varying(50) NOT NULL REFERENCES  sacco.sacco_savers(savers_account_id),
	member_savers_account_id character varying(50) NOT NULL REFERENCES  sacco.sacco_savers(savers_account_id),
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	PRIMARY KEY (sacco_id,group_savers_account_id,member_savers_account_id)
);

CREATE INDEX savers_group_members_ind1 ON sacco.sacco_savers_group_members(sacco_id);	

create table sacco.sacco_loan_types(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	loan_type_id character varying(50) PRIMARY KEY,
	loan_name character varying(100),
	eligibility_min_months_membership integer,
	eligibility_min_no_of_deposits integer,
	eligibility_min_total_deposit_amount numeric,
	eligible_min_no_of_shares numeric,
	max_total_loan_amount numeric,
	min_total_loan_amount numeric,
	depends_on_savings_amount character varying(1) default 'T' check (depends_on_savings_amount in ('T','F')),
	max_loan_savings_multiplier numeric,
		/*  Maximum loan a perosn can take can be related to the total savings say "cant exceed twice the total savings" etc  
			If total_savings = 250,000/=
			and max possible loan cannot exceed twice the savings
			max_loan_savings_multiplier = 2
			loan <= 500000/=
		*/
	max_loan_shares_multiplier numeric,  
		/*  Maximum loan a person can take can be related to the total shares say "cant exceed twice the total shares" etc  
			If total_savings = 250,000/= 
			and max possible loan cannot exceed twice the savings
			max_loan_savings_multiplier = 2
		*/
	allow_conc_loans_per_saver character varying(1) default 'F' check (allow_conc_loans_per_saver in ('F','T')),
	max_no_of_conc_loans_per_saver integer default 1,
	max_repayment_months integer check (max_repayment_months > 0 ),
	no_of_guarantors integer default 0, 
	interest_rate numeric,
	enable_late_surcharge character varying(1) default 'T' check (enable_late_surcharge in ('T','F')),
	loan_surcharge_account_id character varying(50) REFERENCES sacco.chart_of_accounts(account_id),
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_id,loan_type_id)
);

CREATE INDEX loan_types_ind1 ON sacco.sacco_loan_types(sacco_id);

create table sacco.sacco_loan_deductables( 
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	loan_type_id character varying(50) NOT NULL REFERENCES sacco.sacco_loan_types(loan_type_id),
	deductable_id character varying(50) PRIMARY KEY,
	deductable_name character varying(100),
	is_percentage_calc character varying(1) default 'T' CHECK (is_percentage_calc in ('T','F')),
	deductable_percentage NUMERIC  default 0 CHECK (deductable_percentage between 0 and 100),
	is_fixed_amount character varying(1) default 'F' check (is_fixed_amount in ('F','T')),
	deductable_amount numeric,
	account_id character varying(50) REFERENCES sacco.chart_of_accounts(account_id),
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_id,loan_type_id,deductable_name)
);

CREATE INDEX loan_deductables_ind1 ON sacco.sacco_loan_deductables(sacco_id);

create table sacco.sacco_loan_surcharge(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	loan_type_id character varying(50) NOT NULL REFERENCES sacco.sacco_loan_types(loan_type_id),
	account_type_id character varying(50) NOT NULL references sacco.sacco_savers_account_types(account_type_id),
	effective_date date NOT NULL,
	is_fixed_surcharge  character varying(1) check (is_fixed_surcharge in ('T','F')),
	fixed_surcharge numeric NOT NULL,
	is_percentage_surcharge character varying(1) check (is_percentage_surcharge in ('T','F')),
	percentage_of_surcharge numeric,
	percentage_applied_on character varying(20) default 'emi' check (percentage_applied_on in ('emi','monthly_balance')),	
	status character varying(50), 
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,	
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	primary key (sacco_id,loan_type_id,effective_date)	
);

CREATE INDEX sacco_loan_surcharge_ind1 ON sacco.sacco_loan_surcharge(sacco_id);

create table sacco.sacco_savers_loans( 
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	savers_account_id character varying(50) NOT NULL REFERENCES sacco.sacco_savers(savers_account_id),
	loan_type_id character varying(50) NOT NULL REFERENCES sacco.sacco_loan_types(loan_type_id),
	loan_instance_id character varying(50) PRIMARY KEY,
	loan_account_no character varying(12),	
	loan_acquired_date date,
	loan_amount numeric NOT NULL,
	principal numeric NOT NULL,
	interest_rate_pa numeric check (interest_rate_pa >= 0 and interest_rate_pa <= 100),
	interest_type character varying(50) references sacco.sacco_static_params(param_id),
	emi numeric,  /* equated monthly installment   [P × r × ((1 + r) power n)/((1 + r) power n) - 1]  */
	no_of_payment_months integer,  /* Monthly Principal = (loan_amount/no_of_payment_periods) */
	start_repayment_date date,
	end_repayment_date date,
	monthly_due_day integer check (monthly_due_day >= 1 and monthly_due_day <= 31),
	guarantors jsonb default '{}'::jsonb,
	reviewed character varying(1) default 'F' check (reviewed in ('T','F')) ,
	review_date date,
	reviewed_by character varying(50),
	review_details jsonb default '{}'::jsonb,
	approved  character varying(1) default 'F' check (approved in ('T','F')) ,
	approved_date date,
	approved_by character varying(50),
	approval_details jsonb default '{}'::jsonb,
	published character varying(1) default 'F' check (published in ('T','F')),
	published_date date,
	published_by character varying(50),
	publish_details jsonb default '{}'::jsonb,
	sent_to_savers_account character varying(1) check (sent_to_savers_account in ('T','F')),
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_id,loan_account_no),
	check (end_date > start_date)
	/*
	
		RP
		==================================================================================
		For example, at an interest rate of three percent, if you borrow 100,000 TSH and agree to a sixmonth repayment plan, your monthly principal payment would be 16, 666.67 TSH (100, 000 / 6
		= 16, 666.67). 
		The interest on your first payment would be calculated as follows:
			100, 000 / 100 = 1000 x 3 = 3, 000 TSH interest
			Thus, your first payment would be 3, 000 + 16, 666.67 = 19, 666.67 TSH
			
			100, 000 – 16, 666.67 = 83, 333.33 TSH remaining principal
			
			The interest on your second month’s payment would be calculated as follows:
			83, 333.33 / 100 = 833.33 x 3 = 2, 499.99 TSH interest
			Your second month’s payment would be 2, 499.99 + 16, 666.67 = 19, 166.67 TSH
			83, 333.33 – 16, 666.67= 66, 666.66 TSH remaining principal
			
			The interest on your third monthly payment would be calculated as follows:
			66, 666.66 / 100 = 666.66 x 3 = 2, 000.00 TSH interest
			Your third month’s payment would be 2, 000.00 + 16, 666.67 = 18, 666.67 TSH
			
			The interest on your fourth month’s payment would be:
			66, 666.66 -16,666.67 = 49,999.99 (remaining principal) / 100 = 499.99 x 3 = 1, 500.00 TSH
			Your fourth month’s payment would be:
			1, 500.00 + 16, 666.67 = 18, 166.67 TSH
			For the fifth month, the interest would be:
			49, 999.99 – 16, 666.67 = 33, 333.32 (remaining principal) /100 =333.33 x 3 = 1, 000.00
			TSH
			Your fifth month’s payment would be:
			1, 000.00 + 16, 666.67 = 17, 666.67 TSH
			For the sixth month, the interest would be:
			33, 333.32 – 16, 666.67 = 16, 666.65 (remaining principal) /100 = 166.67 x 3 = 500.00 TSH
			Your sixth month’s payment would be:
			500.00 + 16, 666.65 = 17, 166.65
				
			At any point in time, you can pay the entire remaining principal. For the interest, divide the
			remaining principal by 100 and then multiply it by the interest rate. Your collateral is still in the
			SACCO, and you would be eligible for another loan if you so desired. You could continue to
			save more to take out another loan at a later date or withdraw your collateral at any time.
			SACCO interest rates differ and some charge 5 percent. The basic formula is the same.
			A loan of 50, 000 TSH at five percent interest with a three-month term:
			50, 000 / 3 = 16, 666.67
			1st month: 50, 000 / 100 = 500 x 5 = 2, 500 TSH interest + 16, 666.67 = 19, 166.67 TSH total
			payment
			2nd month: 50, 000 – 16, 666.67 = 33, 333.33/ 100 = 333.33 x 5 = 1, 666.67 TSH interest +
			16, 666.67 = 18, 333.34 TSH total payment
			3rd month: 33, 333.33 – 16, 666.67 = 16, 666.66 / 100 = 166.67 x 5 = 833.33 TSH interest +
			16, 666.66 = 17, 499.99 TSH total monthly payment
			
			Principal / Months in term = Monthly Principal Payment
			
			1st month: principal / 100 x interest rate = interest payment
			Interest payment + monthly principal payment = first month total payment
			2nd month: principal – monthly principal payment =remaining principal / 100 x interest rate =
			interest payment
			Interest payment + monthly principal payment = second month total payment
			3rd month: remaining principal from 2nd month – monthly principal payment = remaining
			principal / 100 x interest rate = interest payment
			Interest payment + monthly principal payment = third month total payment
	
			NRP
			============================================
			
			Here's an example: let's say you get an auto loan for $10,000 at a 7.5% annual interest rate for 5 years after making a $1,000 down payment. To solve the equation, you'll need to find the numbers for these values:

 

				A = Payment amount per period

				P = Initial principal or loan amount (in this example, $10,000)

				r = Interest rate per period (in our example, that's 7.5% divided by 12 months)

				n = Total number of payments or periods

			 

			The formula for calculating your monthly payment is:

			A = P (r (1+r)^n) / ( (1+r)^n -1 )

			 

			When you plug in your numbers, it would shake out as this:

				P = $10,000

				r = 7.5% per year / 12 months = 0.625% per period (0.00625 on your calculator)

				n = 5 years x 12 months = 60 total periods
				
				A = $200.38

				*/
);

CREATE INDEX savers_loans_ind1 ON sacco.sacco_savers_loans(sacco_id);
CREATE INDEX savers_loans_ind2 ON sacco.sacco_savers_loans(loan_type_id);

/* 
 Members financial transactions.
*/
CREATE TABLE sacco.sacco_savers_payments  
(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	sacco_txnid character varying(50) PRIMARY KEY,	
	savers_account_id character varying(50) NOT NULL REFERENCES sacco.sacco_savers(savers_account_id),
	username character varying(100) references sacco.auth_users(username),
	loan_instance_id character varying(50) REFERENCES sacco.sacco_savers_loans(loan_instance_id),
	effective_deposit_date date NOT NULL default current_date,
	ref_no character varying(13), 
	serial_no character varying(10),
	narration character varying(500),                                                 
	amount numeric,
	payment_type character varying(20) NOT NULL default 'DEPOSIT' check (payment_type in ('DEPOSIT','LOAN-REPAYMENT','SHARE-PURCHASE','SURCHARGE','ENTRANCE-FEE','MONTHLY-CHARGE','OTHER')),
	service_namespace character varying(100),
	service_code character varying(50),
	payment_method character varying(20) default 'CASH' check ( payment_method in ('CASH','VISA','MOBILE-MONEY','DIRECT-DEPOSIT','OTHER')),
	mobile_money_no character varying(20),	
	bank character varying(100),
	branch character varying(100),
	receipt_no character varying(20),
	txnid character varying(50),
	zeepay_payment_log_id character varying(500),
	is_directpost character varying(1) check (is_directpost in ('T','F')),
	posted_by  character varying(100),
	approved  character varying(1) check (approved in ('F','T')),
	approved_by character varying(1) check (approved_by in ('F','T')),
	approved_date date,
	approval_details jsonb default '{}'::jsonb,
	authorised character varying(1) check (authorised in ('F','T')),
	authorised_by character varying(100),
	authorised_date date,
	authorisation_details jsonb default '{}'::jsonb,
	processed character varying(1) default 'F' CHECK (processed in ('T','F')),
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_id,savers_account_id,ref_no,serial_no,amount,effective_deposit_date, payment_type)
);

CREATE INDEX savers_paymentnots_ind1 ON sacco.sacco_savers_payments(sacco_id);

/*
Line items to model the receivables of the sacco
*/
CREATE TABLE sacco.sacco_items 
(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	item_id character varying(50) PRIMARY KEY,
    item_code character varying(50) NOT NULL,
    item_name character varying(50) NOT NULL,
    item_category character varying(50)  NOT NULL REFERENCES sacco.sacco_static_params(param_id) ,
    item_type character varying(50)  NOT NULL REFERENCES sacco.sacco_static_params(param_id) ,	
	account_id character varying(50) NOT NULL references sacco.chart_of_accounts(account_id),    
    item_desc character varying(500),
	unit_amount numeric default 0 check (unit_amount >= 0),
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_id,item_code),
	UNIQUE (sacco_id,item_name)
);

CREATE INDEX items_ind1 ON sacco.sacco_items(sacco_id);

/*
 Invoice table. I think that we can model surcharges, monthly charges, shares purchases, loan repayments and 
  monthly deposits as invoices to track whether. The user interface does not represent most of these as invoices but rather 
expected payments. 
*/

CREATE TABLE sacco.sacco_invoices 
( 
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	invoice_id character varying(50) PRIMARY KEY,
    invoice_no character varying(50) NOT NULL,
    reference character varying(100), /* LINV00235161 */
	entity_id character varying(50) NOT NULL,
    invoice_date date DEFAULT CURRENT_DATE,
    due_date date DEFAULT (CURRENT_DATE + 30),     
    invoice_amount numeric NOT NULL check (invoice_amount > 0 ),
    voided character varying(10) DEFAULT 'F' check (voided in ('T','F')),
    voided_by character varying(100),
    voided_date date,
    voided_reason character varying(200),
    invoice_type character varying(100) check (invoice_type in ('virtual','actual')),
    invoice_category character varying(100) check (invoice_category in ('DEPOSIT','LOAN-REPAYMENT','SHARE-PURCHASE','MONTHLY-CHARGE','ENTRANCE-FEE','SURCHARGE','OTHER')),
    narration character varying(500), /* SURCHARGE FOR LOAN LINV00235161  */
    invoice_by character varying(100) ,
    invoice_comments text,
    status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_id,invoice_no)
);

CREATE INDEX invoice_ind1 ON sacco.sacco_invoices(sacco_id);

/*

invoice line items

*/
CREATE TABLE sacco.sacco_invoices_line_items 
(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	invoice_id character varying(50) NOT NULL REFERENCES sacco.sacco_invoices(invoice_id),
	item_id character varying(50) NOT NULL REFERENCES sacco.sacco_items(item_id),
	quantity numeric default 1 check (quantity > 0),
	unit_amount numeric check (unit_amount > 0),
	item_desc character varying(200),
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	PRIMARY KEY (sacco_id,invoice_id,item_id)
);
    
CREATE INDEX invoice_line_items_ind1 ON sacco.sacco_invoices_line_items(sacco_id);

/*

 If the sacco administration wishes to apply credit notes on a invoice.
 
*/
CREATE TABLE sacco.sacco_credit_notes 
(
   sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	invoice_id character varying(50) NOT NULL REFERENCES sacco.sacco_invoices(invoice_id),
	credit_note_id character varying(50) PRIMARY KEY,
    credit_note_no character varying(50) NOT NULL,
    reference character varying(100),
	applied_by character varying(50),
    approved character varying(10)  DEFAULT 'false'::character varying,
    approved_by character varying(50) ,
	approved_date date,
	approval_details jsonb default '{}'::jsonb,
	authorised_by character varying(50),
	authorised_date date,
	authorised_details jsonb default '{}'::jsonb,
    credit_comments text,
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	UNIQUE (sacco_id,credit_note_no)
);

CREATE INDEX credit_note_ind1 ON sacco.sacco_credit_notes(sacco_id);

/*
 credit is applied to specific items on an invoice to reduce its amount_due as will be visible in the views
*/ 

CREATE TABLE sacco.sacco_credit_notes_items 
(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	credit_note_id character varying(50) NOT NULL REFERENCES sacco.sacco_credit_notes(credit_note_id),
	invoice_id character varying(50) NOT NULL REFERENCES sacco.sacco_invoices(invoice_id),
	item_id character varying(50) NOT NULL REFERENCES sacco.sacco_items(item_id),
	credit_amount numeric,
	credit_comments text,
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone,
	PRIMARY KEY (sacco_id,credit_note_id,invoice_id,item_id)
);

CREATE INDEX credit_note_items_ind1 ON sacco.sacco_credit_notes_items(sacco_id);

CREATE TABLE sacco.sacco_invoices_payments 
(
   sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	sacco_id character varying(50) NOT NULL references sacco.sacco(sacco_id),
	invoice_id character varying(50) NOT NULL REFERENCES sacco.sacco_invoices(invoice_id),
	sacco_txnid character varying(100) NOT NULL REFERENCES sacco.sacco_savers_payments(sacco_txnid),
	allocation_id character varying(50) PRIMARY KEY,
	amount numeric NOT NULL check (amount > 0),
	allocated_by character varying(50),
	effective_allocation_date date,
	is_manual_allocation character varying(1) default 'F' check (is_manual_allocation in ('T','F')),
	approved character varying(10)  DEFAULT 'false'::character varying,
    approved_by character varying(50),
	approved_date date,
	approval_details jsonb default '{}'::jsonb,
	authorised_by character varying(50),
	authorised_date date,
	authorised_details jsonb default '{}'::jsonb,
	status character varying(50),
	status_details jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
	attachments jsonb default '[]'::jsonb,
	created_by character varying(100),
	last_updated_by character varying(100),
	last_updated_date timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),
	locked  character varying(1) DEFAULT 'F' check (locked in ('T','F')),
	locked_by character varying(100),
	locked_date timestamp with time zone,
	object_vsn numeric default 2.0,
	archived  character varying(1) DEFAULT 'F' check (archived in ('T','F')),
	archived_by character varying(100),
	archived_date timestamp with time zone,
	deleted  character varying(1) DEFAULT 'F' check (deleted in ('T','F')),
	deleted_by character varying(100),
	deleted_date timestamp with time zone
);

CREATE INDEX invoice_payments_ind1 ON sacco.sacco_invoices_payments(sacco_id);


	

