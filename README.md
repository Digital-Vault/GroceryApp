# Group_02

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
Keeping track of items in shopping lists can be a difficult task. Most people try to memorize all the items just before they leave the house. The problem with this approach is that human memory is unreliable and even if they write it down, the paper usually gets lost. A bigger challenge is coordinating grocery shopping between multiple people. It usually results in purchase of duplicate or wrong items and multiple trips to the store. Food gets spoiled everyday because people don't have the required time and energy to track all items in the fridge.

Our app allows users to keep track of their shopping list in a simple format. They can add new items to the list and cross them when picked up. Our app provides a list of items currently in their refrigerator along with an estimated expiry date. Users can add expiry dates either manually or by using our expiry estimator that suggest expiry dates based on the product. The app can sync multiple accounts together which is perfect for busy families. All shopping lists and refrigerator contents are accessible on synced accounts.

## Use Cases

### Create User Account

#### Brief Description (Scope)
This use case is the process that a user goes through in order to create their account for the application.

#### Actors (Users)
Users (anyone that is using the application)

#### Preconditions
The user has the application installed on their smartphone and has clicked the "Create Account" button to navigate to the registration form.

#### Basic flow
The user enters the required information into the registration form by clicking on the available text input fields and inputting text via the on-screen keyboard on their smart phone. All inputted text is validated via client side algorithms (see Alternate / Exception Flows below). Once all required information is inputted (eg. first name, last name, username, password, email, etc...) into the form, the "Register Account" button will be made available for the user to click. All data on the form will then be parsed for integrity/validity and stored into a database as user credentials for future login operations.

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

### Add an item to the grocery list
#### Brief description
This use case describes the process of a user adding a new item to the grocery list.

#### Actors
Typical user

#### Preconditions
The user has opened the application and is currently in the grocery list section.

#### Basic flow
The user taps on the floating action button (FAB) which opens a new screen with text fields for product name and additional notes. The user then fills in the information and when ready taps on the add to list button. The application then redirects the user back to the grocery list screen.

#### Alternate / Exception Flows
**_Alternate Flow 1: Missing Product Name_**
The add to list button will be disabled until the user inputs a value.

**_Alternate Flow 2: User presses back button_**
In case of a user pressing the back button, the application won't save the new item and will redirect the user back to grocery list screen.

**_Alternate Flow 3: Other Issues_**
An error message will appear in case of any unexpected errors.

#### Post-conditions
A new item is added to the grocery list.

### Sync Accounts

#### Brief description
This use case is the process that a user goes through to sync multiple accounts together.

#### Actors
User(Anyone that uses the application)

#### Preconditions
The user must have the application installed and opened

#### Basic flow
The user clicks the "Send Sync Invite" button located in the home page of the app. This will navigate them to a page where they can enter additional users. They will be prompted to enter the email of the additional user into a textfield. If they need to keep adding new users, there will be a "+ add new user" button at the end, which will keep creating new rows that will ask for the email of the additional user. Once they have added all the users, they can click the "Save" button.

#### Alternate / Exception Flows
**_Alternate Flow 1: Invalid Email_**

If the email is not recognized by the application as a valid email, the user will get a notification saying "invalid email" and will be prompted to enter the email again.

**_Alternate Flow 2: Missing Email_**

The Save button will be disabled until atleast one valid email is entered.

**_Alternate Flow 3: Other Issues_**

An appropriate error message will be shown in case of unexpected errors.

#### Post-conditions
A request of confirmation is sent out to all the users being added to the family account.
A new item is added to the grocery list.

## Use Cases

### Crossing out items from the grocery list, and adding expiry date

#### Brief description (scope)
This use case describes the process of a grocery shopper crossing out the items that they have purchased and adding an expiry date for the items (expiry date can be added by the user or automatically generated by the app).

#### Actors (users)
Grocery Shoppers

#### Preconditions
The user is on the grocery list view page of the app.
The user has items to cross out.

#### Basic flow
The user looks through the selected grocery list and clicks one or more items to cross out of the list. Once the item(s) is/are crossed out, the application will ask the user to enter in an estimated expiry date for all the item(s) that has/have been crossed out in a drop-down list format. When the user has entered in the dates for the items (providing expiry dates for items are not mandatory; refer to the alternation flows), he/she clicks complete. The application will redirect the user back to the grocery list page.

#### Alternate and/or exception flows
**_Alternate Flow 1: Missing Expiry Date Input_**
If the user decides to not enter in an expiry date, they can click a button by the drop-down list to allow the application to generate its own estimated expiry date from its database.
**_Alternate Flow 2: Automatic Expiry Date Generator Error_**
If the user decides to let the application provide the expiry dates but the app cannot find the date for the item, it will alert the user that no expiry date was found in the database and provide a null value.


#### Post-conditions
Once completed button is clicked, the crossed-out items will be added “My Items” page, where you can find the them with its corresponding expiry dates.
