//
//  DropButton.h
//  Crypto
//
//  Created by Evgeniy on 20.01.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DropButton : NSButton

- (void)updateTrackingAreaWithDropRect;

- (void)restoreOriginalArea;

@property(nonatomic, strong) id pointer;

@end
