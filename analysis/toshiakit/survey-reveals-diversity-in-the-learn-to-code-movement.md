# Survey Reveals Diversity in the “Learn to Code” Movement

Posted by Loren Shure, June 27, 2016

Do you use any free "learn to code" website to teach yourself programming? You may already know how to program in MATLAB, but you may very well be learning other skills on [MOOCs](https://en.wikipedia.org/wiki/Massive_open_online_course).

Today's guest blogger, Toshi, analyzed a publicly available survey data to understand the demographic of self-taught coders.

## Contents

- [Load Data](http://blogs.mathworks.com/loren/2016/06/27/survey-reveals-diversity-in-the-learn-to-code-movement/#d93d69a7-bbe1-4d71-9199-04667a401710)
- [Higher Female Representation Than Expected](http://blogs.mathworks.com/loren/2016/06/27/survey-reveals-diversity-in-the-learn-to-code-movement/#bfddaa56-0b3a-42c8-baff-9dab7527b7b0)
- [Mostly Studying in Countries of Citizenship](http://blogs.mathworks.com/loren/2016/06/27/survey-reveals-diversity-in-the-learn-to-code-movement/#3640d862-a498-4e79-a43e-dedde1a3f715)
- [Ethnically Diverse English Speakers in US](http://blogs.mathworks.com/loren/2016/06/27/survey-reveals-diversity-in-the-learn-to-code-movement/#c105553c-1bb2-4250-aa57-76b7a685c7e1)
- and [more](http://blogs.mathworks.com/loren/2016/06/27/survey-reveals-diversity-in-the-learn-to-code-movement/)

## About the Data

I came across a Techcrunch article, [Free Code Camp survey reveals demographics of self-taught coders](http://techcrunch.com/2016/05/04/free-code-camp-survey-reveals-demographics-of-self-taught-coders/), and I got curious because a lot of people seem to interested in learning how to code, and industry and government are also encouraging this trend. But programming is hard. Who exactly are the kind of people who have taken the plunge? Our own free interactive online programming classes on [MATLAB Academy](https://matlabacademy.mathworks.com/) or gamified [MATLAB Cody](https://www.mathworks.com/matlabcentral/about/cody/) are also gaining popularity and I would like to understand what motivates this interest.

The survey was conducted anonymously and published on the web and promoted via social media from March 28 through May 2, 2016, targeting people who are relatively new to programming.

The following analysis shows significant diversity in gender and ethnic mix among self-taught coders and the possible impact of MOOCs in opening up access for under-served populations by traditional STEM education paths.

I first downloaded the [2016 New Coder Survey result from Github](https://github.com/FreeCodeCamp/2016-new-coder-survey). I then unzipped the CSV files into my current folder. There are two files - part 1 and part 2 - and we will read them into separate tables. We could perhaps merge them using [innerjoin](http://www.mathworks.com/help/matlab/ref/innerjoin.html), but in this case I am primarily interested in part 2 only and we will be discarding at least 1000 responses from part 1, given the differences in number of responses.

(see the [blog post](http://blogs.mathworks.com/loren/2016/06/27/survey-reveals-diversity-in-the-learn-to-code-movement/) for further reading)
