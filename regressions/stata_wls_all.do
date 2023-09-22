

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

eststo MATH_NOINT_PER: reghdfe mathpass hybridper virtualper white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

eststo MATH_NOINT_NOPER: reghdfe mathpass schoolmode white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, RACE INTERACTION ///

g hispanic_virtual_int = hispanic * virtualper
g hispanic_hybrid_int = hispanic * hybridper
g black_virtual_int = black * virtualper
g black_hybrid_int = black * hybridper

g hispanic_int = hispanic * schoolmode
g black_int = black * schoolmode

eststo MATH_RACE_NOPER: reghdfe mathpass schoolmode hispanic_int black_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

eststo MATH_RACE_PER: reghdfe mathpass virtualper hybridper hispanic_virtual_int /// 
hispanic_hybrid_int black_virtual_int black_hybrid_int ///
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, LOW INCOME INTERACTION ///

g lowincome_virtual_int = lowincome * virtualper
g lowincome_hybrid_int = lowincome * hybridper

g lowincome_int = lowincome * schoolmode

eststo MATH_LOWINC_NOPER: reghdfe mathpass schoolmode lowincome_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

eststo MATH_LOWINC_PER:reghdfe mathpass virtualper hybridper lowincome_virtual_int /// 
lowincome_hybrid_int ///
white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, CHARTER INTERACTION ///

g charter_virtual_int = charter * virtualper
g charter_hybrid_int = charter * hybridper

g charter_int = charter * schoolmode

eststo MATH_CHAR_NOPER: reghdfe mathpass schoolmode charter_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

eststo MATH_CHAR_PER: reghdfe mathpass virtualper hybridper charter_virtual_int /// 
charter_hybrid_int ///
white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, STATE-YEAR INTERACTION ///

eststo MATH_STATEYEAR_NOPER: reghdfe mathpass schoolmode /// 
white black hispanic charter lowincome ///
i.statecode##i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

eststo MATH_STATEYEAR_PER:reghdfe mathpass virtualper hybridper  /// 
white black hispanic charter lowincome ///
i.statecode##i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, STATE-YEAR, RACE INTERACTION ///

eststo MATH_STATEYEARRACE_NOPER: reghdfe mathpass schoolmode /// 
hispanic_int black_int /// 
white black hispanic charter lowincome ///
i.statecode##i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe mathpass virtualper hybridper /// 
hispanic_hybrid_int hispanic_virtual_int black_hybrid_int black_virtual_int ///
white black hispanic charter lowincome ///
i.statecode##i.year [aweight=totaltested], ///
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

eststo ELA_NOINT_PER: reghdfe elapass hybridper virtualper white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

eststo ELA_NOINT_NOPER:reghdfe elapass schoolmode white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, RACE INTERACTION ///

g hispanic_virtual_int = hispanic * virtualper
g hispanic_hybrid_int = hispanic * hybridper
g black_virtual_int = black * virtualper
g black_hybrid_int = black * hybridper

g hispanic_int = hispanic * schoolmode
g black_int = black * schoolmode

eststo ELA_RACE_NOPER: reghdfe elapass schoolmode hispanic_int black_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

eststo ELA_RACE_PER: reghdfe elapass virtualper hybridper hispanic_virtual_int /// 
hispanic_hybrid_int black_virtual_int black_hybrid_int ///
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, LOW INCOME INTERACTION ///

g lowincome_virtual_int = lowincome * virtualper
g lowincome_hybrid_int = lowincome * hybridper

g lowincome_int = lowincome * schoolmode

eststo ELA_LOWINC_NOPER: reghdfe elapass schoolmode lowincome_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

eststo ELA_LOWINC_PER: reghdfe elapass virtualper hybridper lowincome_virtual_int /// 
lowincome_hybrid_int ///
white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, CHARTER INTERACTION ///

g charter_virtual_int = charter * virtualper
g charter_hybrid_int = charter * hybridper

g charter_int = charter * schoolmode

eststo ELA_CHAR_NOPER: reghdfe elapass schoolmode charter_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

eststo ELA_CHAR_PER: reghdfe elapass virtualper hybridper charter_virtual_int /// 
charter_hybrid_int ///
white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, STATE-YEAR INTERACTION ///

eststo ELA_STATEYEAR_NOPER:  reghdfe elapass schoolmode /// 
white black hispanic charter lowincome ///
i.statecode##i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

eststo ELA_STATEYEAR_PER:  reghdfe elapass virtualper hybridper /// 
white black hispanic charter lowincome ///
i.statecode##i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, STATE-YEAR, RACE INTERACTION ///

eststo ELA_STATEYEARRACE_NOPER: reghdfe elapass schoolmode /// 
black_int hispanic_int ///
white black hispanic charter lowincome ///
i.statecode##i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

eststo ELA_STATEYEARRACE_PER: reghdfe elapass virtualper hybridper /// 
hispanic_hybrid_int hispanic_virtual_int black_hybrid_int black_virtual_int ///
white black hispanic charter lowincome ///
i.statecode##i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)




// IMPORT DROPOUT DATASET
insheet using "/Users/natan/Dev/education_research/final_data_all_state/final_data_all_state_dropout.csv", clear

set emptycells drop 

encode schoolcode, gen(schoolcodenum)
encode districtcode, gen(district)
encode countycode,gen(county)
encode state, gen(statecode)
g totaltested = totalenroll


/// SCHOOL FE, NO INTERACTION ///

eststo DROP_NOINT_PER: reghdfe dropout hybridper virtualper white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

eststo DROP_NOINT_NOPER: reghdfe dropout schoolmode white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, RACE INTERACTION ///

g hispanic_virtual_int = hispanic * virtualper
g hispanic_hybrid_int = hispanic * hybridper
g black_virtual_int = black * virtualper
g black_hybrid_int = black * hybridper

g hispanic_int = hispanic * schoolmode
g black_int = black * schoolmode

eststo DROP_RACE_NOPER: reghdfe dropout schoolmode hispanic_int black_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

eststo DROP_RACE_PER: reghdfe dropout virtualper hybridper hispanic_virtual_int /// 
hispanic_hybrid_int black_virtual_int black_hybrid_int ///
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, LOW INCOME INTERACTION ///

g lowincome_virtual_int = lowincome * virtualper
g lowincome_hybrid_int = lowincome * hybridper

g lowincome_int = lowincome * schoolmode

eststo DROP_LOWINC_NOPER: reghdfe dropout schoolmode lowincome_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

eststo DROP_LOWINC_PER: reghdfe dropout virtualper hybridper lowincome_virtual_int /// 
lowincome_hybrid_int ///
white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, CHARTER INTERACTION ///

g charter_virtual_int = charter * virtualper
g charter_hybrid_int = charter * hybridper

g charter_int = charter * schoolmode

eststo DROP_CHAR_NOPER: reghdfe dropout schoolmode charter_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

eststo DROP_CHAR_PER: reghdfe dropout virtualper hybridper charter_virtual_int /// 
charter_hybrid_int ///
white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, STATE-YEAR INTERACTION ///

eststo DROP_STATEYEAR_NOPER: reghdfe dropout schoolmode /// 
white black hispanic lowincome ///
i.statecode#i.year i.year charter [aweight=totaltested], ///
absorb(schoolcode) 

eststo DROP_STATEYEAR_PER: reghdfe dropout virtualper hybridper ///
white black hispanic charter lowincome ///
i.statecode##i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)


/// SCHOOL FE, STATE-YEAR, RACE INTERACTION ///

eststo DROP_STATEYEARRACE_NOPER: reghdfe dropout schoolmode black_int hispanic_int /// 
white black hispanic charter lowincome ///
i.statecode##i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

eststo DROP_STATEYEARRACE_PER: reghdfe dropout virtualper hybridper ///
hispanic_hybrid_int hispanic_virtual_int black_hybrid_int black_virtual_int ///
white black hispanic charter lowincome ///
i.statecode##i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)



// esttab DROP_NORMAL using "/Users/natan/Dev/education_research/table/table1", ///
// keep(_cons white black hispanic) ///
// coeflabels(virtualper "Virtual" hybridper "Hybrid" ///
// lowincome "Low Income"  ///
// ) ///
// refcat(lowincome "\textbf{\emph{Controls}}") ///
// booktabs fragment label replace ///
// nonotes mtitles("DROP" "DROP") nonumbers ///
// stats(N, fmt(%18.0g) labels("\midrule Observations")) ///
// mgroups("\textbf{\emph{Dependent Variables}}", pattern(1 0 0 0) ///
// prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))

esttab ELA_NOINT_NOPER MATH_NOINT_NOPER DROP_NOINT_NOPER /// 
ELA_NOINT_PER MATH_NOINT_PER DROP_NOINT_PER /// 
using "/Users/natan/Dev/education_research/tables/table_noint.tex", ///
keep(charter schoolmode virtualper hybridper lowincome black hispanic)  ///
order( ///
schoolmode virtualper hybridper ///
black_int black_virtual_int black_hybrid_int ///
hispanic_int hispanic_virtual_int hispanic_hybrid_int ///
lowincome_int lowincome_virtual_int lowincome_hybrid_int ///
lowincome black hispanic white charter ///
) ///
coeflabels( ///
schoolmode "Learning Mode" hispanic_int "Hispanic I" black_int "Black I" ///
virtualper "Virtual \%" hybridper "Hybrid \%" charter "Charter" ///
hispanic_virtual_int "Hispanic Virtual I" hispanic_hybrid_int "Hispanic Hybrid I" ///
black_virtual_int "Black Virtual I" black_hybrid_int "Black Hybrid I" ///
lowincome "Low Income" female "Female" totaltested "Total Tested" ///
white "White" black "Black" hispanic "Hispanic"  ///
retention "Retention" classize_int "Class Size I" ///
) ///
refcat(lowincome "\textbf{\emph{Controls}}") ///
booktabs fragment label replace ///
nonotes mtitles("ELA" "MATH" "DROP" "ELA" "MATH" "DROP") nonumbers ///
stats(N, fmt(%18.0g) labels("\midrule Observations")) ///
mgroups("\textbf{\substack{\text{Dependent Variables} \\ \text{w/ Schoolmode}} }" /// 
"\textbf{\substack{\text{Dependent Variables} \\ \text{w/o Schoolmode}} }", pattern(1 0 0 1) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))



esttab ELA_RACE_NOPER MATH_RACE_NOPER DROP_RACE_NOPER ///
ELA_RACE_PER MATH_RACE_PER DROP_RACE_PER ///
using "/Users/natan/Dev/education_research/tables/table_race.tex", ///
keep(charter schoolmode lowincome black hispanic  ///
virtualper hybridper black_int hispanic_int ///
black_virtual_int black_hybrid_int hispanic_virtual_int hispanic_hybrid_int) ///
order( ///
schoolmode virtualper hybridper ///
black_int hispanic_int black_virtual_int black_hybrid_int ///
 hispanic_virtual_int hispanic_hybrid_int ///
lowincome_int lowincome_virtual_int lowincome_hybrid_int ///
lowincome black hispanic white charter ///
) ///
coeflabels( ///
schoolmode "Learning Mode" hispanic_int "Hispanic I" black_int "Black I" ///
virtualper "Virtual \%" hybridper "Hybrid \%" charter "Charter" ///
hispanic_virtual_int "Hispanic Virtual I" hispanic_hybrid_int "Hispanic Hybrid I" ///
black_virtual_int "Black Virtual I" black_hybrid_int "Black Hybrid I" ///
lowincome "Low Income" female "Female" totaltested "Total Tested" ///
white "White" black "Black" hispanic "Hispanic"  ///
retention "Retention" classize_int "Class Size I" ///
) ///
refcat(black_int "\textbf{\emph{Interactions}}" lowincome "\textbf{\emph{Controls}}") ///
booktabs fragment label replace ///
nonotes mtitles("ELA" "MATH" "DROP" "ELA" "MATH" "DROP") nonumbers ///
stats(N, fmt(%18.0g) labels("\midrule Observations")) ///
mgroups("\textbf{\substack{\text{Dependent Variables} \\ \text{w/ Schoolmode}} }" /// 
"\textbf{\substack{\text{Dependent Variables} \\ \text{w/o Schoolmode}} }", pattern(1 0 0 1) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))



esttab ELA_LOWINC_NOPER MATH_LOWINC_NOPER DROP_LOWINC_NOPER ///
ELA_LOWINC_PER MATH_LOWINC_PER DROP_LOWINC_PER ///
using "/Users/natan/Dev/education_research/tables/table_lowinc.tex", ///
keep(charter schoolmode lowincome black hispanic  ///
virtualper hybridper lowincome_int lowincome_virtual_int lowincome_hybrid_int) ///
order( ///
schoolmode virtualper hybridper ///
black_int black_virtual_int black_hybrid_int ///
hispanic_int hispanic_virtual_int hispanic_hybrid_int ///
lowincome_int lowincome_virtual_int lowincome_hybrid_int ///
lowincome black hispanic white charter ///
) ///
coeflabels( ///
schoolmode "Learning Mode" hispanic_int "Hispanic I" black_int "Black I" ///
virtualper "Virtual \%" hybridper "Hybrid \%" charter "Charter" ///
hispanic_virtual_int "Hispanic Virtual I" hispanic_hybrid_int "Hispanic Hybrid I" ///
black_virtual_int "Black Virtual I" black_hybrid_int "Black Hybrid I" ///
lowincome "Low Income" female "Female" totaltested "Total Tested" ///
white "White" black "Black" hispanic "Hispanic"  ///
retention "Retention" classize_int "Class Size I" lowincome_int "Low Income I" ///
lowincome_virtual_int "Low Income Virtual I" lowincome_hybrid_int "Low Income Hybrid I" ///
) ///
refcat(lowincome_int "\textbf{\emph{Interactions}}" lowincome "\textbf{\emph{Controls}}") ///
booktabs fragment label replace ///
nonotes mtitles("ELA" "MATH" "DROP" "ELA" "MATH" "DROP") nonumbers ///
stats(N, fmt(%18.0g) labels("\midrule Observations")) ///
mgroups("\textbf{\substack{\text{Dependent Variables} \\ \text{w/ Schoolmode}} }" /// 
"\textbf{\substack{\text{Dependent Variables} \\ \text{w/o Schoolmode}} }", pattern(1 0 0 1) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))



esttab ELA_CHAR_NOPER MATH_CHAR_NOPER DROP_CHAR_NOPER ///
ELA_CHAR_PER MATH_CHAR_PER DROP_CHAR_PER ///
using "/Users/natan/Dev/education_research/tables/table_char.tex", ///
keep(charter schoolmode lowincome black hispanic  ///
virtualper hybridper charter_int charter_virtual_int charter_hybrid_int) ///
order( ///
schoolmode virtualper hybridper ///
black_int black_virtual_int black_hybrid_int ///
hispanic_int hispanic_virtual_int hispanic_hybrid_int ///
lowincome_int lowincome_virtual_int lowincome_hybrid_int ///
lowincome black hispanic white charter ///
charter_int charter_virtual_int charter_hybrid_int ///
) ///
coeflabels( ///
schoolmode "Learning Mode" hispanic_int "Hispanic I" black_int "Black I" ///
virtualper "Virtual \%" hybridper "Hybrid \%" charter "Charter" ///
hispanic_virtual_int "Hispanic Virtual I" hispanic_hybrid_int "Hispanic Hybrid I" ///
black_virtual_int "Black Virtual I" black_hybrid_int "Black Hybrid I" ///
lowincome "Low Income" female "Female" totaltested "Total Tested" ///
white "White" black "Black" hispanic "Hispanic"  ///
retention "Retention" classize_int "Class Size I" ///
) ///
refcat(black_int "\textbf{\emph{Interactions}}" lowincome "\textbf{\emph{Controls}}") ///
booktabs fragment label replace ///
nonotes mtitles("ELA" "MATH" "DROP" "ELA" "MATH" "DROP") nonumbers ///
stats(N, fmt(%18.0g) labels("\midrule Observations")) ///
mgroups("\textbf{\substack{\text{Dependent Variables} \\ \text{w/ Schoolmode}} }" /// 
"\textbf{\substack{\text{Dependent Variables} \\ \text{w/o Schoolmode}} }", pattern(1 0 0 1) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))


esttab ELA_STATEYEAR_NOPER MATH_STATEYEAR_NOPER DROP_STATEYEAR_NOPER ///
ELA_STATEYEAR_PER MATH_STATEYEAR_PER DROP_STATEYEAR_PER ///
using "/Users/natan/Dev/education_research/tables/table_stateyearint.tex", ///
keep(charter schoolmode lowincome black hispanic  ///
virtualper hybridper) ///
order( ///
schoolmode virtualper hybridper ///
black_int black_virtual_int black_hybrid_int ///
hispanic_int hispanic_virtual_int hispanic_hybrid_int ///
lowincome_int lowincome_virtual_int lowincome_hybrid_int ///
lowincome black hispanic white charter ///
) ///
coeflabels( ///
schoolmode "Learning Mode" hispanic_int "Hispanic I" black_int "Black I" ///
virtualper "Virtual \%" hybridper "Hybrid \%" charter "Charter" ///
hispanic_virtual_int "Hispanic Virtual I" hispanic_hybrid_int "Hispanic Hybrid I" ///
black_virtual_int "Black Virtual I" black_hybrid_int "Black Hybrid I" ///
lowincome "Low Income" female "Female" totaltested "Total Tested" ///
white "White" black "Black" hispanic "Hispanic"  ///
retention "Retention" classize_int "Class Size I" ///
) ///
refcat(black_int "\textbf{\emph{Interactions}}" lowincome "\textbf{\emph{Controls}}") ///
booktabs fragment label replace ///
nonotes mtitles("ELA" "MATH" "DROP" "ELA" "MATH" "DROP") nonumbers ///
stats(N, fmt(%18.0g) labels("\midrule Observations")) ///
mgroups("\textbf{\substack{\text{Dependent Variables} \\ \text{w/ Schoolmode}} }" /// 
"\textbf{\substack{\text{Dependent Variables} \\ \text{w/o Schoolmode}} }", pattern(1 0 0 1) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))


// esttab B D F using "/Users/natan/Dev/econometrics_compeition/table3.tex", ///
// drop(_cons white black asian hispanic disability t18 t19 attendance) ///
// coeflabels(schoolmode "Learning Mode" H_int "Hispanic I" B_int "Black I" ///
// lowincome "Low Income" female "Female" totaltested "Total Tested" ///
// retention "Retention") ///
// refcat(H_int "\textbf{\emph{Interactions}}" lowincome "\textbf{\emph{Controls}}") ///
// booktabs fragment label replace ///
// nonotes mtitles("ELA" "MATH" "DROP") nonumbers ///
// stats(N, fmt(%18.0g) labels("\midrule Observations")) ///
// mgroups("\textbf{\emph{Dependent Variables}}", pattern(1 0 0 0) ///
// prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))


