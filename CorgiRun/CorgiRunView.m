//
//  CorgiRunView.m
//  CorgiRun
//
//  Created by Ran Tao on 8.22.12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CorgiRunView.h"
#import "Corgi.h"

@interface CorgiRunView()
@property (nonatomic) CGPoint currentLocation;
@property (nonatomic, strong) UIImage *corgi;
@property (nonatomic, strong) Corgi *corgiLayer;
@end

@implementation CorgiRunView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            }
    return self;
}

- (void)awakeFromNib
{
    NSLog(@"eyes in the awake");
    NSString *fileName = [NSString stringWithFormat:@"corgi.png"];
    self.corgi = [UIImage imageNamed:fileName];
    self.corgiLayer = [Corgi layer];
    self.corgiLayer.contents = (__bridge id)([self.corgi CGImage]);
    //self.corgiLayer.backgroundColor = [[UIColor redColor] CGColor];

    [self.layer addSublayer:self.corgiLayer];
    [self setNeedsDisplay];
    
}


- (void)drawRect:(CGRect)rect
{
    // Drawing corgi and make it move with touch
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // capture the location where the user starts touching the view
    self.currentLocation = [[touches anyObject] locationInView:self];
    self.corgiLayer.position = self.currentLocation;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Grab the current point
    self.currentLocation = [[touches anyObject] locationInView:self];
    self.corgiLayer.position = self.currentLocation;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.currentLocation = [[touches anyObject] locationInView:self];
    
    [self setNeedsDisplay];
}




@end
