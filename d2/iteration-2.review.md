# TDSB-Student Agenda (Team 1)

## Iteration 02 - Review & Retrospect

 * When: Nov 12th
 * Where: Discord

## Process - Reflection

Since our last deliverable, we feel that our team has come into their stride. We are all more comfortable with our stack, which was new for all of our members and our application is beginning to really take shape. 

Since the last deliverable, we’ve met some important milestones, most significant of all, our backend API is finished which will allow our work to continue at a much more rapid pace. Group members will now be able to immediately pull data once a view is finished, instead of having to populate it with dummy data, and revisit their work at a later time. Some very important front-end work has also been completed. Things like the calendar, agenda, task addition and goal visualization screens have really given our application form and we feel our members have a clearer vision of what we’re trying to build moving forward. 

On the other hand, this deliverable has also come with its fair share of challenges. Flutter/Dart’s, Firebase’s, and Google Classroom’s lack of consistent documentation and relative novelty has made implementing some features (like the bottom navigation bar and google authentication) difficult. Also, commitments to other courses with heavy workloads (like CSC369 and CSC311) has made meeting some deadlines difficult. Still, our group remains optimistic that we will be able to deliver a quality product.

#### Decisions that turned out well

> List process-related (i.e. team organization) decisions that, in retrospect, turned out to be successful.


 > * 2 - 4 decisions.
 > * Ordered from most to least important.
 > * Explain why (i.e. give a supporting argument) you consider a decision to be successful.
 > * Feel free to refer/link to process artifact(s).

* Keeping front-end and back-end distinct and then linking them instead of feature oriented design
    * This decision was successful because of the scope of our back end implementation. Everything in the front end requires the same implementation of the backend, and if we went with a feature oriented approach, the backend for each feature would differ slightly. Once we had the backend finished, this allowed us to develop front end features much more quickly.

* Using Trello for organization
    * Using Trello has been a boon for our productivity. By displaying all of our tasks in one place, it allows everyone to get a good idea of where we are in the project and what still needs to be done. Furthermore, it allowed us to split up our tasks into sprints which allowed us to set realistic goals.

* Using Firebase and Flutter
    * Using Firebase and Flutter has allowed us to abstract away a lot of the lower level implementation details of things we are trying to do. Firebase also takes away a lot of the legwork required for things like storing data and user authentication, which allows us to focus our efforts in other areas and ultimately, makes us more productive. Flutter allows us to focus our efforts into a single code base instead of multiple for each OS

#### Decisions that did not turn out as well as we hoped

> List process-related (i.e. team organization) decisions that, in retrospect, were not as successful as you thought they would be.

 > * 2 - 4 decisions.
 > * Ordered from most to least important.
 > * Feel free to refer/link to process artifact(s).

* Having people individually pick Trello issues to work on was not a good decision because this ended up making the work done by team members uneven. We should have instead had one or two people assign work to other members so that the work is distributed more or less evenly. This would also make our workflow faster since some members lagged behind in choosing things to work on.
* Not enforcing sprint deadlines and relying on members of the group being proactive about meeting deadlines was not a good decision. This prevented us from completing some tasks in a timely manner and slowed down our progress.  
* We put only coding tasks into Trello which created a false sense of security as to how much time we have to complete tasks related to the deliverables. It made us really focused on the development of the application and writing code, while possibly neglecting documentation, READMEs and other project documents.
* Deciding to demo the app so early on may have not been a good idea because we did not have some of the front end features working at that point. While we were and still are moving in the right direction with the features themselves, we might have missed out on some feedback about how the frontend design looks like and whether that needs changing. 




#### Planned changes

> List any process-related changes you are planning to make (if there are any)

 > * Ordered from most to least important.
 > * Explain why you are making a change.

* Specific teammates, Victor and Josh, will choose tasks for the sprints and assign them to other teammates to make sure the expectations of them is clear  
* To fix out third bad decision we will also be putting all of the subtasks that we have to do (READMEs, documentation, deliverable documents, etc.) onto Trello so that we have a clear and organized way of tracking when these get done and by whom. 
* To fix deadlines not being reached by other members we will urge members who are behind to focus more on the project. (Hard to do without authority since they are fellow students)


## Product - Review

#### Goals and/or tasks that were met/completed:

 > * From most to least important.
 > * Refer/link to artifact(s) that show that a goal/task was met/completed.
 > * If a goal/task was not part of the original iteration plan, please mention it.
 
Organized by importance under each Sprint

 * __Sprint 1 Goals that were met:__ 
     * Setup flutter and firebase
     * Created all UI/frontend Screens
    * Added ability to login with a google account through firebase authentication and google authentication apis
        * Pressing login button in Login UI signs user into google account
    * Stored needed user data in Firebase's Firestore database in order to get google classroom authentication working
 * __Sprint 2 Goals that were met:__
    * Built out backend API
        * Internal API functions for storing and grabbing data from Firestore
        * Internal API functions for getting google classroom data that is stored in Firestore under each user
        * Internal API functions that call google classroom API to request user's google classroom data
     * Added Navigation between pages using bottom nav bar and sliding side menu
    * Connect Screens to backend API (partial)
        * Connected Course Works Screen
        * Connected My Courses Screen

#### Goals and/or tasks that were planned but not met/completed:

 > * From most to least important.
 > * For each goal/task, explain why it was not met/completed.      
 >  e.g. Did you change your mind, or did you just not get to it yet?
 
 * __Sprint 1 Goals not met:__
     * ALL GOALS WERE COMPLETED
 * __Sprint 2 Goals not met:__
     * Connect Screens to backend API:
        * Agenda/Calendar Screen
        * Main Dashboard Screen
        * Add Goals Screen
        * Goals List Screen
        * Performance Screen
 
 * __Other Goals not met__
    * Have not yet tested the iOS version (difficult for us to compile/test with lack of apple products)
 

#### How was your product demo?
 
 > * How did you prepare your demo?  
 
 We Prepared by 
 * Completed most important UI/frontend elements before the demo meeting 
 * Added temporary routing/navigation to show all screens
 * Prepared a phone with the app running
 
 > * What did you manage to demo to your partner?
 
 We were able to demo most of our frontend/UI and the google sign-in functionality 
 
 > * Did your partner accept the features?
 
 The partner accepted all the demoed features, all change requests were additions
 
 > * Were there change requests?
 
 The partner requested that we not only have course/assignment specific goals but also overarching goals for the students themselves
 
 > * What did you learn from the demo from either a process or product perspective?
 
We learned that sometimes we need to better articulate our questions and requirements to fully outline what work needs to be done. For example, due to a miscommunication with our partner concerning the goals screen, we had to rework a couple of views to fit their needs. In the same vein, we also learned that sometimes instructions are not exhaustive and we need to make decisions about features ourselves. 

From a product perspective, we learned that allowing an app to develop naturally has its pros and cons. While it may lead to some great results, the lack of specific roles between team members can make it hard to meet deadlines and integrate different portions of the app.


# Meeting Highlights

> Going into the next iteration, our main insights are:
 > * 2 - 4 items
 > * Short (no more than one short paragraph per item)
 > * High-level concepts that should guide your work for the next iteration.
 > * These concepts should help you decide on where to focus your efforts.
 > * Can be related to product and/or process.

* Need to split tasks better to avoid work being split unevenly between group members creating inefficiencies in the development process.
* Need more descriptions of code that will be used by other members
    * In the example of our backend API, members cleared up any confusion by reading the documentation and looking at the diagrams that were created by the backend developer
* Now that the structure of the application is complete we will focus on completing features directly by linking front end views to the backend API
