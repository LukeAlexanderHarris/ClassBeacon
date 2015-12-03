# ClassBeacon
Student Attendance tracking iOS app that utilises iBeacons.

Please open and edit ClassBeacon.xcworkspace.

Setup
-------

Parse - http://www.parse.com

Once you've created an account

* Create an App

* Copy Application ID & Client Key and use them in the AppDelegate
* Create core classes
* ------
* Users
* ClassList: for storing all information of each lesson.
* Individual CLasses for recording each Lesson subject Attendance.
* iBeacon class for storing all iBeacon major and minor values and the room location of each beacon.
* Notes: for storing students notes.



Installation
-------
You may need to install the Pod for EstimoteSDK in that case follow these instrustions.


The easiest way to intall is to use CocoaPods. It takes care of all the required frameworks and third party dependencies:

```
pod 'EstimoteSDK'
```

Alternatively, you can install it manually. Follow the steps described below:

* Copy the EstimoteSDK directory (containing libEstimoteSDK.a and Headers) into your project directory.

* Open your project settings and go to the "Build Phases" tab. In the Link library with binaries section click "+". In the popup window click "add another" at the bottom and select the libEstimoteSDK.a library file.

* You are done, congratulations! Happy tinkering!


Acknowledgments
--------

Joan Lluch - [AMSmoothAlert] (https://github.com/mtonio91/AMSmoothAlert)
Antoine Marliac - [SWRevealViewController] (https://github.com/John-Lluch/SWRevealViewController)
Shuichi Tsutsumi - [Pulsating Halo] (https://github.com/shu223/PulsingHalo)
Kevin Zhow - [PNChart] (https://github.com/kevinzhow/PNChart) 
