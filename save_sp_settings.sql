-- Get session ID
COLUMN session_id NEW_VALUE sid NOPRINT
SELECT SYS_CONTEXT('USERENV', 'SESSIONID') AS session_id FROM DUAL;
-- Store settings in a temporary file
STORE SET sqlplus_settings_&sid..sql REPLACE
