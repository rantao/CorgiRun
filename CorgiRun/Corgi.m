//
//  Corgi.m
//  CorgiRun
//
//  Created by Ran Tao on 8.22.12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import "Corgi.h"

@interface Corgi()  
@end

@implementation Corgi

-(Corgi*) init {
    self = [super init];
    if (self) {
        self.position = CGPointMake(100.0f, 100.0f);
        self.bounds = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    }
   
    return self;
}

-(void) drawInContext:(CGContextRef)ctx{
    //do all our corgi drawing here
}

@end
