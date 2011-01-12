//
//  WhatKeysAppDelegate.m
//  WhatKeys
//
//  Created by Andy Lee on 7/6/10.
//  Feel free to use this code however you like.
//

#import "WhatKeysAppDelegate.h"
#import "WKHotKeyAssignment.h"
#import "WKListEditorWindowController.h"


static NSString *	WKHotKeyAssignmentsPrefName = @"WKHotKeyAssignments";


@implementation WhatKeysAppDelegate

#pragma mark -
#pragma mark Class initialization

+ (void)initialize
{
	// Make sure this method only gets called once for this class.
	if (self != [WhatKeysAppDelegate class])
	{
		return;
	}
	
	// Construct an array of hotkey assignments.  I got the key codes for the numeric keys
	// (0-9) via this link: <http://boredzo.org/blog/archives/2007-05-22/virtual-key-codes>.
	static int			keyCodesFor0Through9[] = { 29, 18, 19, 20, 21, 23, 22, 26, 28, 25 };
	NSMutableArray *	defaultHotKeys = [NSMutableArray array];
	
	[defaultHotKeys addObject:
	 [WKHotKeyAssignment assignmentWithName:@"Google"
									keyCode:keyCodesFor0Through9[1]
							  modifierFlags:NSControlKeyMask
								AppleScript:@"open location \"http://www.google.com/\""]];
	
	[defaultHotKeys addObject:
	 [WKHotKeyAssignment assignmentWithName:@"Say Today's Date"
									keyCode:keyCodesFor0Through9[2]
							  modifierFlags:NSControlKeyMask
								AppleScript:@"say \"Today is \" & date string of (current date)"]];
	
	[defaultHotKeys addObject:
	 [WKHotKeyAssignment assignmentWithName:@"iTunes - Play"
									keyCode:keyCodesFor0Through9[3]
							  modifierFlags:NSControlKeyMask
								AppleScript:@"tell application \"iTunes\"\n"
	  @"	play\n"
	  @"end tell"]];
	
	[defaultHotKeys addObject:
	 [WKHotKeyAssignment assignmentWithName:@"iTunes - Pause"
									keyCode:keyCodesFor0Through9[4]
							  modifierFlags:NSControlKeyMask
								AppleScript:@"tell application \"iTunes\"\n"
	  @"	pause\n"
	  @"end tell"]];
	
	[defaultHotKeys addObject:
	 [WKHotKeyAssignment assignmentWithName:@"Sleep Computer"
									keyCode:keyCodesFor0Through9[5]
							  modifierFlags:NSControlKeyMask
								AppleScript:@"tell application \"Finder\"\n"
	  @"	sleep\n"
	  @"end tell"]];
	
	// Register these hotkeys as defaults in the defaults database (NSUserDefaults).
	//
	// In my opinion the word "defaults" in "defaults database" is misleading.  The defaults
	// database does indeed contain default values for various application settings, but it
	// also contains any custom values the user has specified for those settings.  The most
	// common use for the defaults database is to store values the user has entered in the
	// application's Preferences panel.  Obviously the values in that panel are not necessarily
	// "default" values -- the whole purpose of the panel is to allow the user to enter
	// non-default values.  To avoid confusion, remember that the default database is not a
	// database of defaults; it is a database of _settings_ with default values that can be
	// overridden by the user.
	//
	// What we're doing here is specifying actual default values -- a set of hotkeys that the
	// app will use in the absence of any change by the user.  This must be done very early in
	// the application.
	NSArray *		defaultHotKeysAsPlist = [WKHotKeyAssignment plistArrayFromAssignments:defaultHotKeys];
	NSDictionary *	defaultsDictionary = [NSDictionary dictionaryWithObject:defaultHotKeysAsPlist
																	forKey:WKHotKeyAssignmentsPrefName];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDictionary];
}


#pragma mark -
#pragma mark Init/awake/dealloc

- (id)init
{
	self = [super init];
	if (self)
	{
		listEditorWindowController = [[WKListEditorWindowController alloc] initWithWindowNibName:@"ListEditorWindow"];
	}
	
	return self;
}

- (void)dealloc
{
	[listEditorWindowController release];
	
	[super dealloc];
}


#pragma mark -
#pragma mark NSApplication delegate methods

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Load our UI with the hotkey assignments specified in the defaults database.
	NSArray *	keyAssignmentsPlist = [[NSUserDefaults standardUserDefaults] objectForKey:WKHotKeyAssignmentsPrefName];
	NSArray *	keyAssignments = [WKHotKeyAssignment assignmentsFromPlistArray:keyAssignmentsPlist];
	
	[listEditorWindowController setHotKeyAssignments:keyAssignments];
	
	// Display our UI.
	[[listEditorWindowController window] center];
	[[listEditorWindowController window] makeKeyAndOrderFront:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	// Save any user-defined hotkey actions in the defaults database.
	NSArray *	keyAssignments = [listEditorWindowController hotKeyAssignments];
	NSArray *	keyAssignmentsPlist = [WKHotKeyAssignment plistArrayFromAssignments:keyAssignments];
	
	[[NSUserDefaults standardUserDefaults] setObject:keyAssignmentsPlist forKey:WKHotKeyAssignmentsPrefName];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


@end
