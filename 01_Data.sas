%macro markov_chain(cnt);
%let clean = 25250;
%let dpd30 = 575;
%let dpd60 = 220;
%let dpd90 = 0;

data fin_pop; 
iteration = 0;
clean = &clean.;
dpd30 = &dpd30.;
dpd60 = &dpd60.;
dpd90 = &dpd90.;
run;

%do i=1 %to &cnt.;
	data calc_mat;	
	clean_to_clean = 0.9901 * &clean.;
	clean_to_dpd30 = 0.0099 * &clean.;
	dpd30_to_clean = 0.3478 * &dpd30.;
	dpd30_to_dpd30 = 0.4348 * &dpd30.;
	dpd30_to_dpd60 = 0.2174 * &dpd30.;
	dpd60_to_clean = 0.0909 * &dpd60.;
	dpd60_to_dpd30 = 0.1136 * &dpd60.;
	dpd60_to_dpd60 = 0.3409 * &dpd60.;
	dpd60_to_dpd90 = 0.4545 * &dpd60.;
	
	call symput('clean',sum(clean_to_clean,dpd30_to_clean,dpd60_to_clean));
	call symput('dpd30',sum(clean_to_dpd30,dpd30_to_dpd30,dpd60_to_dpd30));
	call symput('dpd60',sum(dpd30_to_dpd60,dpd60_to_dpd60));
	call symput('dpd90',sum(&dpd90.,dpd60_to_dpd90));	
	run;
	
	data temp;
	iteration = &i.;
	clean = &clean.;
	dpd30 = &dpd30.;
	dpd60 = &dpd60.;
	dpd90 = &dpd90.;
	run;
	
	data fin_pop;
	set fin_pop temp;
	run;	
%end;
%mend;

%markov_chain(12)