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

Keeping track of shopping lists can be a difficult task. People forget to write them and even if they did write it on a piece of paper, it might get lost. A bigger challenge is coordinating a list of items with multiple people when shopping. If not done correctly it might result in duplicate purchases. Additionally, tracking refrigerator contents or checking the expiry date of every item is a time consuming task however, if not done it can result in spoiled food on a daily basis.

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
The user enters the required information into the registration form by clicking on the available text input fields and inputting text via the on-screen keyboard on their smart phone. All inputted text is validated via client side algorithmns (see Alternate / Exception Flows below). Once all required information is inputted (eg. first name, last name, username, password, email, etc...) into the form, the "Register Account" button will be made available for the user to click. All data on the form will then be parsed for integrity/validity and stored into a database as user credentials for future login operations.

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
