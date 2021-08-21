# Estimating U.S. Labour Flow Statistics
Data pull script for 'Uncertainty and Labor Market Fluctuations' by [Jo and Lee (2019)](https://doi.org/10.24149/wp1904), Federal Reserve Bank of Dallas Working Paper.

See data overview below for data used and how data are pulled for the exercise

## Application
### Uncertainty state estimation following [Jo and Lee (2019)](https://doi.org/10.24149/wp1904)
### Hidden Markov Model for transition probability estimation
- [ ] State-space model implementation
- [ ] Recession predictor and space estimation of labor flow

## Data overview
| Data | Description | Data Source | Relevant Literature |
| --- | :---: | :---: | :---: |
| Unemployment by duration and by reason | Unemployment by duration (weeks) by reasons | BLS |  - |
| Initial claims of unemployment insurance | Initial claims of unemployment insurance aggregated in national level | BLS/FRED | - | - |
| Employment: Part-time by reason | Part-timer employment statistics by reason (economic conditions) | BLS/FRED | - |
| Hours worked | Average hours worked for non-agricultural sector | BLS/FRED | - |
| Job finding statistics | Job finding and separation rate | CPS/JOLTS/FRED | [Elsby et al. (2009)](https://doi.org/10.1257/mac.1.1.84) |
| Flow hazard rate | Flow of labor between different states | BLS/[Elsby et al. (2009)](https://doi.org/10.1257/mac.1.1.84) | [Elsby et al. (2009)](https://doi.org/10.1257/mac.1.1.84) |
| Transition probability | Probability of changing employment state/status | BLS/Borowczyk-Martins and Lalé ([2019](https://doi.org/10.1257/mac.20160078), [2020](https://doi.org/10.1016/j.labeco.2020.101940)) | Borowczyk-Martins and Lalé ([2019](https://doi.org/10.1257/mac.20160078), [2020](https://doi.org/10.1016/j.labeco.2020.101940)) |

### (a) Unemployment by duration and by reason

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
| Job loser | BLS | [julia - BLS API](https://www.bls.gov/developers/api_sample_code.htm) | (level: LNU03023633) |
| Job leaver | BLS | [julia - BLS API](https://www.bls.gov/developers/api_sample_code.htm) | (level: LNU03023717) |
| Re-entrants  | BLS | [julia - BLS API](https://www.bls.gov/developers/api_sample_code.htm) | (level: LNU03023581) |
| New entrants  | BLS | [julia - BLS API](https://www.bls.gov/developers/api_sample_code.htm) | (level: LNU03023585) |

### (b) Initial claims of unemployment insurance
| Data | Source | Data Pull Method | Aggregation |
| :---: | :---: | :---: | :---: |
| Job losers on layoff | BLS/FRED | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | (rate: ICSA) |

### (c) Employment: Part-time by reason
Part-time employment count in non-agricultural sector, for, 

| Data | Source | Data Pull Method | Aggregation |
| :---: | :---: | :---: | :---: |
| Economic reason | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | (level: LNS12032197) |
| Non-Economic reasons | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | (level: LNS12033182) |

### (d) Hours worked for part-time workers
For non-agricultural part-time workers,

| Average hours worked  | BLS | [julia - BLS API](https://www.bls.gov/developers/api_sample_code.htm) | (level: LNU02033235) |

### (e) Job finding statistics
### (f) Flow hazard rate
### (g) Transition probability
