set termout off

-- Get session ID
COLUMN session_id NEW_VALUE sid NOPRINT
SELECT SYS_CONTEXT('USERENV', 'SESSIONID') AS session_id FROM DUAL;

-- Restore settings
@sqlplus_settings_&sid..sql

-- Delete the settings file
HOST perl -e "unlink 'sqlplus_settings_&sid..sql' if -e 'sqlplus_settings_&sid..sql';"
