using Pkg
using FredData, BlsData
using CSV, DataFrames
# Set working directory
cd(@__DIR__)

# Add Fred API key: 
api_key_fred = "-------------------------- USE YOUR FRED API KEY HERE --------------------------"
api_key_bls = "-------------------------- USE YOUR FRED API KEY HERE --------------------------"

api_fred = Fred(api_key_fred);
api_bls  = Bls(api_key_bls);

# Specific date for mapping
date_start = "1980-01-01"
year_start = parse(Int64, date_start[1:4])

date_last = "2021-07-01"; date_last_txt = "2020 November";
year_end = parse(Int64, date_last[1:4])

date_baseline = "2020-01-01"; date_baseline_txt = "2020 January";

# Stats for unemployed less than 5 weeks
stunemp_5_lvl = FredData.get_data(api_fred, "UEMPLT5"; observation_start = date_start)
stunemp_5_pct = FredData.get_data(api_fred, "LNS13008397"; observation_start = date_start)

stunemp_14_lvl = FredData.get_data(api_fred, "UEMP5TO14"; observation_start = date_start)
stunemp_14_pct = FredData.get_data(api_fred, "LNS13025701"; observation_start = date_start)

stunemp_15over_lvl = FredData.get_data(api_fred, "UEMP15OV"; observation_start = date_start)
stunemp_15over_pct = FredData.get_data(api_fred, "U1RATE"; observation_start = date_start)

unemp_loser_layoff_pct = FredData.get_data(api_fred, "LNS13023654"; observation_start = date_start)
unemp_loser_layoffnot_pct = FredData.get_data(api_fred, "LNS13026511"; observation_start = date_start)
unemp_leaver_pct = FredData.get_data(api_fred, "LNS13023706"; observation_start = date_start)
unemp_reentrant_pct = FredData.get_data(api_fred, "LNS13023558"; observation_start = date_start)
unemp_newentrant_pct = FredData.get_data(api_fred, "LNS13023570"; observation_start = date_start)

# Unemployement initial claims
ini_claim = FredData.get_data(api_fred, "ICSA"; observation_start = date_start)

# Part-time employment by reason - econ/nonecon, respectively
ptemply_econ = FredData.get_data(api_fred, "LNS12032197"; observation_start = date_start)
ptemply_econnot = FredData.get_data(api_fred, "LNS12033182"; observation_start = date_start)

# Average duration of unemployment
duration_unemp = FredData.et_data(api_fred, "UEMPMEAN"; observation_start = date_start)


### PULL by reason by duration data
str_byreason_byduration = ["LNU03023633", "LNU03023717", "LNU03023581", "LNU03023585"];
dict_unemp_byreasonbyduration = BlsData.get_data(api_bls, str_byreason_byduration; startyear = year_start, endyear = year_end, catalog = false)

# Housrs worked
str_use = "LNU02033235"
dict_hours_worked = BlsData.get_data(api_bls, str_use; startyear = year_start, endyear = year_end, catalog = false)
dict_hours_worked.data
# COnvert to dataframe of all joined
#Data clean-ups
unempus.data[:value] = unempus.data[:value];