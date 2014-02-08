//
//  NSDate+Additions.m
//  Breadcrumbs
//
//  Created by Grey Lee on 2014/2/9.
//  Copyright (c) 2014年 Grey Lee. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

- (NSString *)bcse_ISO8601String {
	struct tm *timeinfo;
	char buffer[21];
    
	time_t rawtime = (time_t)[self timeIntervalSince1970];
	timeinfo = gmtime(&rawtime);
    
	strftime(buffer, 21, "%Y-%m-%dT%H:%M:%SZ", timeinfo);
    
	return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

@end
