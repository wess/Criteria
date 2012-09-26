//
//  Dispatch.h
//  Dispatch
//
//  Created by Wess Cope on 8/14/12.
//  Copyright (c) 2012 Wess Cope. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DispatchCallback)(NSString *value);

@interface Dispatch : NSObject
@property (strong) NSMutableDictionary *routes;
+ (void)addOption:(id)argument callback:(DispatchCallback)callback;
+ (void)run;
@end
