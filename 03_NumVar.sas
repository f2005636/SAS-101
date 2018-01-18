data rg.c3; set rg.c2; run;

%macro numvar(var,var_mod);
proc rank data=rg.c3 out=rg.c3 groups=7;
var &var;
ranks &var._bin;
run;

proc sql;
select &var._bin, avg(&var.) as x, avg(Rating) as y
from rg.c3
group by &var._bin;
quit;

proc glm data=rg.c3;
model Rating = &var_mod./ solution;
run;
quit;
%mend;

/*1 Calories*/
/*y = 129.73e-0.01x (R² = 0.7805)*/
/*y = -0.4832x + 96.071 (R² = 0.7744)*/
/*y = -53.57ln(x) + 293.62 (R² = 0.8475)*/
data rg.c3; 
set rg.c3;
Calories_trans = -53.57 * log(Calories) + 293.62;
run;
%numvar(Calories,Calories_trans);

/*2 Sodium*/
%numvar(Sodium,Sodium);

/*3 Fiber*/
%numvar(Fiber,Fiber);

/*4 Carbo*/
proc sql; 
select Carbo_bin, min(Carbo) as min_var, max(Carbo) as max_var, count(Carbo) as cnt_var, avg(Rating) as y
from rg.c3
group by Carbo_bin;
quit;
data rg.c3;
format Carbo_trans $10.;
set rg.c3;
if Carbo <= 10.5 then Carbo_trans = "c. High";
else if Carbo <= 12 then Carbo_trans = "a. Low";
else if Carbo <= 15 then Carbo_trans = "b. Mid";
else if Carbo <= 20 then Carbo_trans = "c. High";
else Carbo_trans = "b. Mid";
run; 
proc glm data=rg.c3;
class Carbo_trans;
model Rating = Carbo_trans/ solution;
run;

/*5 Sugars*/
/*y = 62.567e-0.057x (R² = 0.8749)*/
/*y = -2.4518x + 60.536 (R² = 0.8521)*/
/*y = -10.74ln(x) + 60.7 (R² = 0.8202)*/
data rg.c3; 
set rg.c3;
Sugars_trans = 62.567 * exp(-0.057 * Sugars);
run;
%numvar(Sugars,Sugars_trans);

/*6 Potass*/
/*y = 35.722e0.0017x (R² = 0.5039)*/
/*y = 0.0702x + 35.851 (R² = 0.5175)*/
/*y = 7.4185ln(x) + 10.411 (R² = 0.651)*/
data rg.c3; 
set rg.c3;
Potass_trans = 7.4185 * log(Potass) + 10.411;
run;
%numvar(Potass,Potass_trans);

/*7 Cups*/
proc sql; 
select Cups_bin, min(Cups) as min_var, max(Cups) as max_var, count(Cups) as cnt_var, avg(Rating) as y
from rg.c3
group by Cups_bin;
quit;
data rg.c3;
format Cups_trans $10.;
set rg.c3;
if Cups <= 0.67 then Cups_trans = "c. High";
else if Cups <= 0.75 then Cups_trans = "a. Low";
else if Cups <= 0.88 then Cups_trans = "c. High";
else Cups_trans = "b. Mid";
run; 
proc glm data=rg.c3;
class Cups_trans;
model Rating = Cups_trans/ solution;
run;

/*8 Correlation*/
proc corr data=rg.c3;
var Rating Calories_trans Sodium Fiber Sugars_trans Potass_trans;
run;

/*9 num model*/
proc glm data=rg.c3;
class Carbo_trans;
model Rating = Carbo_trans Calories_trans Sugars_trans Sodium Fiber/ solution;
run;

/*10 final data*/
data rg.c3;
set rg.c3 (keep=Rating
Manuf_bin Protein_bin Fat_bin Vitamins_bin Shelf_bin
Carbo_trans Calories_trans Sugars_trans Sodium Fiber);
run;
