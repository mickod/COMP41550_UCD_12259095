Mesh Display
============

Project overview
----------------
The project has three main components:
- Mesh Display Server
- Mesh Display Controller
- Mesh Display Client

These combine to produce a system allowing multiple clients (iphones at this time) be combined to create a display, where each phone forms part of the display. The system currently supports text display only so the most obvious combined display is a word or a sentence with each iphone displaying one character of the message.

Mesh Display Server
-------------------
This is hosted on an Amazon EC2 Ubuntu instance, and built on the Codeigniter PHP MVC framework, which in turn sits on a standard Ubuntu LAMP installation. The Mesh Display Server uses an extension to the Codeigniter framework called codeigniter-restserver, and it implements a RESTFUL web API returning JSON encoded information to the Controller and client.

Mesh Display Controller
-----------------------
This is an iPAD app which allows a user create and delete display events, and line up and set the text for the client devices. It speaks only to the server, not to the client devices themselves. It uses HTTP GET, POST and DELETE messages and accepts JSON encoded responses from the server. It automatically addes clients to the display when new clients join an event, and it allows the user pan and line up the clients as required to match the physical layout of the clients in the real world. To support adding the devices automatically it contains a main storyboard and also a separate xob view, which is used for programatically added subviews when the clients are added. Asynch messaging and block handlers are used extensively to ensure the GUI remains responsive and to keep the design as simple and robust as possible.

Mesh Display Client
-------------------
This is an iPhone app which allows a user join and event and then simply displays whatever the server tells it it should. Again, it uses HTTP REST messaging to communicate with the server and similar mechanisms to the controller to keep the messaging design as simple and 'readable' as possible.

iOS technical notes
-------------------
Both clients use polling rather than apple notifications. This was mainly to keep the complexity and the integration effort manageable and one of the next logical evolution steps will be to experiment with notifications and see if they are a suitable mechanism for this type of application. The http messaging elements of the project along with the necessary asynchronous methods and block handlers provided most of the technical challenges. and the threading implications in particular are something that would be very interesting to study further. Surprisingly, more time consuming were the small xcode and apple centric nuances which over time one would hopefully become more familiar with. Examples are the fact that the keyboard does not close automatically on the iPhone, that independent xib views have a slightly different builder than the storyboards making it hard to see nesting sometimes, and the fact that nil objects can be messaged. When you are not used to it, the latter can actually be tricky as issues which would normally cause a crash in other languages may cause more subtle problems in objectiveC.

Project Integration notes
-------------------------
Getting the different elements of the system to integrate successfully was one of the key challenges of this project - not because any one parts in itself was particularly complex, but because a careful strategy was needed to avoid repeating lengthy setup and test steps whenever changes and modifications were made. To this end, as much as possible of the testing was done on one machine using the iOS simulator and MAMP (a MAC based LAMP like stack) for the server. One thing that would have helped would be a reliable apple supported way to run multiple simulators at the same time - I could not find an obvious 'official' way to do this and did not have time to experiment with some of the suggestions on the web.

Reflections on iOS after the assignments and the project
---------------------------------------------------------
It is interesting (if a little tough...) doing the Android and iOS courses at the same time. I do find objective-C syntax a little strange, but the xcode editor helps enormously with its autocompletion. I am not entirely convinced by the strong reliance on the GUI elements of xcode and in particular some of the 'magic' that the storyboard and xib builder provide. I found that when it all worked the magic was great, but when something went wrong it could be very hard to work out the root cause. In common with Android I found that some of the documentation and guides were out of date or wrong - in particular there was an issue getting the UCD iPAD recognised on my development machine and the apple documentation was obscure and out of date. Contrasting it with the Linux and LAMP elements of this project, I think maybe commercial enterprises like Apple, Microsoft etc probably raise our expectations where as with the more 'open source' systems we are maybe more tolerant of having to search through the web for answers to issues.


