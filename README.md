# MCS
Implementation of the Model Confidence Set procedure of Hansen, Lunde and Nason (2011). The main function the user interacts with is estMCS, which carries out  the Model Confidence Set procedure of Hansen, Lunde and Nason (2011), i.e. a set that contains the best model with a given probability. This code is almost entirely adapted from the modelconf R package written by Rolf Tschernig and maintained by Niels Aka, which is availabe at https://github.com/nielsaka/modelconf/. 

# NOTES
The original paper proposed using one of two statistics in the MCS procedure. One is based on a maximum t-statistic (T_max), and the other is based on a 
range statistic (T_R). However, due to a mistake in the implementation, the authors reported results using a minimum t-statistic. In a corrigendum
to the paper, the authors recommend the use of the range statistics, which is the only one used in this implementation. Note that the modelconf R package from which this code was adapted allows the user to select the other statistics. 

# EXAMPLE
The script example_corrigendum_HLN2011.m replicates the results from the first column of Table IV in the Corrigendum to the paper. The file SW_infl4cast.csv contains inflation data (columns 'Obs') and inflation forecasts from 19 linear models (remaining columns). The example runs the MCS procedure and compares with the results in the table, producing the graph below.  
