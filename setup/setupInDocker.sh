sqlplus system/oracle@docker << __end
create user affablebean identified by affablebean;
grant connect, resource to affablebean;
__end
sqlplus affablebean/affablebean@docker << __end
@schemaCreation.sql
@sampleData.sql
select table_name from user_tables;
select * from category;
__end
