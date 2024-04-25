----1 создали табличку

create table user_table (
user_id serial,
parent_id int,
first_name varchar,
last_name varchar,
age integer,
is_valid boolean,
primary key(user_id),
   CONSTRAINT fk_user_table
      FOREIGN KEY(parent_id)
        REFERENCES user_table(user_id));

------------- наполняем данными -------------------
insert into user_table(parent_id, first_name, last_name, age, is_valid)
select
	   case when generate_series % 10000 = 0 then generate_series
	   else null
	   end
     , md5(random()::text)
     , md5(random()::text)
     , floor(random() * 99)::int
     , case when generate_series % 21000 = 0 then true
	   		when generate_series % 29000 = 0 then false
	   else null
	   end
  from generate_series(1, 10000000);

------------- запросы  удаление ---------
 EXPLAIN ANALYZE delete from user_table where user_id = 100;

----------- добавляем индекс -------------
CREATE INDEX parent_id_idx ON user_table (parent_id);
EXPLAIN ANALYZE delete from user_table where user_id = 101;

-------------- смотрим статистику -----------------------

select * from pg_stats where tablename = 'user_table' and attname = 'parent_id'
--убераем null в индекск
CREATE INDEX parent_id_not_null ON user_table (parent_id)
	WHERE parent_id is not null;

EXPLAIN ANALYZE delete from user_table where user_id = 1003;

select * from user_table where user_id = 102;


------------------
SELECT * FROM information_schema.tables WHERE table_schema = 'public';
SELECT column_name, data_type, collation_name, is_nullable  FROM information_schema.columns WHERE table_name ='user_table';

-------------- посмотреть параметры таьлицы
SELECT
 --i.relname "Table Name",
 indexrelname "Index Name",
 --pg_size_pretty(pg_total_relation_size(relid)) As "Total Size",
 --pg_size_pretty(pg_indexes_size(relid)) as "TS of all Indexes",
 --pg_size_pretty(pg_relation_size(relid)) as "Table Size",
 pg_size_pretty(pg_relation_size(indexrelid)) "Index Size"
 --reltuples::bigint "table row count"
 FROM pg_stat_all_indexes i JOIN pg_class c ON i.relid=c.oid
 WHERE i.relname='user_table';
