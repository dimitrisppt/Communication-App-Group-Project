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

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "FTupleFirebase.h"
#import "FRepoManager.h"
#import "FIRDatabaseReference_Private.h"
#import "FTestContants.h"
#import "FSnapshotUtilities.h"
#import <FirebaseCore/FIRApp.h>
#import <FirebaseCore/FIROptions.h>
#import <FirebaseDatabase/FIRDatabase.h>
#import <FirebaseDatabase/FIRDatabaseReference.h>

#define WAIT_FOR(x) [self waitUntil:^{ return (BOOL)(x); }];

#define NODE(__node) [FSnapshotUtilities nodeFrom:(__node)]
#define PATH(__path) [FPath pathWithString:(__path)]

@interface FTestHelpers : XCTestCase
+ (FIRDatabaseReference *) getRandomNode;
+ (FIRDatabaseReference *) getRandomNodeWithoutPersistence;
+ (FTupleFirebase *) getRandomNodePair;
+ (FTupleFirebase *) getRandomNodePairWithoutPersistence;
+ (FTupleFirebase *) getRandomNodeTriple;
+ (id<FNode>)leafNodeOfSize:(NSUInteger)size;

@end
