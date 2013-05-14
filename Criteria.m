//
//  Criteria.m
//  Criteria
//
//  Created by Wess Cope on 8/14/12.
//  Copyright (c) 2012 Wess Cope. All rights reserved.
//

#import "Criteria.h"

static NSDictionary *parsedArguments()
{
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    
    if(arguments.count < 2)
        return nil;
    
    NSMutableDictionary *argsDict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *args = [arguments mutableCopy];
    [args removeObjectAtIndex:0];
    
    NSInteger skip = 0;
    for(NSString *arg in args)
    {
        if(skip > 0 && ((NSInteger)[arguments indexOfObject:arg]) == skip)
        {
            continue;
        }
        else
        {
            if([arg rangeOfString:@"="].location != NSNotFound && [arg rangeOfString:@"--"].location != NSNotFound)
            {
                NSArray *components = [arg componentsSeparatedByString:@"="];
                NSString *key       = [[components objectAtIndex:0] stringByReplacingOccurrencesOfString:@"--" withString:@""];
                NSString *value     = (components.count > 1)? [components objectAtIndex:1] : nil;
                
                [argsDict setObject:value forKey:key];
            }
            else if([arg rangeOfString:@"-"].location != NSNotFound)
            {
                NSInteger index = [arguments indexOfObject:arg];
                NSString *key   = [arg stringByReplacingOccurrencesOfString:@"-" withString:@""];
                NSInteger next  = index + 1;

                skip = next;
                
                NSString *value;
                if(args.count >= next)
                {
                    value = [arguments objectAtIndex:next];
                    value = ([value rangeOfString:@"-"].location == NSNotFound)? value : @"";
                }
                else
                {
                    value = @"";
                }
                
                [argsDict setObject:value forKey:key];
            }
        }
    }

    return [argsDict copy];
}

@interface Criteria()
+ (Criteria *)instance;
@end

@implementation Criteria
+ (Criteria *)instance
{
    static Criteria *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Criteria alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        _routes = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (void)addOption:(id)argument callback:(CriteriaCallback)callback
{
    //argument can be an array or single string only
    Criteria *router = [Criteria instance];
    [router.routes setObject:callback forKey:argument];
}

+ (void)run
{
    Criteria *router          = [Criteria instance];
    NSDictionary *arguments   = parsedArguments();
    NSArray *keys             = [arguments allKeys];
    NSArray *routeKeys        = [router.routes allKeys];
    
    for(NSString *key in keys)
    {
        for(id routeKey in routeKeys)
        {
            if ([routeKey isKindOfClass:[NSArray class]])
            {
                for(NSString *routeString in routeKey)
                {
                    if([routeString isEqualToString:key])
                    {
                        CriteriaCallback callback = [router.routes objectForKey:routeKey];
                        callback([arguments objectForKey:key]);
                        return;
                    }
                }
            }
        }
    }
}

@end
