proc sort data=rg.c3 out=rg.c4; by Rating; run;

%macro foldvar(var);
data rg.c4; set rg.c4; row_num = _n_ + &var.; run;

data train;
set rg.c4;
if mod(row_num,7) ^= 0;
run;

data test;
set rg.c4;
if mod(row_num,7) = 0;
run;

proc glmselect data=train testdata=test;
class Manuf_bin Protein_bin Fat_bin Vitamins_bin Shelf_bin Carbo_trans;
model Rating = 
Manuf_bin
Protein_bin * Fat_bin * Vitamins_bin
Shelf_bin
Carbo_trans
Calories_trans Sugars_trans Sodium Fiber;
run;
%mend;

/*1 Fold 1*/
%foldvar(1);

/*2 Fold 2*/
%foldvar(2);

/*3 Fold 3*/
%foldvar(3);

/*4 Fold 4*/
%foldvar(4);

/*5 Fold 5*/
%foldvar(5);

/*6 Fold 6*/
%foldvar(6);

/*7 Fold 7*/
%foldvar(7);

/*8 final model*/
proc glm data=rg.c4;
class /*Manuf_bin*/ Protein_bin Fat_bin Vitamins_bin /*Shelf_bin*/ /*Carbo_trans*/;
model Rating = 
/*Manuf_bin*/
Protein_bin * Fat_bin * Vitamins_bin
/*Shelf_bin*/
/*Carbo_trans*/
Calories_trans Sugars_trans Sodium Fiber/ solution;
output out=temp1 p=Rating_hat r=Rating_resid;
run;

/*9 actual vs predicted*/
data temp2 (rename=(
Rating = actual 
Rating_hat = predicted
)); 
set temp1 (keep=Rating Rating_hat); 
run;
proc sgplot data = temp2;
scatter x = actual y = predicted;
run;

/*10 error*/
data temp3;
set temp2;
diff = actual - predicted;
Error_rate	= diff / actual;
abs_error = ABS(Error_rate);
run;
proc sql;
select avg(abs_error) as MAPE, avg(Error_rate) as bias
from temp3;
quit;
