@save_sp_settings.sql
SET SERVEROUTPUT ON
SET LONG 1000000
SET LINESIZE 227
SET FEEDBACK OFF
SET VERIFY OFF
SET TERMOUT ON

-- Prompt only if &1 was not provided
column 1 new_value target_user
select '' "1" from dual where rownum=0;
define target_user=&1

DECLARE
  ddl       CLOB;
  user_name VARCHAR2(30) := '&target_user';
  cnt       PLS_INTEGER;
BEGIN
  -- Check if user exists
  SELECT COUNT(*) INTO cnt FROM DBA_USERS WHERE USERNAME = user_name;
  IF cnt = 0 THEN
    DBMS_OUTPUT.PUT_LINE('User "' || user_name || '" does not exist.');
    RETURN;
  END IF;

  -- Enable semicolon terminator and pretty formatting
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', TRUE);
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'PRETTY', TRUE);

  -- USER DDL
  ddl := DBMS_METADATA.GET_DDL('USER', user_name);
  DBMS_OUTPUT.PUT_LINE(REGEXP_REPLACE(ddl, '^\s+', ''));

  -- TABLESPACE QUOTAS
  SELECT COUNT(*) INTO cnt FROM DBA_TS_QUOTAS WHERE USERNAME = user_name;
  IF cnt > 0 THEN
    ddl := DBMS_METADATA.GET_GRANTED_DDL('TABLESPACE_QUOTA', user_name);
    DBMS_OUTPUT.PUT_LINE(REGEXP_REPLACE(ddl, '^\s+', ''));
  END IF;

  -- SYSTEM GRANTS
  SELECT COUNT(*) INTO cnt FROM DBA_SYS_PRIVS WHERE GRANTEE = user_name;
  IF cnt > 0 THEN
    ddl := DBMS_METADATA.GET_GRANTED_DDL('SYSTEM_GRANT', user_name);
    DBMS_OUTPUT.PUT_LINE(REGEXP_REPLACE(ddl, '^\s+', ''));
  END IF;

  -- ROLE GRANTS
  SELECT COUNT(*) INTO cnt FROM DBA_ROLE_PRIVS WHERE GRANTEE = user_name;
  IF cnt > 0 THEN
    ddl := DBMS_METADATA.GET_GRANTED_DDL('ROLE_GRANT', user_name);
    DBMS_OUTPUT.PUT_LINE(REGEXP_REPLACE(ddl, '^\s+', ''));
  END IF;

  -- OBJECT GRANTS
  SELECT COUNT(*) INTO cnt FROM DBA_TAB_PRIVS WHERE GRANTEE = user_name;
  IF cnt > 0 THEN
    ddl := DBMS_METADATA.GET_GRANTED_DDL('OBJECT_GRANT', user_name);
    DBMS_OUTPUT.PUT_LINE(REGEXP_REPLACE(ddl, '^\s+', ''));
  END IF;
END;
/

--Clear variables for subsequent runs
undefine target_user
undefine 1

@restore_sp_settings.sql
