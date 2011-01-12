//
//  WhatKeysAppDelegate.h
//  WhatKeys
//
//  Created by Andy Lee on 7/6/10.
//  Feel free to use this code however you like.
//

#import <Cocoa/Cocoa.h>

@class WKListEditorWindowController;


/*!
 *	@class		WhatKeysAppDelegate
 *	@discussion	Application delegate for the WhatKeys application.  This class is instantiated
 *				in Interface Builder (see MainMenu.xib) and connected to the application object
 *				as the application's delegate.  Only one instance of this class should ever be
 *				created.
 *
 *				The application delegate implements various optional methods that are called
 *				by AppKit during the lifetime of the application.  Look at the .m file to see
 *				which delegate methods this class implements.
 *
 *				Before Snow Leopard, application delegates were declared in an informal protocol.
 *				In Snow Leopard, a formal protocol called NSApplicationDelegate was created.
 *				For backward compatibility, this class does not formally implement that protocol.
 *				For more about application delegate methods, see the docs on NSApplicationDelegate:
 *				<http://developer.apple.com/mac/library/documentation/cocoa/reference/NSApplicationDelegate_Protocol/Reference/Reference.html>.
 *				For more about formal and informal protocols, see the chapter on Protocols:
 *				<file:///Developer/Documentation/DocSets/com.apple.adc.documentation.AppleSnowLeopard.CoreReference.docset/Contents/Resources/Documents/documentation/Cocoa/Conceptual/ObjectiveC/Articles/ocProtocols.html>.
 */
@interface WhatKeysAppDelegate : NSObject
{
@private
	WKListEditorWindowController *	listEditorWindowController;
}


@end
