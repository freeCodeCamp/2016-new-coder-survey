# Survey Data Dictionary

This file contains a list of the questions from the survey and descriptions on
what each question can have as an answer.


## Example

> ### Question 1
> 
> - **Type**: Boolean
> - **Options**: Yes (1), No (0)
> - **Note**: This should have a value.


## Survey Questions and Metadata (Part 1)

### Are you already working as a software developer?

- **Type**: Boolean
- **Options**: Yes (1), No (0)


### Would you prefer to...

- **Type**: Categorical
- **Options**:
    - work for a startup
    - start your own business
    - work for a multinational corporation
    - freelance
    - work for a medium-sized company


### Which one of these roles are you most interested in?

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

- **Type**: Categorical
- **Options**:
    - I'm already applying
    - Within the next 6 months
    - Within 7 to 12 months
    - more than 12 months from now
    - I haven't decided


### About how much month do you expect to earn per year at your first developer job (in US Dollars)?

- **Type**: Numeric
- **Options**: User input
- **Note**: This is a free-text field. You'll need to parse through this for any
  input not in numeric form (e.g. "$56k")


### Would you prefer to work...

- **Type**: Categorical
- **Options**:
    - from home
    - no preference
    - in an office with other developers


### Which types of in-person coding events have you attended?

- **Type**: Categorical/Boolean
- **Options**:
    - coffee-and-codes
    - hackathons
    - conference
    - NodeSchool
    - RailsBridge
    - Startup Weekend
    - Women Who Code
    - None
    - Other
- **Note**: This question allowed multiple options. Thus, each option has its
  own column named as the option itself. Each value of a cell in these columns
  were the option name itself. The "Other" category allowed for user input for
  their answer. The "Other" column is next to the other columns, given the raw
  data. Will need to normalize this text if present.


### Which learning resources have you found helpful?

- **Type**: Categorical/Boolean
- **Options**:
    - EdX
    - Coursera
    - Free Code Camp
    - Khan Academy
    - Code School (Pluralsight)
    - Codeacademy
    - Udacity
    - Udemy
    - Code Wars
    - The Odin Project
    - DevTips
    - Other
- **Note**: This question allowed multiple options. Thus, each option has its own
  column named as the option itself. Each value of a cell in these columns were
  the option name itself. The "Other" category allowed for user input for their
  answer. The "Other" column is next to the other columns, given the raw data.
  Will need to normalize this text if present.


### Which coding-related podcasts have you found helpful?

- **Type**: Categorical/Boolean
- **Options**:
    - Code Newbie
    - The Changelog
    - Software Engineering Daily
    - JavaScript Jabber
    - None
    - Other
- **Note**: This question allowed multiple options. Thus, each option has its
  own column named as the option itself. Each value of a cell in these columns
  were the option name itself. The "Other" category allowed for user input for
  their answer. The "Other" column is next to the other columns, given the raw
  data. Will need to normalize this text if present.


### About how many months have you been programming for?

- **Type**: Numeric
- **Options**: User input


### Have you attended a full-time coding bootcamp?

- **Type**: Boolean
- **Options**: Yes (1), No (0)


### Aside from university tuition, about how much money have you spent on learning to code so far (in US dollars)?

- **Type**: Numeric
- **Options**: User input
- **Note**: You'll need to parse this to make sure the data is indeed in
  numeric form.


## Survey Questions and Metadata (Part 2)

### How old are you?

- **Type**: Numeric
- **Options**: User input
- **Note**: You'll need to parse this to make sure the data is indeed in
  numeric form.


### What's your gender?

- **Type**: Categorical/Boolean
- **Options**:
    - female
    - male
    - agender
    - trans
    - genderqueer


### Which country are you a citizen of?

- **Type**: Categorical
- **Options**: Countries of the world
- **Note**: This field allowed free-text entry but gave options to choose from.


### Which country do you currently live in?

- **Type**: Categorical
- **Options**: Countries of the world
- **Note**: This field allowed free-text entry but gave options to choose from.


### About how many people live in your city?

- **Type**: Categorical
- **Options**:
    - less than 100,000
    - between 100,000 and 1 million
    - more than 1 million


### Are you an ethnic minority in your country?

- **Type**: Boolean
- **Options**: Yes (1), No (0)


### Which language do you speak at home with your family?

- **Type**: Categorical
- **Options**: Languages of the world
- **Note**: This field allowed free-text entry but gave options to choose from.


### What's the highest degree of level of school you have completed?

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

- **Type**: Categorical
- **Options**: User input
- **Note**: This field became open if you choose anything greater than trade,
  technical, or vocational training (i.e. associate's degree and greater).

### Do you financially support any dependents?

- **Type**: Boolean
- **Options**: Yes (1), No (0)


### Do you have any debt?

- **Type**: Boolean
- **Options**: Yes (1), No (0)


###  Do you have a home mortgage?

- **Type**: Boolean
- **Options**: Yes (1), No (0)
- **Note**: This option was given if you answered "Yes" to having debt.


### About how much do you owe on your home mortgage in US Dollars?

- **Type**: Numeric
- **Options**: User input
- **Note**: This option was given if you answered "Yes" to having a home
  mortgage. This question allowed user input. This will need to be screened and
  normalized based on varying answers.


### Do you have student loan debt?

- **Type**: Boolean
- **Options**: Yes (1), No (0)
- **Note**: This option was given if you answered "Yes" to having any debt.
  This question allowed user input. This will need to be screened and
  normalized based on varying answers.


### Regarding employment status, are you currently...

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

- **Type**: Numeric
- **Options**: User input
- **Note**: This field allowed user input so you'll need to parse this column
  to make sure the data is how you expect and want it to be.


### About how many minutes total do you spend commuting to and from work each day?

- **Type**: Numeric
- **Options**: User input
- **Note**: This field allowed user input so you'll need to parse this column
  to make sure the data is how you expect and want it to be.


### Do you consider yourself under-employed?

- **Type**: Boolean
- **Options**: Yes (1), No (0)
- **Note**: The explanation for this question was, "Under-employed means
  working a job that is below your education level?"


### Have you served in your country's military before?

- **Type**: Boolean
- **Options**: Yes (1), No (0)


### Do you receive disability benefits from your government?

- **Type**: Boolean
- **Options**: Yes (1), No (0)


### Do you have high speed internet at your home?

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
