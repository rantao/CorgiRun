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
@property (nonatomic) BOOL isFacingRight;
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
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grass.jpg"]];
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

-(BOOL) isMovingLeft:(CGPoint) location {
    if (self.corgiLayer.position.x < location.x) {
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // capture the location where the user starts touching the view

    self.currentLocation = [[touches anyObject] locationInView:self];
    
    // NEED TO STILL FIX THIS PART TO MAKE CORGI FACE THE CORRECT WAY
    if (self.isFacingRight) {
        if ([self isMovingLeft:self.currentLocation]) {
            self.corgiLayer.transform = CATransform3DMakeRotation(0.0, 0.0, 1.0, 0.0);
            self.isFacingRight = NO;
        }
    } else {
        if (![self isMovingLeft:self.currentLocation]) {
            self.corgiLayer.transform = CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0);
            self.isFacingRight = YES;
        }
    }
    self.corgiLayer.position = self.currentLocation;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Grab the current point
    self.currentLocation = [[touches anyObject] locationInView:self];
    [CATransaction begin];
    //[CATransaction setDisableActions:YES];
    if (self.isFacingRight) {
        if ([self isMovingLeft:self.currentLocation]) {
            self.corgiLayer.transform = CATransform3DMakeRotation(0.0, 0.0, 1.0, 0.0);
            self.isFacingRight = NO;
        }
    } else {
        if (![self isMovingLeft:self.currentLocation]) {
            self.corgiLayer.transform = CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0);
            self.isFacingRight = YES;
        }
    }
    self.corgiLayer.position = self.currentLocation;
    [CATransaction commit];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.currentLocation = [[touches anyObject] locationInView:self];
    
    [self setNeedsDisplay];
}




@end
