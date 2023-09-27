import pandas as pd
from linearmodels.panel import PanelOLS
from linearmodels.iv import AbsorbingLS

def run_generalized_regression_function(outcome_var, weight, locality_time_fe, interaction):
    try:
        data = pd.read_csv(f'../final_data_all_state/final_data_all_state_{outcome_var}.csv').iloc[:, 1:]

        exog_vars_schoolmode = ['schoolmode', 'black', 'hispanic', 'lowincome', 'white']
        exog_vars_virtual_hybrid = ['virtualper', 'hybridper', 'black', 'hispanic', 'lowincome', 'white']

        if locality_time_fe in ["district", "county"]:
            data[f'{locality_time_fe}_year'] = data[f'{locality_time_fe}code'] + data['year'].astype('str')
        elif locality_time_fe in ["state"]:
            data[f'{locality_time_fe}_year'] = data[f'{locality_time_fe}'] + data['year'].astype('str')
            
        if interaction in ["black_hispanic", "black", "hispanic", "lowincome", "charter"]:
            if interaction in ["black", "hispanic", "lowincome", "charter"]:
                data[f'{interaction}_int'] = data[interaction] * data['schoolmode']
                data[f'{interaction}_virtual_int'] = data[interaction] * data['virtualper']
                data[f'{interaction}_hybrid_int'] = data[interaction] * data['hybridper']
            else:
                data[f'{interaction}_int'] = (data['black'] + data['hispanic']) * data['schoolmode']
                data[f'{interaction}_virtual_int'] = (data['black'] + data['hispanic']) * data['virtualper']
                data[f'{interaction}_hybrid_int'] = (data['black'] + data['hispanic']) * data['hybridper']
            exog_vars_schoolmode.append(f'{interaction}_int')
            exog_vars_virtual_hybrid.append(f'{interaction}_virtual_int')
            exog_vars_virtual_hybrid.append(f'{interaction}_hybrid_int')


        absorbed_variables = ['schoolcode', 'year', f'{locality_time_fe}_year'] if locality_time_fe else ['schoolcode', 'year'] 
        absorb = data[absorbed_variables].astype('category')

        model = AbsorbingLS(dependent=data[outcome_var], exog=data[exog_vars_schoolmode], absorb=absorb, weights=data[weight])
        panel_results_schoolmode = model.fit(cov_type = 'clustered', clusters = data['schoolcode'])

        model = AbsorbingLS(dependent=data[outcome_var], exog=data[exog_vars_virtual_hybrid], absorb=absorb, weights=data[weight])
        panel_results_virtual_hybrid = model.fit(cov_type = 'clustered', clusters = data['schoolcode'])

        return [panel_results_schoolmode, panel_results_virtual_hybrid]
    
    except Exception as e:
        print(e)

def print_summarized_results(results):
    # UNCOMMENT BELOW TO ONLY SEE COEFFS, STD ERRORS, AND P VALUES
    
    # # Extract parameter estimates, standard errors and p-values
    # params = results.params
    # std_errors = results.std_errors.round(5)  # Round the standard errors to 5 decimal places
    # pvalues = results.pvalues.round(5)

    # # Construct a DataFrame
    # results_df = pd.DataFrame({
    #     'Parameter Estimates': params,
    #     'Standard Errors': std_errors,
    #     'P-values': pvalues
    # })

    # # Print the resulting DataFrame
    # print(results_df)
    print(results)