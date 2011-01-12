//
//  WKHotKeyAssignment.h
//  WhatKeys
//
//  Created by Andy Lee on 7/6/10.
//  Feel free to use this code however you like.
//

#import <Cocoa/Cocoa.h>
#import "SRCommon.h"


@class DDHotKeyCenter;


#define WKNoKeyCode		-1
#define WKNoKeyFlags	0


/*! Types of actions that WKHotKeyAssignment can assign to a hotkey. */
typedef enum {
	/*! Run an AppleScript file to which we have a path. */
	WKPathToAppleScriptActionType,
	
	/*! Run AppleScript code which has been given to us in a string. */
	WKEmbeddedAppleScriptActionType,
} WKHotKeyActionType;


/*!
 *	@class		WKHotKeyAssignment
 *	@discussion	Encapsulates a mapping between a global hotkey and an action.  Registers the
 *				hotkey (using a third-party class called DDHotKeyCenter) and performs the
 *				action when the key is pressed.  The possible types of actions are given by
 *				the WKHotKeyActionType enumeration.
 *
 *				WKHotKeyAssignment knows how to convert itself to and from a kind of object
 *				called a property list ("plist" for short).  Property lists are used in the
 *				defaults database, which is where the user's application preferences are
 *				stored.  The plist for this application is in the file
 *				~/Library/Preferences/com.yourcompany.WhatKeys.plist.
 *
 *				Within the Model-View-Controller paradigm ("MVC"), WKHotKeyAssignment is a
 *				model class.  It is the only model class in the WhatKeys application.  For
 *				more on MVC, see "The Model-View-Controller Design Pattern"
 *				<http://developer.apple.com/mac/library/documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaDesignPatterns/CocoaDesignPatterns.html#//apple_ref/doc/uid/TP40002974-CH6-SW1>.
 *
 *				See "Introduction to User Defaults" for more on the defaults database:
 *				<http://developer.apple.com/mac/library/documentation/Cocoa/Conceptual/UserDefaults/UserDefaults.html>.
 *				See "Introduction to Property Lists" for more on plists:
 *				<http://developer.apple.com/mac/library/documentation/Cocoa/Conceptual/PropertyLists/Introduction/Introduction.html>.
 */
@interface WKHotKeyAssignment : NSObject
{
@private
	DDHotKeyCenter *	hotKeyCenter;  // Used behind the scenes for registering and unregistering hotkeys.
	
	// Stuff the user sees.
	NSString *			name;
	NSInteger			keyCode;
	NSUInteger			keyFlags;
	WKHotKeyActionType	actionType;
	NSString *			pathToAppleScript;  // Used if actionType is WKPathToAppleScriptActionType.
	NSString *			embeddedAppleScript;  // Used if actionType is WKEmbeddedAppleScriptActionType.
}

@property (readwrite, copy)		NSString *			name;
@property (readwrite, assign)	NSInteger			keyCode;
@property (readwrite, assign)	NSUInteger			keyFlags;
@property (readwrite, assign)	WKHotKeyActionType	actionType;
@property (readwrite, copy)		NSString *			pathToAppleScript;
@property (readwrite, copy)		NSString *			embeddedAppleScript;
@property (readonly)			NSString *			keyComboDisplayString;


#pragma mark -
#pragma mark Factory methods

/*! Returns a new instance of WKHotKeyAssignment with the given values. */
+ (id)assignmentWithName:(NSString *)theName
				 keyCode:(NSInteger)theKeyCode
		   modifierFlags:(NSUInteger)theModifierFlags
	   pathToAppleScript:(NSString *)thePath;

/*! Returns a new instance of WKHotKeyAssignment with the given values. */
+ (id)assignmentWithName:(NSString *)theName
				 keyCode:(NSInteger)theKeyCode
		   modifierFlags:(NSUInteger)theModifierFlags
			 AppleScript:(NSString *)theAppleScript;


#pragma mark -
#pragma mark Converting to and from plists

/*!
 *	Elements of the returned array are instances of WKKeyAssignment.  arrayOfDicts must
 *	contain a plist of the form returned by plistArrayFromAssignments:.
 */
+ (NSArray *)assignmentsFromPlistArray:(NSArray *)arrayOfDicts;

/*! Elements of the given array must be instances of WKKeyAssignment. */
+ (NSArray *)plistArrayFromAssignments:(NSArray *)arrayOfAssignments;


#pragma mark -
#pragma mark Managing hotkey actions

/*!
 *	Registers the global hotkey specified by the receiver.  Associates it with
 *	the action specified by the receiver.
 */
- (BOOL)registerHotKeyAction;

/*! Unregisters the global hotkey specified by the receiver. */
- (void)unregisterHotKeyAction;

/*!
 *	Invoked when the user presses the receiver's global hotkey.  The WhatKeys
 *	application does not have to be the frontmost application, but it does have
 *	to be running in order for the hotkey to work.
 */
- (NSError *)performHotKeyAction;


@end
