//
//  DnD.h
//  NOMORECIA
//
//  Created by Evgeniy on 20.01.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

@interface DnD : NSView <NSDraggingSource, NSDraggingDestination, NSPasteboardItemDataProvider>

- (id)initWithCoder:(NSCoder* )coder;

@end
