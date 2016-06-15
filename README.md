# Data Analysis of 2016 New Coder Survey

## New Coders Data Analysis.ipynb

### Learnings
.hist(bins=x)

x = number of bins you'd like to display, you can increase or decrease the amount of bars that are displayed when data is displayed in histogram. The default number of bins is 10.

### Issues
df.columns.value_counts() shows more columns than df.columns although, since this data set has a large number of columns (113) some are truncated/not printed out.

df['MoneyForLearning'].hist(bins=20, range=(0,93000)) # trying to figure out how to best display the data regarding how much money was spent on learning because the range of the int is from 0 to 93000. This huge range does not display well in a histogram!
