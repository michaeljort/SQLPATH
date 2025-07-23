# SQLPATH 🎯
Commonly used Oracle scripts for quick access in SQL*Plus or SQLcl when the SQLPATH environment variable or registry key includes the local clone location

## 📘 What is SQLPATH?

SQLPATH is an Oracle environment variable that defines one or more directories that SQL*Plus searches for scripts. It simplifies execution by removing the need to path to each .sql file manually.  
📖 Learn more in Oracle’s official documentation 👉 [Oracle SQLPATH documentation (23c)](https://docs.oracle.com/en/database/oracle/oracle-database/23/sqpug/configuring-SQL-Plus.html#GUID-5A2953BF-9E2F-450B-AFBA-EE2846C59B5E)

## 🚀 Getting Started

1. Clone the repository  
```git clone https://github.com/michaeljort/SQLPATH.git ```

2. Set your SQLPATH environment variable to include this directory alongside any existing paths:  

For **Linux/macOS**, append to the current SQLPATH value like so:  
```export SQLPATH=$SQLPATH:/path/to/SQLPATH```

For **Windows**, append ```;C:\path\to\SQLPATH``` to the existing SQLPATH value located in the registry at:  
```HKEY_LOCAL_MACHINE\SOFTWARE\ORACLE\HOMEn```  
(Replace `n` with your Oracle home ID. You may need admin rights to edit the registry.)

3. Use in SQL*Plus  
@script_name.sql  
