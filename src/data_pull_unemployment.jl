# Aggregate (un)employment ------------------------------------------------------------------------------------
# Total unemployment
#   Initial Claims (Insured Unemployment)	
#   Continued Claims (Insured Unemployment)	
#   Unemployment claim per labor force
#   Unemployment claim per labor force per unemployment
unemp = FredData.get_data(api_fred, "UNRATE"; observation_start = date_start)
unemp_cc = FredData.get_data(api_fred, "CCSA"; observation_start = date_start, frequency = "m", 
    aggregation_method = "avg")
unemp_ic = FredData.get_data(api_fred, "ICSA"; observation_start = date_start, frequency = "m", 
    aggregation_method = "avg")
unemp_cc_lab = deepcopy(unemp_cc.data)
unemp_cc_lab["value"] = unemp_cc.data.value ./ labforce.data.value /10
unemp_cc_lab_unemp = deepcopy(unemp_cc_lab)
unemp_cc_lab_unemp["value"] = unemp_cc_lab.value ./ unemp.data.value * 100
# Average duration of unemployment
duration_unemp = FredData.get_data(api_fred, "UEMPMEAN"; observation_start = date_start)

# organize data
df_unemp = unemp.data[:, ["date", "value"]]
rename!(df_unemp, Dict(:value => "unemp_rate"))

df_unemp = dfjoins(df_unemp, unemp_ic.data[:, ["date", "value"]], "unemp_initialclaim")
df_unemp = dfjoins(df_unemp, unemp_cc.data[:, ["date", "value"]], "unemp_continueclaim")
df_unemp = dfjoins(df_unemp, unemp_cc_lab[:, ["date", "value"]], "unemp_perlabforce")
df_unemp = dfjoins(df_unemp, unemp_cc_lab_unemp[:, ["date", "value"]], "unemp_perlabforceperunemp")
df_unemp = dfjoins(df_unemp, duration_unemp.data[:, ["date", "value"]], "unemp_duration")