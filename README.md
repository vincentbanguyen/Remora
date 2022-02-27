# Remora
<img src="https://github.com/vincentbanguyen/Remora/blob/main/Remora/Assets.xcassets/AppIcon.appiconset/RemoraAppIcon-1024.png?raw=true" width="170">
Remora was created during HackIllinois 2022 with a 36-hour constraint. Contributors: Vincent Nguyen, Dhruv Chowdhary, Matt Paul, and Randy Thai.
## Inspiration
Constantly remembering to drink water can be hard, especially for us students when we are too busy with schoolwork or mindlessly scrolling on TikTok. Many people just don’t feel motivated to drink water since it seems to be the least of their problems with all the homework assignments or upcoming midterms. Even if we remember to drink some water, most people don’t drink nearly enough! Dehydration leads to many health problems such as headaches, dizziness, and overall tiredness. My mom used to caringly nag me to drink water every day, but being away from home forced me to make an app as a solution.

Although the concept of water drinking reminder apps already exists out there, none of them provide the proper motivation to drink water. Remora ups the stakes by providing a pet Remora for the user to take care of, by taking care of themselves. 

That is why we built Remora. Remora aims to provide a little remora fish buddy to help people stay hydrated!

## What it does
Throughout the day, the Remora app’s fish tank loses some water due to evaporation, just like how people start to get dehydrated due to daily activities. This serves as motivation for users to track and record their water intake, which fills up the fish tank to keep the remora fish alive! The app also has two viewing options for the fish tank: a pannable 3D fish tank and augmented reality.

## How we built it
We first used Figma to prototype our design. We then used SwiftUI to layout the user interface. The augmented reality was designed using ARKit. All of our 2D and 3D assets were created and animated using Blender and Adobe Illustrator. We used GitHub for version control and used GitHub projects to keep us on track.

## Challenges we ran into

Learning how to model in Blender was like stepping into a corn maze. Blender is an amazing 3D modeling software, but there are countless buttons and features that left us completely lost. Exporting textures and animations from Blender to Xcode was another hurdle since Xcode needed a .dae file which made exporting all the necessary data much more difficult.

Building an application in SwiftUI forced us to completely change how we approached programming. We were used to imperative programming where we code the “how”. In SwiftUI, we used declarative programming, where we code the “what”. There was a point where we asked ourselves, “Wait… what even is a function?!”. 

The augmented reality technology we used was also mind-numbingly bizarre. Referencing nodes in the scene was more complicated than it sounded. Scaling and moving the nodes in augmented reality did not work like the way it does in two dimensions as well. Some 3D objects were either so big or so small in the augmented reality that we had to hunt for them with the camera on our phones. It was like we were in another world.

We also wanted to develop an accurate water drinking recording system, so our idea was to match the app’s water bottle to a user’s real-life water bottle. As the user drinks water, they would adjust the app’s water bottle level to match, and we had to program how many oz that was. As a result, our innovative system was accurate, but much more complicated to create the algorithm than we had thought.

## What we learned
Creating Remora was an amazing experience where we learned how to make a mobile app that has augmented reality, improved our version control skills, and collaborated better to spark innovative ideas. Working under a 36-hour time constraint also helped us work under pressure, but have fun at the same time!

## What's next for Remora
So much! We hope to improve Remora’s movement in the fish tank as well as take our augmented technology to the next level by adding the option to interact with Remora. We hope to add in 3d food pellets that Remora would swim up to and eat. Our goal is to motivate users to drink water for Remora’s sake, so our efforts will be focused on strengthening that emotional bond.
