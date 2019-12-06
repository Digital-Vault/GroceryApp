# BTS530 Iteration 4

## Multiple Grocery Lists Research

From research of Google's [Cloud Firestore](https://cloud.google.com/firestore/ "Firestore Homepage"), we are planning on redesigning the database based on the user authentication UID (User Identification) value. The UID value is a unique hash code generated to identify a user in the system.

![alt text](./Images/BTS530_Iter4_MultipleListDesign.png)

When a user logs in, their UID will be used to fetch their lists from the Cloud Firestore database.