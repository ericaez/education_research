

/*

VARIABLE NAME DESCRIPTIONS:

TEST DATASET:
"schoolcode": School Identifier
"year": School Year
"charter": Indicator for whether given school is charter
"elapass": Ela Test Pass Rate
"mathpass": Math Test Pass Rate
"schoolmode": Share of "virtual learning" using V computation
"virtualper": Percentage of virtual learning for the year
"hybridper": Percentage of hybrid learing for the year
"totaltested": Total number of students tested
"lowincome": Proporortion of low income students for given school
"white": percentage of white students enrolled
"black": Percentage of black students enrolled
"hispanic": Percentage of hispanic students enrolled
"asian": Percentage of asian students enrolled

final_cols = [
'schoolcode',
 'year',
 'charter',
 'elapass'/'mathpass',
 'schoolmode',
 'virtualper',
 'hybridper',
 'totalenroll',
 'lowincome',
 'white',
 'black',
 'hispanic',
 'asian',
      ]

DROPOUT DATASET:
"schoolcode": School Identifier
"year": School Year
"charter": Indicator for whether given school is charter
"dropout": Dropout Rate
"schoolmode": Share of "virtual learning" using V computation
"virtualper": Percentage of virtual learning for the year
"hybridper": Percentage of hybrid learing for the year
"totalenroll": Total number of students enrolled
"lowincome": Proporortion of low income students for given school
"white": percentage of white students enrolled
"black": Percentage of black students enrolled
"hispanic": Percentage of hispanic students enrolled
"asian": Percentage of asian students enrolled

final_cols = [
'schoolcode',
 'year',
 'charter',
 'dropout',
 'schoolmode',
 'virtualper',
 'hybridper',
 'totalenroll',
 'lowincome',
 'white',
 'black',
 'hispanic',
 'asian',
      ]
*/

// ssc install reghdfe


// IMPORT MATH DATASET
insheet using "/Users/natan/Dev/education_research/final_data_all_state/final_data_all_state_mathpass.csv", clear

set emptycells drop 
drop if state == "nyc"

encode schoolcode, gen(schoolcodenum)
encode districtcode, gen(district)
encode countycode,gen(county)
encode state, gen(statecode)


/// SCHOOL FE, NO INTERACTION ///

reghdfe mathpass hybridper virtualper white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe mathpass schoolmode white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, RACE INTERACTION ///

g hispanic_virtual_int = hispanic * virtualper
g hispanic_hybrid_int = hispanic * hybridper
g black_virtual_int = black * virtualper
g black_hybrid_int = black * hybridper

g hispanic_int = hispanic * schoolmode
g black_int = black * schoolmode

reghdfe mathpass schoolmode hispanic_int black_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe mathpass virtualper hybridper hispanic_virtual_int /// 
hispanic_hybrid_int black_virtual_int black_hybrid_int ///
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, LOW INCOME INTERACTION ///

g lowincome_virtual_int = lowincome * virtualper
g lowincome_hybrid_int = lowincome * hybridper

g lowincome_int = lowincome * schoolmode

reghdfe mathpass schoolmode lowincome_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe mathpass virtualper hybridper lowincome_virtual_int /// 
lowincome_hybrid_int ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, CHARTER INTERACTION ///

g charter_virtual_int = charter * virtualper
g charter_hybrid_int = charter * hybridper

g charter_int = charter * schoolmode

reghdfe mathpass schoolmode charter_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe mathpass virtualper hybridper charter_virtual_int /// 
charter_hybrid_int ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, STATE-YEAR INTERACTION ///

reghdfe mathpass schoolmode charter_int /// 
white black hispanic charter lowincome ///
i.statecode##i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe mathpass virtualper hybridper charter_virtual_int /// 
charter_hybrid_int ///
charter i.statecode##i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)





// IMPORT ELA DATASET
insheet using "/Users/natan/Dev/education_research/final_data_all_state/final_data_all_state_elapass.csv", clear

set emptycells drop 
drop if state == "nyc"

encode schoolcode, gen(schoolcodenum)
encode districtcode, gen(district)
encode countycode,gen(county)
encode state, gen(statecode)


/// SCHOOL FE, NO INTERACTION ///

reghdfe elapass hybridper virtualper white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe elapass schoolmode white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, RACE INTERACTION ///

g hispanic_virtual_int = hispanic * virtualper
g hispanic_hybrid_int = hispanic * hybridper
g black_virtual_int = black * virtualper
g black_hybrid_int = black * hybridper

g hispanic_int = hispanic * schoolmode
g black_int = black * schoolmode

reghdfe elapass schoolmode hispanic_int black_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe elapass virtualper hybridper hispanic_virtual_int /// 
hispanic_hybrid_int black_virtual_int black_hybrid_int ///
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, LOW INCOME INTERACTION ///

g lowincome_virtual_int = lowincome * virtualper
g lowincome_hybrid_int = lowincome * hybridper

g lowincome_int = lowincome * schoolmode

reghdfe elapass schoolmode lowincome_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe elapass virtualper hybridper lowincome_virtual_int /// 
lowincome_hybrid_int ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, CHARTER INTERACTION ///

g charter_virtual_int = charter * virtualper
g charter_hybrid_int = charter * hybridper

g charter_int = charter * schoolmode

reghdfe elapass schoolmode charter_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe elapass virtualper hybridper charter_virtual_int /// 
charter_hybrid_int ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, STATE-YEAR INTERACTION ///

reghdfe elapass schoolmode charter_int /// 
white black hispanic charter lowincome ///
i.statecode##i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe elapass virtualper hybridper charter_virtual_int /// 
charter_hybrid_int ///
charter i.statecode##i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)





// IMPORT DROPOUT DATASET
insheet using "/Users/natan/Dev/education_research/final_data_all_state/final_data_all_state_dropout.csv", clear

set emptycells drop 
drop if state == "nyc"

encode schoolcode, gen(schoolcodenum)
encode districtcode, gen(district)
encode countycode,gen(county)
encode state, gen(statecode)


/// SCHOOL FE, NO INTERACTION ///

reghdfe dropout hybridper virtualper white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe dropout schoolmode white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, RACE INTERACTION ///

g hispanic_virtual_int = hispanic * virtualper
g hispanic_hybrid_int = hispanic * hybridper
g black_virtual_int = black * virtualper
g black_hybrid_int = black * hybridper

g hispanic_int = hispanic * schoolmode
g black_int = black * schoolmode

reghdfe dropout schoolmode hispanic_int black_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe dropout virtualper hybridper hispanic_virtual_int /// 
hispanic_hybrid_int black_virtual_int black_hybrid_int ///
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, LOW INCOME INTERACTION ///

g lowincome_virtual_int = lowincome * virtualper
g lowincome_hybrid_int = lowincome * hybridper

g lowincome_int = lowincome * schoolmode

reghdfe dropout schoolmode lowincome_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe dropout virtualper hybridper lowincome_virtual_int /// 
lowincome_hybrid_int ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, CHARTER INTERACTION ///

g charter_virtual_int = charter * virtualper
g charter_hybrid_int = charter * hybridper

g charter_int = charter * schoolmode

reghdfe dropout schoolmode charter_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe dropout virtualper hybridper charter_virtual_int /// 
charter_hybrid_int ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, STATE-YEAR INTERACTION ///

reghdfe dropout schoolmode charter_int /// 
white black hispanic charter lowincome ///
i.statecode##i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe dropout virtualper hybridper charter_virtual_int /// 
charter_hybrid_int ///
charter i.statecode##i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)





esttab DROP_NORMAL using "/Dev/virtual_mode_research/table12.tex", ///
drop(_cons white black hispanic t21) ///
coeflabels(virtualper "Virtual" hybridper "Hybrid" ///
lowincome "Low Income"  ///
) ///
refcat(lowincome "\textbf{\emph{Controls}}") ///
booktabs fragment label replace ///
nonotes mtitles("DROP" "DROP") nonumbers ///
stats(N, fmt(%18.0g) labels("\midrule Observations")) ///
mgroups("\textbf{\emph{Dependent Variables}}", pattern(1 0 0 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))

esttab A C E using "/Users/natan/Dev/econometrics_compeition/table1.tex", ///
drop(_cons white black asian hispanic disability t18 t19 attendance) ///
coeflabels(schoolmode "Learning Mode" H_int "Hispanic I" B_int "Black I" ///
lowincome "Low Income" female "Female" totaltested "Total Tested" ///
retention "Retention" classsize_int "Class Size I" ) ///
refcat(lowincome "\textbf{\emph{Controls}}") ///
booktabs fragment label replace ///
nonotes mtitles("ELA" "MATH" "DROP") nonumbers ///
stats(N, fmt(%18.0g) labels("\midrule Observations")) ///
mgroups("\textbf{\emph{Dependent Variables}}", pattern(1 0 0 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))

esttab AA BA DROP_NORMAL AL BL DROP_LOWINC using "/Users/natan/Dev/econometrics_compeition/table2.tex", ///
drop(_cons white black hispanic disability t18 t19 attendance) ///
coeflabels(schoolmode "Learning Mode" H_int "Hispanic I" B_int "Black I" ///
lowincome "Low Income" female "Female" totaltested "Total Tested" ///
retention "Retention" classize_int "Class Size I") ///
refcat(classize_int "\textbf{\emph{Interactions}}" lowincome "\textbf{\emph{Controls}}") ///
booktabs fragment label replace ///
nonotes mtitles("ELA" "MATH" "DROP") nonumbers ///
stats(N, fmt(%18.0g) labels("\midrule Observations")) ///
mgroups("\textbf{\emph{Dependent Variables}}" "\textbf{\emph{Dependent Variables W/ Low Income I}}", pattern(1 0 0 1) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))

esttab B D F using "/Users/natan/Dev/econometrics_compeition/table3.tex", ///
drop(_cons white black asian hispanic disability t18 t19 attendance) ///
coeflabels(schoolmode "Learning Mode" H_int "Hispanic I" B_int "Black I" ///
lowincome "Low Income" female "Female" totaltested "Total Tested" ///
retention "Retention") ///
refcat(H_int "\textbf{\emph{Interactions}}" lowincome "\textbf{\emph{Controls}}") ///
booktabs fragment label replace ///
nonotes mtitles("ELA" "MATH" "DROP") nonumbers ///
stats(N, fmt(%18.0g) labels("\midrule Observations")) ///
mgroups("\textbf{\emph{Dependent Variables}}", pattern(1 0 0 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))


