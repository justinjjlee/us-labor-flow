# Starter package relevant to run the code

using Pkg
using HTTP, FredData, BlsData
using JSON
using CSV, DataFrames, XLSX
using Dates
using Plots # Or Gadfly
using LinearAlgebra, Statistics;
using NonlinearSolve, StaticArrays

# Identity matrix function
eye(n) = Matrix{Float64}(I, n, n)

################################### 
## API set up
################################### 

# Specific date for mapping
date_start = "1980-01-01"
year_start = parse(Int64, date_start[1:4])

date_last = string(Date(now())); #date_last_txt = "2019 December";
year_end = parse(Int64, date_last[1:4])

date_baseline = "2020-01-01"; date_baseline_txt = "2020 January";

################################### 
## Functions used
################################### 

function cps_correction(xdf, colval)
    # Entering vector df - column name value,
    # This function is used to adjust for CPS revision that reflects the past 
    #   data weighting.
    # Elsby et al. (2009 AEJ) Correction constants	
    if colval == "total"
        xdf[xdf.date .>= Date(1994,2,1), :value] = xdf[xdf.date .>= Date(1994,2,1), :value].* 1.1
        return xdf
    elseif colval == "loser"
        xdf[xdf.date .>= Date(1994,2,1), :value] = xdf[xdf.date .>= Date(1994,2,1), :value] .* 1.0948
        return xdf
    elseif colval == "leaver"
        xdf[xdf.date .>= Date(1994,2,1), :value] = xdf[xdf.date .>= Date(1994,2,1), :value] .* 1.1644
        return xdf
    elseif colval == "entrant"
        xdf[xdf.date .>= Date(1994,2,1), :value] = xdf[xdf.date .>= Date(1994,2,1), :value] .* 1.2221
        return xdf
    else
        error("wrong choice of value")
    end
end

function dfjoins(dfbase, data, colname)
    # Function used to rename and join data
    rename!(data, Dict(names(data)[2] => colname))
    dfbase = leftjoin(dfbase, data, on = :date) # join
    return dfbase
end


function hzutil(x, valu)
    # Objective function used to estimate hazard rate
    # Default parameter sought
    local Lt0 = valu[1]
    local Qt0 = valu[2]
    local IUt0 = valu[3]

    local LeadL0 = valu[4]
    local LeadQ0 = valu[5]
    local LeadIU0 = valu[6]
    
    local LFt0 = valu[7]
    local It0 = valu[8]
    
    local F_L0 = valu[9]
    local F_Q0 = valu[10]
    local F_IU0 = valu[11]

    # Estimation
    A   = [x[1]*LFt0; x[2]*LFt0; x[3]*It0];
    B   = [(1-x[1]-F_L0) -x[1] -x[1]; 
            -x[2] (1-x[2]-F_Q0) -x[2]; 
            0 0 (1-F_IU0)];
    Y1  = [LeadL0; LeadQ0; LeadIU0];
    Y0  = [Lt0; Qt0; IUt0];

    # error for optimization function
    eps = Y1 - (eye(3) + B + B^2 + B^3)*A - (B^4)*Y0;

    # For one output optimization
    #optval = sum(eps.^2)
    return eps
end

function jsr_min(s_prop, valu)
    # Optimization function for job separation rate
    # f_t, l_t, u_t, u_t1
    f_t = valu[1]
    l_t = valu[2]
    u_t = valu[3] 
    u_t1= valu[4]

    s0 = s_prop[1]
    target_min = u_t1 -
                ((1 - exp(-f_t-s0))*s0*l_t/(f_t+s0)) +
                (exp(-f_t-s0)*u_t);
    return [target_min]
end