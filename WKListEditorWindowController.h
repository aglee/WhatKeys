//
//  WKListEditorWindowController.h
//  WhatKeys
//
//  Created by Andy Lee on 7/6/10.
//  Feel free to use this code however you like.
//

#import <Cocoa/Cocoa.h>


@class WKListEditorViewController;


/*!
 *	@class		WKListEditorWindowController
 *	@discussion	Window controller for the primary window in the WhatKeys application.
 *				This class doesn't do much besides instantiate a WKListEditorViewController,
 *				which does the real work.
 */
@interface WKListEditorWindowController : NSWindowController
{
@private
	WKListEditorViewController *	listEditorViewController;
}


#pragma mark -
#pragma mark Accessors

/*! Elements of the returned array are instances of WKKeyAssignment. */
- (NSArray *)hotKeyAssignments;

/*! Elements of the given array must be instances of WKKeyAssignment. */
- (void)setHotKeyAssignments:(NSArray *)assignments;


@end
