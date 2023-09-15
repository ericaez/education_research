

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

ssc install reghdfe


// IMPORT MATH DATASET
insheet using "/Users/natan/Dev/virtual_mode_research/final_data_all_states/mathpass_district_allstates.csv", clear

set emptycells drop 

encode schoolcode, gen(schoolcodenum)
encode districtcode, gen(district)
encode countycode,gen(county)
encode state, gen(statecode)

g H_int = hispanic * remote
g B_int = black * remote
g lowincome_int = remote * lowincome

// Define periods
gen period_before = year <= 2019
gen period_after = year > 2019

// Run the regression for the before 2019 period
reghdfe mathpass white black hispanic charter i.statecode i.year lowincome ///
[aweight=totaltested] if period_before == 1, absorb(district schoolcode) cluster(district) 

estimates store benchmark

// Predict mathpass for the 2017-2019 period
predict mathpass_expected if period_before == 1, xb

// Define performance_diff for the 2019-2021 period
gen performance_diff = mathpass - mathpass_expected 

// Run the regression on performance_diff for the 2019-2021 period
reg performance_diff remote white black hispanic charter lowincome ///
[aweight=totaltested] if period_after == 1, robust



reghdfe mathpass hybridper virtualper white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe mathpass remote H_int B_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe mathpass remote white black hispanic /// 
charter i.statecode##i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe mathpass remote H_int B_int white black /// 
hispanic charter i.statecode##i.year /// 
lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)





// IMPORT ELA DATASET
insheet using "/Users/natan/Dev/virtual_mode_research/final_data_all_states/elapass_district_allstates.csv", clear

encode schoolcode, gen(schoolcodenum)
encode districtcode, gen(district)
encode countycode,gen(county)
encode state, gen(statecode)

g H_int = hispanic * remote
g B_int = black * remote
g lowincome_int = remote * lowincome

// REGRESSIONS FOR ELA PASS RATE
reghdfe elapass remote white black hispanic charter /// 
i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe elapass hybridper virtualper white black hispanic ///
charter i.statecode i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe elapass remote H_int B_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe elapass remote white black hispanic /// 
charter i.statecode##i.year lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)

reghdfe elapass remote H_int B_int white black /// 
hispanic charter i.statecode##i.year /// 
lowincome [aweight=totaltested], ///
absorb(district schoolcode) cluster(district)




// IMPORT DROPOUT DATASET
insheet using "/Users/natan/Dev/virtual_mode_research/final_data_all_states/dropout_district_allstates.csv", clear

encode schoolcode, gen(schoolcodenum)
encode districtcode, gen(district)
encode state, gen(statecode)

drop if totalenrolled < 0

g H_int = hispanic * remote
g B_int = black * remote
g lowincome_int = remote * lowincome

reghdfe dropout remote white black hispanic charter /// 
i.statecode i.year lowincome [aweight=totalenrolled], ///
absorb(district schoolcode) cluster(district)

reghdfe dropout hybridper virtualper white black hispanic ///
charter i.statecode i.year lowincome [aweight=totalenrolled], ///
absorb(district schoolcode) cluster(district)

reghdfe dropout remote H_int B_int /// 
white black hispanic charter lowincome ///
i.statecode i.year [aweight=totalenrolled], ///
absorb(district schoolcode) cluster(district)

reghdfe dropout remote white black hispanic /// 
charter i.statecode##i.year lowincome [aweight=totalenrolled], ///
absorb(district schoolcode) cluster(district)

reghdfe dropout remote H_int B_int white black /// 
hispanic charter i.statecode##i.year /// 
lowincome [aweight=totalenrolled], ///
absorb(district schoolcode) cluster(district)





esttab DROP_NORMAL using "/Dev/virtual_mode_research/table12.tex", ///
drop(_cons white black hispanic t21) ///
coeflabels(virtual_per "Virtual" hybrid_per "Hybrid" ///
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







