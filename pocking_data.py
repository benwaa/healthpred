import pandas as pd

Location = "Hospital_Inpatient_Discharges__SPARCS_De-Identified___2012.csv"
df = pd.read_csv(Location, names=['Health_Service_Area','Hospital_County','Operating_Certificate_Number','Facility_Id','Facility_Name','Age_Group','Zip_Code_-_3_digits','Gender','Race','Ethnicity','Length_of_Stay','Admit_Day_of_Week','Type_of_Admission','Patient_Disposition','Discharge_Year','Discharge_Day_of_Week','CCS_Diagnosis_Code','CCS_Diagnosis_Description','CCS_Procedure_Code','CCS_Procedure_Description','APR_DRG_Code','APR_DRG_Description','APR_MDC_Code','APR_MDC_Description','APR_Severity_of_Illness_Code','APR_Severity_of_Illness_Description','APR_Risk_of_Mortality','APR_Medical_Surgical_Description','Payment_Typology_1','Payment_Typology_2','Payment_Typology_3','Attending_Provider_License_Number','Operating_Provider_License_Number','Other_Provider_License_Number','Birth_Weight','Abortion_Edit_Indicator','Emergency_Department_Indicator','Total_Charges','Total_Costs'])
# remove dollar stuff

electives = df.loc[df.Type_of_Admission == 'Elective']
procedures_count = electives.CCS_Procedure_Description.value_counts()

import matplotlib.pyplot as plt
procedures_percent = 100 * procedures_count / procedures_count.sum()
procedures_percent[:10].plot(kind='bar')
#plt.show()

for k in procedures_percent.keys()[:10]:
	procedure_elect = electives.loc[electives.CCS_Procedure_Description == k]
	cost = (procedure_elect.Total_Charges.replace( '[\$,)]','', regex=True ).astype(float))
	print k,"{0:.2f}".format(round(cost.sum()/1000000,2)), "Millions"

