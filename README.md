# U.S. Labor State and Flow Big Data

This repository contains a series of API calls that pull and aggregate labor market time series data from the public sources using [julia programming language](https://github.com/JuliaLang/julia). The script builds a big data frame used in my co-authored research paper 'Uncertainty and Labor Market Fluctuations' by [Jo and Lee (2019)](https://doi.org/10.24149/wp1904), Federal Reserve Bank of Dallas Working Paper. Other research papers citing our research is documented by the [Google Scholar](https://scholar.google.com/scholar?cites=9919406685530542947&as_sdt=5,44&sciodt=0,44&hl=en). The dataframe is best used to evaluate the U.S. labor market in the application of macroeconomics and machine learning.

Use of this repository requires a citation of this repository and a note of proper authorships of myself and the cited papers noted in the code.

## Application: Data overview used in [Jo and Lee (2019)](https://doi.org/10.24149/wp1904)
The metrics calculated in the code use snippets translated from the MATLAB codes provided by the authors' research note below. All optimization processes uses [julia's non-linear solver](https://docs.sciml.ai/NonlinearSolve/stable/) instead of MATLAB's `fsolve`.

| Data | Description | Data Source | Relevant Literature |
| --- | :---: | :---: | :---: |
| Unemployment by duration and by reason | Unemployment by duration (weeks) by reasons | BLS |  - |
| Claims of unemployment insurance | Initial claims of unemployment insurance aggregated in national level | BLS/FRED | - | - |
| Employment: Part-time by reason | Part-timer employment statistics by reason (economic conditions) | BLS/FRED | - |
| Hours worked | Average hours worked for non-agricultural sector | BLS/FRED | - |
| Job finding statistics | Job finding and separation rate | CPS/JOLTS/FRED | [Elsby et al. (2009)](https://doi.org/10.1257/mac.1.1.84) |
| Flow hazard rate | Flow of labor between different states | BLS/[Elsby et al. (2009)](https://doi.org/10.1257/mac.1.1.84) | [Elsby et al. (2009)](https://doi.org/10.1257/mac.1.1.84) |
| Transition probability | Probability of changing employment state/status | BLS/Borowczyk-Martins and Lalé ([2019](https://doi.org/10.1257/mac.20160078), [2020](https://doi.org/10.1016/j.labeco.2020.101940)) | Borowczyk-Martins and Lalé ([2019](https://doi.org/10.1257/mac.20160078), [2020](https://doi.org/10.1016/j.labeco.2020.101940)) |

### Unemployment by duration and by reason

| Data | Source | Data Pull Method | Aggregation |
| :---: | :---: | :---: | :---: |
| Unemployed less than 5 weeks | BLS/FRED | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | (level: UEMPLT5 / rate: LNS13008397) |
| Unemployed for 5 to 14 weeks | BLS/FRED | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | (level: UEMP5TO14 / rate: LNS13025701) |
| Unemployed for 15 weeks and over | BLS/FRED | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | (level: UEMP15OV / rate: U1RATE) |
| Average duration of unemployment | BLS/FRED | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | (level: UEMPMEAN) |

For those with specific reasons, as a percent of total unemployed,

| Data | Source | Data Pull Method | Aggregation |
| :---: | :---: | :---: | :---: |
| Job losers on layoff | BLS/FRED | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | (rate: LNS13023654) |
| Job losers not on layoff | BLS/FRED | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | (rate: LNS13026511) |
| Job leaver | BLS/FRED | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | (rate: LNS13023706) |
| Re-entrants | BLS/FRED | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | (rate: LNS13023558) |
| New entrants | BLS/FRED | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | (rate: LNS13023570) |

For those with unemployed less than 5 weeks, specifically,

| Data | Source | Data Pull Method | Aggregation |
| :---: | :---: | :---: | :---: |
| Initial Claims | BLS/FRED | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | (rate: ICSA) |
| Continuous Claims | BLS/FRED | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | (rate: CCSA) |
| Job loser | BLS | [julia - BLS API](https://www.bls.gov/developers/api_sample_code.htm) | (level: LNU03023633) |
| Job leaver | BLS | [julia - BLS API](https://www.bls.gov/developers/api_sample_code.htm) | (level: LNU03023717) |
| Re-entrants  | BLS | [julia - BLS API](https://www.bls.gov/developers/api_sample_code.htm) | (level: LNU03023581) |
| New entrants  | BLS | [julia - BLS API](https://www.bls.gov/developers/api_sample_code.htm) | (level: LNU03023585) |

The BLS series of unemployment by reasons are also broken down by different durations of unemployed.

### Employment: Part-time by reason
Part-time employment count in non-agricultural sector, for, 

| Data | Source | Data Pull Method | Aggregation |
| :---: | :---: | :---: | :---: |
| Economic reason | BLS/FRED | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | (level: LNS12032197) |
| Non-Economic reasons | BLS/FRED | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | (level: LNS12033182) |

### Hours worked for part-time workers

| Data | Source | Data Pull Method | Aggregation |
| :---: | :---: | :---: | :---: |
| Average hours worked  | BLS | [julia - BLS API](https://www.bls.gov/developers/api_sample_code.htm) | (level: LNU02033235) |

## Future Applications
With the collection of labor time series data, there are numerous applications to investigate the historical and real-time labor market and macroeconomic dynamics. Here is a growing list to explore in future research.

### Hidden Markov Model for transition probability estimation
- [ ] State-space model implementation
- [ ] Recession predictor and space estimation of labor flow
