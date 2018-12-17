/************************DVT Test Library***************
 *         NAME: rsmimppd
 *      PURPOSE: RSM Database Transaction test - Import planograms
 *
 *   COMPONENTS: RSM.SERVER
 *      PRIMARY: RSM
 *    SECONDARY:
 *       GLOBAL:
 *      OPTIONS:
 *        TABLE: rsmdb00x
 *      DEFECTS:
 *      SUPPORT: shasmi
 *        NEEDS:
 *   OTHER: LOG: yes
 *          LST: yes
 *          DMS: no
 *          BDI: no
 *          BDO: no
 *          HTM: no
 *          GRF: no
 *          RTF: no
 *     COMMENTS:
 *      HISTORY: 11MAR2009 - sachit - Created
 ********************************************************/
	options nodate nostimer generic nonotes nocenter ls=max ps=max
        nomprint nonotes generic;

	/* Get a connection to the server. */
 
	 %filenm(testcase,filepath=STD:rsm:testsrc:rsmdb01i.sas);
	   %include testcase;

	dm 'log;clear;output;clear;';
	libname dbldata clear;
	libname CDBLOAD clear;
	libname dbldata '\\sashq\root\dept\dvt\RSM\DB_LOC_DATA\id';
	libname CDBLOAD odbc user=maxdata password=madmary datasrc=CDBLOAD;
	*Filters out the planograms whose diplay type name is 'Planogram';
	data work.pogs;
		set dbldata.pogs;
		if display_type_name='Planogram';
	run;
	*Assigns the moniker and absolute file path to the macro variables;
	Data _null_;
	Set work.pogs end=eof;
	Call symput ('moniker'||strip(put(_n_,4.)), moniker);
	Call symput ('file_in'|| strip(put(_n_,4.)),strip('\\sashq\root\dept\dvt\RSM\DB_LOC_DATA\POGS\'||strip(moniker)||'_'|| strip(put(id,4.)))||'.xml');
	if eof then call symput('tot',trim(left(_n_)));
	Run;
	*imports the planograms;
	%macro run_rsm_import_pog (total);
	%do I = 1 %to &total;
	Filename fname&I "&&file_in&I";
	%rsm_import_pog(fname&i);
	%put "import time is = "  &rsm_import_time;
	%end;
	%mend run_rsm_import_pog;
	%run_rsm_import_pog(&tot);
	*gets the lv7loc table records into work.lv7loc dataset ;
	proc sql;
	create table work.lv7loc as
	select * from CDBLOAD.lv7loc;
	quit;
	*sorts the work.lv7loc dataset by desending order on lv7loc_id;
	proc sort in=work.lv7loc
			  out=work.lv7loc;
			  by descending lv7loc_id ;
	run;
	*Proc prints the first 12 observations;
	Proc print data=work.lv7loc(obs=12 drop=lv7loc_id);
	run;

