BrewMobile
========

iOS client for the [Brewfactory][1] project

What is this?
-------------
App for supervising the brewing process from your iPhone.

 - continuous temperature updates
 - displays current phases with necessary info
 - gives visual feedback of the current state

**The UI**

![brew_demo_1][2]
![brew_demo_2][3]
 
Used technologies
-----------------

 - iOS >= 7.0
 - Socket.IO for WebSocket

### Setting up the project ###

$ pod install

$ open BrewApp.xcworkspace/

// TODO
-------

 - cover with tests
 - support push notifications (for phase changes)
 - iOS 8 support (Swift)

  [1]: https://github.com/brewfactory/BrewCore
  [2]: http://vasarhelyia.github.io/BrewMobile/img/1.png
  [3]: http://vasarhelyia.github.io/BrewMobile/img/2.png

