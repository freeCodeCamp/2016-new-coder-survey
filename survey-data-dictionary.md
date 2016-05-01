# Survey Data Dictionary

This file contains a list of the questions from the survey and descriptions on
what each question can have as an answer.

The variable section for each question (**Variable**) is the column name in the
cleaned up dataset.


## Data and Survey Description

The survey itself is separated into two parts: (1) information about coding and
(2) demographic information.

This is not the same as the two parts of the raw data. The first dataset
contains all responses for the first half of the survey. The second dataset
contains all responses for the first and second parts of the survey of those who
submitted both parts of the survey.

There are multiple types of questions:

- free text where user inputs values
- multiple choice in choosing one answer
- multiple choice allowing for multiple selections


## Missing Data Encoding

There is missing data in the dataset for several reasons, which will be encoded
as follows in the parentheses:

- Conditioning (`-11`) - This is for values that cannot be answered because
  they do pass the condition for this question. E.g. you can't answer a question
  about how long ago you finished a bootcamp if you answered `no` to finishing
  one.
- Not Selected (`-55`) - This is for values in questions where you can select
  multiple answers e.g. learning resources you find helpful. Some choices won't
  be selected and will be coded as so.
- Not Available (`-99`) - This is for when the surveyed skipped the question all
  together.


## Example Question Description

> ### Question 1
> 
> - **Question Type**: Single Answer
> - **Variable**: `quest1`
> - **Type**: Boolean
> - **Options**: Yes (1), No (0)
> - **Note**: This should have a value.


## Survey Questions and Metadata (Part 1)

### Are you already working as a software developer?

- **Question Type**: Single Answer
- **Variable**: `IsSoftwareDev`
- **Type**: Boolean
- **Options**: Yes (1), No (0)


### Would you prefer to...

- **Question Type**: Single Answer
- **Variable**: `JobPref`
- **Type**: Categorical
- **Options**:
    - work for a startup
    - start your own business
    - work for a multinational corporation
    - freelance
    - work for a medium-sized company


### Which one of these roles are you most interested in?

- **Question Type**: Single Answer (or User Input)
- **Variable**: `JobRoleInterest`
- **Type**: Categorical
- **Options**:
    - Front-End Web Developer
    - Mobile Developer
    - Data Scientist/Data Engineer
    - User Experience Designer
    - Back-End Web Developer
    - Full-Stack Web Developer
    - Quality Assurance Engineer
    - Product Manager
    - DevOps/SysAdmin
    - Other
- **Note**: The "Other" option gave the individual the freedom to type in
  whatever they wish. This field is the column directly after this question's
  column. Thus, this "Other" column is mostly empty.


### When do you plan to start applying for developer jobs?

- **Question Type**: Single Answer
- **Variable**: `JobApplyWhen`
- **Type**: Categorical
- **Options**:
    - I'm already applying
    - Within the next 6 months
    - Within 7 to 12 months
    - more than 12 months from now
    - I haven't decided


### About how much money do you expect to earn per year at your first developer job (in US Dollars)?

- **Question Type**: User Input
- **Variable**: `ExpectedEarning`
- **Type**: Numeric
- **Options**: User input
- **Note**: This is a free-text field. You'll need to parse through this for
  any input not in numeric form (e.g. "$56k")


### Would you prefer to work...

- **Question Type**: 
- **Variable** - `JobWherePref`
- **Type**: Categorical
- **Options**:
    - from home
    - no preference
    - in an office with other developers


## Are you willing to relocate for a job?

- **Question Type**: 
- **Variable**: `JobRelocate`
- **Type**: Boolean
- **Options**: Yes (1), No (0)


### Which types of in-person coding events have you attended?

- **Question Type**: 
- **Type**: Categorical/Boolean
- **Options**:
    - coffee-and-codes (`CodeEventCoffee`)
    - hackathons (`CodeEventHackathons`)
    - conferences (`CodeEventConference`)
    - NodeSchool (`CodeEventNodeSchool`)
    - RailsBridge (`CodeEventRailsBridge`)
    - Startup Weekend (`CodeEventStartUpWknd`)
    - Women Who Code (`CodeEventWomenCode`)
    - Girl Develop It (`CodeEventGirlDev`)
    - None (`CodeEventNone`)
    - Other (`CodeEventOther`)
- **Note**: This question allowed multiple options. Thus, each option has its
  own column named as the option itself. Each value of a cell in these columns
  were the option name itself. The "Other" category allowed for user input for
  their answer. The "Other" column is next to the other columns, given the raw
  data. Will need to normalize this text if present.


### Which learning resources have you found helpful?

- **Question Type**: 
- **Type**: Categorical/Boolean
- **Options**:
    - EdX (`ResourceEdX`)
    - Coursera (`ResourceCoursera`)
    - Free Code Camp (`ResourceFCC`)
    - Khan Academy (`ResourceKhanAcademy`)
    - Code School (Pluralsight) (`ResourcePluralsign`)
    - Codeacademy (`ResourceCodeacademy`)
    - Udacity (`ResourceUdacity`)
    - Udemy (`ResourceUdemy`)
    - Code Wars (`ResourceCodeWars`)
    - The Odin Project (`ResourceOdinProj`)
    - DevTips (`ResourceDevTips`)
    - Other (`ResourceOther`)
- **Note**: This question allowed multiple options. Thus, each option has its
  own column named as the option itself. Each value of a cell in these columns
  were the option name itself. The "Other" category allowed for user input for
  their answer. The "Other" column is next to the other columns, given the raw
  data.  Will need to normalize this text if present.


### Which coding-related podcasts have you found helpful?

- **Question Type**: 
- **Type**: Categorical/Boolean
- **Options**:
    - Code Newbie (`PodcastCodeNewbie`)
    - The Changelog (`PodcastChangelog`)
    - Software Engineering Daily (`PodcastSEDaily`)
    - JavaScript Jabber (`PodcastJSJabber`)
    - None (`PodcastNone`)
    - Other (`PodcastOther`)
- **Note**: This question allowed multiple options. Thus, each option has its
  own column named as the option itself. Each value of a cell in these columns
  were the option name itself. The "Other" category allowed for user input for
  their answer. The "Other" column is next to the other columns, given the raw
  data. Will need to normalize this text if present.


### About how many hours do you spend learning each week?

- **Question Type**: 
- **Variable**: `HoursLearning`
- **Type**: `Numeric`
- **Options**: User input


### About how many months have you been programming for?

- **Question Type**: 
- **Variable**: `MonthsProgramming`
- **Type**: Numeric
- **Options**: User input


### Have you attended a full-time coding bootcamp?

- **Question Type**: 
- **Variable**: `BootcampYesNo`
- **Type**: Boolean
- **Options**: Yes (1), No (0)


### Which one?

- **Question Type**: 
- **Variable**: `BootcampName`
- **Type**: Categorical
- **Options**: User input
- **Note**: This question allowed the surveyed to choose from a list of
  potential bootcamps they may have attended. Also, if their bootcamp was not
  available, they could input their bootcamp name.


### Have you finished yet?

- **Question Type**: 
- **Variable**: `BootcampFinish`
- **Type**: Boolean
- **Option**: Yes (1), No (0)
- **Note**: This variable will only exist if the surveyed named a bootcamp in
  the previous question.


### How many months ago?

- **Question Type**: 
- **Variable**: `BootcampMonthsAgo`
- **Type**: Numeric
- **Options**: User input
- **Note**: This variable will only exist if the surveyed answered yes to the
  previous questions.


### Were you able to get a full time developer job afterward?

- **Question Type**: 
- **Variable**: `BootcampFullJobAfter`
- **Type**: Boolean
- **Option**: Yes (1), No (0)
- **Note**: This variable will only exist if the surveyed answered yes to
  finishing the bootcamp.


### How much was your salary?

- **Question Type**: 
- **Variable**: `BootcampPostSalary`
- **Type**: Numeric
- **Option**: User input
- **Note**: This variable will only exist if the surveyed answered yes to
  whether they were able to get a full time developer job after their bootcamp.


### Did you take a loan to pay for the bootcamp?

- **Question Type**: 
- **Variable**: `BootcampLoan`
- **Type**: Boolean
- **Option**: Yes (1), No (0)
- **Note**: This variable will have a value if the surveyed answered yes to
  attending a bootcamp.


### Based on your experience, would you recommend this bootcamp to your friends?

- **Question Type**: 
- **Variable**: `BootcampRecommend`
- **Type**: Boolean
- **Option**: Yes (1), No (0)
- **Note**: This variable will have a value if the surveyed answered yes to
  attending a full-time coding bootcamp.


### Aside from university tuition, about how much money have you spent on learning to code so far (in US dollars)?

- **Question Type**: 
- **Variable**: `MoneyForLearning`
- **Type**: Numeric
- **Options**: User input
- **Note**: You'll need to parse this to make sure the data is indeed in
  numeric form.


### Start Date and Submit Date

- **Variable**: `Part1StartTime` and `Part1EndTime`
- **Type**: Date
- **Options**: Computer generated
- **Note**: These are two separate columns indicating the start and finish
  times for the survey.


### Network ID

- **Variable**: `NetworkID`
- **Type**: String
- **Options**: Computer generated
- **Note**: This is a unique identifier for the user.


## Survey Questions and Metadata (Part 2)

### How old are you?

- **Question Type**: 
- **Type**: Numeric
- **Options**: User input
- **Note**: You'll need to parse this to make sure the data is indeed in
  numeric form.


### What's your gender?

- **Question Type**: 
- **Type**: Categorical/Boolean
- **Options**:
    - female
    - male
    - agender
    - trans
    - genderqueer


### Which country are you a citizen of?

- **Question Type**: 
- **Type**: Categorical
- **Options**: Countries of the world
- **Note**: This field allowed free-text entry but gave options to choose from.


### Which country do you currently live in?

- **Question Type**: 
- **Type**: Categorical
- **Options**: Countries of the world
- **Note**: This field allowed free-text entry but gave options to choose from.


### About how many people live in your city?

- **Question Type**: 
- **Type**: Categorical
- **Options**:
    - less than 100,000
    - between 100,000 and 1 million
    - more than 1 million


### Are you an ethnic minority in your country?

- **Question Type**: 
- **Type**: Boolean
- **Options**: Yes (1), No (0)


### Which language do you speak at home with your family?

- **Question Type**: 
- **Type**: Categorical
- **Options**: Languages of the world
- **Note**: This field allowed free-text entry but gave options to choose from.


### What's the highest degree of level of school you have completed?

- **Question Type**: 
- **Type**: Categorical
- **Options**:
    - no high school (secondary school)
    - some high school
    - high school diploma or equivalent (GED)
    - some college credit, no degree
    - trade, technical, or vocational training
    - associate's degree
    - bachelor's degree
    - master's degree (non-professional)
    - professional degree (MBA, MD, JD, etc.)
    - Ph.D.


### What was the main subject your studied in university?

- **Question Type**: 
- **Type**: Categorical
- **Options**: User input
- **Note**: This field became open if you choose anything greater than trade,
  technical, or vocational training (i.e. associate's degree and greater).

### Do you financially support any dependents?

- **Question Type**: 
- **Type**: Boolean
- **Options**: Yes (1), No (0)


### Do you have any debt?

- **Question Type**: 
- **Type**: Boolean
- **Options**: Yes (1), No (0)


###  Do you have a home mortgage?

- **Question Type**: 
- **Type**: Boolean
- **Options**: Yes (1), No (0)
- **Note**: This option was given if you answered "Yes" to having debt.


### About how much do you owe on your home mortgage in US Dollars?

- **Question Type**: 
- **Type**: Numeric
- **Options**: User input
- **Note**: This option was given if you answered "Yes" to having a home
  mortgage. This question allowed user input. This will need to be screened and
  normalized based on varying answers.


### Do you have student loan debt?

- **Question Type**: 
- **Type**: Boolean
- **Options**: Yes (1), No (0)
- **Note**: This option was given if you answered "Yes" to having any debt.
  This question allowed user input. This will need to be screened and
  normalized based on varying answers.


### Regarding employment status, are you currently...

- **Question Type**: 
- **Type**: Categorical
- **Options**:
    - Employed for wages
    - Self-employed freelancer
    - Self-employed business owner
    - Doing an unpaid internship
    - Not working but looking for work
    - Not working and not looking for work
    - A stay-at-home parent or homemaker
    - Military
    - Retired
    - Unable to work
    - Other
- **Note**: The "Other" option, if selected, creates a new column for user
  input.


### Which field do you work in?

- **Question Type**: 
- **Type**: Categorical
- **Options**:
    - software development and IT
    - architecture or physical engineering
    - health care
    - education
    - finance
    - legal
    - sales
    - arts, entertainment, sports, or media
    - law enforcement and fire and rescue
    - food and beverage
    - office and administrative support
    - farming, fishing, and forestry
    - construction and extraction
    - transportation
    - Other
- **Note**: The "Other" option, if selected, creates a new column for user
  input.


### About how much money did you make last year in (US dollars)?

- **Question Type**: 
- **Type**: Numeric
- **Options**: User input
- **Note**: This field allowed user input so you'll need to parse this column
  to make sure the data is how you expect and want it to be.


### About how many minutes total do you spend commuting to and from work each day?

- **Question Type**: 
- **Type**: Numeric
- **Options**: User input
- **Note**: This field allowed user input so you'll need to parse this column
  to make sure the data is how you expect and want it to be.


### Do you consider yourself under-employed?

- **Question Type**: 
- **Type**: Boolean
- **Options**: Yes (1), No (0)
- **Note**: The explanation for this question was, "Under-employed means
  working a job that is below your education level?"


### Have you served in your country's military before?

- **Question Type**: 
- **Type**: Boolean
- **Options**: Yes (1), No (0)


### Do you receive disability benefits from your government?

- **Question Type**: 
- **Type**: Boolean
- **Options**: Yes (1), No (0)


### Do you have high speed internet at your home?

- **Question Type**: 
- **Type**: Boolean
- **Options**: Yes (1), No (0)


### Start Date and Submit Date

- **Type**: Date
- **Options**: Computer generated
- **Note**: These are two separate columns indicating the start and finish
  times for the survey.


### Network ID

- **Type**: String
- **Options**: Computer generated
- **Note**: This is a unique identifier for the user.
