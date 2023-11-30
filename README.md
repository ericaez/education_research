# Economics Education Research
Building on Erica Zhou's final project for the course **ECON 383: Applied Econometrics** and our team's analysis in the [University of Chicago Econometrics Game 2023](https://economics.northwestern.edu/about/news/chicago-econometrics-game-winners.html), we extended our research to inform broader education policy. We conducted weighted least squares regression analyses with time and entity fixed effects and leveraged attribute interactions to further examine the impact of instruction mode on high school students' education outcomes.

Special thanks to Prof. Joel L. Horowitz and Prof. Richard Walker for their guidance and constructive feedback.

## Repository Description

>[!TIP]
>`<outcome>` is either mathpass, elapass, or dropout<br />
>`<state>` is the abbreviation of chosen U.S. states<br />
>`<interaction_variable>` is either year, income, schooltype, black, hispanic, or black_hispanic

### data_combined: 

Contains replication code `final_data_all_state.ipynb` for `final_data_all_state_<outcome>.csv`, which are final data files used to conduct regression analyses by outcome. 

### data_component: 

Contains replication code `data_cleaning_<state>_<outcome>.ipynb` for `final_data_<state>_<outcome>.csv`, which are state-level data files merged in `final_data_all_state.ipynb`.

Contains replication code `descriptive_analysis_replication.ipynb` used to obtain state-level `.csv` files used for descriptive analysis. 

### descriptive analysis: 

Both `net_change` and `summary_statistics` contains `<outcome>_by_<interaction_variable>.csv`.
- `net_change`: differences between (1) year 2021 and all-year averaged `<outcome>` and (2) year 2021 and year 2019 `<outcome>`, which are used for written description purposes in the research paper. 
- `summary_statistics`: state-level `<outcome>` by year, race and ethnicity, income level, and school type, which are used to create visualizations in `figures`. 

### figures: 

Contains `<outcome>_by_<interaction_variable>.png` figures, visualizing state-level `outcome` changes by year, race and ethnicity, income level, and school type. 

### generative scripts: 

Contains replication code `descriptive_analysis_net_replication.R`, `descriptive_analysis_net_replication.R`, and `dfigure_generation_change_by_year_<interaction_variable>.R` used to create files in `descriptive anaysis` and `figures`. 

### regressions: 

Contains replication code for regression analyses in Python and Stata. 

- `python_wls_functions.py`: written functions used in `python_wls_results.ipynb` to automate weighted least squares regression analyses with two-way fixed effects, including attribute interactions.
- `python_wls_results.ipynb`: results of the preliminary regression analyses (please prioritize the ones **with district-year interaction**, as they provide more robust and unbiased results). 
- `stata_wls_all.do`: regression analyses replication file written in Stata language. 

### tables: 

Contains tables describing primary regression results, which are placed in the research paper Appendix. 


