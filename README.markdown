*[Presented at the joint meeting of CocoaHeads-NYC and the New York FileMaker Developers Group, July 8, 2010.  I've heavily edited this since giving the presentation.  The original text was much more sparse.]*


The notes below are [online](http://www.notesfromandy.com/intro-to-global-hot-keys/).


### Mixed audience for this meeting ###

Therefore:

* Partly an intro to global hotkeys
* Partly a glimpse into Cocoa development, for newcomers
* Will show two apps, one trivial and one more advanced


### App One: "Hello World" of hot keys ###

App is called "Hotness".

* A minimal complete app
* Bare-bones UI with five buttons (actually a matrix of five button cells)
* Just one Objective-C class, four methods
* Hotkey actions are defined in five AppleScript files
* Uses a third-party library called <a href="http://github.com/davedelong/DDHotKey" target="_blank">DDHotKey</a> which makes registering hotkeys very simple

Cocoa patterns and techniques:

* target-action (the button matrix has a target)
* delegation (the application object has a delegate)
* calling AppleScript from Cocoa
* bringing your application to the front (see the hotkey mapping for Control-0)


### App Two: more realistic ###

App is called "WhatKeys".

* User can create, modify, and remove hotkey assignments
* Hotkeys can be mapped to either an AppleScript file or AppleScript code entered directly
* Like Hotness, uses DDHotKey
* Uses a third-party library called <a href="http://wafflesoftware.net/shortcut/" target="_blank">ShortcutRecorder</a> for entering and displaying keyboard shortcuts

Cocoa patterns and techniques are same as in Hotness, plus:

* MVC ("Model-View-Controller")
  * a model class (WKHotKeyAssignment)
  * view controller and window controller ("coordinating controllers")
  * array controller ("mediating controller")
* bindings
* properties
* responder chain
* user defaults and property lists (for saving the user's hotkey assignments)
* handling NSError


### Where to get ###

Here are links for the source:

* [Hotness](http://notesfromandy.com/stufftoshare/Hotness-1.0.zip)
* [WhatKeys](http://notesfromandy.com/stufftoshare/WhatKeys-1.0.zip)

To compile the example code you'll need Apple's Developer Tools, which you can get for free [here](http://developer.apple.com/) (requires registration).  After installing the Dev Tools, double-click an xcodeproj file to open the project in Xcode.


