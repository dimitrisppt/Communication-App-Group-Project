/*
 * Copyright 2017 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <XCTest/XCTest.h>
#import "FDevice.h"

//#import <FirebaseDatabase/FIRDatabaseReference.h>

#import "FRepoManager.h"
#import "FIRDatabaseReference_Private.h"
#import "FIRDatabaseConfig_Private.h"
#import "SenTest+FWaiter.h"
#import "FTestHelpers.h"

@interface FDevice() {
    FIRDatabaseConfig * config;
    NSString *url;
    BOOL isOnline;
    BOOL disposed;
}
@end

@implementation FDevice

- (id)initOnline {
    FIRDatabaseReference * ref = [FTestHelpers getRandomNode];
    return [self initOnlineWithUrl:[ref description]];
}

- (id)initOffline {
    FIRDatabaseReference * ref = [FTestHelpers getRandomNode];
    return [self initOfflineWithUrl:[ref description]];
}

- (id)initOnlineWithUrl:(NSString *)firebaseUrl {
    return [self initWithUrl:firebaseUrl andOnline:YES];
}

- (id)initOfflineWithUrl:(NSString *)firebaseUrl {
    return [self initWithUrl:firebaseUrl andOnline:NO];
}

static NSUInteger deviceId = 0;

- (id)initWithUrl:(NSString *)firebaseUrl andOnline:(BOOL)online {
    self = [super init];
    if (self) {
        config = [FIRDatabaseConfig configForName:[NSString stringWithFormat:@"device-%lu", deviceId++]];
        config.persistenceEnabled = YES;
        url = firebaseUrl;
        isOnline = online;
    }
    return self;
}

- (void) dealloc
{
    if (!self->disposed) {
        [NSException raise:NSInternalInconsistencyException format:@"Forgot to dispose device"];
    }
}

- (void) dispose {
    // TODO: clear persistence
    [FRepoManager disposeRepos:self->config];
    self->disposed = YES;
}

- (void)goOffline {
    isOnline = NO;
    [FRepoManager interrupt:config];
}

- (void)goOnline {
    isOnline = YES;
    [FRepoManager resume:config];
}

- (void)restartOnline {
    @autoreleasepool {
        [FRepoManager disposeRepos:config];
        isOnline = YES;
    }
}

- (void)restartOffline {
    @autoreleasepool {
        [FRepoManager disposeRepos:config];
        isOnline = NO;
    }
}

// Waits for us to connect and then does an extra round-trip to make sure all initial state restoration is completely done.
- (void)waitForIdleUsingWaiter:(XCTest*)waiter {
    [self do:^(FIRDatabaseReference *ref) {
        __block BOOL connected = NO;
        FIRDatabaseHandle handle = [[ref.root child:@".info/connected"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
            connected = [snapshot.value boolValue];
        }];
        [waiter waitUntil:^BOOL { return connected; }];
        [ref.root removeObserverWithHandle:handle];

        // HACK: Do a deep setPriority (which we expect to fail because there's no data there) to do a no-op roundtrip.
        __block BOOL done = NO;
        [[ref.root child:@"ENTOHTNUHOE/ONTEHNUHTOE"] setPriority:@"blah" withCompletionBlock:^(NSError *error, FIRDatabaseReference *ref) {
            done = YES;
        }];
        [waiter waitUntil:^BOOL { return done; }];
    }];
}

- (void)do:(void (^)(FIRDatabaseReference *))action {
    @autoreleasepool {
        FIRDatabaseReference *ref = [[[[FIRDatabaseReference alloc] initWithConfig:self->config] database] referenceFromURL:self->url];
        if (!isOnline) {
            [FRepoManager interrupt:config];
        }
        action(ref);
    }
}

@end
