# **TODO: Get a Product Name**


## 
**Product Details**


### 
**Q1: What are you planning to build?**

An organizational platform in the form of a mobile application that helps middle school students organize their work and build organizational skills by allowing them to track their class assignments and marks, and collaborate through a chat function. Currently students have paper agendas that they are not using, our application aims to offer a more flexible alternative to it in the form of a digital agenda that students can easily use on their personal electronic devices.

For a physical agenda to work it has to be constantly updated manually by the student. A student who is struggling to do so on a consistent basis could use our product instead since it will be updated automatically and could alert them when an assignment has been posted by the teacher as well as sending notifications close to the due date of the assignment. For students who are better organized, the platform would offer a way of keeping an easier track of all of their assignments without the hassle of going through pages upon pages in agenda searching for due dates.

Teachers would use the platform to post marks for each assignment and parents would be able to track their child's progress for every class that is available on the platform.


#### 
**TODO: ADD DIAGRAMS**


### 
**Q2: Who are your target users?**

Our primary users will be Grade 6 - 8 students who are taking a number of different classes such as (English, French, Mathematics and Science) and are having difficulty in keeping track of all of their assigned work between classes. Secondary users will include teachers of said students who will use the platform to post assignments and grades, as well as parents who will use the platform to track their child's progress.


### 
**Q3: Why would your users choose your product? What are they using today to solve their problem/need?**

Students would use our application to organize the information for all of their classes on one platform. Currently students are using a combination of Google Classroom and paper agendas in order to organize their class work. This creates the problem of updating Google classroom to be consistent with the agenda and vice versa. Ideally, the students will only have to check and work with a single platform instead of keeping track of information on multiple platforms. Our application will help students organize their work by keeping all of the information about assignments and classes in a single place (platform), allow students to track assignments by receiving notifications of when assignments are posted and receive continuous notifications before an assignment is due (currently Google classroom offers a notification feature for when something is posted, but we would like to continuously remind students that they should be working on a project) and allow students to set their own incremental deadlines for a project and receive notifications for those deadlines to help them keep track of their progress and lastly provide calendar timelines for their assignments. In addition, we will provide a chat function that saves students time on assignments by allowing them to collaborate; Google classroom currently only supports comments. The aim is to not replace Google classroom, but to integrate additional features of our application with Google classroom so that in combination they may replace the need for a paper agenda.

Teachers would use the platform to ensure that when they post assignments and marks, students are immediately notified. Parents would be saved time in keeping track of their child's progress since all of the information about it would be available on one platform, allowing for quick and easy access.


### 
**Q4: How will you build it?**

Flutter - multi-platform framework

Java Backend

Dart Frontend

**Architecture:** The application will be built for multiple platforms, we plan for our time limits to code for Android and iOS. These applications will be built out with Flutter, a multi-platform framework, the backend of the application is currently undecided, We would like to do this on Firebase but might have to look elsewhere if the possibility of cost with Firebase does not work with the partner (this will be discussed in the upcoming meeting with the partner). If using Firebase we would write a backend in Java. Firebase will allow us to build out authentication, chats, and databases very easily. 



<p id="gdcalert1" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/CSC301-D10.jpg). Store image on your image server and adjust path/filename if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert2">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/CSC301-D10.jpg "image_tooltip")


**Process: **Stories will be split up to team members so each member is working on their own feature. Larger features (like google auth and google classroom integration) that will be used by others will need to be discussed and documented so that other members will be able to use the documentation on other stories. 


### 
**Q5: User Stories**

**Notifications**



1. As a student, I want to add goals/deadlines to my Agenda for upcoming assignments and receive notifications/reminders to work on those assignments in order to be able to complete assignments on time.
    *   Acceptance Criteria:
        *   User can set when and how often they want to receive a reminder
        *   View upcoming goals and deadlines which are ordered chronologically
        *   Able to add a goal and deadline with a title, description and time
1.  As a student, I want to receive due dates and marks on my agenda from google classroom in order to improve my time management and monitor my academic performance.
    *   Acceptance Criteria:
        *   View due dates for upcoming assignments
        *   View marks for past assignments (if available)
2. As a Teacher, I want to post assignments and grades to Google Classroom, in order to allow students to view what they need to do and how they have done previously.
    *   Acceptance Criteria:
        *   Linking between Google Classroom features and our application to be able to access mark information
        *   Notifications appear on phones of students and parents when grades are uploaded
3. As a Student, I want to receive notifications when items on the agenda have been posted, or are coming up to a due date in order to keep my work organized and plan out my time.
    *   Acceptance Criteria:
        *   Whenever an assignment is posted onto the app, the student version of the app sends a notification to the student’s device 
        *   When an assignment is coming up a student gets incremental notifications 7 days, 3 days and 1 day before the assignment is due
        *   As a Student, I will receive reminders to work on current assignments before they are due
4. As a Student, using non-mobile versions of the platform, I want to receive notifications in the form of email in order to be reminded of work that is due.
    *   Acceptance Criteria:
        *   Student is able to sign up for email notifications
        *   Notifications described above are sent to email instead of the student’s device

**Monitoring**



5. As a Teacher, I want to be able to access the students' agenda to monitor the students' performance in order to see which students require more help and guidance and who I should focus my attention to.
    *   Acceptance Criteria:
        *   Teacher has privileged access to student information
        *   Teacher is able to see detailed information about when a student created a task, when they completed it and how long it took them
6. As a Parent, I want to view my child's agenda to see what type of goals they have set for themselves in order to make sure they are organized and are on top of their work.
    *   Acceptance Criteria:
        *   Parent has privileged access to student information
        *   Parent is able to see detailed information about when a student created a task, when they completed it and how long it took them

**Chatting**



7. As a Student or Teacher, I will be able to communicate with other students/teachers through a chat in order to be able to organize group work and bounce ideas off of each other.
    *   Acceptance Criteria:
        *   Select who to chat with (can be multiple people)
        *   Can send messages to selected people
        *   Can see replies
8. As a Student or Teacher, I want to be able to share files (links, pictures, etc) with other students over the chat in order to be able to share useful websites and notes to others.
    *   Acceptance Criteria:
        *   Links are clickable
        *   Pictures are shown directly in the chat
9.  As a Student, I want to not be able to view chats that I am not in in order to not invade on other’s privacy.
    *   Acceptance Criteria:
        *   Students will only be able to see chats they created or were invited to
10. As a Parent, I want to not be able to use chats in order to not invade on my student’s privacy.
    *   Acceptance Criteria:
        *   Parents are unable to use chats
11.  As a School Staff Member, I want to view chats of students in order to monitor for inappropriate behavior
    *   Acceptance Criteria:
        *   School Staff are able to see chats of all students

**Agenda**



12. As a School, I would like to view statistics of how the agendas are being used by students in order to see if students are using the agenda effectively.
    *   Acceptance Criteria:
        *   For each student, staff can see the number of times a student uses their agenda per [time period]
13. As a Student, I want to sign in to my google classroom account in order to view my agenda.
    *   Acceptance Criteria:
        *   The agenda will display a calendar where each day holds tasks and reminders for the student
14. As a Student, I want to not be able to view other students' agendas in order to focus on myself and what I need to get done.
    *   Acceptance Criteria:
        *   Students will only be able to see their own account’s calendar/agenda and the restriction will be handled by google accounts
15. As a Student, I want to break up tasks into subtasks where subtasks are chosen from a list in order to easily see what needs to be done for each assignment
    *   Acceptance Criteria:
        *   Teachers can create a list of subtasks
        *   Students can select subtasks

**Camera**



16. As a Student, I want to take pictures using my phone's camera in order to share the notes with other students
    *   Acceptance Criteria:
        *   Can take pictures of their notes and send them via the chat

**Performance Metrics**



17.  As a Student, I want to receive a type of points for completing deadlines on time in order to motivate me to complete work on time.
    *   Acceptance criteria:
        *   Receive points for completing work on time
        *   Be able to receive more points for streaks of completed work
        *   Receive star or badge for enough work completed
        *   View progress in a bar that fills up in real time
18.  As a Student, I want to view a visual representation of my performance (possibly in the form of a bar graph) in order to easily monitor my progress.
    *   Acceptance Criteria:
        *   Graphs representing user performance and task completion over time
        *   Timeline that shows how many tasks were completed on a particular date
19.  As a Student, I want to receive reflection questions when goals have been completed in order to reflect and be able to improve in the future.
    *   Acceptance Criteria:
        *   There will be a list of reflection questions (from a database)  that will be sent to the student each time they check off a task
20.  As a Student, I want to be able to break up tasks and label them with a type in order to group tasks together.
    *   Acceptance Criteria:
        *   For each task, students will be able to break them down by listing the pieces in which combine to form the whole task, afterwards, they are asked to label each subtask in the list

**Bonus (later if time allows)**



21. BONUS: As a Student, I will be able to access dictionary.com and thesaurus.com directly through the platform
22. BONUS: As a Student, I will have access to a reference builder similar to easybib \
	



---



## 
**Process Details**


#### 
**Roles & responsibilities**

**Role(s) and Responsibilities**: Currently we are planning to split the User Stories to each of the team members, this will allow members to gain experience in each aspect of the project along with allowing us to more quickly build out features without blocking each other.

**Robert Fang**: 



*   Role(s) and Responsibilities:
    *   Role: Front End
    *   User Stories Responsible For:
        *   13
        *   15
        *   16
    *   Non-Software Responsibilities:
        *   Conduct test sessions with the students using a prototype product
*   Technical Strengths:
    *   Python, C, Java 
*   Technical Weaknesses:
    *   Front end development, iOS, Web Dev

**Michael Lee**: 



*   Role(s) and Responsibilities:
    *   Role: Backend
    *   User Stories Responsible For:
        *   3
        *   2
        *   17
    *   Non-Software Responsibilities:
        *   Conduct test sessions with the students using a prototype product
*   Technical Strengths:
    *   Java, OOP, Python
*   Technical Weaknesses:
    *   Mobile dev (not done since 207)

**Joshua Prier**: 



*   Role(s) and Responsibilities:
    *   Role: 
        *   Tech Lead (LMAO)
    *   User Stories Responsible For:
        *   6
        *   9 
        *   11
    *   Non-Software Responsibilities:
        *   Go to meetings with partner to discuss topics on features and progress, and other tech related topics
*   Technical Strengths:
    *   Java, Android, Python, Flask, Databases
    *   Work Experience with larger scale projects at _Amazon_
*   Technical Weaknesses:
    *   Web dev, Front End, iOS

**Nikita Shumeiko**: 



*   Role(s) and Responsibilities:
    *   Role: Backend
    *   User Stories Responsible For:
        *   19
        *   20
        *   7
    *   Non-Software Responsibilities:
        *   Conduct test sessions with the students using a prototype product
*   Technical Strengths:
    *   C, Java, Android Studio, Python
    *   Strong grasp of OOP
    *   Experience working on larger scale projects
    *   Experience with databases and SQL 
*   Technical Weaknesses:
    *   Front End Web development, iOS, 

**Viktar Chyhir**: 



*   Role(s) and Responsibilities:
    *   Role: Backend/Strike Manager/Partner Communication
    *   User Stories Responsible For:
        *   18
        *   4
        *   14
    *   Non-Software Responsibilities:
        *   Conducting test sessions with the students using a prototype product
*   Technical Strengths:
    *   Java, C, C#
    *   Unity
    *    Android API
    *   OOP
*   Technical Weaknesses:
    *   Web development, Front End, Databases, iOS development

**Arian Safaei**: 



*   Role(s) and Responsibilities:
    *   Role: Backend/Communication with partner
    *   User Stories Responsible For:
        *   1
        *   8
        *   19
    *   Non-Software Responsibilities:
        *   Conducting test sessions with the students using a prototype product
*   Technical Strengths:
    *   Java, C, Python, designing and implementing user interfaces
*   Technical Weaknesses:
    *   Not too much experience with web development
    *   Have not built apps on iOS

**Brandon Truong**:



*   Role(s) and Responsibilities:
    *   Role: Front End
    *   User Stories Responsible For:
        *   10
        *   5
        *   21
    *   Non-Software Responsibilities:
        *   Conducting test sessions with the students using a prototype product
*   Technical Strengths:
    *   Good with Java: Preferred and most comfortable programming language.
    *   Good with Object Oriented Design
    *   Good at debugging problems
*   Technical Weaknesses:
    *   No web development experience
    *   No mobile app development experience
    *   No database experience (but currently taking CSC343)

#### 
**Team Rules**


Communications:



*   Team Communications
    *   Discord - every day as necessary and weekly meetings on Fridays from   6 pm - 7 pm
*   Partner Communications
    *   Email as needed
    *   Skype meetings every other week on Wednesdays (12pm - 1pm)

Meetings:



*   Accountability for not Attending Meetings and Not Completing Action Items
    *   If work is not completed or a meeting is not attended, we will contact the person and discuss why they are not completing their responsibilities. The purpose of this meeting would be not to antagonize the person, but to find out how the group can help.
    *   After the above meeting, if work is not completed or meetings are not attended on a regular basis, we would employ a strike system. For each time an issue or ticket is not completed on time, we would find out the reason why and if the reason was not legitimate (exams, medical/family emergency, etc) we would apply a strike to that teammate.

         

    *   If a teammate receives three strikes, we would contact our TA or instructor to hopefully find a resolution.
    *   A person is able to erase a strike through a group meeting where they show the work they have done and how they made up for the uncompleted tickets. A person is also able to erase strikes by helping out other members.  \


Conflict Resolution:



*   Team members being indecisive:
    *   Organize a meeting and have team members voice their opinions for either side to try and convince team members to decide either way
    *   If that doesn’t succeed, bring topic at hand to a vote, we have a group of 7 people, so ties are impossible.
*   Team members not responding:
    *   Try to contact them via different mediums at first (maybe phone broke, etc.)
    *   If repeated attempts to contact fail, try and see them in person at school
    *   If this fails, seek advice of TA/Instructor
*   Team member being combative:
    *   Give them some time to calm down and think over their actions
    *   If the behaviour continues, immediately go to a TA as this behaviour will not be tolerated.

#### 
**Events**


We will be online using Discord to communicate with our team members. Communication will be done when necessary and we will also have weekly meetings on Friday from 6pm to 7pm. On the Friday meeting, we will conduct a code review and discuss what we have done. We will all comment on each other's work and discuss any problems we have if any. Next, we will discuss what we are planning to do in the following week and talk about any issues we might run into.


#### 
**Partner Meetings**


##### 
**Meeting 1 (October 7)**



*   Video call meeting from 1pm to 2pm over _Zoom_

###### 
**Meeting Minutes:**

*   Users include students, parents and teachers with different features available to each user group
*   The app should offer enough functionality to be a replacement of the physical agenda
*   The app should minimally support a number of users equal to the size of an average middle school class
*   Partner would like students to be involved in the development process with possible field trips to UofT from 8:55 am to 11:40 am
    *   Ideally meet with the students once in the beginning, middle and end of the project development cycle
*   Application should be supported by a mobile platform
*   Teachers and parents should be able to monitor student progress over the app
*   No need to submit assignments over the app (Google Classroom is being used for this already)
*   Would be nice for students to be able to ask questions and collaborate over the platform (something similar to Piazza?)
*   Integrate Google Classroom features if possible

###### 
**Meeting Outcomes:**

*   Confirmed primary users being students, secondary users being teachers and parents
*   Confirmed scale as being just for a single class for now
*   Obtained new information to facilitate user story creation
*   Gained more understanding of what the product is expected to be; started thinking of what technologies would be best suited (Flask, FireBase, Flutter, languages)
*   Agreed on next meeting being Oct 9 at 1pm

##### 
**Meeting 2 (October 9)**

*   Video call meeting from 1pm to 2pm over _Skype_

###### 
**Meeting Minutes (Discussion Points):**

*   Need students to enter marks into the app themselves (later clarified that this can be integrated with Google Classroom by just pulling marks off of there)
*   Motivate students to use the software just like an agenda
*   Need a goal setting feature letting students set incremental goals and to measure progress throughout the academic year
    *   If the results are below expectations, the application will help guide the students to success (provides task breakdown options based on priority which is calculated through a mix of assignment weight, due date and size)
    *   These goals can be more of a completion style goals and are added to the app by the students themselves
    *   Teachers should be able to view these goals
*   Simple chat function between students only
    *   Teachers should have moderation permissions such as deleting messages and flagging useful ones
*   Students should be able to upload pictures of notes onto Google Classroom and have them be automatically synced without app
*   Ability for students to add assignments themselves is needed
    *   Assignments to be divided according to type (individual, partner, group, etc...) and subject (math, English, French, science, etc...)
    *   Should offer subtasks to be added when an assignment is added
*   Ok with just Android for now
*   Bonus: Integrate Google Classroom
*   Bonus: Dictionary/Thesaurus function
*   Partner wants students to have a tour of the university and its facilities (If possible, need to organize with the Community Partnership Center and David). Tentative date is Oct. 30

###### 
**Meeting Outcomes:**

*   Now have a better idea of what the school is expecting
*   Confirmed Android as the minimal functional platform
*   Confirmed application features
*   Confirmed time of regular meetings being Wednesdays from 12pm to 1pm
*   Confirmed amount of student involvement desired by the school

#### 
**Artifacts**

*   Discord for communication, organization
*   Trello for task management and reminders
    *   Trello allows us to create a board to organize our work with scrum
    *   Tasks are organized by user stories
    *   We prioritize stories related to the Agenda and Performance aspects of the product
*   Git for version control

### 
**Highlights**


#### 
**Questions For Partner: **


Completed:



*   ~~We can get data from google classroom to mark things on the agenda and add things such as marks. Is this a use case that works with the expected project and if so what type of data from google classroom would you like to be used?~~
*   ~~Where should we store data? Should we continue to use google products like you currently are?~~
*   ~~What are you currently using google classroom for (what are the students and teachers doing on google classroom currently)? What software are you currently using besides classroom?~~
*   ~~Monitoring of students? Would there be any type of monitoring in place so that teachers or other staff can view what students have posted, in case of inappropriate content? (especially in the chat)~~
*   ~~What is meant by the camera being accessible on google classroom and would like the ability to "pull" this info?~~
*   ~~More info on task chunking and the goal setting~~

To Ask:



*   Is the cost of Firebase okay?

