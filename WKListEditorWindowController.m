//
//  WKListEditorWindowController.m
//  WhatKeys
//
//  Created by Andy Lee on 7/6/10.
//  Feel free to use this code however you like.
//

#import "WKListEditorWindowController.h"
#import "WKHotKeyAssignment.h"
#import "WKListEditorViewController.h"


@implementation WKListEditorWindowController

- (id)initWithWindowNibName:(NSString *)windowNibName owner:(id)owner
{
	self = [super initWithWindowNibName:windowNibName owner:owner];
	if (self)
	{
		listEditorViewController = [[WKListEditorViewController alloc] initWithNibName:@"ListEditorView"
																				bundle:nil];
	}
	
	return self;
}

- (void)dealloc
{
	[listEditorViewController release];
	
	[super dealloc];
}

- (void)awakeFromNib
{
	// Populate the window's UI by adding listEditorViewController's view to the window's
	// content view.  See "How Windows Work" for an explanation of the content view:
	// <http://developer.apple.com/mac/library/documentation/Cocoa/Conceptual/WinPanel/Concepts/HowWindowsWork.html>.
	// Note we set the list editor's *frame* to the content view's *bounds*.  See
	// "View Geometry" to help understand frame vs. bounds:
	// <http://developer.apple.com/mac/library/documentation/cocoa/conceptual/CocoaViewsGuide/Coordinates/Coordinates.html#//apple_ref/doc/uid/TP40002978-CH10-SW1>.
	NSView *	listEditorView = [listEditorViewController view];
	
	[[self window] setContentView:listEditorView];
	
	// Patch listEditorViewController into the responder chain so that it will receive
	// menu events.  See "The Responder Chain" for more about the responder chain:
	// <http://developer.apple.com/mac/library/documentation/Cocoa/Conceptual/EventOverview/EventArchitecture/EventArchitecture.html#//apple_ref/doc/uid/10000060i-CH3-SW2>.
	[listEditorViewController setNextResponder:[[self window] nextResponder]];
	[[self window] setNextResponder:listEditorViewController];
}

- (NSArray *)hotKeyAssignments
{
	return [listEditorViewController hotKeyAssignments];
}

- (void)setHotKeyAssignments:(NSArray *)assignments
{
	[listEditorViewController setHotKeyAssignments:assignments];
}


@end
