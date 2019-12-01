# CSC301 - TDSB TEAM 1 (Student Agenda)

> _Note:_ This document is intended to be relatively short. Be concise and precise. Assume the reader has no prior knowledge of your application and is non-technical. 
### Users: 
Arian Safaei 1004206691 Github id: ArianSafaei 
## Description 
 * Provide a high-level description of your application and it's value from an end-user's perspective
 * What is the problem you're trying to solve?
 * Is there any context required to understand **why** the application solves this problem?  
 
Many middle school students have trouble keeping up with tasks they write down in their agendas; many don't even write anything down. Our application aims to help solve and simplify these organizational by automating some of the processes involved. Instead of constantly checking online for when an assignment has been assigned, students will get notifications from our application, which links to their Google Classroom accounts, every time an assignment has been posted. Students can then set up in-app goals and reminders for the work that has to be done for the assignment and track their overall progress through our performance metrics.


## Key Features
 * Described the key features in the application that the user can access
 * Feel free to provide a breakdown or detail for each feature that is most appropriate for your application <br/>  
 
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

<br/>

__4. Perfmormance Metrics:__ <br/>
Our application offers a variety of metrics to track a user's performance. It provides information about completed, created, late and incomplete goals for the past four, five and 12 months. The user is able to view dynamic pie charts displaying the ratio of each type of goal for that time period, a timeline of completed goals and the counts of each type of goal in a colour-coded table in the Performance screen.
<br/>

__5. Calendar View:__ <br/>
Our application provides an internal calendar that allows users to see upcoming goals. Goals are marked as green dots for each day on the calendar where a goal is due. The user can switch between month, 2-week, and weekly view by pressing the orange button next to the month. The user is also able to see the description of the goals for a specific day once they click on that day in the calendar.
<br/>

__6. Goal List View:__<br/>
The user is able to see all of their goals (complete, late and incomplete) in a single view. They are also able to mark goals as complete in the same view broken down by day.. This allows the user to have a detailed breakdown of everything that they have to do.
<br/><br/>


## Instructions
 * Clear instructions for how to use the application from the end-user's perspective
 * How do you access it? Are accounts pre-created or does a user register? Where do you start? etc. 
 * Provide clear steps for using each feature described above
 * If you cannot deploy your application for technical reasons, please let your TA know at the beginning of the iteration. You will need to demo the application to your partner either way. <br/>
 
 __Running the Application:__<br/>
In order to install and run the application, the user will need an Android device. Our application only supports Android and will not work on other platforms.
<br/>

__Accounts:__<br/>
The application is only accessible with a Google account, if a user does not have a google account, they will not be able to sign in. If a user has a Google account, they can simply press the login button and enter their login information to use the application. Once they have logged in once, Android will save their sign in information and the next time a user logs in they can just click login without having to enter their information again. <br/>

__Using the App:__ <br/>
The user is able to navigate to the calendar, goals screena and the main dashboard using a navigation bar at the bottom of the application window. They are able to access the rest of the views through the drawer menu in the top left corner of the main app bar. 
<br/><br/>

 
 ## Development requirements
 * If a developer were to set this up on their machine or a remote server, what are the technical requirements (e.g. OS, libraries, etc.)?
 * Briefly describe instructions for setting up and running the application (think a true README). <br/>
 
 __System Requirements:__<br/>
 * An Operating System that supports running Android studio.
 * Android Studio to be able to run, write and test the code.
 * Flutter framework has to be installed to be able to build and run the project.
 * The project requires all dependencies listed in the pybsepc.yaml file.
 <br/><br/>
 
 __Set Up Instructions:__ <br/> <br/>
__1. Set Up Flutter:__ <br/>
* Download flutter from https://flutter.dev/docs/development/tools/sdk/releases?tab=windows
* Unzip the file in a directory of your choice and depending on what platform you are, update your PATH environment variable to include the path to the Flutter folder.
* Run the command `flutter doctor` in the command line to ensure that the installation went smoothly. <br/>

 __2. Set Up Android Studio:__ <br/>
 __Although you can write code in any editor of your choice, Flutter relies on the complete installation of Android Studio to supply its Android dependencies, without it, you will not be able to run the app.__<br/>
 
* Install the latest version of Android Studio and make sure to update the AndroidX library.
* Update all SDKs to API version 27 or above.
* Make sure that the virtual device you plan on testing the project on has Google Play Services enabled and updated to the latest version. This can be done from the SDK manager window in Android Studio.
* Download the Flutter and Dart plugins from Android Studio's plugin manager. (In Android Studio: File->Settings->Plugins).
* Run `flutter doctor` again to make sure that Flutter recognizes Android Studio.<br/>

__3. Add the Codebase as a project to Android Studio:__<br/>
* The easiest way to do this is to push the codebase to VCS like GitHub and then "checkout a project from version control" in the Android Studio dashboard. 
* Alternatively you can do `File->New->New Flutter Project` and then add the codebase to the project files in the project directory.<br/>

__4. Set Up Firebase and OAth2:__<br/>
The project also requires it to be added to Firebase in order to use the Firebase Cloud Firestore. This is the NoSQL database that we decided to use to support this project.
* The instructions for this can be found here: https://firebase.google.com/docs/android/setup
* In addition, to enable user notifications you will have to set up your project in the Google Developer Console and link it to OAth2, instructions for this are here: https://developers.google.com/google-ads/api/docs/oauth/cloud-project
* More detailed instructions can be found here: https://support.google.com/cloud/answer/6158849?hl=en <br/>
* __Make sure to fill out ALL fields in the OAth consent screen tab in the Google Developers Console. IF YOU DO NOT DO THIS, YOU WILL LIKELY NOT BE ABLE TO LOG IN WITH GOOGLE.__
* Add developer SHA-1 keys to the project using the Firebae console and the `keytool` command. Detailed instructions on enabling Google Sign In with Firebase are here: https://firebase.google.com/docs/auth/android/google-signin
<br/>




 ## Licenses 
We are going to be using an MIT license. This allows anyone (most importantly our partner) to freely modify our codebase as they see fit. This will allow our partner to make any additions or changes to our application as they see fit. In addition, it removes any responsibility from us in regards to further supporting the software or any damages that may have occurred in connection with our product. We want this mostly because we are unlikely to be actively supporting this product in the future.

