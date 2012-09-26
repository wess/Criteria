//
//  Criteria.h
//  Criteria
//
//  Created by Wess Cope on 8/14/12.
//  Copyright (c) 2012 Wess Cope. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CriteriaCallback)(NSString *value);

@interface Criteria : NSObject
@property (strong) NSMutableDictionary *routes;
+ (void)addOption:(id)argument callback:(CriteriaCallback)callback;
+ (void)run;
@end
