//
//  WKListEditorViewController.m
//  WhatKeys
//
//  Created by Andy Lee on 7/6/10.
//  Feel free to use this code however you like.
//

#import "WKListEditorViewController.h"
#import "WKHotKeyAssignment.h"
#import "SRRecorderControl.h"


@implementation WKListEditorViewController

@synthesize keyAssignmentsArrayController, hotKeysTable, nameField, hotKeyField;

- (void)awakeFromNib
{
	
	[hotKeysTable setTarget:self];
	[hotKeysTable setDoubleAction:@selector(testHotKeyAction:)];
}

- (NSArray *)hotKeyAssignments
{
	return [keyAssignmentsArrayController arrangedObjects];
}

- (void)setHotKeyAssignments:(NSArray *)assignments
{
	// Our array controller comes from the nib file, so make sure we've loaded the nib.
	if (keyAssignmentsArrayController == nil)
	{
		(void)[self view];
	}
	
	// Now we can give the array to the array controller.
	[keyAssignmentsArrayController setContent:assignments];
	
	for (WKHotKeyAssignment * ka in assignments)
	{
		[ka registerHotKeyAction];
	}
}


#pragma mark -
#pragma mark Action methods

- (IBAction)addHotKey:(id)sender
{
	[keyAssignmentsArrayController add:self];
	[nameField selectText:self];
}

- (IBAction)removeHotKey:(id)sender
{
	[keyAssignmentsArrayController remove:self];
}

- (IBAction)choosePathToScript:(id)sender
{
}

- (IBAction)testHotKeyAction:(id)sender
{
	WKHotKeyAssignment *	ka = [[keyAssignmentsArrayController selectedObjects] lastObject];
	
	if (ka != nil)
	{
		[[[self view] window] makeFirstResponder:nil];  // Make sure we pick up edits to text views.
		
		NSError *	error = [ka performHotKeyAction];
		if (error != nil)
		{
			NSAlert *	alert = [NSAlert alertWithError:error];
			
			[alert beginSheetModalForWindow:[[self view] window]
							  modalDelegate:nil
							 didEndSelector:nil
								contextInfo:NULL];
		}
	}
}


#pragma mark -
#pragma mark NSTableView delegate methods

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	WKHotKeyAssignment *	ka = [[keyAssignmentsArrayController selectedObjects] lastObject];
	
	if (ka != nil)
	{
		[hotKeyField setKeyCombo:SRMakeKeyCombo([ka keyCode], [ka keyFlags])];
	}
	else
	{
		[hotKeyField setKeyCombo:SRMakeKeyCombo(WKNoKeyCode, WKNoKeyFlags)];
	}
}


#pragma mark -
#pragma mark SRRecorder delegate methods

//- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isKeyCode:(NSInteger)keyCode andFlagsTaken:(NSUInteger)flags reason:(NSString **)aReason
//{
////	return NO;
//}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo
{
	WKHotKeyAssignment *	ka = [[keyAssignmentsArrayController selectedObjects] lastObject];
	
	if (ka == nil)
	{
		return;
	}
	
	if (([ka keyCode] == newKeyCombo.code) && ([ka keyFlags] == newKeyCombo.flags))
	{
		return;
	}
	
	[ka unregisterHotKeyAction];
	[ka setKeyCode:newKeyCombo.code];
	[ka setKeyFlags:newKeyCombo.flags];
	[ka registerHotKeyAction];  // TODO: Handle failure to register.
}


@end
