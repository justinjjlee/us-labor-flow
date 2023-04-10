# Unemployment Decomposition ----------------------------------------------------------------------------------
# NOTE: Other CPS-based measure: https://www.bls.gov/cps/cps_flows.htm
#Unemployment level
#Unemployment Level: Looking for Full-Time Work (or this series would work: LNS14200000)
#Unemployment Level: Looking for Part-Time Work (or this series would work: LNS14100000)
unemp_lvl = FredData.get_data(api_fred, "UNEMPLOY"; observation_start = date_start)
unemp_lvl_ft = FredData.get_data(api_fred, "LNS13100000"; observation_start = date_start)
unemp_lvl_pt = FredData.get_data(api_fred, "LNS13200000"; observation_start = date_start)

df_unemp_decom = unemp_lvl.data[:, ["date", "value"]]
rename!(df_unemp_decom, Dict(:value => "unemp_lvl"))

df_unemp_decom = dfjoins(df_unemp_decom, unemp_lvl_ft.data[:, ["date", "value"]], "unemp_ft")
df_unemp_decom = dfjoins(df_unemp_decom, unemp_lvl_pt.data[:, ["date", "value"]], "unemp_pt")

# Number of Civilians Unemployed for Less Than 5 Weeks
#   Need to apply correction constant 
#   5 weeks; 5-14 weeks; 15+weeks
unemp_lvl_5 = FredData.get_data(api_fred, "UEMPLT5"; observation_start = date_start)
unemp_lvl_5_df = cps_correction(unemp_lvl_5.data, "total")
unemp_lvl_514 = FredData.get_data(api_fred, "UEMP5TO14"; observation_start = date_start)
unemp_lvl_514_df = cps_correction(unemp_lvl_514.data, "total")
unemp_lvl_16 = FredData.get_data(api_fred, "UEMP15OV"; observation_start = date_start)
unemp_lvl_16_df = cps_correction(unemp_lvl_16.data, "total")

df_unemp_decom = dfjoins(df_unemp_decom, unemp_lvl_5_df[:, ["date", "value"]], "unemp_lvl_5")
df_unemp_decom = dfjoins(df_unemp_decom, unemp_lvl_514_df[:, ["date", "value"]], "unemp_lvl_514")
df_unemp_decom = dfjoins(df_unemp_decom, unemp_lvl_16_df[:, ["date", "value"]], "unemp_lvl_16")

# By unemployment duration, and by type (share)
# Total: Loser, Leaver, retrant, new entrant
#   For non seasonal adjustment, change format
# LNU03023621	LNU03023705	LNU03023557	LNU03023569
# For seasonal adjustment
# LNS13023621   LNS13023705 LNS13023557 LNS13023569
unemp_lvl_loser = FredData.get_data(api_fred, "LNU03023621"; observation_start = date_start)
unemp_lvl_loserdf = cps_correction(unemp_lvl_loser.data, "loser")
unemp_lvl_leaver = FredData.get_data(api_fred, "LNU03023705"; observation_start = date_start)
unemp_lvl_leaverdf = cps_correction(unemp_lvl_leaver.data, "leaver")
unemp_lvl_retrant = FredData.get_data(api_fred, "LNU03023557"; observation_start = date_start)
unemp_lvl_retrantdf = cps_correction(unemp_lvl_retrant.data, "entrant")
unemp_lvl_newentrant = FredData.get_data(api_fred, "LNU03023569"; observation_start = date_start)
unemp_lvl_newentrantdf = cps_correction(unemp_lvl_newentrant.data, "entrant")

df_unemp_decom = dfjoins(df_unemp_decom, unemp_lvl_loserdf[:, ["date", "value"]], "unemp_lvl_loser")
df_unemp_decom = dfjoins(df_unemp_decom, unemp_lvl_leaverdf[:, ["date", "value"]], "unemp_lvl_leaver")
df_unemp_decom = dfjoins(df_unemp_decom, unemp_lvl_retrantdf[:, ["date", "value"]], "unemp_lvl_retrant")
df_unemp_decom = dfjoins(df_unemp_decom, unemp_lvl_newentrantdf[:, ["date", "value"]], "unemp_lvl_newentrant")
df_unemp_decom["unemp_lvl_entrant"] = df_unemp_decom[:,"unemp_lvl_retrant"] + 
                                        df_unemp_decom[:,"unemp_lvl_newentrant"]

# Broken down by type .........................................................................................

# 5 weeks
str_use = "LNU03023633"
dfblsping = BlsData.get_data(api_bls, str_use; startyear = year_start, endyear = year_end, catalog = false)
unemp_loser_5 = dfblsping.data
df_unemp_decom[:,"loser_wk5"] = unemp_lvl_loserdf.value .* unemp_loser_5.value / 100

str_use = "LNU03023717"
dfblsping = BlsData.get_data(api_bls, str_use; startyear = year_start, endyear = year_end, catalog = false)
unemp_leaver_5 = dfblsping.data
df_unemp_decom[:,"leaver_wk5"] = unemp_lvl_leaverdf.value .* unemp_leaver_5.value / 100

str_use = "LNU03023581"
dfblsping = BlsData.get_data(api_bls, str_use; startyear = year_start, endyear = year_end, catalog = false)
unemp_retrant_5 = dfblsping.data
df_unemp_decom[:,"retrant_wk5"] = unemp_lvl_retrantdf.value .* unemp_retrant_5.value / 100

str_use = "LNU03023585"
dfblsping = BlsData.get_data(api_bls, str_use; startyear = year_start, endyear = year_end, catalog = false)
unemp_newetrant_5 = dfblsping.data
df_unemp_decom[:,"newentrant_wk5"] = unemp_lvl_newentrantdf.value .* unemp_newetrant_5.value / 100

df_unemp_decom[:,"entrant_wk5"] = df_unemp_decom[:,"retrant_wk5"] + df_unemp_decom[:,"newentrant_wk5"]

# 5 - 14 weeks
str_use = "LNU03023645"
dfblsping = BlsData.get_data(api_bls, str_use; startyear = year_start, endyear = year_end, catalog = false)
unemp_loser_514 = dfblsping.data
df_unemp_decom[:,"loser_wk514"] = unemp_lvl_loserdf.value .* unemp_loser_514.value / 100

str_use = "LNU03023729"
dfblsping = BlsData.get_data(api_bls, str_use; startyear = year_start, endyear = year_end, catalog = false)
unemp_leaver_514 = dfblsping.data
df_unemp_decom[:,"leaver_wk514"] = unemp_lvl_leaverdf.value .* unemp_leaver_514.value / 100

str_use = "LNU03023605"
dfblsping = BlsData.get_data(api_bls, str_use; startyear = year_start, endyear = year_end, catalog = false)
unemp_retrant_514 = dfblsping.data
df_unemp_decom[:,"retrant_wk514"] = unemp_lvl_retrantdf.value .* unemp_retrant_514.value / 100

str_use = "LNU03023609"
dfblsping = BlsData.get_data(api_bls, str_use; startyear = year_start, endyear = year_end, catalog = false)
unemp_newetrant_514 = dfblsping.data
df_unemp_decom[:,"newentrant_wk514"] = unemp_lvl_newentrantdf.value .* unemp_newetrant_514.value / 100

df_unemp_decom[:,"entrant_wk514"] = df_unemp_decom[:,"retrant_wk514"] + df_unemp_decom[:,"newentrant_wk514"]

# 15 weeks +
str_use = "LNU03023637"
dfblsping = BlsData.get_data(api_bls, str_use; startyear = year_start, endyear = year_end, catalog = false)
unemp_loser_15 = dfblsping.data
df_unemp_decom[:,"loser_wk15"] = unemp_lvl_loserdf.value .* unemp_loser_15.value / 100

str_use = "LNU03023721"
dfblsping = BlsData.get_data(api_bls, str_use; startyear = year_start, endyear = year_end, catalog = false)
unemp_leaver_15 = dfblsping.data
df_unemp_decom[:,"leaver_wk15"] = unemp_lvl_leaverdf.value .* unemp_leaver_15.value / 100

str_use = "LNU03023589"
dfblsping = BlsData.get_data(api_bls, str_use; startyear = year_start, endyear = year_end, catalog = false)
unemp_retrant_15 = dfblsping.data
df_unemp_decom[:,"retrant_wk15"] = unemp_lvl_retrantdf.value .* unemp_retrant_15.value / 100

str_use = "LNU03023593"
dfblsping = BlsData.get_data(api_bls, str_use; startyear = year_start, endyear = year_end, catalog = false)
unemp_newetrant_15 = dfblsping.data
df_unemp_decom[:,"newentrant_wk15"] = unemp_lvl_newentrantdf.value .* unemp_newetrant_15.value / 100

df_unemp_decom[:,"entrant_wk15"] = df_unemp_decom[:,"retrant_wk15"] + df_unemp_decom[:,"newentrant_wk15"]