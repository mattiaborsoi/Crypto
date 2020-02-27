//
//  EncryptionManager.h
//  Crypto
//
//  Created by Evgeniy on 20.01.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LzmaSDK_ObjC/LzmaSDKObjC.h>
#import "NSData+AES.h"
#import "Constant.h"

@interface EncryptionManager : NSObject

+ (void)encryptFiles:(nonnull NSArray* )files isURL:(BOOL)aURL;
+ (void)decryptFiles:(nonnull NSArray* )files isURL:(BOOL)aURL;

@end
