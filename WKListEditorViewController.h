//
//  WKListEditorViewController.h
//  WhatKeys
//
//  Created by Andy Lee on 7/6/10.
//  Feel free to use this code however you like.
//

#import <Cocoa/Cocoa.h>

@class SRRecorderControl;

/*!
 *	@class		WKListEditorViewController
 *	@discussion	View controller that provides the UI for the WhatKeys application.  The
 *				UI displays a list of global hotkey definitions in a table view.  The
 *				user can double-click a hotkey to trigger its action.
 *
 *				When a hotkey is selected in the table, details about it are displayed
 *				in text fields and other controls below the table.  These controls allow
 *				the user to edit the hotkey definition.  The user can also add and remove
 *				hotkeys.
 */
@interface WKListEditorViewController : NSViewController
{
@private
	// Outlet ivars.
	NSArrayController *	keyAssignmentsArrayController;
	NSTableView *		hotKeysTable;
	NSTextField *		nameField;
	SRRecorderControl *	hotKeyField;
}

// Outlet properties.  You can see these in Interface Builder when you
// right-click on the instance of WKListEditorViewController.
@property (readwrite, assign)	IBOutlet NSArrayController *	keyAssignmentsArrayController;
@property (readwrite, assign)	IBOutlet NSTableView *			hotKeysTable;
@property (readwrite, assign)	IBOutlet NSTextField *			nameField;
@property (readwrite, assign)	IBOutlet SRRecorderControl *	hotKeyField;


#pragma mark -
#pragma mark Accessors

/*! Elements of the returned array are instances of WKKeyAssignment. */
- (NSArray *)hotKeyAssignments;

/*! Elements of the given array must be instances of WKKeyAssignment. */
- (void)setHotKeyAssignments:(NSArray *)assignments;


#pragma mark -
#pragma mark Action methods

/*! Adds a hotkey to the list, with a default key combo and a default action. */
- (IBAction)addHotKey:(id)sender;

/*! Removes the selected hotkey from the list. */
- (IBAction)removeHotKey:(id)sender;

/*! Prompts the user for a path to a .scpt file to associate with a hotkey. */
- (IBAction)choosePathToScript:(id)sender;

/*! Executes the action associated with the selected hotkey. */
- (IBAction)testHotKeyAction:(id)sender;


@end
