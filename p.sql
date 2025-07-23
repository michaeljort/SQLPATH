/*******************************************************************************
--  Script Name   : p.sql
--  Description   : Displays a menu of available pdbs and performs an
--                  ALTER SESSION SET CONTAINER={pdbname}
--                  based on the con_id selected
--  Author        : Michael Ort
--  Created Date  : 2025-07-23
--  Last Modified : 2025-07-23 by Michael Ort
--  Usage         : Run in SQL*Plus using the command: @p
--  Requirements  : Oracle Container Database
--  Notes         : 
*******************************************************************************/
SET verify   OFF
SET feedback OFF

-- Get the current con_id
COL CurrentConID NEW_VALUE CurrentConID
SET termout OFF
select SYS_CONTEXT('userenv','con_id') CurrentConID from dual;
SET termout ON

-- Set container to cdb$root, to show ALL PDBs
ALTER SESSION SET CONTAINER=CDB$ROOT;

-- Display list of PDBs, like "show pdbs" but with CDB$ROOT added to the list
COL CON_ID FORMAT 999999999
COL CON_NAME FORMAT A30
COL RESTRICTED FORMAT A10
select
  CON_ID
, NAME as CON_NAME
, OPEN_MODE as "OPEN MODE"
, RESTRICTED
from v$containers
order by con_id;
-- Prompt for CON_ID
ACCEPT NewConID CHAR PROMPT 'Enter CON_ID[&&CurrentConID]: ' DEFAULT &CurrentConID
COL NewConName NEW_VALUE NewConName
SET termout OFF
SELECT NAME NewConName
FROM V$CONTAINERS
WHERE CON_ID=&NewConID;
SET termout ON

-- Set new container & update the prompt
PROMPT
PROMPT ALTER SESSION SET container=&NewConName;;
SET feedback 6
ALTER SESSION SET container=&NewConName;
SET sqlprompt "&_user:&_connect_identifier:&NewConName> "

SET verify   ON
