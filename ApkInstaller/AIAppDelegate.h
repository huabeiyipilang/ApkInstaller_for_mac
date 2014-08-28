//
//  AIAppDelegate.h
//  ApkInstaller
//
//  Created by Carl Li on 14-8-21.
//  Copyright (c) 2014年 Carl Li. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AIAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *apkPathView;

@end
