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
| Unemployed less than 5 weeks | BLS/FRED | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | - |
| Unemployed for 5 to 14 weeks | BLS/FRED | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | - |
| Unemployed for 15 weeks and over | BLS/FRED | [julia - FRED API](https://github.com/micahjsmith/FredData.jl) | - |

For those with unemployed less than 5 weeks, specifically

| Data | Source | Data Pull Method | Aggregation |
| :---: | :---: | :---: | :---: |
| Job loser | BLS | [julia - BLS API](https://www.bls.gov/developers/api_sample_code.htm) | - |
| Job leaver | BLS | [julia - BLS API](https://www.bls.gov/developers/api_sample_code.htm) | - |
| Entrant  | BLS | [julia - BLS API](https://www.bls.gov/developers/api_sample_code.htm) | - |

### (b) Initial claims of unemployment insurance
### (c) Employment: Part-time by reason
### (d) Hours worked
### (e) Job finding statistics
### (f) Flow hazard rate
### (g) Transition probability
