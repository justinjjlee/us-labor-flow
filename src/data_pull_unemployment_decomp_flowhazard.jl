# Matlab translation of function to calculate flow hazard rate: hazmain.m
#   Discrete time correction
# This code is translated and modified from
#       “The Ins and Outs of Cyclical Unemployment” 
#           by Michael Elsby, Ryan Michaels, and Gary Solon.

# Need to remove missing value in these
#   Population data tends to lag the most
T = length(filter(!ismissing, skipmissing(df_labforce[:, "pop"])))

U           = df_unemp_decom[1:T-1, "unemp_lvl"];
Emp         = df_emp[1:T-1, "emp_headline"];
Pop         = df_labforce[1:T-1, "pop"];
L           = df_unemp_decom[1:T-1, "unemp_lvl_loser"]; # job losers 
Llead       = df_unemp_decom[2:T, "unemp_lvl_loser"];   
stL         = df_unemp_decom[1:T-1, "loser_wk5"]; # job loser inflows
stLlead     = df_unemp_decom[2:T, "loser_wk5"];
Q           = df_unemp_decom[1:T-1, "unemp_lvl_leaver"]; # quits
Qlead       = df_unemp_decom[2:T, "unemp_lvl_leaver"];
stQ         = df_unemp_decom[1:T-1, "leaver_wk5"]; # quit inflows 
stQlead     = df_unemp_decom[2:T, "leaver_wk5"];
IU          = df_unemp_decom[1:T-1, "unemp_lvl_entrant"]; # re-entrants + new entrants
IUlead      = df_unemp_decom[2:T, "unemp_lvl_entrant"];
stIU        = df_unemp_decom[1:T-1, "entrant_wk5"]; # entrant inflows
stIUlead    = df_unemp_decom[2:T, "entrant_wk5"];
# Resid statistics
LF          = U+Emp;
NILF        = Pop-LF;

################################### 
## PART I) COMPUTE outflow rates
################################### 
T = length(U)

FLmo   = 1 .- ( (Llead .- stLlead)./L );
FQmo   = 1 .- ( (Qlead .- stQlead)./Q );
FIUmo  = 1 .- ( (IUlead - stIUlead)./IU );

FLwk   = 1 .- ( (ones(T,1) .- FLmo).^0.25 );
FQwk   = 1 .- ( (ones(T,1) .- FQmo).^0.25 );
FIUwk  = 1 .- ( (ones(T,1) .- FIUmo).^0.25 );

fhazLmo = -log.(1 .- FLmo);
fhazQmo = -log.(1 .- FQmo);
fhazIUmo = -log.(1 .- FIUmo);

################################### 
## PART II) COMPUTE entry rates
################################### 
# Initialize
inLwk  = zeros(T,1);
inQwk  = zeros(T,1);
inIUwk = zeros(T,1);


j = 1
for j ∈ 1:T
    LeadL0  = Llead[j]; 
    LeadQ0  = Qlead[j]; 
    LeadIU0 = IUlead[j];

    Lt0     = L[j]; 
    Qt0     = Q[j]; 
    IUt0    = IU[j];

    LFt0    = LF[j]; 
    It0     = NILF[j];   

    F_L0    = FLwk[j]; 
    F_Q0    = FQwk[j]; 
    F_IU0   = FIUwk[j];

    in_L0   = stLlead[j]/Emp[j];
    in_Q0   = stQlead[j]/Emp[j];
    in_IU0  = stIUlead[j]/NILF[j]; 

    # initial guess
    x0      = @SVector[in_L0, in_Q0, in_IU0];
    valu_i  = [Lt0, Qt0, IUt0, 
            LeadL0, LeadQ0, LeadIU0, 
            LFt0, It0, 
            F_L0, F_Q0, F_IU0];

    # Solver optimization - mulitple output
    probN = NonlinearProblem(hzutil, x0, valu_i)
    solver = solve(probN, NewtonRaphson(), reltol = 1e-9)

    # In case of iterative solve
    #cache = init(probN, NewtonRaphson())
    #solver = solve!(cache)
    inLwk[j]   = solver[1];
    inQwk[j]   = solver[2];
    inIUwk[j]  = solver[3];
end

# Estimation proc
inLmo  = ones(T,1) - ( ones(T,1) - inLwk ).^4;
inQmo  = ones(T,1) - ( ones(T,1) - inQwk ).^4;
inIUmo  = ones(T,1) - ( ones(T,1) - inIUwk ).^4;
    
inLhazmo = -log.(1 .- inLmo);
inQhazmo = -log.(1 .- inQmo);
inIUhazmo = -log.(1 .- inIUmo);            
    
# Combine calculated hazard rate
hazreasmo=[inLhazmo inQhazmo inIUhazmo];
df_hazard = DataFrame(hazreasmo, [:leaver_hazardinflow, :loser_hazardinflow, :entrant_hazardinflow])
df_hazard["date"] = df_unemp_decom.date[2:T+1]

# Add to the decomposition function
df_unemp_decom = leftjoin(df_unemp_decom, df_hazard, on=:date)