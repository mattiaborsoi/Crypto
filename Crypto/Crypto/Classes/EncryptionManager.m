//
//  EncryptionManager.m
//  Crypto
//
//  Created by Evgeniy on 20.01.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

#import "EncryptionManager.h"

@implementation EncryptionManager

+ (void)encryptFiles:(nonnull NSArray* )files isURL:(BOOL)aURL
{
    LzmaSDKObjCWriter* writer = [[LzmaSDKObjCWriter alloc] initWithFileURL: [NSURL fileURLWithPath: outFile] andType: LzmaSDKObjCFileType7z];
    
    if (aURL)
        for (NSURL* filePath in files)
        {
            [writer addPath: [filePath resourceSpecifier] forPath: [filePath lastPathComponent]];
        }
    else
        for (NSString* filePath in files)
        {
            [writer addPath: filePath forPath: [filePath lastPathComponent]];
        }
    
    // Setup writer
    writer.delegate = self;
    writer.passwordGetter = ^NSString*(void) { return lzmaPass; };
    
    // Optional settings
    writer.method = LzmaSDKObjCMethodLZMA2;
    writer.solid = YES;
    writer.compressionLevel = 9;
    writer.encodeContent = YES;
    writer.encodeHeader = YES;
    writer.compressHeader = YES;
    writer.compressHeaderFull = YES;
    writer.writeModificationTime = NO;
    writer.writeCreationTime = NO;
    writer.writeAccessTime = NO;
    
    NSError* error = nil;
    [writer open: &error];
    
    [writer write]; //uses current thread
    
    NSData* encArchData = [[NSData dataWithContentsOfFile: outFile] AES128EncryptedDataWithKey: aesKey iv: lzmaPass];
    [encArchData writeToFile: outFile atomically: NO];
}

+ (void)decryptFiles:(nonnull NSArray* )files isURL:(BOOL)aURL
{
    if (aURL)
        for (NSURL* filePath in files)
        {
            NSData* decArchData = [[NSData dataWithContentsOfURL: filePath] AES128DecryptedDataWithKey: aesKey iv: lzmaPass];
            [decArchData writeToURL: filePath atomically: NO];
            
            LzmaSDKObjCReader* reader = [[LzmaSDKObjCReader alloc] initWithFileURL: filePath andType: LzmaSDKObjCFileType7z];
            
            reader.delegate = self;
            reader.passwordGetter = ^NSString*(void){
                return lzmaPass;
            };
            
            NSError* error = nil;
            if (![reader open: &error])
            {
                NSLog(@"Open error: %@", error);
            }
            
            NSMutableArray* items = [NSMutableArray array];
            
            [reader iterateWithHandler: ^BOOL(LzmaSDKObjCItem * item, NSError * error)
             {
                 if (item) [items addObject:item];
                 return YES;
             }];
            
            [reader extract: items
                     toPath: [[filePath URLByDeletingLastPathComponent] resourceSpecifier]
              withFullPaths: YES];
            
            
            [reader test: items]; //test extracted
            NSLog(@"test error: %@", reader.lastError);
            
            [[NSFileManager defaultManager] removeItemAtURL: filePath error: nil];
        }
    
    else
        for (NSString* filePath in files)
        {
            NSData* decArchData = [[NSData dataWithContentsOfFile: filePath] AES128DecryptedDataWithKey: aesKey iv: lzmaPass];
            [decArchData writeToFile: filePath atomically: NO];
            
            LzmaSDKObjCReader* reader = [[LzmaSDKObjCReader alloc] initWithFileURL: [NSURL URLWithString: filePath] andType: LzmaSDKObjCFileType7z];
            
            reader.delegate = self;
            reader.passwordGetter = ^NSString*(void){
                return lzmaPass;
            };
            
            NSError* error = nil;
            if (![reader open: &error])
            {
                NSLog(@"Open error: %@", error);
            }
            
            NSMutableArray* items = [NSMutableArray array];
            
            [reader iterateWithHandler: ^BOOL(LzmaSDKObjCItem * item, NSError * error)
             {
                 if (item) [items addObject:item];
                 return YES;
             }];
            
            [reader extract: items
                     toPath: [filePath stringByDeletingLastPathComponent]
              withFullPaths: YES];
            
            
            [reader test: items]; //test extracted
            NSLog(@"test error: %@", reader.lastError);
            
            [[NSFileManager defaultManager] removeItemAtPath: filePath error: nil];
        }
}

@end
