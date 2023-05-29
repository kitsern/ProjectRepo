create table evoting.users(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	user_id character varying(50) DEFAULT gen_random_uuid () PRIMARY KEY, /*  uuid system own generated */ 
	username character varying(4000) UNIQUE NOT NULL,	
    first_name character varying(4000) NOT NULL,
    other_names character varying(4000) NOT NULL,	
	gender  character varying(1) check (gender in ('F','M')),
	sms_telno character varying(15) CHECK (sms_telno ~* '^\+[1-9]\d{1,14}$'),
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
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

create table evoting.admin_users(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	user_id character varying(50) DEFAULT gen_random_uuid () PRIMARY KEY, /*  uuid system own generated */ 
	username character varying(4000) UNIQUE NOT NULL,	
	external_id character varying(4000) UNIQUE,	
    first_name character varying(4000) NOT NULL,
    other_names character varying(4000) NOT NULL,	
	gender  character varying(1) check (gender in ('F','M')),
	sms_telno character varying(15) CHECK (sms_telno ~* '^\+[1-9]\d{1,14}$'),
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
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

create table evoting.user_credentials(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	pwd_id character varying(50) DEFAULT gen_random_uuid () PRIMARY KEY, /*  uuid system own generated */ 
    user_id character varying(100) references evoting.users(user_id),
    pwd_hash character varying(100),
    UNIQUE (user_id,pwd_hash)
);
create table evoting.election_instances(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	election_id character varying(50) DEFAULT gen_random_uuid () PRIMARY KEY, /*  uuid system own generated */ 
	election_name character varying(4000) UNIQUE NOT NULL,	
    election_description character varying(4000) NOT NULL,
    election_start_date timestamp with time zone,
    election_end_date timestamp with time zone,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
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

create table evoting.election_positions(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	position_id character varying(50) DEFAULT gen_random_uuid () PRIMARY KEY, /*  uuid system own generated */ 
    position_name character varying(4000) UNIQUE NOT NULL,	
    position_description character varying(4000) NOT NULL,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
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
    election_id character varying(100) references evoting.election_instances(election_id)
);

create table evoting.voter_registers(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	register_id character varying(50) DEFAULT gen_random_uuid () PRIMARY KEY, /*  uuid system own generated */ 
    register_name character varying(4000) UNIQUE NOT NULL,	
    register_description character varying(4000) NOT NULL,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
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
create table evoting.voter_register_users(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	voter_user_id character varying(50) DEFAULT gen_random_uuid () PRIMARY KEY, /*  uuid system own generated */ 
    user_id character varying(100) references evoting.users(user_id),
    register_id character varying(100) references evoting.voter_registers(register_id),
    UNIQUE (user_id,register_id)
);
create table evoting.polling_stations(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	station_id character varying(50) DEFAULT gen_random_uuid () PRIMARY KEY, /*  uuid system own generated */ 
    station_name character varying(4000) UNIQUE NOT NULL,	
    station_description character varying(4000) NOT NULL,
    station_cordinates jsonb default '{}'::jsonb,
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
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

create table evoting.position_registers(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	position_register_id character varying(50) DEFAULT gen_random_uuid () PRIMARY KEY, /*  uuid system own generated */ 
    position_id character varying(100) references evoting.election_positions(position_id),
    register_id character varying(100) references evoting.voter_registers(register_id),
    UNIQUE (position_id,register_id)
);
create table evoting.polling_s_returning_o(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	returning_officer_id character varying(50) DEFAULT gen_random_uuid () PRIMARY KEY, /*  uuid system own generated */ 
    station_id  character varying(100) references evoting.polling_stations(station_id),
	user_id character varying(100) references evoting.users(user_id),
    election_id character varying(100) references evoting.election_instances(election_id),
    UNIQUE (station_id,election_id,user_id)
);
create table evoting.candidates(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	candidate_id character varying(50) DEFAULT gen_random_uuid () PRIMARY KEY, /*  uuid system own generated */ 
  	user_id character varying(100) references evoting.users(user_id),
    position_id character varying(100) references evoting.election_positions(position_id),
    candidate_slogan character varying(100),
    candidate_symbol character varying(100),
    candidate_color character varying(100),
	other_info jsonb default '{}'::jsonb,
    tags jsonb default '[]'::jsonb,
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
    UNIQUE (user_id,position_id)
);

create table evoting.vins(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	vin_id character varying(50) DEFAULT gen_random_uuid () PRIMARY KEY, /*  uuid system own generated */ 
    vin_no  character varying(8) NOT NULL,
  	user_id character varying(100) references evoting.users(user_id),
    election_id character varying(100) references evoting.election_instances(election_id),
    voted character varying(1) DEFAULT 'F' check (voted in ('T','F')),
    tags jsonb default '[]'::jsonb,
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

create table evoting.votes(
	sdate timestamp with time zone default (current_timestamp at TIME ZONE 'Africa/Kampala'),	
	vote_id character varying(50) DEFAULT gen_random_uuid () PRIMARY KEY, /*  uuid system own generated */ 
  	vin_id character varying(100) references evoting.users(user_id),
    election_id character varying(100) references evoting.election_instances(election_id),
    position_id character varying(100) references evoting.election_positions(position_id),
    candidate_id character varying(100) references evoting.candidates(candidate_id),
    tags jsonb default '[]'::jsonb,
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
    UNIQUE (vin_id,position_id,election_id,candidate_id)

);