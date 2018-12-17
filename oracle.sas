/*
The libref MYDBLIB uses SAS/ACCESS Interface to Oracle to connect to an Oracle database. The SAS/ACCESS connection options are USER=, PASSWORD=, and PATH=. PATH= specifies an alias for the database specification, which SQL*Net requires. 
Updated from SASStudio
*/

libname mydblib oracle user=testuser password=testpass path=hrdept_002;
