//
//  StenoEngine.h
//  Plover
//
//  Created by Wesley Moore on 29/11/2015.
//  Copyright © 2015 Open Steno Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StenoEngine;

typedef NS_ENUM(NSInteger, StenoEngineState) {
    StenoEngineStateStopped,
    StenoEngineStateInitializing,
    StenoEngineStateRunning,
    StenoEngineStateError,
    StenoEngineStateNone,
};

@protocol StenoEngineDelegate <NSObject>

- (void)stenoEngine:(StenoEngine *)engine stateDidChange:(StenoEngineState)newState;

@end

@interface StenoEngine : NSObject

@property id<StenoEngineDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)start; // Start the steno engine running in a background thread
- (void)shutdown;

- (BOOL)isRunning;
- (void)setIsRunning:(BOOL)running;

- (NSURL *)applicationDirectory;

@end
