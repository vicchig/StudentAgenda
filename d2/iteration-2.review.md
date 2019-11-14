# TDSB-Student Agenda (Team 1)

## Iteration 02 - Review & Retrospect

 * When: Nov 12th
 * Where: Discord

## Process - Reflection

> (Optional) Short introduction

#### Decisions that turned out well

> List process-related (i.e. team organization) decisions that, in retrospect, turned out to be successful.


 > * 2 - 4 decisions.
 > * Ordered from most to least important.
 > * Explain why (i.e. give a supporting argument) you consider a decision to be successful.
 > * Feel free to refer/link to process artifact(s).

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


## Product - Review

#### Goals and/or tasks that were met/completed:

 > * From most to least important.
 > * Refer/link to artifact(s) that show that a goal/task was met/completed.
 > * If a goal/task was not part of the original iteration plan, please mention it.
 
 * __Sprint 1 Goals that were met:__ 
 	* Setup flutter and firebase
 	* Created all UI/frontend Screens
	* Added ability to login with a google account through firebase authentication and google authentication apis
		* Pressing login button in Login UI signs user into google account
	* Stored needed user data in Firebase's Firestore database in order to get google classroom authentication working
 * __Sprint 2 Goals that were met:__
 	* Added Navigation between pages using bottom nav bar and sliding side menu
	* Connect Screens to backend API (partial)
		* Connected Course Works Screen
		* Connected My Courses Screen
	* Built out backend API
		* Internal API functions for storing and grabbing data from Firestore
		* Internal API functions for getting google classroom data that is stored in Firestore under each user
		* Internal API functions that call google classroom API to request user's google classroom data

#### Goals and/or tasks that were planned but not met/completed:

 > * From most to least important.
 > * For each goal/task, explain why it was not met/completed.      
 >  e.g. Did you change your mind, or did you just not get to it yet?
 
 * __Sprint 1 Goals not met:__
 	* ALL GOALS WERE COMPLETED
 * __Sprint 2 Goals not met:__
 	* Connect Screens to backend API:
		* Agenda/Calendar Screen
		* Add Goals Screen
		* Goals List Screen
		* Main Dashboard Screen
 
 * __Other Goals not met__
 	* Was promised by partner to see a group of students who would be able to test the application, this meeting has been lost in the ether
	* Have not yet tested the iOS version (difficult for us to compile/test with lack of apple products)
 

#### How was your product demo?
 
 > * How did you prepare your demo?  
 
 We Prepared by 
 * Completing all UI/frontend elements before the demo meeting 
 * Added temporary routing/navigation to show all screens
 * Prepared a phone with the app running
 
 > * What did you manage to demo to your partner?
 
 We were able to demo all of our frontend/UI and the google sign-in functionality 
 
 > * Did your partner accept the features?
 
 The partner accepted all the demoed features, all change requests were additions
 
 > * Were there change requests?
 
 The partner requested that we not only have course/assignment specific goals but also overarching goals for the students themselves
 
 > * What did you learn from the demo from either a process or product perspective?
 
 We learned that requirements may change arbitrarily because the client does not know how to express what they want. For example, at first the partner said that she wanted course specific goals, but during the demo we found out that we needed overarching goals as well

 

## Meeting Highlights

> Going into the next iteration, our main insights are:
 > * 2 - 4 items
 > * Short (no more than one short paragraph per item)
 > * High-level concepts that should guide your work for the next iteration.
 > * These concepts should help you decide on where to focus your efforts.
 > * Can be related to product and/or process.

* Need to split tasks better to avoid a few people carrying the group unintentionally 
* Need more descriptions of code that will be used by other members
	* In the example of our backend API, members cleared up any confusion by reading the documentation and looking at the diagrams that were created by the backend developer
* Now that the structure of the application is complete we will focus on completing features directly
