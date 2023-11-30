# Economics Education Research
Building on Erica Zhou's final project for the course **ECON 383: Applied Econometrics** and our team's analysis in the [University of Chicago Econometrics Game 2023](https://economics.northwestern.edu/about/news/chicago-econometrics-game-winners.html), we extended our research to inform broader education policy. We conducted weighted least squares regression analyses with time and entity fixed effects and leveraged attribute interactions to further examine the impact of instruction mode on high school students' education outcomes.

Special thanks to Prof. Joel L. Horowitz and Prof. Richard Walker for their guidance and constructive feedback.

## Repository Description

>[!TIP]
>`<outcome>` is either mathpass, elapass, or dropout<br />
>`<state>` is the abbreviation of chosen U.S. states

### data_cleaning_component: 

Contains replication code `data_cleaning_<outcome>_<state>.ipynb` used to obtain state-level education outcomes files `<outcome>_all_state.csv`.

### descriptive_analysis: 

Contains replication code `descriptive_analysis_replication.ipynb` used to obtain state-level `.csv` files used for descriptive analysis. 

- Naming convention: `<outcome>_by_<interaction_variable>.csv`
- `<outcome>` is either mathpass, elapass, or dropout
- `<interaction_variable>` is either year, income, schooltype, black, hispanic, or black_hispanic

### figures: 

Contains replication code `figure_replication.R` and included figures in `.pdf` format.

- Naming convention: `figure_<number>.pdf`

### final_data_all_state: 

Contains replication code `final_data_all_state_replication.ipynb` and all-state combined `.csv` files used for regression analysis.

- Naming convention: `<outcome>_all_state.csv`
- `<outcome>` is either mathpass, elapass, or dropout

### final_data_component: 

Contains state-level `.csv` files.

- Naming convention: `<outcome>_<state>.csv`
- `<outcome>` is either mathpass, elapass, or dropout
- 

● .csv file naming convention: <outcome>_<state>.csv

### python_regression: 

replication .ipynb file to obtain regression analysis results in Python

● .ipynb file naming convention: pyreg_<regression type>_<outcome>.ipynb

### stata_regression: 

replication .do file to obtain regression analysis results in Stata

● .do file naming convention: stata_<regression type>_<outcome>.do

### table: 

(1) replication .R file to obtain all included tables; and (2) .pdf tables
● .R file naming convention: table_replication.R
● .pdf file naming convention: table_<number>.pdf
