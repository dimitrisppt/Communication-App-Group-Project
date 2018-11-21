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

#import "FIRDataSnapshotTests.h"
#import "FIRDatabaseConfig_Private.h"
#import "FTestHelpers.h"
#import "FLeafNode.h"
#import "FChildrenNode.h"
#import "FEmptyNode.h"
#import "FImmutableSortedDictionary.h"
#import "FUtilities.h"
#import "FSnapshotUtilities.h"
#import "FIRDataSnapshot_Private.h"
#import "FPathIndex.h"
#import "FLeafNode.h"
#import "FValueIndex.h"

@implementation FIRDataSnapshotTests

- (void)setUp
{
    [super setUp];

    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.

    [super tearDown];
}

- (FIRDataSnapshot *)snapshotFor:(id)jsonDict {
    FIRDatabaseConfig *config = [FIRDatabaseConfig defaultConfig];
    FRepoInfo* repoInfo = [[FRepoInfo alloc] initWithHost:@"example.com" isSecure:NO withNamespace:@"default"];
    FIRDatabaseReference * dummyRef = [[FIRDatabaseReference alloc] initWithRepo:[FRepoManager getRepo:repoInfo config:config] path:[FPath empty]];
    FIndexedNode *indexed = [FIndexedNode indexedNodeWithNode:[FSnapshotUtilities nodeFrom:jsonDict]];
    FIRDataSnapshot * snapshot = [[FIRDataSnapshot alloc] initWithRef:dummyRef indexedNode:indexed];
    return snapshot;
}

- (void) testCreationLeafNodesVariousTypes {

    id<FNode> fortyTwo = [FSnapshotUtilities nodeFrom:@42];
    FLeafNode* x = [[FLeafNode alloc] initWithValue:@5 withPriority:fortyTwo];

    XCTAssertEqualObjects(x.val, @5, @"Values are the same");
    XCTAssertEqualObjects(x.getPriority, [FSnapshotUtilities nodeFrom:@42], @"Priority is the same");
    XCTAssertTrue([x isLeafNode], @"Node is a leaf");

    x = [[FLeafNode alloc] initWithValue:@"test"];
    XCTAssertEqualObjects(x.value, @"test", @"Check if leaf node is holding onto a string value");

    x = [[FLeafNode alloc] initWithValue:[NSNumber numberWithBool:YES]];
    XCTAssertTrue([x.value boolValue], @"Check if leaf node is holding onto a YES boolean");

    x = [[FLeafNode alloc] initWithValue:[NSNumber numberWithBool:NO]];
    XCTAssertFalse([x.value boolValue], @"Check if leaf node is holding onto a NO boolean");
}

- (void) testUpdatingPriorityWithoutChangingOld {
    FLeafNode* x = [[FLeafNode alloc] initWithValue:@"test" withPriority:[FSnapshotUtilities nodeFrom:[NSNumber numberWithInt:42]]];
    FLeafNode* y = [x updatePriority:[FSnapshotUtilities nodeFrom:[NSNumber numberWithInt:187]]];

    // old node is the same
    XCTAssertEqualObjects(x.value, @"test", @"Values of old node are the same");
    XCTAssertEqualObjects(x.getPriority, [FSnapshotUtilities nodeFrom:[NSNumber numberWithInt:42]], @"Priority of old node is the same.");

    // new node has the new priority but the old value
    XCTAssertEqualObjects(y.value, @"test", @"Values of old node are the same");
    XCTAssertEqualObjects(y.getPriority, [FSnapshotUtilities nodeFrom:[NSNumber numberWithInt:187]], @"Priority of new node is update");
}

- (void) testUpdateImmediateChildReturnsANewChildrenNode {
    FLeafNode* x = [[FLeafNode alloc] initWithValue:@"test" withPriority:[FSnapshotUtilities nodeFrom:[NSNumber numberWithInt:42]]];
    FChildrenNode* y = [x updateImmediateChild:@"test" withNewChild:[[FLeafNode alloc] initWithValue:@"foo"]];

    XCTAssertFalse([y isLeafNode], @"New node is no longer a leaf");
    XCTAssertEqualObjects(y.getPriority, [FSnapshotUtilities nodeFrom:[NSNumber numberWithInt:42]], @"Priority of new node is update");

    XCTAssertEqualObjects([[y getImmediateChild:@"test"] val], @"foo", @"Child node has the correct value");
}

- (void) testGetImmediateChildOnLeafNode {
    FLeafNode* x = [[FLeafNode alloc] initWithValue:@"test"];
    XCTAssertEqualObjects([x getImmediateChild:@"foo"], [FEmptyNode emptyNode], @"Get immediate child on leaf node returns empty node");
}

- (void) testGetChildReturnsEmptyNode {
    FLeafNode* x = [[FLeafNode alloc] initWithValue:@"test"];
    XCTAssertEqualObjects([x getChild:[[FPath alloc] initWith:@"foo/bar"]], [FEmptyNode emptyNode], @"Get child returns an empty node.");
}

- (NSComparator) defaultComparator {
    return ^(id obj1, id obj2) {
        if([obj1 respondsToSelector:@selector(compare:)] && [obj2 respondsToSelector:@selector(compare:)]) {
            return [obj1 compare:obj2];
        }
        else {
            if(obj1 < obj2) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            else if (obj1 > obj2) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            else {
                return (NSComparisonResult)NSOrderedSame;
            }
        }
    };
}

- (void) testUpdateImmediateChildWithNewNode {
    FImmutableSortedDictionary* children = [FImmutableSortedDictionary dictionaryWithComparator:[self defaultComparator]];
    FChildrenNode* x = [[FChildrenNode alloc] initWithChildren:children];
    FLeafNode* newValue = [[FLeafNode alloc] initWithValue:@"new value"];
    FChildrenNode* y = [x updateImmediateChild:@"test" withNewChild:newValue];

    XCTAssertEqualObjects(x.children, children, @"Original object stays the same");
    XCTAssertEqualObjects([y.children objectForKey:@"test"], newValue, @"New internal node with the proper new value");
    XCTAssertEqualObjects([[y.children objectForKey:@"test"] val], @"new value", @"Check the payload");
}

- (void) testUpdatechildWithNewNode {
    FImmutableSortedDictionary* children = [FImmutableSortedDictionary dictionaryWithComparator:[self defaultComparator]];
    FChildrenNode* x = [[FChildrenNode alloc] initWithChildren:children];
    FLeafNode* newValue = [[FLeafNode alloc] initWithValue:@"new value"];
    FChildrenNode* y = [x updateChild:[[FPath alloc] initWith:@"test/foo"] withNewChild:newValue];
    XCTAssertEqualObjects(x.children, children, @"Original object stays the same");
    XCTAssertEqualObjects([y getChild:[[FPath alloc] initWith:@"test/foo"]], newValue, @"Check if the updateChild held");
    XCTAssertEqualObjects([[y getChild:[[FPath alloc] initWith:@"test/foo"]] val], @"new value", @"Check the payload");
}

- (void) testObjectTypes {
    XCTAssertEqualObjects(@"string", [FUtilities getJavascriptType:@""], @"Check string type");
    XCTAssertEqualObjects(@"string", [FUtilities getJavascriptType:@"moo"], @"Check string type");

    XCTAssertEqualObjects(@"boolean", [FUtilities getJavascriptType:@YES], @"Check boolean type");
    XCTAssertEqualObjects(@"boolean", [FUtilities getJavascriptType:@NO], @"Check boolean type");

    XCTAssertEqualObjects(@"number", [FUtilities getJavascriptType:@5], @"Check number type");
    XCTAssertEqualObjects(@"number", [FUtilities getJavascriptType:@5.5], @"Check number type");
    XCTAssertEqualObjects(@"number", [FUtilities getJavascriptType:@0], @"Check number type");
    XCTAssertEqualObjects(@"number", [FUtilities getJavascriptType:@8273482734], @"Check number type");
    XCTAssertEqualObjects(@"number", [FUtilities getJavascriptType:@-2], @"Check number type");
    XCTAssertEqualObjects(@"number", [FUtilities getJavascriptType:@-2.11], @"Check number type");
}

- (void) testNodeHashWorksCorrectly {
    id<FNode> node = [FSnapshotUtilities nodeFrom:@{ @"intNode" : @4,
                                                      @"doubleNode" : @4.5623,
                                                      @"stringNode" : @"hey guys",
                                                      @"boolNode" : @YES }];

    XCTAssertEqualObjects(@"eVih19a6ZDz3NL32uVBtg9KSgQY=", [[node getImmediateChild:@"intNode"] dataHash], @"Check integer node");
    XCTAssertEqualObjects(@"vf1CL0tIRwXXunHcG/irRECk3lY=", [[node getImmediateChild:@"doubleNode"] dataHash], @"Check double node");
    XCTAssertEqualObjects(@"CUNLXWpCVoJE6z7z1vE57lGaKAU=", [[node getImmediateChild:@"stringNode"] dataHash], @"Check string node");
    XCTAssertEqualObjects(@"E5z61QM0lN/U2WsOnusszCTkR8M=", [[node getImmediateChild:@"boolNode"] dataHash], @"Check boolean node");
    XCTAssertEqualObjects(@"6Mc4jFmNdrLVIlJJjz2/MakTK9I=", [node dataHash], @"Check compound node");
}

- (void) testNodeHashWorksCorrectlyWithPriorities {
    id<FNode> node = [FSnapshotUtilities nodeFrom:@{
                      @"root": @{ @"c": @{@".value": @99, @".priority": @"abc"}, @".priority" : @"def"  }
                      }];

    XCTAssertEqualObjects(@"Fm6tzN4CVEu5WxFDZUdTtqbTVaA=", [node dataHash], @"Check compound node");
}

- (void) testGetPredecessorChild {
    id<FNode> node = [FSnapshotUtilities nodeFrom:@{@"d": @YES, @"a": @YES, @"g": @YES, @"c": @YES, @"e": @YES}];

    XCTAssertNil([node predecessorChildKey:@"a"],
            @"Check the first one sorted properly");
    XCTAssertEqualObjects([node predecessorChildKey:@"c"],
            @"a",  @"Check a comes before c");
    XCTAssertEqualObjects([node predecessorChildKey:@"d"],
            @"c",  @"Check c comes before d");
    XCTAssertEqualObjects([node predecessorChildKey:@"e"],
            @"d",  @"Check d comes before e");
    XCTAssertEqualObjects([node predecessorChildKey:@"g"],
            @"e",  @"Check e comes before g");
}

- (void) testSortedChildrenGetPredecessorChildWorksCorrectly {
    // XXX impl SortedChildren
}

- (void) testSortedChildrenUpdateImmediateChildrenWorksCorrectly {
    // XXX imple SortedChildren
}

- (void) testDataSnapshotChildWorks {
    FIRDataSnapshot * snap = [self snapshotFor:@{@"x": @5, @"y": @{@"yy": @3, @"yz": @4}}];

    XCTAssertEqualObjects([[snap childSnapshotForPath:@"x"] value], @5, @"Check x");
    NSDictionary* dict = @{@"yy": @3, @"yz": @4};
    XCTAssertTrue([[[snap childSnapshotForPath:@"y"] value] isEqualToDictionary:dict], @"Check y");

    XCTAssertEqualObjects([[[snap childSnapshotForPath:@"y"] childSnapshotForPath:@"yy"] value], @3, @"Check y/yy");
    XCTAssertEqualObjects([[snap childSnapshotForPath:@"y/yz"] value], @4, @"Check y/yz");
    XCTAssertTrue([[snap childSnapshotForPath:@"z"] value] == [NSNull null], @"Check nonexistent z");
    XCTAssertTrue([[snap childSnapshotForPath:@"x/y"] value] == [NSNull null], @"Check value of existent internal node");
    XCTAssertTrue([[[snap childSnapshotForPath:@"x"] childSnapshotForPath:@"y"] value] == [NSNull null], @"Check value of existent internal node");
}

- (void)testNameComparator {
    NSComparator keyComparator = [FUtilities keyComparator];
    XCTAssertEqual(keyComparator(@"1234", @"1234"), NSOrderedSame, @"NameComparator compares ints");
    XCTAssertEqual(keyComparator(@"1234", @"12345"), NSOrderedAscending, @"NameComparator compares ints");
    XCTAssertEqual(keyComparator(@"4321", @"1234"), NSOrderedDescending, @"NameComparator compares ints");
    XCTAssertEqual(keyComparator(@"1234", @"zzzz"), NSOrderedAscending, @"NameComparator priorities ints");
    XCTAssertEqual(keyComparator(@"4321", @"12a"), NSOrderedAscending, @"NameComparator priorities ints");
    XCTAssertEqual(keyComparator(@"abc", @"abcd"), NSOrderedAscending, @"NameComparator uses lexiographical sorting for strings.");
    XCTAssertEqual(keyComparator(@"zzzz", @"aaaa"), NSOrderedDescending, @"NameComparator compares strings");
    XCTAssertEqual(keyComparator(@"-1234", @"0"), NSOrderedAscending, @"NameComparator compares negative values");
    XCTAssertEqual(keyComparator(@"-1234", @"-1234"), NSOrderedSame, @"NameComparator compares negative values");
    XCTAssertEqual(keyComparator(@"-1234", @"-4321"), NSOrderedDescending, @"NameComparator compares negative values");
    XCTAssertEqual(keyComparator(@"-1234", @"-"), NSOrderedAscending, @"NameComparator does not parse - as integer");
    XCTAssertEqual(keyComparator(@"-", @"1234"), NSOrderedDescending, @"NameComparator does not parse - as integer");
}


- (void) testUpdatingEmptyChildDoesntOverwriteLeafNode {
    FLeafNode *node = [[FLeafNode alloc] initWithValue:@"value"];
    XCTAssertEqualObjects(node, [node updateChild:[[FPath alloc] initWith:@".priority"] withNewChild:[FEmptyNode emptyNode]], @"Update should not affect node.");
    XCTAssertEqualObjects(node, [node updateChild:[[FPath alloc] initWith:@"child"] withNewChild:[FEmptyNode emptyNode]], @"Update should not affect node.");
    XCTAssertEqualObjects(node, [node updateChild:[[FPath alloc] initWith:@"child/.priority"] withNewChild:[FEmptyNode emptyNode]], @"Update should not affect node.");
    XCTAssertEqualObjects(node, [node updateImmediateChild:@"child" withNewChild:[FEmptyNode emptyNode]], @"Update should not affect node.");
    XCTAssertEqualObjects(node, [node updateImmediateChild:@".priority" withNewChild:[FEmptyNode emptyNode]], @"Update should not affect node.");
}

/* This was reported by a customer, which broke because 유주연 > 윤규완오빠 but also 윤규완오빠 > 유주연  with the default
 * string comparison... */
- (void)testUnicodeEquality {
    FNamedNode *node1 = [[FNamedNode alloc] initWithName:@"a" andNode:[[FLeafNode alloc] initWithValue:@"유주연"]];
    FNamedNode *node2 = [[FNamedNode alloc] initWithName:@"a" andNode:[[FLeafNode alloc] initWithValue:@"윤규완오빠"]];
    id<FIndex> index = [FValueIndex valueIndex];

    // x < y should imply y > x
    XCTAssertEqual([index compareNamedNode:node1 toNamedNode:node2], -[index compareNamedNode:node2 toNamedNode:node1]);
}

@end
