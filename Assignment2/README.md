Mick O'Doherty 12259095 mick.odoherty@amodtech.com (using this email as GITHUB set up before UCD email)

Notes:
- Added a Webview linking to Wiki with polygon name as parameter.
- Added animation using Quartz framework. It took quite a bit of effort to get this working and the documentation was not great - I did it as I have time this week and may not have as much time for the main project due to work commitments so wanted to try things out now and get as much done as possible.
- Added Modal and Push Seques - mixing them does not really look great but wanted to get a feel for both.
- I tried to stick strictly to Apple's MVC paradigm and use protocol delegates where ever appropriate, including for communication between view controllers.
- Further improvements if the project was being expanded: refactor a little, for example to create a single constants header file; Create a more elegant mapping mechanism between image files names and the image selection UI element; Add a check for running animations before starting animation (clicking to start another while one is running will leave an image on the screen at the end at the moment)


