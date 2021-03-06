SELECT 'Upgrading MetaStore schema from 2.1.1000 to 2.1.2000' AS ' ';

-- SOURCE 044-HIVE-16997.mysql.sql;
ALTER TABLE PART_COL_STATS ADD COLUMN BIT_VECTOR BLOB;
ALTER TABLE TAB_COL_STATS ADD COLUMN BIT_VECTOR BLOB;

-- SOURCE 045-HIVE-16886.mysql.sql;
INSERT INTO `NOTIFICATION_SEQUENCE` (`NNI_ID`, `NEXT_EVENT_ID`) SELECT * from (select 1 as `NNI_ID`, 1 as `NOTIFICATION_SEQUENCE`) a WHERE (SELECT COUNT(*) FROM `NOTIFICATION_SEQUENCE`) = 0;

UPDATE VERSION SET SCHEMA_VERSION='2.1.2000', VERSION_COMMENT='Hive release version 2.1.2000' where VER_ID=1;
SELECT 'Finished upgrading MetaStore schema from 2.1.1000 to 2.1.2000' AS ' ';

