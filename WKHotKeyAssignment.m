//
//  WKHotKeyAssignment.m
//  WhatKeys
//
//  Created by Andy Lee on 7/6/10.
//  Feel free to use this code however you like.
//

#import "WKHotKeyAssignment.h"
#import "DDHotKeyCenter.h"


// A category declaring methods that we want to treat as if they were private to this class.
// Objective-C does not have true private methods.  Using a category in the .m like this is
// a convention for helping us treat methods _as if_ they were private, by not exposing them
// in the header.
@interface WKHotKeyAssignment ()

@property (readwrite, retain)	NSAppleScript *	compiledAppleScript;

- (NSError *)_errorWithMessage:(NSString *)errorMessage;
- (NSError *)_performPathAction;
- (NSError *)_performEmbeddedScriptAction;
@end


@implementation WKHotKeyAssignment

@synthesize name, keyCode, keyFlags, actionType, pathToAppleScript, embeddedAppleScript, compiledAppleScript;
@dynamic keyComboDisplayString;


#pragma mark -
#pragma mark Factory methods

+ (id)assignmentWithName:(NSString *)theName
				 keyCode:(NSInteger)theKeyCode
		   modifierFlags:(NSUInteger)theModifierFlags
	   pathToAppleScript:(NSString *)thePath
{
	WKHotKeyAssignment *	ka = [[[[self class] alloc] init] autorelease];
	
	[ka setName:theName];
	[ka setKeyCode:theKeyCode];
	[ka setKeyFlags:theModifierFlags];
	[ka setActionType:WKPathToAppleScriptActionType];
	[ka setPathToAppleScript:thePath];
	
	return ka;
}

+ (id)assignmentWithName:(NSString *)theName
				 keyCode:(NSInteger)theKeyCode
		   modifierFlags:(NSUInteger)theModifierFlags
			 AppleScript:(NSString *)theAppleScript
{
	WKHotKeyAssignment *	ka = [[[[self class] alloc] init] autorelease];
	
	[ka setName:theName];
	[ka setKeyCode:theKeyCode];
	[ka setKeyFlags:theModifierFlags];
	[ka setActionType:WKEmbeddedAppleScriptActionType];
	[ka setEmbeddedAppleScript:theAppleScript];
	
	return ka;
}


#pragma mark -
#pragma mark Init/awake/dealloc

- (id)init
{
	self = [super init];
	if (self)
	{
		hotKeyCenter = [[DDHotKeyCenter alloc] init];
		name = @"Untitled";
		keyCode = WKNoKeyCode;
		keyFlags = WKNoKeyFlags;
		actionType = WKEmbeddedAppleScriptActionType;
		pathToAppleScript = @"";
		embeddedAppleScript = @"beep";
		compiledAppleScript = nil;
		
		// Use KVO to observe values that should cause us to recompute compiledAppleScript.
		[self addObserver:self forKeyPath:@"actionType" options:0 context:NULL];
		[self addObserver:self forKeyPath:@"pathToAppleScript" options:0 context:NULL];
		[self addObserver:self forKeyPath:@"embeddedAppleScript" options:0 context:NULL];
	}
	
	return self;
}

- (void)dealloc
{
	// Stop observing things by KVO, since the things we observe have weak references to us.
	[self removeObserver:self forKeyPath:@"actionType"];
	[self removeObserver:self forKeyPath:@"pathToAppleScript"];
	[self removeObserver:self forKeyPath:@"embeddedAppleScript"];
	
	// Release ivars for which we have strong references.
	[hotKeyCenter release];
	[name release];
	[pathToAppleScript release];
	[embeddedAppleScript release];
	[compiledAppleScript release];
	
	[super dealloc];
}


#pragma mark -
#pragma mark Accessors

- (NSString *)keyComboDisplayString
{
	if (keyCode == WKNoKeyCode)
	{
		return @"";
	}
	else
	{
		return SRStringForCocoaModifierFlagsAndKeyCode(keyFlags, keyCode);
	}
}


#pragma mark -
#pragma mark Converting to and from plists

+ (NSArray *)assignmentsFromPlistArray:(NSArray *)arrayOfDicts
{
	NSMutableArray *	keyAssignments = [NSMutableArray array];
	
	for (NSDictionary * dict in arrayOfDicts)
	{
		WKHotKeyAssignment *	ka = [[[self alloc] init] autorelease];
		
		[ka setValuesForKeysWithDictionary:dict];
		[keyAssignments addObject:ka];
	}
	
	return keyAssignments;
}

+ (NSArray *)plistArrayFromAssignments:(NSArray *)arrayOfAssignments
{
	NSMutableArray *	plistArray = [NSMutableArray array];
	
	for (WKHotKeyAssignment * ka in arrayOfAssignments)
	{
		[plistArray addObject:[ka dictionaryWithValuesForKeys:[NSArray arrayWithObjects:
															   @"name",
															   @"keyCode",
															   @"keyFlags",
															   @"actionType",
															   @"pathToAppleScript",
															   @"embeddedAppleScript",
															   nil]]];
	}
	
	return plistArray;
}


#pragma mark -
#pragma mark Managing hotkey actions

- (BOOL)registerHotKeyAction
{
	BOOL	ok = [hotKeyCenter registerHotKeyWithKeyCode:keyCode
										modifierFlags:keyFlags
											   target:self
											   action:@selector(_handleHotkeyWithEvent:)
											   object:nil];
	
	if (!ok)
	{
		NSLog(@"failed to register hotkey %@", [self keyComboDisplayString]);
	}
	
	return ok;
}

- (void)unregisterHotKeyAction
{
	[hotKeyCenter unregisterHotKeysWithTarget:self];
}

- (NSError *)performHotKeyAction
{
	NSError *	error = nil;
	
	if (actionType == WKPathToAppleScriptActionType)
	{
		error = [self _performPathAction];
	}
	else if (actionType == WKEmbeddedAppleScriptActionType)
	{
		error = [self _performEmbeddedScriptAction];
	}
	else
	{
		NSString *	errorMessage = [NSString stringWithFormat:@"Unexpected value for action type: %d.", actionType];
		error = [self _errorWithMessage:errorMessage];
	}
	
	if (error != nil)
	{
		NSLog(@"ERROR performing hotkey action: %@", error);
	}
	
	return error;
}


#pragma mark -
#pragma mark NSKeyValueObserving methods

+ (NSSet *)keyPathsForValuesAffectingKeyComboDisplayString
{
	return [NSSet setWithObjects:@"keyCode", @"keyFlags", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"actionType"]
		|| [keyPath isEqualToString:@"pathToAppleScript"]
		|| [keyPath isEqualToString:@"embeddedAppleScript"])
	{
		// Force compiledAppleScript to be recreated.
		[self setCompiledAppleScript:nil];
	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}


#pragma mark -
#pragma mark NSObject methods

// In case you're ever debugging or just exploring and you ever use NSLog to print
// a WKHotKeyAssignment, this override of the description method provides more helpful
// information than the default implementation.  (NSLog calls the description method
// when it prints an object.)
- (NSString *)description
{
	NSString *	actionText = nil;
	
	if (actionType == WKPathToAppleScriptActionType)
	{
		actionText = [NSString stringWithFormat:@"path:'%@'", pathToAppleScript];
	}
	else if (actionType == WKEmbeddedAppleScriptActionType)
	{
		NSArray *	lines = [embeddedAppleScript componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		
		if ([lines count] > 1)
		{
			actionText = [NSString stringWithFormat:@"script: %@...", [lines objectAtIndex:0]];
		}
		else
		{
			actionText = [NSString stringWithFormat:@"script: %@", embeddedAppleScript];
		}
	}
	else
	{
		actionText = [NSString stringWithFormat:@"unexpected action type %d", actionType];
	}
	
	return [NSString stringWithFormat:@"<%@ -- %@>", [self keyComboDisplayString], actionText];
}


#pragma mark -
#pragma mark Private methods

- (void)_handleHotkeyWithEvent:(NSEvent *)event
{
	[self performHotKeyAction];
}

- (NSError *)_errorWithDict:(NSDictionary *)errorDict
{
	return [NSError errorWithDomain:@"WhatKeys" code:0 userInfo:errorDict];
}

- (NSError *)_errorWithMessage:(NSString *)errorMessage
{
	return [self _errorWithDict:[NSDictionary dictionaryWithObjectsAndKeys:
								 errorMessage, NSLocalizedDescriptionKey,
								 nil]];
}

- (NSError *)_performAppleScript:(NSAppleScript *)script
{
	NSDictionary *				errorDict = nil;
	NSAppleEventDescriptor *	scriptResult = [script executeAndReturnError:&errorDict];
	
	if (scriptResult == nil)
	{
		NSLog(@"ERROR performing AppleScript: %@", errorDict);
		
		return [self _errorWithMessage:[errorDict objectForKey:NSAppleScriptErrorMessage]];
	}
	else
	{
		return nil;
	}
}

- (NSError *)_performPathAction
{
	// Handle case where the script path is unspecified or invalid.
	if (pathToAppleScript == nil)
	{
		return [self _errorWithMessage:@"No script path was specified."];
	}
	
	NSURL *	scriptURL = [NSURL fileURLWithPath:pathToAppleScript];
	if (scriptURL == nil)
	{
		return [self _errorWithMessage:[NSString stringWithFormat:@"Invalid script path: '%@'.", pathToAppleScript]];
	}
	
	// Try to load the script if we haven't already.
	if (compiledAppleScript == nil)
	{
		NSDictionary *	errorDict = nil;
		NSAppleScript *	script = [[[NSAppleScript alloc] initWithContentsOfURL:scriptURL error:&errorDict] autorelease];
		
		if (script == nil)
		{
			return [self _errorWithDict:errorDict];
		}
		
		if (![script compileAndReturnError:&errorDict])
		{
			return [self _errorWithDict:errorDict];
		}
		
		[self setCompiledAppleScript:script];
	}
	
	// Try to execute the script.
	return [self _performAppleScript:compiledAppleScript];
}

- (NSError *)_performEmbeddedScriptAction
{
	// Handle the case where the script is unspecified.
	if ([embeddedAppleScript length] == 0)
	{
		return [self _errorWithMessage:@"No script was specified."];
	}
	
	// Try to load the script if we haven't already.
	if (compiledAppleScript == nil)
	{
		NSDictionary *	errorDict = nil;
		NSAppleScript *	script = [[[NSAppleScript alloc] initWithSource:embeddedAppleScript] autorelease];
		
		if (script == nil)
		{
			return [self _errorWithMessage:@"There's a problem with the AppleScript code."];
		}
		
		if (![script compileAndReturnError:&errorDict])
		{
			return [self _errorWithDict:errorDict];
		}
		
		[self setCompiledAppleScript:script];
	}
	
	// Try to execute the script.
	return [self _performAppleScript:compiledAppleScript];
}


@end
