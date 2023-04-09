# U.S. Labor State and Flow Big Data
# Author: Justin (https://github.com/justinjoliver/labour-flow-data)
# Set working directory
cd(@__DIR__)

# Import all packages and functions required for this workflow
include("initialize.jl");

# Pull from .json file - .gitignore
# For the public users, recommend to enter your APIs
apikeys = JSON.parsefile("credential.json")
api_key_fred = apikeys["api_key_fred"]
api_key_bls = apikeys["api_key_bls"]
api_key_fred = "-------------------------- USE YOUR FRED API KEY HERE --------------------------"
api_key_bls = "-------------------------- USE YOUR FRED API KEY HERE --------------------------"

# Dataframe generation for labor force and population statistics
include("data_pull_LaborForce.jl")
# OUTPUT: df_labforce

# Dataframe generation for headline unemployment statistics
include("data_pull_unemployment.jl")
# OUTPUT: df_unemp

# Dataframe generation for headline employment and labor supply statistics
include("data_pull_employment.jl")
# OUTPUT: df_emp

# Dataframe generation for decomposed unemployment by durations and reasons
include("data_pull_unemployment_decomp.jl")
# OUTPUT: df_unemp_decom

# Dataframe generation for estimating inflow of unemployment by reason
include("data_pull_unemployment_decomp_flowhazard.jl")
# NOTE: the resulting series are appended to `df_unemp_decom``
# OUTPUT: df_unemp_decom

# Dataframe generation for estimating job finding/separation rate
include("data_pull_LaborForce_fineseparaterate.jl")
# NOTE: This data series can go back to 1940's, base with the unemployment
#   For the purpose of the data matching, the joining cuts off at 1980's
#   The resulting data is appended to `df_labforce``
# OUTPUT: df_labforce

# =============================================================================================================
# Join database
# =============================================================================================================
# Join - if you wish to combine the database/frame

# =============================================================================================================
# Print data
# =============================================================================================================
CSV.write("./data/df_emp.csv", df_emp)
CSV.write("./data/df_hazard.csv", df_hazard)
CSV.write("./data/df_jsfrate.csv", df_jsfrate)
CSV.write("./data/df_labforce.csv", df_labforce)
CSV.write("./data/df_unemp.csv", df_unemp)
CSV.write("./data/df_unemp_decom.csv", df_unemp_decom)