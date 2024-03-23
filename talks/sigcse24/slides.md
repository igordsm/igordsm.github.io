---
footer: 'Igor Montagner (igorsm1@insper.edu.br)'
---

<style>

:root {
	--red-color: #962426;
	--h1-color: var(--red-color);
	--color-fg-default: #6D6B6B;
}

section h1 {
	position: absolute;
	top: 1.5rem;
}

section img {
	margin-left: auto;
	margin-right: auto;

	margin-top: 1rem;
	margin-bottom: 1rem;

	display: block;
		
}

section.side-by-side {
	display:flex;
	flex-direction: row;
	align-items: center;
	flex-wrap: wrap;
}

section.side-by-side p:nth-child(2) {
	margin-left: 2rem;
}

section.side-by-side img {
	width: 500px;
}

section.side-by-side > p.bottom {
	flex-basis: 100%;
}

section.quote blockquote {
    border:none;
    quotes: "\201C""\201D""\2018""\2019";
    position: relative;
    margin-top: 1.5rem;
    margin-bottom: 1.5rem;
}

section.quote blockquote p:before {
	content: open-quote;
	font-weight: bold;
	font-size:100px;
	color: var(--red-color);
	position: absolute;
	left: -30px;
	top: -50px;
}

section.quote blockquote p:after {
	content: close-quote;
	font-weight: bold;
	font-size:100px;
	color: var(--red-color);
	position: absolute;
	right: -15px;
}

section.front h1 {
	position: relative;
	margin-bottom: 2.3rem;
	font-size: 2rem;
	padding-top: 100px;
}	

section.front h2 {
	text-align: right;
	font-size: 1.3rem;
	padding-left: 200px;
}

section.front strong {
	color: #852022;
}

section.front img {
	max-height: 40px;
	display: inline-block;
	float: right;
}

footer {
	position: absolute;
	right: 10px;
	text-align: right;
}

section p.bottom-right {
	position: absolute;
	right: 50px;
	bottom: 70px;
	background-color: var(--red-color);
	opacity: 0.6;
	font-weight: bold;
	max-width: 300px;	
	padding: 0.3rem;
	border-radius: 0.5rem;
}

</style>

<!-- _class: front -->

# Evaluating Mastery-oriented Grading in an Intensive CS1 Course

## **Igor Montagner**, Rafael Corsi, Andrew Kurauchi, Mariana Silva, Craig Zilles

![](logo-insper.png) ![](logo-uiuc.png)


------

# Our context - Insper

![bg left:30%](insper.jpg)


- Brazilian private non-profit institution
- Scholarships + stipends for 10-15% of students
- CS major started in 2022
- Cohort-based (*no courses outside of major*)

----------------

# Developer Life - Intensive CS1 course

![bg left:30%](aula.jpg)


- 24 hours per week
- 6 two-hour in person meetings
- 5 office hours
- Active learning with occasional mini-lectures and live coding
- Shared between 3-5 professors

------

# DeveloperLife - Intensive CS1 course

### Broad view into many aspects of computing

### Students are able to deliver a working software 

### Every course from the 2nd semester on can involve coding
 
---------

# Developer Life - Assessment

![width:800px](sem-overview.svg)

- 5 low stakes formative quizzes $Q_i$ worth 10% of final grade
- 5 high(er) stakes Exams $E_i$ worth 55% of final grade
- Each week a new topic is included

### Exams are spread over the semester to allow student to catch-up if necessary

### Final exam grade is the average of the 3 largest scores

--------

# First experience (challenges)

- **Tendency to increase the gap between the faster and the slower learners**
- For students, catching-up was hard even with 5 exams
  - Double the workload
  - Even higher stakes on the last exam
- Coding-only exams gave us (instructors) little feedback on students weaknesses

-----------

# Mastery Learning and Second-chance testing

### Incorporate a way to help students catch-up into the "regular" course path

**Second-chance testing**: Every assessment includes a retake a few days later and some time dedicated to reviewing mistakes.
 
- Reduce failure rates
- Study for the second-chance remediating material missed on the first one
- Reduces self-reported test anxiety

--------

# Research Questions

- **RQ1**: Do second chances help students to increase their performance over time in intensive courses?
- **RQ2**: Are second chances effective in reducing stress/mental load/weight of assessments in intensive courses?

-----

# Intervention 

Cohort of Fall 2023 had the following changes

1. Add second chances for Quizzes
2. Two types of questions:
	- Short answer - parsons, multiple choice, fill the blank
	- Coding - autograded, involve problem solving, manual code quality evaluation
3. Extra week for reviewing material between Exams 1 and 2

------------

![bg width:800px](fig2a-1-gray.svg)

--------

# Methodology

Mixed-methods study, $N=39$ students.

1. Quantitative analysis
	- Quiz and exam grades
	- Coding and short answer
2. Qualitative study
	- Interviewed $10$ students
	- Grounded Theory
	- Prompts about mental state, study habits and test-taking strategies

-----------

 # Second chances on Quizzes

![width:600px](quiz-1st-retake.svg)

### Improvements in all topics

### Final scores include both first and second attempts

-------------

# Second chances on Quizzes

Students have different test-taking behaviors and gains

- **ALL** ($N=12$): 
	- From failling to passing grades
- **FIRST** ($N=6$):
	- Improved from already good grades (>70%)
- **SKIP** ($N=21$):
	- Almost all skipped $Q5$ (dictionaries)
	- Might be procrastinating/gaming the system
	
----

# Second chances on Exams

![width:1800px](tabela1.png)

- Short answers are satisfactory from the start
- Coding questions start lower and trend upwards with decreasing standard deviation

----------

# Second chances on Exams

- 5 exams, average of the largest 3 scores
	- Exams $E4$ and $E5$ are optional for some
- Taking $E4$ and/or $E5$ benefits students differently
	- $N=5$ went from failling to passing grade
	- $N=16$ improved a passing grade (<75%)
	- $N=14$ improved an excellent grade (>75%)

--------------

## Students are getting better over time

## Encouraging results for the slower learners

## Many students are taking all quizzes/exams even when they don't needed it 

<p class="bottom-right">
More statistical details in the paper!
</p>

----------------

# Interviews analysis

- $N=10$ students with different final grades
- Grounded theory analysis, 2 coding steps
- Three main themes

	1. retake decision making
	2. mental state
	3. study habits


---------

<!-- _class: quote -->
# Retake decision making

Students find grading system confusing and are not sure if they can skip

> (...)  I didn't know how to make the calculation to see if it was worth it for me to retake the exam


Exam is challeging in a good way

> They were coding exercises that involved something quite challenging, you know? And we could do something interesting.

<!--
> (...)  I didn't know how to make the calculation to see if it was worth it for me to retake the exam

> So it's kind of strange not to take the test. Everyone is doing it and I'm not doing anything else. So I wanted to do it
-->

------------

<!-- _class: quote -->
# Mental state 

First chance matters, but retakes help reduce anxiety after exams

> It was good to have this second chance, because it was not discouraging. I think I even knew some cases of friends who didn't do so well at the beginning, but they're doing well now, and they didn't give up. 

### Being rewarded for persistence

-------

<!-- _class: quote -->
# Study habits

Study habits did not change over time. Student display good attitude towards learning

> You must always be studying, always up-to-date with the subject matter because, otherwise, it will accumulate, and the faculty won't always be pushing you to study


-------

# Lessons Learned I

1. Adding second-chance testing had a positive effect on grades
2. Students reported decreased test-related stress
    - but not for the first-chance
3. Good attitude towards learning was observed

---------------

# Lessons Learned II - improvements

### Feedback delay is very relevant when multiple chances exist	

### Grading systems for large (in terms of content) courses

--------------

<!-- _class: front -->

# Evaluating Mastery-oriented Grading in an Intensive CS1 Course

## **Igor Montagner**, Rafael Corsi, Andrew Kurauchi, Mariana Silva, Craig Zilles

![](logo-insper.png) ![](logo-uiuc.png)
