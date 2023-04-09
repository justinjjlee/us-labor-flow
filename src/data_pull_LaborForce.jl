# Aggregate stats =============================================================================================
# Civilian Labor Force 
#   Level
#   Participation rate
#   Participation rate - working age
#   Not in labor force
# Adult population (OECD) - 2-month lag
labforce = FredData.get_data(api_fred, "CLF16OV"; observation_start = date_start)
labforce_rate = FredData.get_data(api_fred, "CIVPART"; observation_start = date_start)
labforce_ratewa = FredData.get_data(api_fred, "LNS11300060"; observation_start = date_start)
labforce_not = FredData.get_data(api_fred, "LNS15000000"; observation_start = date_start)
pop = FredData.get_data(api_fred, "LFWA64TTUSM647S"; observation_start = date_start)

# Aggregate
df_labforce = labforce.data[:, ["date", "value"]]
rename!(df_labforce, Dict(:value => "laborforce_total"))

df_labforce = dfjoins(df_labforce, labforce_rate.data[:, ["date", "value"]], "laborforce_rate")
df_labforce = dfjoins(df_labforce, labforce_ratewa.data[:, ["date", "value"]], "laborforce_rate_workage")
df_labforce = dfjoins(df_labforce, labforce_not.data[:, ["date", "value"]], "laborforce_not")
df_labforce = dfjoins(df_labforce, pop.data[:, ["date", "value"]], "pop")

# make population unit in thousands
df_labforce["pop"] = df_labforce["pop"] ./ 1000