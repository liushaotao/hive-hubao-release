set hive.input.format = org.apache.hadoop.hive.ql.io.CombineHiveInputFormat;

-- This tests that a query can span multiple partitions which can not only have different file formats, but
-- also different serdes
create table partition_test_partitioned_n7(key string, value string) partitioned by (dt string) stored as rcfile;
insert overwrite table partition_test_partitioned_n7 partition(dt='1') select * from src;
alter table partition_test_partitioned_n7 set serde 'org.apache.hadoop.hive.serde2.columnar.LazyBinaryColumnarSerDe';
insert overwrite table partition_test_partitioned_n7 partition(dt='2') select * from src;

select * from partition_test_partitioned_n7 where dt is not null order by key, value, dt limit 20;
select key+key as key, value, dt from partition_test_partitioned_n7 where dt is not null order by key, value, dt limit 20;

