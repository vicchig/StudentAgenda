# TDSB-Student Agenda (Team 1)

## Description 
Our application is a mobile app for both iOS and Android where students organize their school work and set goals to help them complete assignments. An increasing number of students are no longer using an agenda so those students need to be able to organize their work and manage their time effectively. This is one of the main purposes of the app. Students will be able to view their assignments which is pulled from Google Classroom. They can then add goals attached to those assignments (e.g. finish brainstorming, finish intro paragraph etc.) and set the time when this goal/task is to be completed. They would be able to view upcoming goals/tasks and view them on a calendar. Students will also be able to choose to be alerted for upcoming goals. They will also able to view task completion performance (tasks completed on-time vs. late) so they can reflect and improve on their time management. A teacher can use the app to view their students goals view their goal completion performance so that they can make sure their students are on track.


## Key Features
__1. Log in through Google:__<br/>
Users are able to link their Google Classroom accounts to our application by signing in through their Gmail account.
Our application then pulls the following information from their Google Classroom classes and either displays it in our application or uses it internally:
    * Class lists
    * Course works
    * Course announcements
    * Course teachers
    * Course topics
<br/>

__2. Users are able to make course specific goals:__ <br/>
Users are able to select goals from a predefined list of goals selected by the teacher and uploaded to the application. Should the user decide to create a goal of their own for a particular course, they may select ‘Other’ which will prompt them to enter this new goal. The user is able to choose the date the goal is due, change the description of the goal and mark goals as completed. After being added, the goal is stored in a database and the application keeps track of it for the user.<br/>

__3. Goal Notifications:__ <br/>
When a goal is added, our application creates notifications that the assignment is due on specific dates. Notifications will be pushed to the users device a week, day and hour before the selected due date
<br/>

__4. Perfmormance Metrics:__ <br/>
Our application offers a variety of metrics to track a user's performance. It provides information about completed, created, late and incomplete goals for the past four, five and 12 months. The user is able to view dynamic pie charts displaying the ratio of each type of goal for that time period, a timeline of completed goals and the counts of each type of goal in a colour-coded table in the Performance screen.
<br/>

__5. Calendar View:__ <br/>
Our application provides an internal calendar that allows users to see upcoming goals. Goals are marked as green dots for each day on the calendar where a goal is due. The user can switch between month, 2-week, and weekly view by pressing the orange button next to the month. The user is also able to see the description of the goals for a specific day once they click on that day in the calendar.
<br/>

__6. Goal List View:__<br/>
The user is able to see all of their goals (complete, late and incomplete) in a single view. They are also able to mark goals as complete in the same view broken down by day.. This allows the user to have a detailed breakdown of everything that they have to do.
<br/>

__7. Teacher View:__<br/>
Users through the course dashboard can access the teacher view of any course in which they are teachers of. In this view, teachers can receive a quick overview of the class, such as the currently enrolled students in that course. 
<br/><br/>

### Current Issues
All current issues that we are aware of on the APK are listed in the [Issues tab on github](https://github.com/csc301-fall-2019/team-project-tdsb-team-1/issues)


## Instructions
 We will provide the [APK file on Google Drive](https://drive.google.com/open?id=1jB17rdsIsMsg4Ml-wohERdrAKem1_m_T). The APK can be installed on a phone running Android.

 We will also provide a dummy Google credential. Here are the credentials for a dummy Google account:
 * Email: tdsbprojectdummy@gmail.com
 * Password: tdsb4321

 When the app is opened, it will show the login screen. To login, press the login button. There will be a popup to choose a Google account. You will scroll down and press "Add another account" and add the dummy account. Once you are signed in the app and it is the first time running it the app should prompt you to allow Google Classroom permissions. Press allow.

## Architecture

The app uses flutter as a frontend framework, and firebase as a backend framework to store data and link google classroom through students accounts

<img src="./Images/csc301_app_backend_diagram.png" width="480" height="300">

## Helpful Links

[Documentation](Documentation.md)
