//
//  DnD.m
//  NOMORECIA
//
//  Created by Evgeniy on 20.01.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

#import "DnD.h"
#import "EncryptionManager.h"
#import "DropButton.h"

@implementation DnD

#pragma mark - Init

- (id)initWithCoder:(NSCoder* )coder
{
    self = [super initWithCoder: coder];
    
    if (self)
    {
        [self registerForDraggedTypes: @[NSFilenamesPboardType]];
    }
    
    return self;
}

#pragma mark - Destination Operations

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    NSArray* dropBtn = self.window.contentView.subviews[0].subviews;
    
    for(id elem in dropBtn)
    {
        if ([elem class] == [DropButton class])
        {
            DropButton* p = elem;
            
            NSTrackingArea* trackArea = [[NSTrackingArea alloc] initWithRect: NSMakeRect(0, 0, 300, 400)
                                                                     options: NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways
                                                                       owner: p userInfo: nil];
            
            NSTrackingArea* orig = p.trackingAreas[0];
            [p removeTrackingArea: orig];
            
            [p addTrackingArea: trackArea];
        }
    }
    
    return NSDragOperationCopy;
}

- (void)draggingEnded:(id<NSDraggingInfo>)sender
{
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    NSArray* dropBtn = self.window.contentView.subviews[0].subviews;
    
    for(id elem in dropBtn)
    {
        if ([elem class] == [DropButton class])
        {
            DropButton* p = elem;
            
            NSTrackingArea* trackArea = [[NSTrackingArea alloc] initWithRect: NSMakeRect(0, 0, 300, 100)
                                                                     options: NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways
                                                                       owner: p userInfo: nil];
            
            NSTrackingArea* orig = p.trackingAreas[0];
            [p removeTrackingArea: orig];
            
            [p addTrackingArea: trackArea];
            [p mouseExited: nil];
        }
    }
    
    [self setNeedsDisplay: YES];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    [self setNeedsDisplay: YES];
    
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSArray* droppedFiles = [[sender draggingPasteboard] propertyListForType: NSFilenamesPboardType];
    
    if ([[[droppedFiles objectAtIndex: 0] pathExtension] isEqualToString: appExt])
        [EncryptionManager decryptFiles: droppedFiles isURL: NO];
    else
        [EncryptionManager encryptFiles: droppedFiles isURL: NO];
    
    
    return YES;
}

#pragma mark - Source Operations

- (NSDragOperation)draggingSession:(NSDraggingSession* )session sourceOperationMaskForDraggingContext:(NSDraggingContext)context
{
    NSLog(@"[draggingSession]");
    
    return NSDragOperationCopy;
}

- (BOOL)acceptsFirstMouse:(NSEvent* )event
{
    return YES;
}

@end
