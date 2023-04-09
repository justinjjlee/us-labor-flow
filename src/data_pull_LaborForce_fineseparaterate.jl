# Job finding/separation rate ---------------------------------------------------------------------------------
#   input data
us_t     = df_unemp_decom["unemp_lvl_5"];   # unemployment level, short
us_t1    = us_t[2:end];                     # unemployment level, short, next period
us_t     = us_t[1:(end - 1)];               # (update) unemployment level, short

u_t      = df_unemp_decom["unemp_lvl"];     # unemployment level
u_t1     = u_t[2:end];                      # unemployment level, next period
u_t      = u_t[1:(end - 1)];                # (update) unemployment level

l_t      = df_labforce["laborforce_total"]; # civilian labor force level
l_t      = l_t[1:(end - 1)];                # (update) civilian labor force level

T        = length(l_t);

################################### 
## PART I) job find rate
###################################

# First, calculate job finding calculation rate
F_t = 1 .- (u_t1 .- us_t1)./(u_t);
# then, job finding rate, continuous time environment.
f_t = -log.(1 .- F_t);
#f_t = (1 - (1 - F_t).^(1/4)); %%% WARNING: this is what EMS does in AEJ'09;
# f_t represents "weekly" (discrete) rates; this is used as an input to calculate
#    the weekly inflow hazard. 

################################### 
## PART II) job separation rate
###################################
# need solution for differential equaiton.
s_t = zeros(T, 1);
# set initial estimate, following the law of motion of unemployment
# s_t_propose  = (u_t1 - ((1 - f_t).*u_t))./(1 - u_t);
# or, follow Elsby et al. (2009)
s_t_propose = (f_t./F_t).*(us_t1./(l_t - u_t)); # guess

for t_time = 1:T
    valu_i = [f_t[t_time], l_t[t_time], u_t[t_time], u_t1[t_time]];
    s_i = @SVector[s_t_propose[t_time]]

    # Solver optimization - mulitple output
    probN = NonlinearProblem(jsr_min, s_i, valu_i)
    solver = solve(probN, NewtonRaphson(), reltol = 1e-9)

    # In case of iterative solve
    #cache = init(probN, NewtonRaphson())
    #solver = solve!(cache)
    s_t[t_time] = solver[1]
end

df_jsfrate = DataFrame(hcat(f_t, s_t), [:laborforce_jobfindrate, :laborforce_jobseparaterate])
df_jsfrate["date"] = df_labforce[2:T+1, "date"]

df_labforce = leftjoin(df_labforce, df_jsfrate, on = :date)