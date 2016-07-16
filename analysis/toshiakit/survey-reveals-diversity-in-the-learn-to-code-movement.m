
%% Survey Reveals Diversity in the "Learn to Code" Movement
% Do you use any free "learn to code" website to teach yourself
% programming? You may already know how to program in MATLAB, but you may
% very well be learning other skills on
% <https://en.wikipedia.org/wiki/Massive_open_online_course MOOCs>.
% 
% Today's guest blogger, Toshi, analyzed a publicly available survey data 
% to understand the demographic of self-taught coders.  
% 
% <<matlab-academy.png>>
%  
%% Load Data
% I came across a Techcrunch article, <http://techcrunch.com/2016/05/04/free-code-camp-survey-reveals-demographics-of-self-taught-coders/ 
% Free Code Camp survey reveals demographics of self-taught coders>, and I got 
% curious because a lot of people seem to interested in learning how to code, 
% and industry and government are also encouraging this trend. But programming 
% is hard. Who exactly are the kind of people who have taken the plunge? Our own 
% free interactive online programming classes on <https://matlabacademy.mathworks.com/ 
% MATLAB Academy> or gamified <https://www.mathworks.com/matlabcentral/about/cody/ 
% MATLAB Cody> are also gaining popularity and I would like to understand what 
% motivates this interest. 
% 
% The survey was conducted anonymously and published on the web and promoted 
% via social media from March 28 through May 2, 2016, targeting people who are 
% relatively new to programming.
% 
% The following analysis shows significant diversity in gender and ethnic 
% mix among self-taught coders and the possible impact of MOOCs in opening up 
% access for under-served populations by traditional STEM education paths. 
% 
% I first downloaded the  <https://github.com/FreeCodeCamp/2016-new-coder-survey 
% 2016 New Coder Survey result from Github>. I then unzipped the CSV files into 
% my current folder. There are two files - part 1 and part 2 - and we will read 
% them into separate tables. We could perhaps merge them using |<http://www.mathworks.com/help/matlab/ref/innerjoin.html 
% innerjoin>|, but in this case I am primarily interested in part 2 only and we 
% will be discarding at least 1000 responses from part 1, given the differences 
% in number of responses. 

warning('off','MATLAB:table:ModifiedVarnames')              % suppress warning
csv = '2016 New Coders Survey Part 1.csv';                  % filename
part1 = readtable(csv);                                     % read into table
part1.Properties.VariableNames = ...                        % format variable names
    regexprep(part1.Properties.VariableNames,'_+$','');     % by removing extra "_"
csv = '2016 New Coders Part 2.csv';                         % filename
part2 = readtable(csv);                                     % read into table 
part2.Properties.VariableNames = ...                        % format variable names
    regexprep(part2.Properties.VariableNames,'_+$','');     % by removing extra "_"
warning('on','MATLAB:table:ModifiedVarnames')               % enable warning
part1.SubmitDate_UTC = datetime(part1.SubmitDate_UTC);      % convert date strings to datetime
part2.SubmitDate_UTC = datetime(part2.SubmitDate_UTC);      % convert date strings to datetime
s = sprintf('part1 %d responses from %s thru %s\n', ...     % summary of part1
    height(part1),datestr(min(part1.SubmitDate_UTC)), ...   % count of responses, start date
    datestr(max(part1.SubmitDate_UTC)));                    % and end date
fprintf('%spart2 %d responses from %s thru %s', ...         % summary of part2
    s,height(part2),datestr(min(part2.SubmitDate_UTC)), ... % count of responses, start date
    datestr(max(part2.SubmitDate_UTC)));                    % and end date
%% Higher Female Representation Than Expected
% Let's start by plotting a histogram of age distrubution. Loren pointed out 
% we can use the |omitnan| flag in |<http://www.mathworks.com/help/matlab/ref/median.html 
% median>| to deal with missing values instead of |<http://www.mathworks.com/help/stats/nanmedian.html 
% nanmedian>|. 
% 
% The histogram shows that a lot of people who responded to this survey fall 
% into the so-called "millenials" category. It is interesting to see the number 
% of women who responded to this survey, considering the often cited gender gap 
% in STEM fields. It is not clear if this reflects the true population or are 
% women are over-represented via self-selection? Or somehow self-teaching programming 
% more appealing to women than traditional instruction?

age = part2.HowOldAreYou;                                   % get age from part2
gender = categorical(part2.What_sYourGender);               % get gender from part2 as categorical
part2.What_sYourGender = gender;                            % update table
figure                                                      % new figure
x = age(age ~= 0 & gender == 'male');                       % subset age by gender
histogram(x)                                                % plot histogram
text(50,550, sprintf('Median Age (Male)   : %d', ...        % annotate
    median(x,'omitnan'))) 
text(50,470, sprintf('Mode Age (Male)     : %d',mode(x)))   % annotate
hold on                                                     % don't overwrite
x = age(age ~= 0 & gender == 'female');                     % subset age by gender
histogram(x)                                                % plot histogram
text(50,520, sprintf('Median Age (Female): %d', ...         % annotate
    median(x,'omitnan')))  
text(50,440, sprintf('Mode Age (Female)  : %d',mode(x)))    % annotate
hold off                                                    % restore default
title('Age Distribution by Gender')                         % add title
xlabel('Age')                                               % add x axis label
ylabel('Count')                                             % add y axis label
legend('Male','Female')                                     % add legend
%% Mostly Studying in Countries of Citizenship
% Since the survey was done online, anyone could participate. Let's check the 
% geographic breakdown. As you would expect, the largest portion of the responses 
% came from the US. You can also see that female responses were 40.59% of male 
% responses in the US, confirming high female representation in the responses. 
% 
% China is notably missing from the top 10 countries. Perhaps the "learn 
% to code" buzz has not caught on there?

part2.WhichCountryDoYouCurrentlyLiveIn = ...                % convert to categorical
    categorical(part2.WhichCountryDoYouCurrentlyLiveIn);           
country = part2.WhichCountryDoYouCurrentlyLiveIn;           % get country of residence
catcount = countcats(country);                              % get category count
cats = categories(country);                                 % get categories
[~, rank] = sort(catcount,'descend');                       % rank category by count
below_top10 = setdiff(cats,cats(rank(1:10)));               % categories below top 10
country = mergecats(country, below_top10, 'Other');         % merge them into other 
country = reordercats(country,[cats(rank(1:10));{'Other'}]);% reorder cats by ranking
ratio = sum(country == 'United States of America' & ...     % ratio of female/male in us
    gender == 'female')/sum(country == 'United States of America' & gender == 'male');
figure                                                      % new figure
histogram(country(gender == 'male'))                        % plot histogram
hold on                                                     % don't overwrite
histogram(country(gender == 'female'))                      % plot histogram 
hold off                                                    % restore default
ax = gca;                                                   % get current axes handle
ax.XTickLabelRotation = 90;                                 % rotate x tick label
title('Country of Residence by Gender')                     % add title
ylabel('Count')                                             % add y axis label
legend('Male','Female')                                     % add legend
text(1.5, 1900, sprintf('US Female/Male %.2f%%',ratio*100)) % annotate
%% 
% You can also visualize migration patterns by mapping countries of citizenship 
% to countries of residence. The number of edges are just 467 - meaning only 467 
% out of all 14,625 responses in part2 are from migrants, and most people live 
% and study in their countries of citizenship. If you take the ratio of immigration 
% over emigration, US, United Kingdom, Canada, Australia Germany and Russia enjoy 
% net gains from any <https://en.wikipedia.org/wiki/Human_capital_flight brain 
% drain>.

part2.WhichCountryAreYouACitizenOf = ...                    % convert to categorical
    categorical(part2.WhichCountryAreYouACitizenOf);           
citizenship = part2.WhichCountryAreYouACitizenOf;           % get country of citizenship
tbl = table(cellstr(citizenship),cellstr(country));         % create table of residence and citizenship 
tbl(isundefined(citizenship) & isundefined(country),:) = [];% drop empty rows
tbl.(1)(strcmp(tbl.(1),'<undefined>')) = ...                % use residence if citizenship is emtpy
    tbl.(2)(strcmp(tbl.(1),'<undefined>'));
tbl.(2)(strcmp(tbl.(2),'<undefined>')) = ...                % use citizenship if residence is emtpy
    tbl.(1)(strcmp(tbl.(2),'<undefined>'));
[tbl, ~, idx] = unique(tbl,'rows');                         % eliminate duplicate rows
w = accumarray(idx, 1);                                     % use count of duplicates as weight
G = digraph(tbl.(1), tbl.(2), w);                           % create a directed graph
indeg = indegree(G);                                        % get in-degrees
ratio = indeg./outdegree(G);                                % get ratio of in-degrees over out-degrees
figure                                                      % new figure
colormap cool                                               % set colormap
w = G.Edges.Weight;                                         % get weights
h = plot(G,'MarkerSize',log(indeg+2),'NodeCData',ratio, ... % plot directional graph
    'EdgeColor',[.7 .7 .7],'EdgeAlpha',0.3,'LineWidth',10*w/max(w));
caxis([0 3])                                                % set color axis scaling
axis([-2.8 3.3 -4.5 3.7])                                   % set axis limits
title({'Migration Pattern'; ...                             % add title
    '467 cases out of 14,625 responses (3.2%)'}) 
labelnode(h,cats(rank(1:10)),cats(rank(1:10)))              % label top 10 nodes
nlabels = {'Argentina','Azerbaijan','Chile','Congo', ...    % additional nodes to label
    'Cote D''Ivoire','Croatia','Greece','Guyana','Latvia','Lesotho', ...
    'Malta','Other','Paraguay','Philippines','Republic of Serbia','Romania'};
labelnode(h,nlabels,nlabels);                               % label additional nodes
h = colorbar;                                               % add colorbar
ylabel(h, 'in-degrees over out-degree ratio')               % add metric
%% Ethnically Diverse English Speakers in US
% Let's focus on the US. As noted earlier, most new self-taught coders who responded 
% to this survey were US citizens, but its ethnic makeup is very diverse. More 
% than half of the women are ethnic minorities, and so are 1/3 of men. They are 
% also predominantly English speakers, given the low ratio of immigrants. However, 
% we should note that the survey itself was in English and promoted via social 
% media in English.

isminority = part2.AreYouAnEthnicMinorityInYourCountry;     % get monority status
figure                                                      % new figure
subplot(1,2,1)                                              % create a subplot
x = gender(country == 'United States of America' ...        % subset 
    & isminority == 0);                                     % us non-minority
histogram(x)                                                % plot histogram
hold on                                                     % don't overwrite
x = gender(country == 'United States of America' ...        % subset gender 
    & isminority == 1);                                     % by us minority
histogram(x)                                                % plot histogram
hold off                                                    % restore default
title('US Gender by Ethnic Category')                       % add title
ylabel('Count')                                             % add y axis label
legend('Majority','Minority', 'Location','northwest')       % add legend
part2.WhichLanguageDoYouYouSpeakAtHomeWithYourFamily = ...  % convert to categorical
    categorical(part2.WhichLanguageDoYouYouSpeakAtHomeWithYourFamily);
lanuage = part2.WhichLanguageDoYouYouSpeakAtHomeWithYourFamily;% get language
usa = lanuage(country == 'United States of America');       % extract us data 
catcount = countcats(usa);                                  % get category count
cats = categories(usa);                                     % get categories
[~, rank] = sort(catcount,'descend');                       % rank category by count
below_top10 = setdiff(cats,cats(rank(1:10)));               % categories below top 10
usa = mergecats(usa, below_top10, 'Other');                 % merge them into other
usa = reordercats(usa,[cats(rank(1:10)); {'Other'}]);       % reorder cats by ranking
ax = gca;                                                   % get current axes handle
ax.XTickLabelRotation = 90;                                 % rotate x tick label
subplot(1,2,2)                                              % create a subplot
histogram(usa(gender(country == ...                         % plot histogram
    'United States of America') == 'male'))                 % subset us language by gender
hold on                                                     % don't overwrite
histogram(usa(gender(country == ...                         % plot histogram
    'United States of America') == 'female'))               % subset us language by gender
hold off                                                    % restore default
title('US Languages by Gender')                             % add title
ylabel('Count')                                             % add y axis label
legend('Male','Female')                                     % add legend
%% Many Are Highly Educated and Already Employed in the US
% We already know that a lot of people who take MOOCs had already earned college 
% degrees and have jobs. This survey also shows the same result. 

part2.What_sTheHighestDegreeOrLevelOfSchoolYouHaveCompleted = ... % convert to categorical
    categorical(part2.What_sTheHighestDegreeOrLevelOfSchoolYouHaveCompleted);
degree = part2.What_sTheHighestDegreeOrLevelOfSchoolYouHaveCompleted;% get degree
usa = degree(country == 'United States of America');        % extract us data
catcount = countcats(usa);                                  % get category count
cats = categories(usa);                                     % get categories
[~, rank] = sort(catcount,'descend');                       % rank category by count
usa = reordercats(usa,cats(rank));                          % reorder cats by ranking
figure                                                      % new figure
subplot(1,2,1)                                              % create a subplot
histogram(usa(gender(country == ...                         % plot histogram
    'United States of America') == 'male'))                 % subset us degree by gender
hold on                                                     % don't overwrite
histogram(usa(gender(country == ...                         % plot histogram
    'United States of America') == 'female'))               % subset us degree by gender
hold off                                                    % restore default
title('US Degrees by Gender')                               % add title
ylabel('Count')                                             % add y axis label
legend('Male','Female')                                     % add legend
part2.RegardingEmploymentStatus_AreYouCurrently = ...       % convert to categorical
    categorical(part2.RegardingEmploymentStatus_AreYouCurrently);
employment = part2.RegardingEmploymentStatus_AreYouCurrently;% get employment
other = part2.Other;                                        % get other in employment
isstudent = zeros(size(other));                             % set up an accumulator
fun = @(x,y) ~cellfun(@isempty,strfind(lower(x),y));        % anonymous function handle
isstudent(fun(other,'student')) = 1;                        % flag if 'studnet' is found
isstudent(fun(other,'studying')) = 1;                       % flag if 'studying' is found
isstudent(fun(other,'school')) = 1;                         % flag if 'school' is found
isstudent(fun(other,'university')) = 1;                     % flag if 'university' is found
isstudent(fun(other,'degree')) = 1;                         % flag if 'degree' is found
isstudent(fun(other,'phd')) = 1;                            % flag if 'phd' is found
employment(logical(isstudent)) = 'Student';                 % update employment
usa = employment(country == 'United States of America');    % extract us data
catcount = countcats(usa);                                  % get category count
cats = categories(usa);                                     % get categories
[~, rank] = sort(catcount,'descend');                       % rank category by count
usa = reordercats(usa,cats(rank));                          % reorder cats by ranking
subplot(1,2,2)                                              % create a subplot
histogram(usa(gender(country == ...                         % plot histogram
    'United States of America') == 'male'))                 % subset us employment by gender
hold on                                                     % don't overwrite
histogram(usa(gender(country == ...                         % plot histogram
    'United States of America') == 'female'))               % subset us employment by gender
hold off                                                    % restore default
title('US Employment by Gender')                            % add title
ylabel('Count')                                             % add y axis label
legend('Male','Female')                                     % add legend
%% Many Already Work In Software Development and IT in US
% It turns out that many respondents already work in software development and 
% IT fields and come from very diverse acadamic backgrounds, including both STEM 
% as well as non-STEM subjects. Since the proportion of women tends to be higher 
% in non-STEM majors, this may explain why we see higher than expected female 
% representation in this survey. It appears that female respondents who studied 
% non-STEM majors in undergraduate are now pursuing a career in software development. 
% 
% Curiously, we also see many computer science majors and they tend to be 
% men. Why are people who already have a computer science background pursuing 
% self-teaching programming? Shouldn't they have learned it in school?

part2.WhichFieldDoYouWorkIn = ...                           % convert to categorical
    categorical(part2.WhichFieldDoYouWorkIn);               
job = part2.WhichFieldDoYouWorkIn;                          % get job
job = mergecats(job, {'software development and IT', ...    % merge similar categories
    'software development'});
us_job = job(country == 'United States of America');        % extract us data
catcount = countcats(us_job );                              % get category count
cats = categories(us_job);                                  % get categories
[~, rank] = sort(catcount,'descend');                       % rank category by count
below_top10 = setdiff(cats,cats(rank(1:10)));               % categories below top 10
us_job = mergecats(us_job, below_top10, 'Other');           % merge them into other
us_job = reordercats(us_job,[cats(rank(1:10)); {'Other'}]); % reorder cats by ranking
figure                                                      % new figure
subplot(1,2,1)                                              % create a subplot
histogram(us_job(gender(country == ...                      % plot histogram
    'United States of America') == 'male'))                 % subset us subject by gender
hold on                                                     % don't overwrite
histogram(us_job(gender(country == ...                      % plot histogram
    'United States of America') == 'female'))               % subset us subject by gender
hold off                                                    % restore default
title('US Job Field by Gender')                             % add title
ylabel('Count')                                             % add y axis label
legend('Male','Female')                                     % add legend
part2.WhatWasTheMainSubjectYouStudiedInUniversity = ...     % convert to categorical
    categorical(part2.WhatWasTheMainSubjectYouStudiedInUniversity);  
major = part2.WhatWasTheMainSubjectYouStudiedInUniversity;  % get academic major
us_maj = major(country == 'United States of America');      % extract us data
catcount = countcats(us_maj);                               % get category count
cats = categories(us_maj);                                  % get categories
[~, rank] = sort(catcount,'descend');                       % rank category by count
below_top10 = setdiff(cats,cats(rank(1:10)));               % categories below top 10
us_maj = mergecats(us_maj, below_top10, 'Other');           % merge them into other
us_maj = reordercats(us_maj,[cats(rank(1:10)); {'Other'}]); % reorder cats by ranking
subplot(1,2,2)                                              % create a subplot
histogram(us_maj(gender(country == ...                      % plot histogram
    'United States of America') == 'male'))                 % subset us subject by gender
hold on                                                     % don't overwrite
histogram(us_maj(gender(country == ...                      % plot histogram
    'United States of America') == 'female'))               % subset us subject by gender
hold off                                                    % restore default
title('US Academic Major by Gender')                        % add title
ylabel('Count')                                             % add y axis label
legend('Male','Female', 'Location', 'northwest')            % add legend
%% 
% Here is a quick sanity check. Yes, those computer science majors do seem 
% to work in software development and IT, as indicated by the line width of the 
% edge between them. 

tbl = table(cellstr(us_maj),cellstr(us_job));               % create table of us major and us job
tbl(isundefined(us_maj) | isundefined(us_job) | ...         % remove undefined
    us_maj == 'Other',:)= [];                               % remove 'Other' from us major
[tbl, ~, idx] = unique(tbl,'rows');                         % eliminate duplicate rows
w = accumarray(idx, 1);                                     % use count of duplicates as weight
G = digraph(tbl.(1), tbl.(2), w);                           % create a directed graph
figure                                                      % new figure
w = G.Edges.Weight;                                         % get weights
h = plot(G,'Layout','layered','LineWidth',5*w/max(w));      % plot the directed graph
xlim([-2.5 16])                                             % x-axis limits
highlight(h, unique(tbl.(2)),'NodeColor',[.85 .33 .1])      % highlight job nodes
title({'US Majors vs. Job Fields'; ...                      % add title
    'Line Width Varies by Frequency'})                           
text(-2, 2, 'Majors', 'FontWeight','Bold')                  % annotate
text(-2, 1, 'Job Fields', 'FontWeight','Bold')              % annotate
annotation('arrow',[.2 .2],[.75 .25], 'Color',[0 .45 .75])  % annotate
%% Academic Background in Software Development and IT
% Taking a deep dive in Software Development and IT, we see that not everyone 
% that is a computer science major and has a diverse academic background is represented 
% in the industry, and they are probably in different career tracks based on their 
% background. Women represent a higher proportion in English, Psychology and Other. 

us_maj_it = major(country == 'United States of America' ... % subset major by country
    & job == 'software development and IT');                % and job
catcount = countcats(us_maj_it);                            % get category count
cats = categories(us_maj_it);                               % get categories
[~, rank] = sort(catcount,'descend');                       % rank category by count
below_top10 = setdiff(cats,cats(rank(1:10)));               % categories below top 10
us_maj_it = mergecats(us_maj_it, below_top10, 'Other');     % merge them into other
us_maj_it = reordercats(us_maj_it,[cats(rank(1:10)); {'Other'}]);% reorder cats by ranking
figure                                                      % new figure
histogram(us_maj_it(gender(country == ...                   % plot histogram
    'United States of America' & ...                        % subset us subject by job
    job == 'software development and IT') == 'male'))       % and gender
hold on                                                     % don't overwrite
histogram(us_maj_it(gender(country == ...                   % plot histogram
    'United States of America' & ...                        % subset us subject by job
    job == 'software development and IT') == 'female'))     % and gender
hold off                                                    % restore default
ax = gca;                                                   % get current axes handle
ax.XTickLabelRotation = 90;                                 % rotate x tick label
title('US Software Development and IT - Majors by Gender')  % add title
ylabel('Count')                                             % add y axis label
legend('Male','Female', 'Location', 'northwest')            % add legend
%% Wide Income Gap in Software Development and IT
% Let's compare the income range by Job Field using a <http://www.mathworks.com/help/stats/boxplot.html 
% box plot>. The bottom and top of the box represents the first and third quantiles 
% and the middle red line represents the median, and whiskers represent +/- 2.7 
% standard deviations. Red "+"s show the outliers.  
% 
% Compared to other job fields, income range in software development and 
% IT has a wide spread (as indicated by the elongnated box shape and longer whisker), 
% meaning there is good upside potential to do better. 

income = part2.AboutHowMuchMoneyDidYouMakeLastYear_inUSDollars;% get income
income = str2double(income);                                % convert to numeric
income(income == 0) = NaN;                                  % don't count zero
us_income = income(country == 'United States of America');  % extract us data
figure                                                      % new figure
boxplot(us_income,us_job)                                   % create a box plot
ylim([0 2*10^5])                                            % set upper limit
title('US Income Distribution by Job Field')                % add title
ax = gca;                                                   % get current axes handle
ax.XTickLabelRotation = 90;                                 % rotate x tick label
ax.YTickLabel = {'$0','$50k','$100k','$150k','$200k'};      % set y tick label
ylabel('Annual Income')                                     % add y axis label
%% What Affects Income in Software Development and IT?
% The first factor that may affect the income in software development and IT 
% is academic background. The box plot shows that Computer Science and Electric 
% Engineering give you the most advantage in getting a higher salary. This is 
% probably the motivation behind the self-learning, how-to-code trend - people 
% want to switch to a more lucrativie career path from their current path or advance 
% more quickly within the same industry. 

us_income_it = income(country == 'United States of America' ...% subset income by country
    & job == 'software development and IT');                % and job
figure                                                      % new figure
boxplot(us_income_it,us_maj_it)                             % create a box plot
ylim([0 2*10^5])                                            % set upper limit
title({'US Income Distribution by Major', ....              % add title
    'in Software Development and IT'})
ax = gca;                                                   % get current axes handle
ax.XTickLabelRotation = 90;                                 % rotate x tick label
ax.YTickLabel = {'$0','$50k','$100k','$150k','$200k'};      % set y tick label
ylabel('Annual Income')                                     % add y axis label
%% Age Factor
% Another important factor to consider is age. If you plot the age against
% income in Software Development and IT, you see a wide income gap among
% younger Computer Science majors. Some 25 year-olds can be earning $0
% vs.$110,000 a year. Income also seems to plateau as you age. You can use
% |<http://www.mathworks.com/help/curvefit/fit.html fit>| with the
% |<http://www.mathworks.com/help/curvefit/list-of-library-models-for-curve-and-surface-fitting.html#btbcvnl
% exp2>| option to <http://www.mathworks.com/help/curvefit/exponential.html
% apply a two-term exponential curve> to the data so you can see it easily.
% Perhaps this provides motivation for CS majors to improve their skills
% and experience as quickly as possible?

us_age_it = age(country == 'United States of America' ...   % subset age by country
    & job == 'software development and IT');                % and job
X = us_age_it(us_maj_it == 'Computer Science');             % subset just CS
Y = us_income_it(us_maj_it == 'Computer Science');          % subset just CS
figure                                                      % new figure
plot(X, Y,'o')                                              % plot data
hold on                                                     % don't overwrite
missingrows = isnan(X) | isnan(Y);                          % find NaNs
X(missingrows) = [];                                        % remove NaNs
Y(missingrows) = [];                                        % remove NaNs
fitresult = fit(X,Y,'exp2');                                % fit to exp2
plot(fitresult)                                             % plot curve
hold off                                                    % restore default
title({'Income by Age Among CS Majors'; ...                 % add title
    'in Software Development and IT'})
xlim([10 60])                                               % set x axis limits
ylim([0 2*10^5])                                            % set y axis limits
ax = gca;                                                   % get current axes handle
ax.YTick = 0:50000:200000;                                  % set y tick
ax.YTickLabel = {'$0','$50k','$100k','$150k','$200k'};      % set y tick label
xlabel('Age')                                               % add x axis label
ylabel('Annual Income')                                     % add y axis label
%% Big Companies Not Preferred
% If you look at the future employment those people are looking for, they prefer 
% big companies the least. Since people are not earning a formal degree, they 
% are probably expecting more flexibility in other employment options. 
% 
% The most popular option is mid-sized companies, but many people are interested 
% in working for a startup, or starting their own businesses, or freelancing. 
% People in software development and IT tend to prefer working for startup or 
% mid-sized companies more. Men tend to prefer doing their own businesses or work 
% for a startup, while women tend to prefer the freelance path. 

part2.want_employment_type = ...                            % convert to categorical
    categorical(part2.want_employment_type);    
interested_emp = part2.want_employment_type;                % get interested employment type
figure                                                      % new figure
subplot(1,2,1)                                              % create a subplot
us_int_emp_it = interested_emp(country == ...               % subset it by country and job
    'United States of America' & job == 'software development and IT');
us_int_emp_it(isundefined(us_int_emp_it)) = [];             % remove undefined
us_int_emp_it = removecats(us_int_emp_it);                  % remove unused categories
histogram(us_int_emp_it,'Normalization','probability')      % plot histogram
hold on                                                     % don't overwrite
us_int_emp_non_it = interested_emp(country == ...           % subset it by country and job
    'United States of America' & job ~= 'software development and IT');
us_int_emp_non_it(isundefined(us_int_emp_non_it)) = [];     % remove undefined
us_int_emp_non_it = removecats(us_int_emp_non_it);          % remove unused categories
histogram(us_int_emp_non_it,'Normalization','probability')  % plot histogram
hold off                                                    % restore default
title({'US Desired Employment Type';'by Job Field'})        % add title
ax = gca;                                                   % get current axes handle
ax.XTickLabelRotation = 90;                                 % rotate x tick label
ax.YTick = 0:0.1:0.6;                                       % set y tick
ax.YTickLabel = {'0%','10%','20%','30%','40%','50%','60%'}; % set y tick label
legend('Software Dev and IT', 'Others')                     % add legend
ylim([0 0.6])                                               % set y axis limits
subplot(1,2,2)                                              % create a subplot
us_int_emp_m = interested_emp(country == ...                % subset it by country
    'United States of America' & gender == 'male');         % gender
us_int_emp_m(isundefined(us_int_emp_m)) = [];               % remove undefined
us_int_emp_m = removecats(us_int_emp_m);                    % remove unused categories
histogram(us_int_emp_m,'Normalization','probability')       % plot histogram
hold on                                                     % don't overwrite
us_int_emp_f = interested_emp(country == ...                % subset it by country
    'United States of America' & gender == 'female');       % gender
us_int_emp_f(isundefined(us_int_emp_f)) = [];               % remove undefined
us_int_emp_f = removecats(us_int_emp_f);                    % remove unused categories
histogram(us_int_emp_f,'Normalization','probability')       % plot histogram
hold off                                                    % restore default
title({'US Desired Employment Type';'by Gender'})           % add title
ax = gca;                                                   % get current axes handle
ax.XTickLabelRotation = 90;                                 % rotate x tick label
ax.YTick = 0:0.1:0.6;                                       % set y tick
ax.YTickLabel = {'0%','10%','20%','30%','40%','50%','60%'}; % set y tick label
legend('Male', 'Female')                                    % add legend
ylim([0 0.6])                                               % set y axis limits
%% Dream Jobs
% When it comes to actual jobs people are interested in, they are mostly web 
% development positions. People already in software development and IT tend to 
% prefer roles with higher technical skills - <https://en.wikipedia.org/wiki/Front_and_back_ends 
% Back-End Web Development>, <https://en.wikipedia.org/wiki/DevOps DevOps>, or 
% <https://en.wikipedia.org/wiki/System_administrator SysAdmin> rather than <https://en.wikipedia.org/wiki/Front-end_web_development 
% Front-End Web Development>, or other non-development roles such as Product Manager 
% or QA Engineer. In terms of gender, women tend to prefer Front-End Web Development 
% and <https://en.wikipedia.org/wiki/User_experience_design User Experience Design>.

int_job = categorical(strtrim(part2.jobs_interested_in));   % get interested job
catcount = countcats(int_job);                              % get category count
cats = categories(int_job);                                 % get categories
[~, rank] = sort(catcount,'descend');                       % rank category by count
below_top10 = setdiff(cats,cats(rank(1:10)));               % categories below top 10
int_job = mergecats(int_job, below_top10,'Other');          % merge them into other
int_job = reordercats(int_job,[cats(rank(1:10));{'Other'}]);% reorder cats by ranking
figure                                                      % new figure
subplot(1,2,1)                                              % create a subplot
us_int_job_non_it = int_job(country == ...                  % subset int job by country and job
     'United States of America' & job ~= 'software development and IT');
histogram(us_int_job_non_it, 'Normalization','probability') % plot histogram
hold on                                                     % don't overwrite
us_int_job_it = int_job(country == ...                      % subset int job by country and job
     'United States of America' & job == 'software development and IT');               
histogram(us_int_job_it, 'Normalization','probability')     % plot histogram
hold off                                                    % restore default
title({'US Jobs Interested In';'By Job Field'})             % add title
legend('All Others','Software Dev & IT')                    % add legend
ax = gca;                                                   % get current axes handle
ax.YTick = 0:0.1:0.5;                                       % set y tick
ax.YTickLabel = {'0%','10%','20%','30%','40%','50%'};       % set y tick label
ylim([0 0.5])                                               % set y axis limits
subplot(1,2,2)                                              % create a subplot
us_int_job_m = int_job(country == ...                       % subset int job by country
     'United States of America' & gender == 'male');        % and gender
histogram(us_int_job_m, 'Normalization','probability')      % plot histogram
hold on                                                     % don't overwrite
us_int_job_f = int_job(country == ...                       % subset int job by country
     'United States of America' & gender == 'female');      % and gender
histogram(us_int_job_f, 'Normalization','probability')      % plot histogram
hold off                                                    % restore default
title({'US Jobs Interested In';'By Gender'})                % add title
legend('Male','Female')                                     % add legend
ax = gca;                                                   % get current axes handle
ax.YTick = 0:0.1:0.5;                                       % set y tick
ax.YTickLabel = {'0%','10%','20%','30%','40%','50%'};       % set y tick label
ylim([0 0.5])                                               % set y axis limits
%% Student Loan Debt
% The survey also answers how much student loan debt respondents carry and how 
% much they spend learning to code. Over 41% of the respondents have student loan 
% debt and the median amount owed is $25,000.  In addition, people do spend during 
% the course of learning to code, and the median total spend is $300. Given that 
% a lot of people have debt, they cannot afford to spend more and add to their 
% deficit, and that also reflects on the more conservative choices in future employment. 

debt = part2.AboutHowMuchDoYouOweInStudentLoans_inUSDollars;% get student load debt
debt = str2double(debt);                                    % convert to numeric
debt(debt == 0) = NaN;                                      % don't count zero
us_debt = debt(country == 'United States of America');      % extract us data
pct_in_debt = sum(~isnan(us_debt))/length(us_debt)*100;     % percentage in debt
median_debt = nanmedian(us_debt)/1000;                      % median debt
figure                                                      % new figure
subplot(1,2,1)                                              % create a subplot
histogram(us_debt)                                          % plot histogram
xlim([0 2*10^5])                                            % set y axis limits
ax = gca;                                                   % get current axes handle
ax.XTick = 0:50000:200000;                                  % set x tick
ax.XTickLabel = {'$0','$50k','$100k','$150k','$200k'};      % set x tick label
xlabel('Amount Owed')                                       % add x axis label
ylabel('Count')                                             % add y axis label
title({'US Student Loan Debt'; ...                          % add title
    sprintf('%.2f%% in Debt (Median $%dk)',pct_in_debt,median_debt)})                               
subplot(1,2,2)                                              % create a subplot
spend = part2.total_spent_learning;                         % get total spend
spend = str2double(spend);                                  % convert to numeric
spend(spend == 0) = NaN;                                    % don't count zero
us_spend = spend(country == 'United States of America');    % extract us data
histogram(us_spend)                                         % plot histogram
xlim([0 3*10^4])                                            % set y axis limits
ax = gca;                                                   % get current axes handle
ax.XTick = 0:10000:30000;                                   % set x tick
ax.XTickLabel = {'$0','$10k','$20k','$30k'};                % set x tick label
xlabel('Total Spend')                                       % add x axis label
ylabel('Count')                                             % add y axis label
title({'US Spend Learning'; sprintf('Median $%d', ...       % add title
    nanmedian(us_spend))})                                  
%% Women Prefer More Welcoming Venues
% This survey seems to show more female participation in the "learn to code" 
% movement compared to a more tranditional computer science education. When you 
% look at the type of events women prefer, they show strong preference for gender-specific 
% events like "Girl Develop It" and "Women Who Code". When you look at the online 
% resources, you don't see much difference by gender. It appears that physical 
% presence of males makes women feel unwelcome.  

events_attended = part2.attended_event_types;               % get events attended
events_attended = cellfun(@(x) strsplit(x,','), ...         % split by comma
    events_attended,'UniformOutput',false);
events_attended_flatten = strtrim([events_attended{:}]);    % un-nest and trim
[~,ia,ib] = unique(lower(events_attended_flatten));         % get indices of uniques
events = events_attended_flatten(ia);                       % get unique values
count = accumarray(ib,1);                                   % count unique values
events(count < 100) = [];                                   % drop unpopular events
events(strcmpi(events,'none')) = [];                        % drop 'none'
events(cellfun(@isempty,events)) = [];                      % drop empty cell
attended = zeros(size(events_attended,1),length(events));   % set up accumulator
for i = 1:size(events_attended,1)                           % loop over events attended
    attended(i,:) = ismember(events,strtrim( ...            % find intersection between
        events_attended{i}));                               % events and attended events
end
attended_m = sum(attended(country == ...                    % subset attended by country
    'United States of America' & gender == 'male',:));      % and gender
attended_f = sum(attended(country == ...                    % subset attended by country
    'United States of America' & gender == 'female',:));    % and gender
gender_ratio = attended_m ./ sum(attended_m);               % get male ratio by event
gender_ratio = [gender_ratio; attended_f./sum(attended_f)]; % add female ratio
figure                                                      % new figure
subplot(1,2,1)                                              % create a subplot
b = bar(gender_ratio','FaceColor',[0 .45 .75], ...          % create a bar chart
    'FaceAlpha',.6);                                        % with histogram colors
b(2).FaceColor = [.85 .33 .1];                              % with histogram colors
ax = gca;                                                   % get current axes handle
ax.XTickLabel = events;                                     % set x tick label
ax.XTickLabelRotation = 90;                                 % rotate x tick label
ax.YTick = 0:0.1:0.4;                                       % set y tick
ax.YTickLabel = {'0%','10%','20%','30%','40%'};             % set y tick label
title('US Popular Events Attended')                         % add title
legend('Male','Female')                                     % add legend
subplot(1,2,2)                                              % create a subplot
resources_used = part2.learning_resources;                  % get resources used
resources_used = cellfun(@(x) strsplit(x,','), ...          % split by comma
    resources_used,'UniformOutput',false);
resources_used_flatten = strtrim([resources_used{:}]);      % un-nest and trim
[~,ia,ib] = unique(lower(resources_used_flatten));          % get indices of uniques
resources = resources_used_flatten(ia);                     % get unique values
count = accumarray(ib,1);                                   % count unique values
resources(count < 100) = [];                                % drop unpopular resources
resources(cellfun(@isempty,resources)) = [];                % drop empty cell
usage = zeros(size(resources_used,1),length(resources));    % set up accumulator
for i = 1:size(resources_used,1)                            % loop over resources used
    usage(i,:) = ismember(resources,strtrim( ...            % find intersection between
        resources_used{i}));                                % resources and resource used
end
usage_m = sum(usage(country == ...                          % subset usage by country
    'United States of America' & gender == 'male',:));      % and gender
usage_f = sum(usage(country == ...                          % subset usage by country
    'United States of America' & gender == 'female',:));    % and gender
gender_ratio = usage_m ./ sum(usage_m);                     % get male ratio by resource
gender_ratio = [gender_ratio; usage_f ./ sum(usage_f)];     % add female ratio
b = bar(gender_ratio','FaceColor',[0 .45 .75], ...          % create a bar chart
    'FaceAlpha',.6);                                        % with histogram colors
b(2).FaceColor = [.85 .33 .1];                              % with histogram colors
ax = gca;                                                   % get current axes handle
ax.XTickLabel = resources;                                  % set x tick label
ax.XTickLabelRotation = 90;                                 % rotate x tick label
ax.YTick = 0:0.1:0.3;                                       % set y tick
ax.YTickLabel = {'0%','10%','20%','30%'};                   % set y tick label
title('US Popular Resources Used')                          % add title
legend('Male','Female')                                     % add legend
%% 
% To give an example, I encouraged my daughter to join a robotics competition 
% team in her high school. She talked to her friends because she didn't want to 
% be only girl in the team and a bunch of girls joined the team. When she came 
% home from the first team session, I asked her what she worked on. She said "we 
% worked on team web page". It turned out boys worked on the building robots and 
% girls were left out, so they worked on building the team web page. When the 
% kits were delivered to the team, boys just huddled togather among themselves, 
% and didn't bother to include girls. Girls were not consciously excluded, but 
% they felt unwelcome anyway. I suspect similar dynamics may be at play which 
% coding events women go to. 
% 
% I also wonder the female preference of Front-End Web Development and User 
% Experience Design is also driven by the same issue?
%% Summary
% Perhaps the most intriguing result of this analysis is that the "learn to 
% code" movement is effective in closing the gender gap in software development 
% and IT and embraced by the minority community under-served by the traditional 
% educational paths. It also underscores the precarious positions those learners 
% face due to the high student loan debt they carry. Ultimately we don't know 
% how many of them actually achieve employment in their dream job from this survey, 
% and hopefully there is a follow-up to find out whether the "learn to code" movement 
% really delivers on its promise. 
% 
% Do you use any of those "learn to code" websites or other MOOCs? What are
% you learning and what motivates you to take those classes? Please share
% your experience <http://blogs.mathworks.com/loren/?p=1687#respond here>!
% 
% 
% 
% 
% 
%

%%
% _Copyright 2016 The MathWorks, Inc._
