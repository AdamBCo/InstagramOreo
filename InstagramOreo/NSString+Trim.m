//
//  NSString+Trim.m
//  InstagramOreo
//
//  Created by Taylor Wright-Sanson on 10/27/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "NSString+Trim.h"

@implementation NSString (Trim)

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
