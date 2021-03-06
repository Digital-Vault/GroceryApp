﻿# Group_02

## Team Members

### Jacky Tea

- Github: JackyTea
- Skype: live:teajacks_1
- Role: UI Design, Implementation

### Abiram Kaimathuruthy

- Github: abiram31
- Skype: live:e09ff44e106efd35
- Role: UI Design, QA Testing, Research

### Sang Min (Rick) Park

- Github: 9714park
- Skype: live:9714park
- Role: Research, Implementation, QA Testing

### Brian Smith

- Github: blackHatMonkey
- Skype: live:9fea3ac00220d3e2
- Role: UI Design, Documentation, Implementation

## Business Description
Keeping track of items in shopping lists can be a difficult task. Most people try to memorize all the items just before they leave the house. The problem with this approach is that human memory is unreliable and even if they write it down, the paper usually gets lost. A bigger challenge is coordinating grocery shopping between multiple people. It usually results in the purchase of duplicate items or items you did not need and can lead to multiple trips to the store. Food gets spoiled everyday because people don't have the required time and energy to track all items in the fridge.

Our app allows users to keep track of their shopping list in a simple format. They can add new items to the list and cross them out when picked up. Our app provides a list of items currently in their refrigerator along with an estimated expiry date. Users can add expiry dates either manually or by using our expiry estimator that suggest expiry dates based on the product. The app can sync multiple accounts together which is perfect for busy families. All shopping lists and refrigerator contents are accessible on synced accounts.

## Use Cases

### Create User Account

#### Brief Description
This use case describes the process that a new user goes through in order to create their account for the application.

#### Actors
First time users (new users)

#### Preconditions
The user has the application installed on his/her smartphone and has clicked the "Create Account" button to navigate to the registration form.

#### Basic flow
The user enters the required information into the registration form by clicking on the available text input fields and inputting text via the on-screen keyboard on their smart phone. All inputted text is validated via client-side algorithms (see Alternate / Exception Flows below). Once all required information is inputted (eg. first name, last name, username, password, email, etc...) into the form, the "Register Account" button will be made available for the user to click. All data on the form will then be parsed for integrity/validity and stored into a database as user credentials for future login operations.

#### Alternate / Exception Flows
**_Alternate Flow 1: Incorrect Input_**

Any input that does not match a specified criteria (eg. format, length, username not unique) will be highlighted and the app will prompt the user to correct it. The "Register Account" button will be disabled until the user has corrected their input.

**_Alternate Flow 2: Missing Input_**

Any required textfield will be highlighted if it is not filled.
The "Register Account" button will be disabled until the user has entered all required information.

**_Alternate Flow 3: Database, Validation & Other Issues_**

An error message will be displayed to the user if any issues arise while their data is being processed, saved or validated. An error code, if available, will also be displayed for ease of troubleshooting.

#### Post-conditions
The user account and all associated data is created and saved to the backend database. The user is now able to login to the application and access its features as well as utilize its intended functionality.

### Add An Item To The Grocery List
#### Brief description
This use case describes the process of a user adding a new item to the grocery list.

#### Actors
Typical user

#### Preconditions
The user has opened the application and is currently in the grocery list section.

#### Basic flow
The user taps on the floating action button (FAB) which opens a new screen with text fields for product name and additional notes. The user then fills in the information and when ready taps on the add to list button. The application adds the new item to the database and redirects the user back to the grocery list screen.

#### Alternate / Exception Flows
**_Alternate Flow 1: User presses back button_**

In case of a user pressing the back button, the application won't save the new item and will redirect the user back to grocery list screen.

**_Alternate Flow 2: Other Issues_**

An error message will appear in case of any unexpected errors.

#### Post-conditions
A new item is added to the database as well as the grocery list.

### Invite Users to Sync Accounts

#### Brief description
This use case is the process that a user goes through to invite multiple accounts to sync together.

#### Actors
Typical User

#### Preconditions
The user must have the application installed and opened

#### Basic flow
The user clicks the "Send Sync Invite" button located in the home page of the app. This will navigate them to a page where they can enter additional users. They will be prompted to enter the email of the additional user into a textfield. If they need to keep adding new users, there will be a "+ add new user" button at the end, which will keep creating new rows that will ask for the email of the additional user. Once they have added all the users, they can click the "Save" button which sends an email to all specified users.

#### Alternate / Exception Flows
**_Alternate Flow 1: Invalid Email_**

If the email is not recognized by the application as a valid email, the user will get a notification saying "invalid email" and will be prompted to enter the email again.

**_Alternate Flow 2: Missing Email_**

The Save button will be disabled until at least one valid email is entered.

**_Alternate Flow 3: Other Issues_**

An appropriate error message will be shown in case of unexpected errors.

#### Post-conditions
A request of confirmation is sent out to all the users being added to the family account.


### Crossing Out Items From the Grocery List and Adding Expiry Date

#### Brief description
This use case describes the process of a grocery shopper crossing out the items that they have purchased and adding an expiry date for the items (expiry date can be added by the user or automatically generated by the app).

#### Actors
Typical user

#### Preconditions
The user is on the grocery list view page of the app.
The user has inserted at least one item to the list

#### Basic flow
The user looks through the selected grocery list and clicks an item to cross out of the list. Once the item is crossed out, the application will display a new page to ask the user to enter in an estimated expiry date for the item that has been crossed out in a drop-down list format.  The user enters in the dates for the items and clicks complete. The database will update the status of the crossed-out grocery lists to purchased and add on the expiry date information. the The application will redirect the user back to the grocery list page. 

#### Alternate / Exception Flows
**_Alternate Flow 1: Missing Expiry Date Input_**

If the user decides to not enter in an expiry date, the user can click a button by the drop-down list to allow a predefined date to be automatically inserted. If the the application cannot provide a predefined date for the item, it will alert the user that no expiry date was provided and leave it blank.

#### Post-conditions
Once completed button is clicked, the crossed-out items will be added “My Items” page possibly with its expiry date. A notification will be automatically scheduled for all the expiry dates. The crossed-out grocery list's status is modified to purchased and expiry date information will be added to the database.

## Technological Choices

### Front-End Technologies

This project will be written in [Dart](https://dart.dev/), a client-optimized programming language and will utilize the [Flutter](https://flutter.dev/) mobile application framework. We chose Flutter because it is backed by Google, has well written documentation and allows us to target both Android and IOS platforms with a single code base. This will save us a considerable amount of work and time compared to writing native Android and IOS applications separately. Additionally, Flutter integrates with [Firebase](https://firebase.google.com/) which is where we will host our data.

The design philosophy of this application will follow the [Material](https://material.io/design/) design language, which emphasizes flexible, intuitive and aesthetic visual layouts. This ensures that the User Interface (UI) is consistent throughout our application. Flutter includes many pre-made Material components that reduces our implementation time.

We will write the application on [Visual Studio Code](https://code.visualstudio.com/) along with [Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code) and [Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) extensions. We chose Visual Studio Code because all team members have previously used it and are comfortable with it.

Additionally Android and IOS emulators verify the progress of the application locally.

### Back-End Technologies

For our back-end, we will be using Google's [Firebase](https://firebase.google.com/). Firebase is a mobile and web development platform that utilizes many products to help build apps faster. We chose Firebase because it is backed by Google, making it an ideal platform for developing mobile apps. They are a reliable company that provides support in their easy to follow documentation. Firebase is our primary platform for performing back-end tasks such as server management, and setting up the database because of the following features: 

[Realtime Database](https://firebase.google.com/docs/database): A cloud-hosted database that stores JSON formatted data and synchronizes data in realtime across multiple platforms such as iOS and Android to every connected client. Realtime Database allows us to implement a database that is cross platform, where all the users share one Realtime Database instance which automatically updates with the newest data. This feature can be used to implement our database to store all the expiry date information and sync user grocery lists. 

[Cloud Storage](https://firebase.google.com/docs/hosting): Easy storage of user generated content like photos. This technology can be used in the future if we want to implement a photo storage system for users who want to take pictures of the expiry dates on their food. 



### Application Programming Interfaces (APIs)

The authentication process will be tasked by the [Firebase Authentication API](https://firebase.google.com/products/auth/), which allows users to sign in to his/her app using multiple authentication providers (Google, Facebook, Twitter, etc.) by linking their credentials to an existing user account. This makes it easier and more intuitive for users to access their accounts through various platforms. Firebase provides flexible authentication functionalities for the developers to integrate into their application.

The app will use the [Crashlytics API](https://firebase.google.com/products/crashlytics) provided by Firebase to report any issues that may occur throughout its usage. It will notify developers of any potential problems without user intervention which can be later handled quickly and accurately. Crashlytics is chosen because it is fairly easy to set up and free for most of its usage.
