# Clean and Combine Free Code Camp's 2016 New Coder Survey
# Author:           Eric Leung (@erictleung)
# Help from:        @evaristoc and @SamAI-Software
# Last Updated:     2016 May 13th

# Load in necessary packages
require(dplyr)

# Title:
#   Read in Data
# Description:
#   First function that should be run to read in the data for cleaning
# Input:
#   None
# Output:
#   List with the 1st and 2nd parts of the survey
# Usage:
#   > allData <- read_in_data()
#   > allData$part1 # access first part
#   > allData$part2 # access second part
read_in_data <- function() {
    cat("Reading in survey data for cleaning...")

    # Set path of where data is
    part1Path <- "../raw-data/2016 New Coders Survey Part 1.csv"
    part2Path <- "../raw-data/2016 New Coders Part 2.csv"

    # Read in data
    survey1 <- read.csv(
        file = part1Path,
        stringsAsFactors = FALSE,
        na.strings = "") %>% tbl_df()
    survey2 <- read.csv(
        file = part2Path,
        stringsAsFactors = FALSE,
        na.strings = "") %>% tbl_df()

    cat("Finished reading in survey data.")
    list(part1 = survey1, part2 = survey2)
}


# Title:
#   Change All Undefined Values to NA
# Description:
#   The second dataset contains values from the first part of the survey.
#   Those were passed as values and the missing values (i.e. NA) were passed
#   as "undefined" and need to be transformed back.
# Input:
#   Designed for the second dataset
# Output:
#   The second dataset with all the undefined changed to NA
# Usage:
#   > part2 <- undefined_to_NA(part2)
undefined_to_NA <- function(part2, changeCols) {
    fixedPart2 <- part2
    for (col in changeCols) {
        varval <- lazyeval::interp(~ ifelse(colName == "undefined",
                                            yes = NA,
                                            no = colName),
                                   colName = as.name(col))
        fixedPart2 <- fixedPart2 %>%
            mutate_(.dots = setNames(list(varval), col))
    }
    fixedPart2
}


# Title:
#   Change All Yes/No to 1/0
# Description:
#   The second dataset contains values from the first part of the survey. The
#
# Input:
#   Designed for the second dataset
# Output:
#   The second dataset with all yes/no answers changed to 1/0
# Usage:
#   > part2 <- yesNo_to_oneZero(part2)
yesNo_to_oneZero <- function(part2, changeCols) {
    fixedPart2 <- part2
    for (col in changeCols) {
        varvalYes <- lazyeval::interp(~ ifelse(colName == "Yes",
                                               yes = "1",
                                               no = colName),
                                   colName = as.name(col))
        varvalNo <- lazyeval::interp(~ ifelse(colName == "No",
                                              yes = "0",
                                              no = colName),
                                   colName = as.name(col))
        fixedPart2 <- fixedPart2 %>%
            mutate_(.dots = setNames(list(varvalYes), col)) %>%
            mutate_(.dots = setNames(list(varvalNo), col))
    }
    fixedPart2
}


# Title:
#   Fix Truncated Job Apply Answer
# Description:
#   When passing answers from the first part of the survey to the next,
#   apostrophes were thrown out. E.g. if the answer was "I haven't decided",
#   it was truncated to "I"
# Input:
#   String or vector of strings
# Output:
#   String or vector of strings
# Usage:
fix_truncate_job_apply <- function(answer) {
    truncateAns <- c()
    for (i in 1: length(answer)) {
        tempAns <- answer[i] %>%
            unlist %>%
            ifelse(. == "I", "I'm already applying", .) %>%
            ifelse(. == "I haven", "I haven't decided", .)
        truncateAns <- c(truncateAns, tempAns)
    }
    truncateAns
}


# Title:
#   Change to Character
change_to_chr <- function(part1, toChr) {
    for (colName in toChr) {
        varval <- lazyeval::interp(~ as.character(colHere),
                                   colHere = as.name(colName))
        part1 <- part1 %>%
            mutate_(.dots = setNames(list(varval), colName))
    }
    part1
}


# Title:
#   Change to Double
change_to_dbl <- function(part2, toDbl) {
    for (colName in toDbl) {
        varval <- lazyeval::interp(~ as.double(colHere),
                                   colHere = as.name(colName))
        part2 <- part2 %>%
            mutate_(.dots = setNames(list(varval), colName))
    }
    part2
}


# Title:
#   Standardize Data Types to String [WIP]
# Description:
#   Make sure both data frames have the string data type for common columns
# Input:
#   part1 = first data set
#   part2 = second data set
#   changeCols = list of column names to change
# Output:
#   List with both parts
# Usage:
#   > bothParts <- standardize_data_types(part1, part2, changeCols)
#   > bothParts$part1 # Access first data set
#   > bothParts$part2 # Access second data set
standardize_data_types <- function(part1, part2, changeCols) {

    for (colName in changeCols) {
        varval <- lazyeval::interp(~ as.character(colHere), colHere = colName)
        subDirty <- dirtyDat %>% filter(dirtyIdx) %>%
            mutate_(.dots = setNames(list(varval), colName))

    }
}


# Title:
#   Remove Duplicate Rows [WIP]
# Description:
#   In the first dataset, there are potentially some entries that are
#   duplicates. This function will remove them based on the composite key given
# Input:
#   part1 = the first dataset
#   key = a vector containing the composite key of column names
# Output:
#   dplyr data frame
# Usage:
#   > part1 <- rm_duplicate(part1, key)
rm_duplicate <- function(part1, key) {

}


# Title:
#   Rename Part 1 of Survey
# Description:
#   Changes column/variable names from questions to something easier to
#   remember and use
# Input:
#   dplyr data frame
# Output:
#   dplyr data frame
# Usage:
#   > cleanPart1 <- rename_part_1(dat$part1)
rename_part_1 <- function(part1) {
    newPart1 <- part1 %>% rename(
        ID = X.
    ) %>% rename(
        IsSoftwareDev = Are.you.already.working.as.a.software.developer.
    ) %>% rename(
        JobPref = Would.you.prefer.to...
    ) %>% rename(
        JobRoleInterest = Which.one.of.these.roles.are.you.most.interested.in.
    ) %>% rename(
        JobRoleInterestOther = Other
    ) %>% rename(
        JobApplyWhen = When.do.you.plan.to.start.applying.for.developer.jobs.
    ) %>% rename(
        ExpectedEarning = About.how.much.money.do.you.expect.to.earn.per.year.at.your.first.developer.job..in.US.Dollars..
    ) %>% rename(
        JobWherePref = Would.you.prefer.to.work...
    ) %>% rename(
        JobRelocate = Are.you.willing.to.relocate.for.a.job.
    ) %>% rename(
        CodeEventCoffee = coffee.and.codes
    ) %>% rename(
        CodeEventHackathons = hackathons
    ) %>% rename(
        CodeEventConferences = conferences
    ) %>% rename(
        CodeEventNodeSchool = NodeSchool
    ) %>% rename(
        CodeEventRailsBridge = RailsBridge
    ) %>% rename(
        CodeEventStartUpWknd = Startup.Weekend
    ) %>% rename(
        CodeEventWomenCode = Women.Who.Code
    ) %>% rename(
        CodeEventGirlDev = Girl.Develop.It
    ) %>% rename(
        CodeEventNone = None
    ) %>% rename(
        CodeEventOther = Other.1
    ) %>% rename(
        ResourceEdX = EdX
    ) %>% rename(
        ResourceCoursera = Coursera
    ) %>% rename(
        ResourceFCC = Free.Code.Camp
    ) %>% rename(
        ResourceKhanAcademy = Khan.Academy
    ) %>% rename(
        ResourcePluralSight = Code.School..Pluralsight.
    ) %>% rename(
        ResourceCodeacademy = Codecademy
    ) %>% rename(
        ResourceUdacity = Udacity
    ) %>% rename(
        ResourceUdemy = Udemy
    ) %>% rename(
        ResourceCodeWars = Code.Wars
    ) %>% rename(
        ResourceOdinProj = The.Odin.Project
    ) %>% rename(
        ResourceDevTips = DevTips
    ) %>% rename(
        ResourceOther = Other.2
    ) %>% rename(
        PodcastCodeNewbie = Code.Newbie
    ) %>% rename(
        PodcastChangeLog = The.Changelog
    ) %>% rename(
        PodcastSEDaily = Software.Engineering.Daily
    ) %>% rename(
        PodcastJSJabber = JavaScript.Jabber
    ) %>% rename(
        PodcastNone = None.1
    ) %>% rename(
        PodcastOther = Other.3
    ) %>% rename(
        HoursLearning = About.how.many.hours.do.you.spend.learning.each.week.
    ) %>% rename(
        MonthsProgramming = About.how.many.months.have.you.been.programming.for.
    ) %>% rename(
        BootcampYesNo = Have.you.attended.a.full.time.coding.bootcamp.
    ) %>% rename(
        BootcampName = Which.one.
    ) %>% rename(
        BootcampFinish = Have.you.finished.yet.
    ) %>% rename(
        BootcampMonthsAgo = How.many.months.ago.
    ) %>% rename(
        BootcampFullJobAfter = Were.you.able.to.get.a.full.time.developer.job.afterward.
    ) %>% rename(
        BootcampPostSalary = How.much.was.your.salary.
    ) %>% rename(
        BootcampLoan = Did.you.take.out.a.loan.to.pay.for.the.bootcamp.
    ) %>% rename(
        BootcampRecommend = Based.on.your.experience..would.you.recommend.this.bootcamp.to.your.friends.
    ) %>% rename(
        MoneyForLearning = Aside.from.university.tuition..about.how.much.money.have.you.spent.on.learning.to.code.so.far..in.US.dollars..
    ) %>% rename(
        Part1StartTime = Start.Date..UTC.
    ) %>% rename(
        Part1EndTime = Submit.Date..UTC.
    ) %>% rename(
        NetworkID = Network.ID
    )

    newPart1
}


# Title:
#   Simple Title Case Function
# Description:
#    Intended to use in mutate functions to title case strings
# Input:
#    List of strings or just a string itself
# Output:
#    List of strings or just a string itself
# Usage:
#   > simple_title_case("hello world")
#   [1] "Hello World"
#   > simple_title_case(c("hello world", "simple title case"))
#   [1] "Hello World"       "Simple Title Case"
# Adapted from: http://stackoverflow.com/a/6364905
simple_title_case <- function(x) {
    titleCase <- c()
    for (i in 1:length(x)) {
        s <- strsplit(x[i], " ")[[1]]
        titleS <- paste(toupper(substring(s, 1,1)), substring(s, 2),
                        sep="", collapse=" ")
        titleCase <- c(titleCase, titleS)
    }
    titleCase
}


# Title:
#   Average Range Earning
# Description:
#   Take a range string (e.g. "50-60000") and take average (e.g. "55"). In
#   this case, there is a string "50-60000" because there was a "k" at the end
#   I removed earlier
# Input:
#   String or vector
# Output:
#   String or vector
# Usage:
#   > average_range_earning("50-60000")
#   [1] "55000"
#   > average_range_earning("50-60")
#   [1] "55000"
average_range_earning <- function(x) {
    avgRange <- c()
    for (i in 1: length(x)) {
        tempRange <- x[i] %>% strsplit("-") %>%
            unlist %>%
            as.numeric %>%
            ifelse(. < 100, . * 1000, .) %>%
            mean %>%
            as.character()
        avgRange <- c(avgRange, tempRange)
    }
    avgRange
}


# Title:
#   Substitution function [WIP]
# Description:
#   Used directly on a dplyr data frame to grep substitute
# Input:
#   dplyr data frame
# Output:
#   dplyr data frame
sub_and_rm <- function(dirtyDat, colName, findStr, replaceStr) {
    varval <- lazyeval::interp(~ gsub(f, r, c),
                               f=findStr,
                               r=replaceStr,
                               c=as.name(colName))

    dirtyIdx <- dirtyDat %>% select_(colName) %>%
        mutate_each(funs(grepl(findStr, ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    subDirty <- dirtyDat %>% filter(dirtyIdx) %>%
        mutate_(.dots = setNames(list(varval), colName))

    cleanDat <- dirtyDat %>% filter(!dirtyIdx) %>% bind_rows(subDirty)

    cleanDat
}


# Title:
#   Clean Expected Earnings
# Description:
#   For the expected earnings part of the survey, this function performs all
#   the necessary cleaning on that part of the data
clean_expected_earnings <- function(cleanPart1) {
    # Remove dollar signs from expected earnings
    dollarIdx <- cleanPart1 %>% select(ExpectedEarning) %>%
        mutate_each(funs(grepl("\\$", ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    dollarData <- cleanPart1 %>% filter(dollarIdx) %>%
        mutate(ExpectedEarning = sub("\\$", "", ExpectedEarning))
    cleanPart1 <- cleanPart1 %>% filter(!dollarIdx) %>% bind_rows(dollarData)

    # Remove commas from expected earnings
    commaIdx <- cleanPart1 %>% select(ExpectedEarning) %>%
        mutate_each(funs(grepl(",", ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    commaData <- cleanPart1 %>% filter(commaIdx) %>%
        mutate(ExpectedEarning = sub(",", "", ExpectedEarning))
    cleanPart1 <- cleanPart1 %>% filter(!commaIdx) %>% bind_rows(commaData)

    # Remove "k" from expected earnings
    kIdx <- cleanPart1 %>% select(ExpectedEarning) %>%
        mutate_each(funs(grepl("k", ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    kData <- cleanPart1 %>% filter(kIdx) %>%
        mutate(ExpectedEarning = sub("k", "000", ExpectedEarning))
    cleanPart1 <- cleanPart1 %>% filter(!kIdx) %>% bind_rows(kData)

    # Change range of expected earnings into average
    rangeIdx <- cleanPart1 %>% select(ExpectedEarning) %>%
        mutate_each(funs(grepl("-", ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    rangeData <- cleanPart1 %>% filter(rangeIdx) %>%
        mutate(ExpectedEarning = average_range_earning(ExpectedEarning))
    cleanPart1 <- cleanPart1 %>% filter(!rangeIdx) %>% bind_rows(rangeData)

    # Remove period from salaries like 50.000 which should be just 50000
    thousandsIdx <- cleanPart1 %>% select(ExpectedEarning) %>%
        mutate_each(funs(grepl("^\\d{2}\\.", ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    thousandsData <- cleanPart1 %>% filter(thousandsIdx) %>%
        mutate(ExpectedEarning = sub("\\.", "", ExpectedEarning))
    cleanPart1 <- cleanPart1 %>% filter(!thousandsIdx) %>%
        bind_rows(thousandsData)

    # Remove any non-numeric characters
    numericIdx <- cleanPart1 %>% select(ExpectedEarning) %>%
        mutate_each(funs(grepl("[A-Za-z]", ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    numericData <- cleanPart1 %>% filter(numericIdx) %>%
        mutate(ExpectedEarning = gsub("[A-Za-z']*", "", ExpectedEarning))
    cleanPart1 <- cleanPart1 %>% filter(!numericIdx) %>%
        bind_rows(numericData)

    # Change all values to numeric for easier manipulation
    cleanPart1 <- cleanPart1 %>%
        mutate(ExpectedEarning = as.integer(ExpectedEarning))

    # Expected values < 19 set to NA
    # Too weird to be monthly income and too small for yearly
    below19 <- cleanPart1 %>%
        filter(ExpectedEarning < 19)
    change19 <- below19 %>%
        mutate(ExpectedEarning = NA)
    cleanPart1 <- cleanPart1 %>% setdiff(below19) %>% bind_rows(change19)

    # Multiply expected 20--200 by 1000
    # Too small for monthly, large enough to be annual if 1000x
    values20to200 <- cleanPart1 %>%
        filter(ExpectedEarning >= 20) %>%
        filter(ExpectedEarning <= 200)
    change20to200 <- values20to200 %>%
        mutate(ExpectedEarning = ExpectedEarning * 1000)
    cleanPart1 <- cleanPart1 %>% setdiff(values20to200) %>%
        bind_rows(change20to200)

    # Remove expected values 201--499
    # Too high for annual, too small for monthly
    values201to499 <- cleanPart1 %>%
        filter(ExpectedEarning >= 201) %>%
        filter(ExpectedEarning <= 499)
    change201to499 <- values201to499 %>%
        mutate(ExpectedEarning = NA)
    cleanPart1 <- cleanPart1 %>% setdiff(values201to499) %>%
        bind_rows(change201to499)

    # Multiply values 500--5999 by 12
    # Looks like monthly salary for poor and middle-rich countries
    values500to5999 <- cleanPart1 %>%
        filter(ExpectedEarning >= 500) %>%
        filter(ExpectedEarning <= 5999)
    change500to5999 <- values500to5999 %>%
        mutate(ExpectedEarning = ExpectedEarning * 12)
    cleanPart1 <- cleanPart1 %>% setdiff(values500to5999) %>%
        bind_rows(change500to5999)

    # Set limit to 200000
    values200k <- cleanPart1 %>%
        filter(ExpectedEarning > 200000)
    change200k <- values200k %>%
        mutate(ExpectedEarning = 200000)
    cleanPart1 <- cleanPart1 %>% setdiff(values200k) %>%
        bind_rows(change200k)

    # Change to correct integers e.g. change 0000000 to just 0
    cleanPart1 <- cleanPart1 %>%
        mutate(ExpectedEarning = as.integer(ExpectedEarning)) %>%
        mutate(ExpectedEarning = as.character(ExpectedEarning))

    cleanPart1
}


# Title:
#   Normalize Text
# Description:
#   Normalize text based on searching list and desired single replacement
#   using non-standard eval in dplyr: http://stackoverflow.com/a/26003971
# Input:
#   inData = dplyr data frame,
#   columnName = column you want to change,
#   search Terms = search terms in a c() vector,
#   replaceWith = replacement string
# Output:
#   dplyr data frame
# Usage:
#   > cleanPart1 <- normalize_text(inData = cleanPart1,
#   + columnName = "JobRoleInterestOther",
#   + searchTerms = undecidedWords,
#   + replaceWith = "Undecided")
# More on NSE:
#   https://cran.r-project.org/web/packages/dplyr/vignettes/nse.html
# Adapted from:
#   http://stackoverflow.com/a/26766945
normalize_text <- function(inData, columnName, searchTerms, replaceWith) {
    # Setup dynamic naming of variables later in function
    varval <- lazyeval::interp(~ replaceText, replaceText = replaceWith)

    # Gets indices for rows that need to be changed
    wordIdx <- inData %>% select_(columnName) %>%
        mutate_each(
            funs(grepl(paste(searchTerms, collapse = "|"),
                       .,
                       ignore.case = TRUE)
            )
        ) %>% unlist(use.names = FALSE)

    # Change row values to intended words
    wordData <- inData %>% filter(wordIdx) %>%
        mutate_(.dots = setNames(list(varval), columnName))

    # Combine data back together
    cleanData <- inData %>% filter(!wordIdx) %>% bind_rows(wordData)

    cleanData
}


# Title:
#   Average String Range
# Description:
#   Take a range string (e.g. "50-60") and take average (e.g. "55").
average_string_range <- function(x) {
    avgRange <- c()
    for (i in 1:length(x)) {
        tempRange <- x[i] %>% strsplit("-|to") %>%
            unlist %>%
            as.numeric %>%
            mean %>%
            as.character()
        avgRange <- c(avgRange, tempRange)
    }
    avgRange
}


# Title:
#   Change Years to Months
# Description:
#   Remove non-numeric characters and change years to months
# Input:
#   String or vector of strings
# Output:
#   String or vector of strings
# Usage:
#   > years_to_months("3")
#   [1] "36"
#   > years_to_months(c("6", "3", "5"))
#   [1] "72" "36" "60"
years_to_months <- function(x) {
    monthsDat <- c()
    for (i in 1:length(x)) {
        tempMonths <- x[i] %>% gsub("[A-Za-z ]", "", .) %>%
            (function (x) as.numeric(x) * 12) %>%
            as.character()
        monthsDat <- c(monthsDat, tempMonths)
    }
    monthsDat
}


# Title:
#   Remove Outliers
# Description:
#   This function remove outliers based on threshold where anything equal to
#   it or above it is changed to an NA
# Input:
#   Numbers and a threshold
# Output:
#   Numbers
# Usage:
#   > remove_outlier(20, 2)
#   [1] NA
#   > remove_outlier(c(1, 2, 3, 4, 5, 6), 4)
#   [1]  1  2  3 NA NA NA
remove_outlier <- function(x, thres) {
    ifelse(test = x >= thres, yes = as.numeric(NA), no = x)
}


# Clean Part 1 of survey
clean_part_1 <- function(part1) {
    # Job Role Interests

    ## Title case answers for other job interests
    ##  See if I can simplify this by just mutating
    jobRoleOtherYes <- part1 %>% filter(!is.na(JobRoleInterestOther)) %>%
        mutate(JobRoleInterestOther = simple_title_case(JobRoleInterestOther))
    jobRoleOtherNo <- part1 %>% filter(is.na(JobRoleInterestOther))
    cleanPart1 <- jobRoleOtherNo %>% bind_rows(jobRoleOtherYes)

    ## Change uncertain job roles to "Undecided"
    undecidedWords <- c("not sure", "don't know", "not certain",
                        "unsure", "dont know", "undecided",
                        "all of the above", "no preference", "not",
                        "any", "no idea")
    cleanPart1 <- normalize_text(inData = cleanPart1,
                   columnName = "JobRoleInterestOther",
                   searchTerms = undecidedWords,
                   replaceWith = "Undecided")

    ## Normalize cyber security interests to "Cyber Security"
    ##  e.g. "Cyber security" == "Cybersercurity"
    cyberWords <- c("cyber", "secure", "penetration tester",
                    "pentester", "security")
    cleanPart1 <- normalize_text(inData = cleanPart1,
                   columnName = "JobRoleInterestOther",
                   searchTerms = cyberWords,
                   replaceWith = "Cyber Security")

    ## Normalize game developer interests to "Game Developer"
    gameWords <- c("game", "games")
    cleanPart1 <- normalize_text(inData = cleanPart1,
                   columnName = "JobRoleInterestOther",
                   searchTerms = gameWords,
                   replaceWith = "Game Developer")

    ## Normalize software engineer interests to "Software Engineer"
    softwareWords <- c("software")
    cleanPart1 <- normalize_text(inData = cleanPart1,
                   columnName = "JobRoleInterestOther",
                   searchTerms = softwareWords,
                   replaceWith = "Software Engineer")

    # Clean expected earnings column
    cleanPart1 <- clean_expected_earnings(cleanPart1)


    # Code Events Other

    ## Convert coding events to binary/boolean
    codeResources <- cleanPart1 %>%
        select(starts_with("CodeEvent"), -CodeEventOther) %>%
        mutate_each(funs(ifelse(!is.na(.), "1", NA)))
    cleanPart1 <- cleanPart1 %>%
        select(-starts_with("CodeEvent"), CodeEventOther) %>%
        bind_cols(codeResources)

    ## Title case other coding events
    codingEvents <- cleanPart1 %>% filter(!is.na(CodeEventOther)) %>%
        mutate(CodeEventOther = simple_title_case(CodeEventOther))
    codeEventsElse <- cleanPart1 %>% filter(is.na(CodeEventOther))
    cleanPart1 <- codeEventsElse %>% bind_rows(codingEvents)

    ## Normalize variations of "meetup" to "Meetups"
    meetupWords <- c("meetup", "meet")
    cleanPart1 <- normalize_text(inData = cleanPart1,
                   columnName = "CodeEventOther",
                   searchTerms = meetupWords,
                   replaceWith = "Meetup(s)")

    ## Normalize FreeCodeCamp
    fccWords <- c("fcc", "freecodecamp", "free code camp")
    cleanPart1 <- normalize_text(inData = cleanPart1,
                                 columnName = "CodeEventOther",
                                 searchTerms = fccWords,
                                 replaceWith = "Free Code Camp")

    ## Normalize variations of "None"
    nones <- c("non", "none", "haven't", "havent", "not", "nothing",
               "didn't", "n/a", "\bna\b", "never", "nil", "nope")
    nonesIdx <- cleanPart1 %>% select(CodeEventOther) %>%
        mutate_each(
            funs(grepl(paste(nones, collapse = "|"),
                       .,
                       ignore.case = TRUE)
                 )
            ) %>% unlist(use.names = FALSE)
    nonesData <- cleanPart1 %>% filter(nonesIdx) %>%
        mutate(CodeEventOther = NA) %>%
        mutate(CodeEventNone = "1")
    cleanPart1 <- cleanPart1 %>% filter(!nonesIdx) %>% bind_rows(nonesData)

    ## Normalize "bootcamps"
    bootcamps <- c("^bootcamp")
    cleanPart1 <- normalize_text(inData = cleanPart1,
                                 columnName = "CodeEventOther",
                                 searchTerms = bootcamps,
                                 replaceWith = "Bootcamp")

    ## Normalize "Rails Girls"
    railsGirls <- c("^rails? ?girls$")
    cleanPart1 <- normalize_text(inData = cleanPart1,
                                 columnName = "CodeEventOther",
                                 searchTerms = railsGirls,
                                 replaceWith = "Rails Girls")

    ## Normalize "Game Jams" to "Game Jam(s)"
    gameJams <- c("game.*?jams?")
    cleanPart1 <- normalize_text(inData = cleanPart1,
                                 columnName = "CodeEventOther",
                                 searchTerms = gameJams,
                                 replaceWith = "Game Jam(s)")


    # Clean Podcasts Other

    ## Convert Podcasts to binary/boolean
    podcasts <- cleanPart1 %>%
        select(starts_with("Podcast"), -PodcastOther) %>%
        mutate_each(funs(ifelse(!is.na(.), "1", NA)))
    cleanPart1 <- cleanPart1 %>%
        select(-starts_with("Podcast"), PodcastOther) %>%
        bind_cols(podcasts)

    ## Normalize variations of "None" in PodcastOther
    nonePod <- c("non", "none", "haven't", "havent", "not a", "nothing",
               "didn't", "n/a", "\bna\b", "never", "nil", "nope", "not tried")
    nonesPodIdx <- cleanPart1 %>% select(PodcastOther) %>%
        mutate_each(
            funs(grepl(paste(nonePod, collapse = "|"),
                       .,
                       ignore.case = TRUE)
            )
        ) %>% unlist(use.names = FALSE)
    nonesPodData <- cleanPart1 %>% filter(nonesPodIdx) %>%
        mutate(PodcastOther = NA) %>%
        mutate(PodcastNone = "1")
    cleanPart1 <- cleanPart1 %>% filter(!nonesPodIdx) %>%
        bind_rows(nonesPodData)

    ## Normalize variations of "Ruby Rogues"
    ## Change to "Ruby Rogues" if listed first
    rubyRogues <- c("^rubyRogues", "^ruby rogues", "^ruby rogue")
    cleanPart1 <- normalize_text(inData = cleanPart1,
                                 columnName = "PodcastOther",
                                 searchTerms = rubyRogues,
                                 replaceWith = "Ruby Rogues")

    ## Normalize variations of "Shop Talk"
    ## Change to "Shop Talk" if listed first
    shopTalk <- c("^shoptalk", "^shop talk",
                    "^shoptalk show", "^shop talk show")
    cleanPart1 <- normalize_text(inData = cleanPart1,
                                 columnName = "PodcastOther",
                                 searchTerms = shopTalk,
                                 replaceWith = "Shop Talk Show")

    ## Normalize variations of "Developer Tea"
    ## Change to "Developer Tea" if listed first
    developerTea <- c("^developertea", "^developer's tea", "^developer tea")
    cleanPart1 <- normalize_text(inData = cleanPart1,
                                 columnName = "PodcastOther",
                                 searchTerms = developerTea,
                                 replaceWith = "Developer Tea")


    # Clean number of hours spent learning

    ## Remove the word "hour(s)"
    hoursIdx <- cleanPart1 %>% select(HoursLearning) %>%
        mutate_each(funs(grepl("hours", ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    hoursData <- cleanPart1 %>% filter(hoursIdx) %>%
        mutate(HoursLearning = sub("hours.*", "", HoursLearning))
    cleanPart1 <- cleanPart1 %>% filter(!hoursIdx) %>% bind_rows(hoursData)

    ## Remove hyphen and "to" for ranges of hours
    rangeHrIdx <- cleanPart1 %>% select(HoursLearning) %>%
        mutate_each(funs(grepl("-|to", ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    rangeHrData <- cleanPart1 %>% filter(rangeHrIdx) %>%
        mutate(HoursLearning = average_string_range(HoursLearning))
    cleanPart1 <- cleanPart1 %>% filter(!rangeHrIdx) %>%
        bind_rows(rangeHrData)

    ## Remove hours greater than 100 hours
    hoursLearnNumeric <- cleanPart1 %>%
        mutate(HoursLearning = as.integer(HoursLearning))
    weekHours <- hoursLearnNumeric %>%
        filter(HoursLearning > 100) %>%
        mutate(HoursLearning = as.integer(NA)) # Change to value later
    cleanPart1 <- hoursLearnNumeric %>%
        filter(!(ID %in% weekHours[["ID"]])) %>%
        bind_rows(weekHours) %>%
        mutate(HoursLearning = as.character(HoursLearning))


    # Clean months programming

    ## Change years to months
    yearsProgramIdx <- cleanPart1 %>% select(MonthsProgramming) %>%
        mutate_each(funs(grepl("years", ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    yearsProgramData <- cleanPart1 %>% filter(yearsProgramIdx) %>%
        mutate(MonthsProgramming = years_to_months(MonthsProgramming))
    cleanPart1 <- cleanPart1 %>% filter(!yearsProgramIdx) %>%
        bind_rows(yearsProgramData)

    ## Remove non-numeric characters
    cleanPart1 <- cleanPart1 %>% sub_and_rm(colName = "MonthsProgramming",
                              findStr = "[A-Za-z ]",
                              replaceStr = "")

    ## Average the range of months
    avgMonthIdx <- cleanPart1 %>% select(MonthsProgramming) %>%
        mutate_each(funs(grepl("-", ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    avgMonthData <- cleanPart1 %>% filter(avgMonthIdx) %>%
        mutate(MonthsProgramming = average_string_range(MonthsProgramming))
    cleanPart1 <- cleanPart1 %>% filter(!avgMonthIdx) %>%
        bind_rows(avgMonthData)


    ## Remove outlier months of programming
    ## 744 months = 62 years = 1954 = Year FORTRAN was invented
    cleanPart1 <- cleanPart1 %>%
        mutate(MonthsProgramming = as.integer(MonthsProgramming)) %>%
        mutate(MonthsProgramming = remove_outlier(MonthsProgramming, 744)) %>%
        mutate(MonthsProgramming = as.integer(MonthsProgramming))


    # Salary post bootcamp
    cleanPart1 <- cleanPart1 %>%
        mutate(BootcampPostSalary = remove_outlier(BootcampPostSalary, 1e10))

    # Money used for learning (not including tuition)

    ## Change variants of "None" to 0
    moneyNone <- c("nil", "none", "not")
    cleanPart1 <- cleanPart1 %>%
        normalize_text(columnName = "MoneyForLearning",
                       searchTerms = moneyNone,
                       replaceWith = "0")

    ## Remove dollar sign and other symbols not including periods
    cleanPart1 <- cleanPart1 %>% sub_and_rm(colName = "MoneyForLearning",
                                            findStr = "\\$|>|<|\\(|\\)",
                                            replaceStr = "")

    ## Remove other text
    cleanPart1 <- cleanPart1 %>% sub_and_rm(colName = "MoneyForLearning",
                                            findStr = "[A-Za-z ]",
                                            replaceStr = "")

    ## Average ranges
    avgLearnIdx <- cleanPart1 %>% select(MoneyForLearning) %>%
        mutate_each(funs(grepl("-", ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    avgLearnData <- cleanPart1 %>% filter(avgLearnIdx) %>%
        mutate(MoneyForLearning = average_string_range(MoneyForLearning))
    cleanPart1 <- cleanPart1 %>% filter(!avgLearnIdx) %>%
        bind_rows(avgLearnData)


    cleanPart1
}


# Rename Part 2 of survey
rename_part_2 <- function(part2) {
    newPart2 <- part2 %>% rename(
        ID = X.
    ) %>% rename(
        Age = How.old.are.you.
    ) %>% rename(
        Gender = What.s.your.gender.
    ) %>% rename(
        CountryCitizen = Which.country.are.you.a.citizen.of.
    ) %>% rename(
        CountryLive = Which.country.do.you.currently.live.in.
    ) %>% rename(
        CityPopulation = About.how.many.people.live.in.your.city.
    ) %>% rename(
        IsEthnicMinority = Are.you.an.ethnic.minority.in.your.country.
    ) %>% rename(
        LanguageAtHome = Which.language.do.you.you.speak.at.home.with.your.family.
    ) %>% rename(
        SchoolDegree = What.s.the.highest.degree.or.level.of.school.you.have.completed.
    ) %>% rename(
        SchoolMajor = What.was.the.main.subject.you.studied.in.university.
    ) %>% rename(
        HasFinancialDependents = Do.you.financially.support.any.dependents.
    ) %>% rename(
        MaritalStatus = What.s.your.marital.status.
    ) %>% rename(
        HasChildren = Do.you.have.children.
    ) %>% rename(
        ChildrenNumber = How.many.children.do.you.have.
    ) %>% rename(
        FinanciallySupporting = Do.you.financially.support.any.elderly.relatives.or.relatives.with.disabilities.
    ) %>% rename(
        DebtAmount = Do.you.have.any.debt.
    ) %>% rename(
        HasHomeMortgage = Do.you.have.a.home.mortgage.
    ) %>% rename(
        HomeMortgageOwe = About.how.much.do.you.owe.on.your.home.mortgage..in.US.Dollars..
    ) %>% rename(
        HasStudentDebt = Do.you.have.student.loan.debt.
    ) %>% rename(
        StudentDebtOwe = About.how.much.do.you.owe.in.student.loans..in.US.Dollars..
    ) %>% rename(
        EmploymentStatus = Regarding.employment.status..are.you.currently...
    ) %>% rename(
        EmploymentStatusOther = Other
    ) %>% rename(
        EmploymentField = Which.field.do.you.work.in.
    ) %>% rename(
        EmploymentFieldOther = Other.1
    ) %>% rename(
        Income = About.how.much.money.did.you.make.last.year..in.US.dollars..
    ) %>% rename(
        CommuteTime = About.how.many.minutes.total.do.you.spend.commuting.to.and.from.work.each.day.
    ) %>% rename(
        IsUnderEmployed = Do.you.consider.yourself.under.employed.
    ) %>% rename(
        HasServedInMilitary = Have.you.served.in.your.country.s.military.before.
    ) %>% rename(
        IsReceiveDiabilitiesBenefits = Do.you.receive.disability.benefits.from.your.government.
    ) %>% rename(
        HasHighSpdInternet = Do.you.have.high.speed.internet.at.your.home.
    ) %>% rename(
        IsSoftwareDev = already_working
    ) %>% rename(
        JobRoleInterest = jobs_interested_in
    ) %>% rename(
        JobPref = want_employment_type
    ) %>% rename(
        ExpectedEarning = expected_earnings
    ) %>% rename(
        JobWherePref = home_or_remote
    ) %>% rename(
        JobRelocate = will_relocate
    ) %>% rename(
        CodeEvent = attended_event_types
    ) %>% rename(
        Resources = learning_resources
    ) %>% rename(
        HoursLearning = hours_learning_week
    ) %>% rename(
        MonthsProgramming = months_learning
    ) %>% rename(
        BootcampYesNo = attend_bootcamp
    ) %>% rename(
        Bootcamp = which_bootcamp
    ) %>% rename(
        BootcampFinish = finished_bootcamp
    ) %>% rename(
        BootcampFullJobAfter = job_after_bootcamp
    ) %>% rename(
        BootcampPostSalary = bootcamp_salary
    ) %>% rename(
        BootcampLoan = loan_for_bootcamp
    ) %>% rename(
        BootcampRecommend = recommend_bootcamp
    ) %>% rename(
        MoneyForLearning = total_spent_learning
    ) %>% rename(
        BootcampMonthsAgo = months_ago_finished
    ) %>% rename(
        Podcast = podcast
    ) %>% rename(
        JobApplyWhen = how_soon_jobhunt
    ) %>% rename(
        Part2StartTime = Start.Date..UTC.
    ) %>% rename(
        Part2EndTime = Submit.Date..UTC.
    ) %>% rename(
        NetworkID = Network.ID
    )

    newPart2
}


# Clean Part 2 of survey [WIP]
clean_part_2 <- function(part2) {
    cleanPart2 <- part2

    # Helper code to look at data being filtered to be changed
    columnToLookAt <- "MoneyForLearning" # Column name you want to examine
    wordSearch <- c("[^0-9]") %>% # Array of regular expressions to search
        paste(collapse = "|")

    charIdx <- part2 %>% select_(columnToLookAt) %>%
        mutate_each(funs(grepl(wordSearch, ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    part2 %>% filter(charIdx) %>% select_(columnToLookAt) %>%
        distinct() %>% View
    #############################################

    cleanPart2
}


# Title:
#   Main Cleaning Function
# Description:
#   This is the main cleaning and transformation function. It will write a new
#   file in the `clean-data/` directory.
# Usage:
#   > main()
main <- function() {
    dat <- read_in_data() # Read in data

    # Change column names to something easier to use
    part1 <- rename_part_1(dat$part1)
    part2 <- rename_part_2(dat$part2)

    # Change the string "undefined" to built in "NA"
    changeCols <- c("IsSoftwareDev", "JobRoleInterest", "JobPref",
                    "ExpectedEarning", "JobWherePref", "JobRelocate",
                    "HoursLearning", "MonthsProgramming", "BootcampYesNo",
                    "BootcampFinish", "BootcampFullJobAfter",
                    "BootcampPostSalary", "BootcampLoan", "BootcampRecommend",
                    "MoneyForLearning", "BootcampMonthsAgo", "JobApplyWhen")
    part2 <- undefined_to_NA(part2, changeCols)

    # Change "Yes"/"No" to "1"/"0"
    changeCols <- c("IsSoftwareDev", "JobRelocate", "BootcampYesNo",
                    "BootcampFinish", "BootcampFullJobAfter", "BootcampLoan",
                    "BootcampRecommend")
    part2 <- yesNo_to_oneZero(part2, changeCols)

    # Fix truncated answers in when you're applying to jobs question
    part2 <- part2 %>%
        mutate(JobApplyWhen = fix_truncate_job_apply(JobApplyWhen))

    # Standardize data types between data sets to allow joining
    toChr <- c("IsSoftwareDev", "JobRelocate", "BootcampYesNo",
               "BootcampFinish", "BootcampFullJobAfter",
               "BootcampLoan", "BootcampRecommend")
    part1 <- change_to_chr(part1, toChr)
    toDbl <- c("BootcampMonthsAgo", "BootcampPostSalary")
    part2 <- change_to_dbl(part2, toDbl)

    # Join datasets together
    key <- c("IsSoftwareDev", "JobPref", "JobApplyWhen", "ExpectedEarning",
             "JobWherePref", "JobRelocate", "BootcampYesNo",
             "MonthsProgramming", "BootcampFinish",
             "BootcampFullJobAfter", "BootcampPostSalary", "BootcampLoan",
             "BootcampRecommend", "MoneyForLearning", "NetworkID",
             "HoursLearning")
    # Remove redundant columns when joined
    dropCol <- c("CodeEvent", "Resources", "Bootcamp", "Podcast")
    part2 <- part2 %>% select(-one_of(dropCol))
    allData <- left_join(part1, part2, by = key)

    # Clean both parts of the data
    part1 <- clean_part_1(part1)
    part2 <- clean_part_2(part2)

    # Combine data and create cleaned data
    write.csv(x = allData,
              file = "2016-FCC-New-Coders-Survey-Data.csv",
              na = "NA",
              row.names = FALSE)
}
main()
