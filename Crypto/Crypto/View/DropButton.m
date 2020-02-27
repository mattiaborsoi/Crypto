//
//  DropButton.m
//  Crypto
//
//  Created by Evgeniy on 20.01.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

#import "DropButton.h"

#import <QuartzCore/QuartzCore.h>

@implementation DropButton

- (void)mouseEntered:(NSEvent* )theEvent
{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext* ctx)
     {
         ctx.duration = 0.08;
         ctx.timingFunction = [CAMediaTimingFunction functionWithName: @"easeIn"];
         self.animator.frame = NSMakeRect(0, 400/3., 300, 400/3.);
     } completionHandler: nil];
    
    
    CATransform3D leftTransform = CATransform3DMakeRotation(0, 0.0, 0.0, 1.0);
    CATransform3D rightTransform = CATransform3DMakeRotation(0, 0.0, 0.0, 1.0);
    
    leftTransform = CATransform3DTranslate (leftTransform, -4, -20, 0);
    rightTransform = CATransform3DTranslate (rightTransform, 5, -20, 0);
    
    self.layer.sublayers[2].transform = leftTransform;
    self.layer.sublayers[3].transform = rightTransform;
    
    self.bounds = NSMakeRect(0, -17, 300, 400/3.);
}

- (void)mouseExited:(NSEvent* )theEvent
{
    [NSAnimationContext runAnimationGroup: ^(NSAnimationContext* ctx)
     {
         ctx.duration = 0.08;
         ctx.timingFunction = [CAMediaTimingFunction functionWithName: @"easeIn"];
         self.animator.frame = NSMakeRect(0, 150, 300, 100);
     } completionHandler: nil];
    
    self.layer.sublayers[2].transform = CATransform3DMakeRotation(45 / 180.0 * M_PI, 0.0, 0.0, 1.0);
    self.layer.sublayers[3].transform = CATransform3DMakeRotation(135 + 135 / 180.0 * M_PI, 0.0, 0.0, 1.0);
    
    self.bounds = NSMakeRect(0, 0, 300, 100);
}

- (void)updateTrackingAreaWithDropRect
{
    if ([[self trackingAreas] count] > 0)
        [self removeTrackingArea: self.trackingAreas[0]];
    
    NSTrackingArea* trackArea = [[NSTrackingArea alloc] initWithRect: NSMakeRect(0, 0, 300, 400)
                                             options: NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways
                                               owner: self userInfo: nil];
    
    [self addTrackingArea: trackArea];
}

- (void)restoreOriginalArea
{
    [self updateTrackingAreas];
}

- (void)updateTrackingAreas
{
    NSTrackingArea* trackArea = self.trackingAreas[0];
    [self removeTrackingArea: trackArea];
    
    trackArea = [[NSTrackingArea alloc] initWithRect: self.bounds
                                             options: NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways
                                               owner: self userInfo: nil];
    
    [self addTrackingArea: trackArea];
}

@end
