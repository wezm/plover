//
//  AppDelegate.h
//  Plover
//
//  Created by Wesley Moore on 13/10/2015.
//  Copyright © 2015 Open Steno Project. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSTextField *label;
@property (weak) IBOutlet NSButton *togglePloverButton;

- (NSURL *)applicationDirectory;
- (void)setPloverReady:(BOOL)ready;

@end

