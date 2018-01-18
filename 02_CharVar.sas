data rg.c2; set rg.c1; run;

%macro catvar(var);
proc sql;
select &var., count(Rating) as cnt, avg(Rating) as y
from rg.c2
group by &var.;
quit;

proc glm data=rg.c2;
class &var.;
model Rating = &var./ solution;
run;
quit;
%mend;

/*1 Manuf*/
data rg.c2 (drop=Manuf);
format Manuf_bin $10.;
set rg.c2;
if Manuf = 'G' then Manuf_bin = 'a. G';
else if Manuf = 'A' then Manuf_bin = 'c. A/N';
else if Manuf = 'N' then Manuf_bin = 'c. A/N';
else Manuf_bin = 'b. R/P/Q/K';
run;
%catvar(Manuf_bin);

/*2 Type*/
data rg.c2 (drop=Type);
format Type_bin $10.;
set rg.c2;
if Type = 'C' then Type_bin = 'a. C';
else Type_bin = 'b. H';
run;
%catvar(Type_bin);

/*3 Protein*/
data rg.c2 (drop=Protein);
format Protein_bin $10.;
set rg.c2;
if Protein = 1 then Protein_bin = 'a. 1';
else if Protein = 2 then Protein_bin = 'b. 2/3';
else if Protein = 3 then Protein_bin = 'b. 2/3';
else Protein_bin = 'c. 4/5/6';
run;
%catvar(Protein_bin);

/*4 Fat*/
data rg.c2 (drop=Fat);
format Fat_bin $10.;
set rg.c2;
if Fat = 0 then Fat_bin = 'a. NO';
else Fat_bin = 'b. YES';
run;
%catvar(Fat_bin);

/*5 Vitamins*/
data rg.c2 (drop=Vitamins);
format Vitamins_bin $10.;
set rg.c2;
if Vitamins = 0 then Vitamins_bin = 'a. NO';
else Vitamins_bin = 'b. YES';
run;
%catvar(Vitamins_bin);

/*6 Shelf*/
data rg.c2 (drop=Shelf);
format Shelf_bin $10.;
set rg.c2;
if Shelf = 2 then Shelf_bin = 'a. 2';
else Shelf_bin = 'b. 1/3';
run;
%catvar(Shelf_bin);

/*7 Weight*/
data rg.c2 (drop=Weight);
format Weight_bin $10.;
set rg.c2;
if Weight <= 0.83 then Weight_bin = 'c. Light';
else if Weight = 1 then Weight_bin = 'b. Mid';
else Weight_bin = 'a. Heavy';
run;
%catvar(Weight_bin);

/*8 interactions*/
proc glm data=rg.c2;
class Manuf_bin Type_bin;
model Rating = Manuf_bin * Type_bin/ solution;
run;

proc glm data=rg.c2;
class Protein_bin Fat_bin Vitamins_bin;
model Rating = Protein_bin * Fat_bin * Vitamins_bin/ solution;
run;

proc glm data=rg.c2;
class Shelf_bin Weight_bin;
model Rating = Shelf_bin * Weight_bin/ solution;
run;

/*9 cat model*/
proc glm data=rg.c2;
class Manuf_bin Protein_bin Fat_bin Vitamins_bin Shelf_bin;
model Rating = 
Manuf_bin
Protein_bin * Fat_bin * Vitamins_bin
Shelf_bin
/ solution;
run;

/*10 final data*/
data rg.c2;
set rg.c2 (drop=Type_bin Weight_bin);
run;
