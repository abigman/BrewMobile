# BrewMobile

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

iOS client for the [Brewfactory](https://github.com/brewfactory/BrewCore) project

What is this?
-------------
App for managing the brewing process from your iPhone.

 - continuous temperature updates
 - displays current phases with necessary info
 - gives visual feedback of the current state
 - brew designer - ability of composing new brew
 - stopping current process
 
## Used technologies

 - Swift
 - iOS >= 8.0
 - Socket.IO for WebSocket
 - [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)

## Setting up the project with [Carthage](https://github.com/Carthage/Carthage)
In case you don't have Carthage installed, run:

```
$ brew update && brew install carthage
```
then:
```
$ carthage checkout && carthage build --platform iOS

$ open BrewMobile.xcworkspace/
```

## The UI

![Brewing a beer](http://brewfactory.org/BrewMobile/img/6.png)![Designing a brew](http://brewfactory.org/BrewMobile/img/7.png)
