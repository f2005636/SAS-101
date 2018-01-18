proc contents data=rg.cereals; run;
 
/*1 missing value imputation*/

/*Potass = 9.60509 + Rating * 2.09633*/
proc reg data=rg.cereals; model Potass = Rating; run;

/*Sugars = 17.11591 + Rating * -0.23708*/
proc reg data=rg.cereals; model Sugars = Rating; run;

/*Carbo = 13.75705 + Rating * 0.02457;*/
proc reg data=rg.cereals; model Carbo = Rating; run;

data rg.c1; 
set rg.cereals; 
if Potass = . then Potass = 9.60509 + Rating * 2.09633;
if Sugars = . then Sugars = 17.11591 + Rating * -0.23708;
if Carbo = . then Carbo = 13.75705 + Rating * 0.02457;
run;

/*2 drop variables*/

/*Manuf same as Nabisco, Quaker, Kelloggs, GeneralMills, Ralston, AHFP */
data rg.c1; set rg.c1 (drop=Nabisco Quaker Kelloggs GeneralMills Ralston AHFP); run;

/*Type same as Cold*/
data rg.c1; set rg.c1 (drop=Cold); run;

/*3 final dataset*/
proc contents data=rg.c1; run;
