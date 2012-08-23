//
//  CorgiRunView.m
//  CorgiRun
//
//  Created by Ran Tao on 8.22.12.
//  Copyright (c) 2012 Ran Tao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "CorgiRunView.h"
#import "Corgi.h"

@interface CorgiRunView()
@property (nonatomic) CGPoint currentLocation;
@property (nonatomic, strong) UIImage *corgi;
@property (nonatomic, strong) Corgi *corgiLayer;
@property (nonatomic) BOOL isFacingRight;
@property (nonatomic, strong) CALayer *background;
@property (nonatomic, strong) CALayer *houseTop;
@property (nonatomic, strong) CALayer *houseBottom;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (strong, nonatomic) AVAudioPlayer *musicPlayer;
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
    //NSLog(@"eyes in the awake");
    
    //add sounds
    NSString *music = [[NSBundle mainBundle] pathForResource:@"bark" ofType:@"wav"];
    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:music] error:NULL];
    self.musicPlayer.delegate;
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barkNow:)];
    self.tap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:self.tap];
    
    //set background to be its own CALayer
    self.background = [CALayer layer];
    self.background.bounds = CGRectMake(0.0, 0.0, self.bounds.size.width*4.0 , self.bounds.size.height*1.1);
    self.background.position = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    self.background.zPosition = -1000.0;
    self.background.contents = (__bridge id)([[UIImage imageNamed:[NSString stringWithFormat:@"grass.jpg"]] CGImage]);
    
    self.houseBottom = [CALayer layer];
    self.houseBottom.bounds = CGRectMake(0.0, 0.0, 200.0, 200.0 );
    self.houseBottom.position = CGPointMake(60.0, self.bounds.size.height - 75);
    self.houseBottom.zPosition = -999.0;
    self.houseBottom.contents = (__bridge id)([[UIImage imageNamed:[NSString stringWithFormat:@"house_bottom.png"]] CGImage]);
    
    self.houseTop = [CALayer layer];
    self.houseTop.bounds = CGRectMake(0.0, 0.0, 200.0, 200.0 );
    self.houseTop.position = CGPointMake(60.0, self.bounds.size.height - 75);
    self.houseTop.zPosition = 999.0;
    self.houseTop.contents = (__bridge id)([[UIImage imageNamed:[NSString stringWithFormat:@"house_top.png"]] CGImage]);

    
    //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grass.jpg"]];
    NSString *fileName = [NSString stringWithFormat:@"corgi.png"];
    self.corgi = [UIImage imageNamed:fileName];
    self.corgiLayer = [Corgi layer];
    self.corgiLayer.contents = (__bridge id)([self.corgi CGImage]);

    [self.layer addSublayer:self.background];
    [self.layer addSublayer:self.houseBottom];
    [self.layer addSublayer:self.corgiLayer];
    [self.layer addSublayer:self.houseTop];
    [self setNeedsDisplay];
    
}


-(void) barkNow:(UIGestureRecognizer*) gesture {
    [self.musicPlayer play];
}

- (void)drawRect:(CGRect)rect
{
    
}

-(BOOL) isMovingLeft:(CGPoint) location {
    if (self.corgiLayer.position.x < location.x) {
        return NO;
    }
    return YES;
}

-(BOOL) isOnLeftSideOfScreen:(CGPoint) location {
    if  (location.x < self.bounds.size.width/2.0){
    return YES;
    }
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // capture the location where the user starts touching the view

    self.currentLocation = [[touches anyObject] locationInView:self];
    
    //parallax background
    if ([self isOnLeftSideOfScreen:self.currentLocation] && self.corgiLayer.position.x > self.currentLocation.x) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:2];
        self.background.position = CGPointMake(self.bounds.origin.x +40.0, self.background.position.y);
        [CATransaction commit];
    } else if (![self isOnLeftSideOfScreen:self.currentLocation] && self.corgiLayer.position.x < self.currentLocation.x){
        [CATransaction begin];
        [CATransaction setAnimationDuration:2];
        self.background.position = CGPointMake(self.bounds.origin.x -40.0, self.background.position.y);
        [CATransaction commit];
    }

    
    //flip the corgi
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
    //[CATransaction setDisableActions:YES];
    //parallax background
    if ([self isOnLeftSideOfScreen:self.currentLocation] && self.corgiLayer.position.x > self.currentLocation.x) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:2];
        self.background.position = CGPointMake(self.bounds.origin.x +40.0, self.background.position.y);
        [CATransaction commit];
    } else if (![self isOnLeftSideOfScreen:self.currentLocation] && self.corgiLayer.position.x < self.currentLocation.x){
        [CATransaction begin];
        [CATransaction setAnimationDuration:2];
        self.background.position = CGPointMake(self.bounds.origin.x -40.0, self.background.position.y);
        [CATransaction commit];
    }

    // Update the background location each and everytime the user moves the Corgi :)
//    UITouch *touch = [touches anyObject];
//    CGPoint currentTouch = [touch locationInView:self];
//    CGPoint lastTouch    = [touch previousLocationInView:self];
//   
//    // From these two pieces of information one (if one were so inclined) could get the distance between touch events.
//    CGFloat deltaX = currentTouch.x - lastTouch.x;
//        
//    // Using this distance move the background a proportionate amount in the opposite direciton.
//    self.background.position = CGPointMake(self.background.position.x );
    
    
    
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
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.currentLocation = [[touches anyObject] locationInView:self];
    
    [self setNeedsDisplay];
}




@end
