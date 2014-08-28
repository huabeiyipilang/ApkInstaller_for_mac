//
//  AdbManager.h
//  ApkInstaller
//
//  Created by Carl Li on 14-8-23.
//  Copyright (c) 2014年 Carl Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"

@interface AdbManager : NSObject
+ (AdbManager*) getInstance;

- (BOOL) adbAvailable;
- (NSString*) install:(NSString*) path device:(NSString*) deviceId;
- (NSArray*) devices;
@end
