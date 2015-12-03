# ClassBeacon
Student Attendance tracking iOS app that utilises iBeacons 


Introduction
-------

Student Attendance tracking application that utilises iBeacon.


Please open and edit ClassBeacon.xcworkspace.

Acknowledgments
--------
Thank you to all those mentioned below for helping make this project a reality

UNIVERSITY STAFF
Dr Christos Efstratiou

ORGANISATIONS
The University of Kent 
Apple, Inc 
Estimote,Inc
Parse

DEVELOPERS
Joan Lluch - AMSmoothAlert
Antoine Marliac - SWRevealViewController 
Shuichi Tsutsumi - Pulsating Halo
Kevin Zhow - PNChart 


Setup
-------

PARSE - http://www.parse.com

Once you've created an account;

1. Create an App

2. Copy Application ID & Client Key and use them in the AppDelegate

3. Create core classes; - ClassList: for storing all information of each lesson.
                        - Individual CLasses for recording each Lesson subject Attendance.
                        - iBeacon class for storing all iBeacon major and minor values and the room location of each beacon.
                        - Notes: for storing students notes.

I will include screen shots of the formats of all the classes in use.


Installation
-------
You may need to install the Pod for EstimoteSDK in that case follow these instrustions.


The easiest way to intall is to use CocoaPods. It takes care of all the required frameworks and third party dependencies:

```
pod 'EstimoteSDK'
```

Alternatively, you can install it manually. Follow the steps described below:

1. Copy the EstimoteSDK directory (containing libEstimoteSDK.a and Headers) into your project directory.

2. Open your project settings and go to the "Build Phases" tab. In the Link library with binaries section click "+". In the popup window click "add another" at the bottom and select the libEstimoteSDK.a library file.

3. You are done, congratulations! Happy tinkering!


