-- Upgrade MetaStore schema from 2.1.0 to 2.1.1000

-- RUN '038-HIVE-10562.derby.sql';
-- Step 1: Add the column for format
ALTER TABLE "APP"."NOTIFICATION_LOG" ADD "MESSAGE_FORMAT" varchar(16);

-- Step 2 : Change the type of the MESSAGE field from long varchar to clob
ALTER TABLE "APP"."NOTIFICATION_LOG" ADD COLUMN "MESSAGE_CLOB" CLOB;
UPDATE "APP"."NOTIFICATION_LOG" SET MESSAGE_CLOB=CAST(MESSAGE AS CLOB);
ALTER TABLE "APP"."NOTIFICATION_LOG" DROP COLUMN MESSAGE;
RENAME COLUMN "APP"."NOTIFICATION_LOG"."MESSAGE_CLOB" TO "MESSAGE";

-- ALTER TABLE "APP"."NOTIFICATION_LOG" ALTER COLUMN "MESSAGE" SET DATA TYPE CLOB;

UPDATE "APP".VERSION SET SCHEMA_VERSION='2.1.1000', VERSION_COMMENT='Hive release version 2.1.1000' where VER_ID=1;
