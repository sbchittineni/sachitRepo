Proc cimport lib=work file="\\spaceopt\public\optimizer_logs\ORSM62X\s4u8.6_rsmopt.cpo";run;

proc sql;
	select sum(rec_facings*width)
	from opt_pddata
	where gl_2=1 and auto_attach_type ne 3;
quit;
proc sql;
	select sum(rec_facings*width)
	from opt_pddata
	where gl_2=2 and auto_attach_type ne 3;
quit;

proc sql;
	select sum(rec_facings*width)
	from opt_pddata
	where gl_2=3 and auto_attach_type ne 3;
quit;
