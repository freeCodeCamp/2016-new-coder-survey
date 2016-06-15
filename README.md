# Data Analysis of 2016 New Coder Survey

## New Coders Data Analysis.ipynb
Description of the survey data is available <a href="https://github.com/M0nica/2016-new-coder-survey/blob/master/survey-data-dictionary.md">here</a>

### Learnings
In matplotlib:

.hist(bins=x)

x = number of bins you'd like to display, you can increase or decrease the amount of bars that are displayed when data is displayed in histogram. The default number of bins is 10.

Adding 'alpha=0.2' to scatterplots makes it easier to see the distribution of data if the data is dense or clumped because regions with fewer data points appear lighter/with fewer dots while places with more data points appear darker/with more dots. 

### Issues
df.columns.value_counts() shows more columns than df.columns although, since this data set has a large number of columns (113) some are truncated/not printed out.

df['MoneyForLearning'].hist(bins=20, range=(0,93000)) # trying to figure out how to best display the data regarding how much money was spent on learning because the range of the int is from 0 to 93000. This huge range does not display well in a histogram!
