sqlplus system/oracle@docker << __end
create user affablebean identified by affablebean;
grant connect, resource to affablebean;
exit;
__end
