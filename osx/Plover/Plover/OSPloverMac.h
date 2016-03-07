//
//  OSPloverMac.h
//  Plover
//
//  Created by Wesley Moore on 28/11/2015.
//  Copyright © 2015 Open Steno Project. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h> // Ideally this would only use Foundation

@interface OSPloverMac : NSObject

+ (instancetype)sharedInstance;

- (NSURL *)applicationDirectory;

@end
