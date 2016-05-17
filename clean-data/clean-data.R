# Clean and Combine Free Code Camp's 2016 New Coder Survey
# Author:           Eric Leung (@erictleung)
# Help from:        @evaristoc and @SamAI-Software
# Last Updated:     2016 May 15th

# Load in necessary packages
require(dplyr)

# Utility Functions ---------------------------------------
# Description:
#   These functions take in arguments to perform simplier transformations

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


# Sub-Process Functions -----------------------------------
# Description:
#   These functions perform larger grouped data transformations

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
#   The second dataset contains values from the first part of the survey. Some
#   of the yes/no questions were encoded as yes/no and 1/0. This function
#   serves to make them consistently into 1/0.
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
#   Change to Character
# Description:
#   Changes the data type of the given column names into character
# Input:
#   part1 = the part 1 dataset
#   toChr = string or vector of strings with column names needing change
# Output:
#   Changed part 1 dataset
# Usage:
#   > part1 <- change_to_chr(part1, toChr)
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
# Description:
#   Changes the data type of the given column names into double
# Input:
#   part2 = the part 2 dataset
#   toDbl = string or vector of strings with column names needing change
# Output:
#   Changed part 2 dataset
# Usage:
#   > part2 <- change_to_dbl(part2, toDbl)
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
#   Normalize Text
# Description:
#   Normalize text based on searching list and desired single replacement
#   using non-standard eval in dplyr: http://stackoverflow.com/a/26003971
# Input:
#   inData        = dplyr data frame,
#   columnName    = column you want to change,
#   search Terms  = search terms in a c() vector,
#   replaceWith   = replacement string
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
    searchStr <- paste(searchTerms, collapse = "|")
    wordIdx <- inData %>% select_(columnName) %>%
        mutate_each(funs(grepl(searchStr, ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)

    # Change row values to intended words
    wordData <- inData %>% filter(wordIdx) %>%
        mutate_(.dots = setNames(list(varval), columnName))

    # Combine data back together
    cleanData <- inData %>% filter(!wordIdx) %>% bind_rows(wordData)

    cleanData
}


# Title:
#   Create New Column Based on Grep
# Description:
#   This function will search for terms in a given column in the rows. It will
#   then add a column with the name of your choosing and label rows that
#   contain your search term as having that term i.e. give a value of "1".
# Input:
#   inData       = dplyr data frame,
#   colName      = column you want to target,
#   searchTerms  = search terms in a c() vector,
#   newCol       = name for new column
# Output:
#   dplyr data frame with new column
# Usage:
#   > cleanPart1 <- search_and_create(inData = cleanPart1,
#   + colName = "CodeEventOther", searchTerms = c("meetup", "meetup"),
#   + newCol = "CodeEventMeetups")
search_and_create <- function(inData, colName, searchTerms, newCol) {
    # Create new column with new name
    makeNew <- lazyeval::interp(~ as.character(NA))
    cleanData <- inData %>% mutate_(.dots = setNames(list(makeNew), newCol))

    # Create search criteria
    searchStr <- paste(searchTerms, collapse = "|")
    varval <- lazyeval::interp(~ grepl(s,c, ignore.case = TRUE),
                               s=searchStr,
                               c=as.name(colName))

    # Label target rows as belonging to new column group
    mut <- lazyeval::interp(~ ifelse(test = grepl(s, c, ignore.case = TRUE),
                                     yes = "1",
                                     no = NA),
                            s=searchStr,
                            c=as.name(colName))
    cleanData <- cleanData %>%
        mutate_(.dots = setNames(list(mut), newCol))

    cleanData
}


# Title:
#   Helper Function
# Description:
#   Temporary function to use to check if regular expression is targeting the
#   rows we think it should be targeting.
# Input:
#   part      = dplyr data frame,
#   col       = column you want to target,
#   words     = string or vector of strings you want to search for,
#   printYes  = default to NA to just view data, set to 1 to print our data
#               frame, and set to anything else to count number of instances
# Usage:
#   > part <- part2
#   > col <- "MoneyForLearning"
#   > words <- c("[^0-9]")
#   > helper_filter(part, col, words)     # To View
#   > helper_filter(part, col, words, 1)  # To print data to console
#   > helper_filter(part, col, words)     # To print number of instances
helper_filter <- function(part, col, words, printYes = NA) {
    # Helper code to look at data being filtered to be changed
    columnToLookAt <- col # Column name you want to examine
    wordSearch <- words %>% # Array of regular expressions to search
        paste(collapse = "|")
    charIdx <- part %>% select_(columnToLookAt) %>%
        mutate_each(funs(grepl(wordSearch, ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    if (is.na(printYes)) {
        part %>% filter(charIdx) %>% count_(columnToLookAt) %>% View
    } else if (printYes == 1) {
        part %>% filter(charIdx) %>% select_(columnToLookAt) %>%
            distinct() %>% as.data.frame
    } else {
        part %>% filter(charIdx) %>% count_(columnToLookAt) %>%
            summarise(total = sum(n))
    }
}


# Sub-Cleaning Functions ----------------------------------
# Description:
#   These functions perform cleaning on specific variables in the data

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
#   Clean Job Role Interest
# Description:
#   This function targets the other job interests people put down and performs
#   some cleaning:
#   - Normalize variants of "Undecided"
#   - Normalize variants of "Cyber Security"
#   - Normalize variants of "Game Developer"
#   - Normalize variants of "Software Engineer"
# Usage:
#   > cleanPart <- clean_job_interest(part)
clean_job_interest <- function(part) {
    cat("Cleaning responses for other job interests...\n")

    ## Title case answers for other job interests
    ##  See if I can simplify this by just mutating
    jobRoleOtherYes <- part %>% filter(!is.na(JobRoleInterestOther)) %>%
        mutate(JobRoleInterestOther = simple_title_case(JobRoleInterestOther))
    jobRoleOtherNo <- part %>% filter(is.na(JobRoleInterestOther))
    cleanPart <- jobRoleOtherNo %>% bind_rows(jobRoleOtherYes)

    ## Change uncertain job roles to "Undecided"
    undecidedWords <- c("not sure", "don't know", "not certain",
                        "unsure", "dont know", "undecided",
                        "all of the above", "no preference", "not",
                        "any", "no idea")
    cleanPart <- normalize_text(inData = cleanPart,
                                columnName = "JobRoleInterestOther",
                                searchTerms = undecidedWords,
                                replaceWith = "Undecided")

    ## Normalize cyber security interests to "Cyber Security"
    ##  e.g. "Cyber security" == "Cybersercurity"
    cyberWords <- c("cyber", "secure", "penetration tester",
                    "pentester", "security")
    cleanPart <- normalize_text(inData = cleanPart,
                                columnName = "JobRoleInterestOther",
                                searchTerms = cyberWords,
                                replaceWith = "Cyber Security")

    ## Normalize game developer interests to "Game Developer"
    gameWords <- c("game", "games")
    cleanPart <- normalize_text(inData = cleanPart,
                                columnName = "JobRoleInterestOther",
                                searchTerms = gameWords,
                                replaceWith = "Game Developer")

    ## Normalize software engineer interests to "Software Engineer"
    softwareWords <- c("software")
    cleanPart <- normalize_text(inData = cleanPart,
                                columnName = "JobRoleInterestOther",
                                searchTerms = softwareWords,
                                replaceWith = "Software Engineer")

    cat("Finished cleaning responses for other job interests.\n")
    cleanPart
}


# Title:
#   Clean Code Events
# Description:
#   The function performs various transformations to coding event data to make
#   it consistent (e.g. fix spelling) and normalize instances of answers to be
#   the same.
# Usage:
#   > cleanPart <- clean_code_events(cleanPart)
clean_code_events <- function(cleanPart1) {
    # Convert coding events to binary/boolean
    codeResources <- cleanPart1 %>%
        select(starts_with("CodeEvent"), -CodeEventOther) %>%
        mutate_each(funs(ifelse(!is.na(.), "1", NA)))
    cleanPart1 <- cleanPart1 %>%
        select(-starts_with("CodeEvent"), CodeEventOther) %>%
        bind_cols(codeResources)

    # Title case other coding events
    codingEvents <- cleanPart1 %>% filter(!is.na(CodeEventOther)) %>%
        mutate(CodeEventOther = simple_title_case(CodeEventOther))
    codeEventsElse <- cleanPart1 %>% filter(is.na(CodeEventOther))
    cleanPart1 <- codeEventsElse %>% bind_rows(codingEvents)

    # Normalize variations of "meetup" to "Meetups"
    meetupWords <- c("meetup", "meet")
    cleanPart1 <- normalize_text(inData = cleanPart1,
                                 columnName = "CodeEventOther",
                                 searchTerms = meetupWords,
                                 replaceWith = "Meetup(s)")

    # Normalize FreeCodeCamp
    fccWords <- c("fcc", "freecodecamp", "free code camp")
    cleanPart1 <- normalize_text(inData = cleanPart1,
                                 columnName = "CodeEventOther",
                                 searchTerms = fccWords,
                                 replaceWith = "Free Code Camp")

    # Normalize variations of "None"
    nones <- c("non", "none", "haven't", "havent", "not", "nothing",
               "didn't", "n/a", "\bna\b", "never", "nil", "nope")
    searchStr <- paste(nones, collapse = "|")
    nonesIdx <- cleanPart1 %>% select(CodeEventOther) %>%
        mutate_each(funs(grepl(searchStr, ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    nonesData <- cleanPart1 %>% filter(nonesIdx) %>%
        mutate(CodeEventOther = NA) %>%
        mutate(CodeEventNone = "1")
    cleanPart1 <- cleanPart1 %>% filter(!nonesIdx) %>% bind_rows(nonesData)

    # Normalize "bootcamps"
    bootcamps <- c("^bootcamp")
    cleanPart1 <- normalize_text(inData = cleanPart1,
                                 columnName = "CodeEventOther",
                                 searchTerms = bootcamps,
                                 replaceWith = "Bootcamp")

    # Normalize "Rails Girls"
    railsGirls <- c("^rails? ?girls$")
    cleanPart1 <- normalize_text(inData = cleanPart1,
                                 columnName = "CodeEventOther",
                                 searchTerms = railsGirls,
                                 replaceWith = "Rails Girls")

    # Normalize "Game Jams" to "Game Jam(s)"
    gameJams <- c("game.*?jams?")
    cleanPart1 <- normalize_text(inData = cleanPart1,
                                 columnName = "CodeEventOther",
                                 searchTerms = gameJams,
                                 replaceWith = "Game Jam(s)")

    cleanPart1
}


# Title:
#   Clean Podcasts
# Description:
#   Cleans the podcasts answers in general but mostly cleans people's answers
#   for "Other". Performs the following:
#   - Convert Podcasts to binary/boolean
#   - Normalize variations of "None" in Podcast Other back to designated col
#   - Normalize variations of "Software Engineering Daily" in Podcast Other
#     back to designated column
#   - Add new columns for other podcasts greater than 15 mentions
#       - "Ruby Rogues"
#       - "Shop Talk Show"
#       - "Developer Tea"
#       - "Programming Throwdown"
#       - ".NET Rocks"
#       - "Talk Python to Me"
#       - "JavaScript Air"
#       - The Web Ahead"
#   - NOTE: honorable mentions to get their own column
#       - "Code Pen Radio"
#       - "Trav and Los"
#       - "Giant Robots Smashing into other Giant Robots"
clean_podcasts <- function(cleanPart) {
    cat("Cleaning responses for other podcasts...\n")

    # Convert Podcasts to binary/boolean
    podcasts <- cleanPart %>%
        select(starts_with("Podcast"), -PodcastOther) %>%
        mutate_each(funs(ifelse(!is.na(.), "1", NA)))
    cleanPart <- cleanPart %>%
        select(-starts_with("Podcast"), PodcastOther) %>%
        bind_cols(podcasts)

    # Normalize variations of "None" in PodcastOther
    nonePod <- c("non", "none", "haven't", "havent", "not a",
                 "nothing", "didn't", "n/a", "\bna\b", "never",
                 "nil", "nope", "not tried", "have not", "do not",
                 "don't")
    searchStr <- paste(nonePod, collapse = "|")
    nonesPodIdx <- cleanPart %>% select(PodcastOther) %>%
        mutate_each(funs(grepl(searchStr, ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    nonesPodData <- cleanPart %>% filter(nonesPodIdx) %>%
        mutate(PodcastOther = NA) %>%
        mutate(PodcastNone = "1")
    cleanPart <- cleanPart %>% filter(!nonesPodIdx) %>%
        bind_rows(nonesPodData)

    # Normalize variations of "Software Engineering Daily" in PodcastOther
    sePod <- c("software engineering")
    searchStr <- paste(sePod, collapse = "|")
    sePodIdx <- cleanPart %>% select(PodcastOther) %>%
        mutate_each(funs(grepl(searchStr, ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    sePodData <- cleanPart %>% filter(sePodIdx) %>%
       mutate(PodcastSEDaily = "1")
    cleanPart <- cleanPart %>% filter(!sePodIdx) %>%
        bind_rows(sePodData)

    # New column for "Ruby Rogues"
    rubyRogues <- c("rubyRogues", "ruby rogues", "ruby rogue")
    cleanPart <- search_and_create(inData = cleanPart,
                                   colName = "PodcastOther",
                                   searchTerms = rubyRogues,
                                   newCol = "PodcastOtherRubyRogues")

    # New column for "Shop Talk Show"
    shopTalk <- c("shoptalk", "shop talk", "talk shop show",
                  "shoptalkshow", "shop talk show", "talkshop")
    cleanPart <- search_and_create(inData = cleanPart,
                                   colName = "PodcastOther",
                                   searchTerms = shopTalk,
                                   newCol = "PodcastOtherShopTalk")

    # New column for "Developer Tea"
    developerTea <- c("developertea", "developer's tea", "developer tea",
                      "devtea")
    cleanPart <- search_and_create(inData = cleanPart,
                                   colName = "PodcastOther",
                                   searchTerms = developerTea,
                                   newCol = "PodcastOtherDeveloperTea")

    # New column for "Programming Throwdown"
    progThrow <- c("programming throwdown", "programmer throwdown",
                   "programing throwdown")
    cleanPart <- search_and_create(inData = cleanPart,
                                  colName = "PodcastOther",
                                  searchTerms = progThrow,
                                  newCol = "PodcastOtherProgrammingThrowDown")

    # New column for ".Net Rocks"
    dotNet <- c("net rocks", "rocks", "dotnetrocks")
    cleanPart <- search_and_create(inData = cleanPart,
                                   colName = "PodcastOther",
                                   searchTerms = dotNet,
                                   newCol = "PodcastOtherDotNetRocks")

    # New column for "Talk Python to Me"
    talkPython <- c("talk python", "talkpython")
    cleanPart <- search_and_create(inData = cleanPart,
                                   colName = "PodcastOther",
                                   searchTerms = talkPython,
                                   newCol = "PodcastOtherTalkPython")

    # New column for "JavaScript Air"
    jsAir <- c("jsair", "js air", "javascript air")
    cleanPart <- search_and_create(inData = cleanPart,
                                   colName = "PodcastOther",
                                   searchTerms = jsAir,
                                   newCol = "PodcastOtherJsAir")

    # New column for "Hanselminutes"
    hansel <- c("hanselminutes")
    cleanPart <- search_and_create(inData = cleanPart,
                                   colName = "PodcastOther",
                                   searchTerms = hansel,
                                   newCol = "PodcastOtherHanselminutes")

    # New column for "The Web Ahead"
    webAhead <- c("web ahead")
    cleanPart <- search_and_create(inData = cleanPart,
                                   colName = "PodcastOther",
                                   searchTerms = webAhead,
                                   newCol = "PodcastOtherWebAhead")

    # New column for "Coding Blocks"
    codingBlocks <- c("codingblocks", "coding blocks")
    cleanPart <- search_and_create(inData = cleanPart,
                                   colName = "PodcastOther",
                                   searchTerms = codingBlocks,
                                   newCol = "PodcastOtherCodingBlocks")

    # Make other column just binary
    cleanPart <- cleanPart %>%
        mutate(PodcastOther = ifelse(!is.na(PodcastOther), "1", NA))

    cat("Finished cleaning responses for other podcasts.\n")
    cleanPart
}


# Title:
#   Clean Hours Learned Per Week
# Usage:
#   > cleanPart <- clean_hours_learn(cleanPart)
clean_hours_learn <- function(cleanPart) {
    cat("Cleaning responses for hours of learning per week...\n")

    ## Remove the word "hour(s)"
    hoursIdx <- cleanPart %>% select(HoursLearning) %>%
        mutate_each(funs(grepl("hours", ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    hoursData <- cleanPart %>% filter(hoursIdx) %>%
        mutate(HoursLearning = sub("hours.*", "", HoursLearning))
    cleanPart <- cleanPart %>% filter(!hoursIdx) %>% bind_rows(hoursData)

    ## Remove hyphen and "to" for ranges of hours
    rangeHrIdx <- cleanPart %>% select(HoursLearning) %>%
        mutate_each(funs(grepl("-|to", ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    rangeHrData <- cleanPart %>% filter(rangeHrIdx) %>%
        mutate(HoursLearning = average_string_range(HoursLearning))
    cleanPart <- cleanPart %>% filter(!rangeHrIdx) %>%
        bind_rows(rangeHrData)

    ## Remove hours greater than 100 hours
    cleanPart <- cleanPart %>%
        mutate(HoursLearning = as.integer(HoursLearning)) %>%
        mutate(HoursLearning = ifelse(HoursLearning > 100, NA, HoursLearning))

    cat("Cleaning responses for hours of learning per week...\n")
    cleanPart
}

# Main Process Functions ----------------------------------
# Description:
#   These functions encompass the bulk work of the cleaning and transformation

# Title:
#   Read in Data
# Description:
#   First function that should be run to read in the data for cleaning
# Usage:
#   > allData <- read_in_data()
#   > allData$part1 # access first part
#   > allData$part2 # access second part
read_in_data <- function() {
    cat("Reading in survey data for cleaning...\n")

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

    cat("Finished reading in survey data.\n")
    list(part1 = survey1, part2 = survey2)
}


# Title:
#   Rename Part 1 of Survey
# Description:
#   Changes column/variable names from questions to something easier to
#   remember and use
# Usage:
#   > cleanPart1 <- rename_part_1(dat$part1)
rename_part_1 <- function(part1) {
    cat("Renaming Part 1 of the survey...\n")
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

    cat("Finished renaming Part 1 of the survey.\n")
    newPart1
}


# Title:
#   Clean Survey
# Usage:
#   > final <- clean_part(allData)
clean_part <- function(part) {
    cat("Beginning cleaning of data...\n")

    cleanPart <- clean_job_interest(part)  # Clean Job Role Interests
    cleanPart <- clean_expected_earnings(cleanPart)  # Clean expected earnings
    cleanPart <- clean_code_events(cleanPart)  # Clean other coding events
    cleanPart <- clean_podcasts(cleanPart)  # Clean Podcasts Other
    cleanPart <- clean_hours_learn(cleanPart) # Clean hours spent learning

    # Clean months programming

    ## Change years to months
    yearsProgramIdx <- cleanPart %>% select(MonthsProgramming) %>%
        mutate_each(funs(grepl("years", ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    yearsProgramData <- cleanPart %>% filter(yearsProgramIdx) %>%
        mutate(MonthsProgramming = years_to_months(MonthsProgramming))
    cleanPart <- cleanPart %>% filter(!yearsProgramIdx) %>%
        bind_rows(yearsProgramData)

    ## Remove non-numeric characters
    cleanPart <- cleanPart %>% sub_and_rm(colName = "MonthsProgramming",
                              findStr = "[A-Za-z ]",
                              replaceStr = "")

    ## Average the range of months
    avgMonthIdx <- cleanPart %>% select(MonthsProgramming) %>%
        mutate_each(funs(grepl("-", ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    avgMonthData <- cleanPart %>% filter(avgMonthIdx) %>%
        mutate(MonthsProgramming = average_string_range(MonthsProgramming))
    cleanPart <- cleanPart %>% filter(!avgMonthIdx) %>%
        bind_rows(avgMonthData)


    ## Remove outlier months of programming
    ## 744 months = 62 years = 1954 = Year FORTRAN was invented
    cleanPart <- cleanPart %>%
        mutate(MonthsProgramming = as.integer(MonthsProgramming)) %>%
        mutate(MonthsProgramming = remove_outlier(MonthsProgramming, 744)) %>%
        mutate(MonthsProgramming = as.integer(MonthsProgramming))


    # Salary post bootcamp
    cleanPart <- cleanPart %>%
        mutate(BootcampPostSalary = remove_outlier(BootcampPostSalary, 1e10))


    # Money used for learning (not including tuition)

    ## Change variants of "None" to 0
    moneyNone <- c("nil", "none", "not")
    cleanPart <- cleanPart %>%
        normalize_text(columnName = "MoneyForLearning",
                       searchTerms = moneyNone,
                       replaceWith = "0")

    ## Remove dollar sign and other symbols not including periods
    cleanPart <- cleanPart %>% sub_and_rm(colName = "MoneyForLearning",
                                            findStr = "\\$|>|<|\\(|\\)",
                                            replaceStr = "")

    ## Remove other text
    cleanPart <- cleanPart %>% sub_and_rm(colName = "MoneyForLearning",
                                            findStr = "[A-Za-z ]",
                                            replaceStr = "")

    ## Average ranges
    avgLearnIdx <- cleanPart %>% select(MoneyForLearning) %>%
        mutate_each(funs(grepl("-", ., ignore.case = TRUE))) %>%
        unlist(use.names = FALSE)
    avgLearnData <- cleanPart %>% filter(avgLearnIdx) %>%
        mutate(MoneyForLearning = average_string_range(MoneyForLearning))
    cleanPart <- cleanPart %>% filter(!avgLearnIdx) %>%
        bind_rows(avgLearnData)


    cleanPart
}


# Title:
#   Rename Part 2 of Survey
# Description:
#   Changes column/variable names from questions to something easier to
#   remember and use
# Usage:
#   > part2 <- rename_part_2(dat$part2)
rename_part_2 <- function(part2) {
    cat("Renaming Part 2 of the survey...\n")
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

    cat("Finished renaming Part 2 of the survey.\n")
    newPart2
}


# Title:
#   Standardize Data Types
# Description:
#   There were some inconsistent encoding of data between the two datasets.
#       - Values passed from first part of survey were passed in as strings. So
#         empty answers were passed on as "undefined"
#       - The second dataset encoded yes/no answers as those strings, versus
#         the first dataset encoding it as 1/0
#       - For the question on when you plan on applying for jobs, some of the
#         answers were truncated at the apostrophe, so the answers were fixed
#         to what they were.
#       - Lastly, some of the numeric values were read into R as numeric, but
#         some were read in as double. So these numeric data types were
#         standarized to either character or double for ease of use later.
std_data_type <- function(part1, part2) {
    cat("Standardizing variables between data for joining...\n")

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

    cat("Finished standardizing variables between data.\n")
    list(part1=part1, part2=part2)
}


# Title:
#   Survey Parts Sanity Check
# Description:
#   After joining the two datasets together, there were some inconsistencies
#   with the survey times starting and ending. For example, for some joined
#   rows, the first part end time was more than 5 minutes before the second
#   part of the survey started.
#
#   This function first changes the Part 1 end time and the Part 2 start time
#   to the appropriate date datatype before manipulating them.
#
#   Cases:
#       - Remove negative time differences where 2nd part of survey started
#         before the 1st part ended
#       - Multiple first part ID's used in conjunction with second part ID's
#       - Multiple second part ID's used in conjunction with first part ID's
# Input:
#   dplyr data frame with joined datasets
# Output:
#   dplyr data frame with joined datasets
# Usage:
#   > allData <- time_diff_check(allData)
time_diff_check <- function(allData) {
    cat("Checking for inconsistencies within survey after joining...\n")

    # Change data type to date so we can easily compare times
    newData <- allData %>%
        mutate(Part1EndTime = as.POSIXct(Part1EndTime)) %>%
        mutate(Part2StartTime = as.POSIXct(Part2StartTime)) %>%
        mutate(OneTwoDiff = Part2StartTime - Part1EndTime)
    newData <- newData %>%
        select(noquote(order(colnames(newData))))

    # Separate data to focus on ones that we can look at differences
    newDataNA <- newData %>% filter(is.na(OneTwoDiff))
    newDataData <- newData %>% filter(!is.na(OneTwoDiff))

    # Remove neg times i.e. 2nd part of survey started before 1st part ended
    newDataData <- newDataData %>% filter(OneTwoDiff > 0)

    # Check for multiple first ID's put to second part ID's
    id1Unique <- newDataData %>% group_by(ID.x) %>%
        filter(n() == 1)
    id1Good <- newDataData %>% group_by(ID.x) %>%
        filter(n() > 1) %>%
        mutate(minDiff = min(OneTwoDiff)) %>%
        filter(OneTwoDiff == minDiff)
    newDataData <- bind_rows(id1Unique, id1Good) %>% select(-one_of("minDiff"))

    # Check for multiple second ID's put to first part ID's
    id2Unique <- newDataData %>% group_by(ID.y) %>%
        filter(n() == 1)
    id2Good <- newDataData %>% group_by(ID.y) %>%
        filter(n() > 1) %>%
        mutate(minDiff = min(OneTwoDiff)) %>%
        filter(OneTwoDiff == minDiff)
    newDataData <- bind_rows(id2Unique, id2Good) %>% select(-one_of("minDiff"))

    # Join two pieces back together
    newData <- bind_rows(newDataData, newDataNA)

    cat("Finished checking inconsistencies within survey after joining.\n")
    newData
}


# Main Function -------------------------------------------

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

    # Make variables between datasets consistent for joining
    consistentData <- std_data_type(part1, part2)

    # Join datasets together
    key <- c("IsSoftwareDev", "JobPref", "JobApplyWhen", "ExpectedEarning",
             "JobWherePref", "JobRelocate", "BootcampYesNo",
             "MonthsProgramming", "BootcampFinish",
             "BootcampFullJobAfter", "BootcampPostSalary", "BootcampLoan",
             "BootcampRecommend", "MoneyForLearning", "NetworkID",
             "HoursLearning", "BootcampMonthsAgo")
    allData <- left_join(consistentData$part1, consistentData$part2, by = key)

    # Check survey times and unique IDs
    allData <- time_diff_check(allData)

    # Clean both parts of the data
    final <- clean_part(allData)

    # Combine data and create cleaned data
    write.csv(x = final,
              file = "2016-FCC-New-Coders-Survey-Data.csv",
              na = "NA",
              row.names = FALSE)
}
# main()
