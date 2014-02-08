//
//  UIDevice+Additions.m
//  Breadcrumbs
//
//  Created by Grey Lee on 2014/2/9.
//  Copyright (c) 2014年 Grey Lee. All rights reserved.
//

#import "UIDevice+Additions.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDevice (Additions)

- (NSString *)bcse_machine
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *machineString = [NSString stringWithUTF8String:machine];
    free(machine);
    return machineString;
}

@end
