#Employment level ---------------------------------------------------------------------------------------------
#Employment Level: Nonagricultural Industries
#Employment Level: Nonagriculture, Self-employed Workers, Unincorporated
#Employment Level: Part-Time for Economic Reasons, Nonagricultural Industries
#Employment Level: Part-Time for Economic Reasons, Slack Work or Business Conditions, 
#                       Nonagricultural Industries 
#Employment Level: Part-Time for Economic Reasons, Could Only Find Part-Time Work, Nonagricultural Industries
#Employment Level: Part-Time for Noneconomic Reasons, Nonagricultural Industries
#Employment-population ratio (PAYEMS/CLF16OV)
emp = FredData.get_data(api_fred, "PAYEMS"; observation_start = date_start)
emp_ni = FredData.get_data(api_fred, "LNS12035019"; observation_start = date_start)
emp_self = FredData.get_data(api_fred, "LNS12032192"; observation_start = date_start)
emp_pt_econ = FredData.get_data(api_fred, "LNS12032197"; observation_start = date_start)
emp_pt_econ_slack = FredData.get_data(api_fred, "LNS12032198"; observation_start = date_start)
emp_pt_econ_only = FredData.get_data(api_fred, "LNS12032199"; observation_start = date_start)
emp_pt_econ_not = FredData.get_data(api_fred, "LNS12032200"; observation_start = date_start)
emp_ratiopop = FredData.get_data(api_fred, "EMRATIO"; observation_start = date_start)
emp_ratiolabforce = deepcopy(emp.data)
emp_ratiolabforce["value"] = emp.data.value ./ labforce.data.value
# Housrs worked part time
# Average Hours, Persons At Work 1-34 Hours, Economic Reasons, Nonagricultural Industries
str_use = "LNU02033235"
emp_part_hours = BlsData.get_data(api_bls, str_use; startyear = year_start, endyear = year_end, catalog = false)

df_emp = emp.data[:, ["date", "value"]]
rename!(df_emp, Dict(:value => "emp_headline"))

df_emp = dfjoins(df_emp, emp_ni.data[:, ["date", "value"]], "emp_nonagri")
df_emp = dfjoins(df_emp, emp_ratiopop.data[:, ["date", "value"]], "emp_perpop")
df_emp = dfjoins(df_emp, emp_ratiolabforce[:, ["date", "value"]], "emp_perlabforce")
df_emp = dfjoins(df_emp, emp_self.data[:, ["date", "value"]], "emp_selfemply")
df_emp = dfjoins(df_emp, emp_pt_econ.data[:, ["date", "value"]], "emp_pt_econ")
df_emp = dfjoins(df_emp, emp_pt_econ_slack.data[:, ["date", "value"]], "emp_pt_econ_slack")
df_emp = dfjoins(df_emp, emp_pt_econ_only.data[:, ["date", "value"]], "emp_pt_econ_only")
df_emp = dfjoins(df_emp, emp_pt_econ_not.data[:, ["date", "value"]], "emp_pt_econ_not")
df_emp = dfjoins(df_emp, emp_part_hours.data[:, ["date", "value"]], "emp_pt_hours")

# Vacancy rate ------------------------------------------------------------------------------------------------
# Stitch Barnichon and JOLTS data 
# Import barnichon
jolts_vacant_origin = XLSX.readdata("./data/barnichon_vacancy/CompositeHWI.xlsx", "Sheet1", "B9:B608")
# Import new data
jolts_vacant = FredData.get_data(api_fred, "JTSJOL"; observation_start = "2001-01-01")
# Date vector from barnichon 
dt = Date(1951,1,1):Dates.Month(1):Date(jolts_vacant.data.date[1])
dt = Vector(dt[1:end-1])
# Create dataframe
barndf = DataFrame(
    realtime_start = jolts_vacant.data.realtime_start[1], 
    realtime_end = jolts_vacant.data.realtime_end[1], 
    date = dt, 
    value = jolts_vacant_origin[:]
    )

vacance = vcat(barndf, jolts_vacant.data)
# Same temporary file
CSV.write("./data/barnichon_vacancy/CompositeHWI_updated.csv", vacance)
# Plotting for checking purpose
#plot(vacance.date, vacance.value)
# Only pull relevant dates for the data pull purpose
vacance = vacance[vacance.date .>= Date(date_start),:]

df_emp = dfjoins(df_emp, vacance[:, ["date", "value"]], "vacancy")

# Relevant FRED-MD data 
# Check https://research.stlouisfed.org/econ/mccracken/fred-databases/
#https://files.stlouisfed.org/files/htdocs/fred-md/monthly/current.csv
fredmd = CSV.read(download("https://files.stlouisfed.org/files/htdocs/fred-md/monthly/current.csv"), DataFrame)
# Cleanup general data
# Remove rows missing
fredmd = fredmd[2:end-1,:]
# Convert date
fredmd["date"] = Date.(fredmd.sasdate, dateformat"m/d/y")
# Add real-time, which is just data pull, this is not the real-time vintage date per se
fredmd["realtime_start"] = jolts_vacant.data.realtime_start[1]
fredmd["realtime_end"] = jolts_vacant.data.realtime_end[1]

# Help wanted unemployment ratio
vacance_ratiounemp = fredmd[:, [:realtime_start, :realtime_end, :date, :HWIURATIO]]

df_emp = dfjoins(df_emp, vacance_ratiounemp[:, ["date", "HWIURATIO"]], "vacancy_ratio")