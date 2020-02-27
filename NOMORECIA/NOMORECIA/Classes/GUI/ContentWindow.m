//
//  ViewController.m
//  NOMORECIA
//
//  Created by Evgeniy on 20.01.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//
#pragma mark - Imports
#import "ContentWindow.h"
#import "EncryptionManager.h"

#pragma mark - Code

@implementation ContentWindow

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
}

#pragma mark - View setup

- (void)setupView
{
#pragma mark  Drop button layer
    CALayer* bgDropLayer = [CALayer layer];
    bgDropLayer.backgroundColor = [NSColor colorWithCalibratedRed: 0.991 green: 0.792 blue: 0.237 alpha: 1].CGColor;
    
    _dropBtn.wantsLayer = YES;
    _dropBtn.layer = bgDropLayer;
    
#pragma mark  Drop button tracking
    NSTrackingArea* trackingArea = [[NSTrackingArea alloc]
                                    initWithRect: [_dropBtn bounds]
                                    options: NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways
                                    owner: _dropBtn userInfo: nil];
    [_dropBtn addTrackingArea: trackingArea];
    
    
#pragma mark  Drop button animation
    CALayer* vertLine = [CALayer layer];
    vertLine.backgroundColor = [NSColor blackColor].CGColor;
    vertLine.frame = NSMakeRect(150, 20, 1.8, 60);
    
    CALayer* leftLine = [CALayer layer];
    leftLine.backgroundColor = [NSColor blackColor].CGColor;
    leftLine.frame = NSMakeRect(125, 70, 30, 1.8);
    
    CALayer* rightLine = [CALayer layer];
    rightLine.backgroundColor = [NSColor blackColor].CGColor;
    rightLine.frame = NSMakeRect(145, 70, 30, 1.8);
    
    
    [_dropBtn.layer addSublayer: vertLine];
    [_dropBtn.layer addSublayer: leftLine];
    [_dropBtn.layer addSublayer: rightLine];
    
    leftLine.transform = CATransform3DMakeRotation(45 / 180.0 * M_PI, 0.0, 0.0, 1.0);
    rightLine.transform = CATransform3DMakeRotation(135 + 135 / 180.0 * M_PI, 0.0, 0.0, 1.0);
    
#pragma mark Textfields setup
    _pSlogan.textColor = [NSColor colorWithCalibratedRed: 0.751 green: 0.751 blue: 0.737 alpha: 1];
    _pAction.textColor = _pSlogan.textColor;
    
    [_pAction setStringValue: @"Drop 0day or sources\nto be safe"];
}

#pragma mark - Drop button processing

- (IBAction)btnShowPanel:(NSButton* )sender
{
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles: YES];
    [panel setCanChooseDirectories: YES];
    [panel setAllowsMultipleSelection: YES];
    panel.animationBehavior = NSWindowAnimationBehaviorDefault;
    
    [panel beginSheetModalForWindow: [[NSApplication sharedApplication] mainWindow] completionHandler:^(NSInteger result)
     {
         if (result == NSFileHandlingPanelOKButton)
         {
             NSMutableArray* files = [NSMutableArray array];
             bool isEncrypted = false;
             
             for (NSURL* fileURL in [panel URLs])
             {
                 [files addObject: fileURL];
                 if ([[fileURL pathExtension] isEqualToString: appExt])
                 {
                     isEncrypted = true;
                 }
             }
             
             isEncrypted ? [EncryptionManager decryptFiles: files isURL: YES] : [EncryptionManager encryptFiles: files isURL: YES];
         }
         
     }];
}

#pragma mark - Other methods

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
}


@end
