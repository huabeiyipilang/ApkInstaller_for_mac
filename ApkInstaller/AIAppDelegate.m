//
//  AIAppDelegate.m
//  ApkInstaller
//
//  Created by Carl Li on 14-8-21.
//  Copyright (c) 2014年 Carl Li. All rights reserved.
//

#import "AIAppDelegate.h"
#import "AdbManager.h"
#import "Device.h"

@interface AIAppDelegate ()
@property (weak) IBOutlet NSPopUpButton *deviceListView;
@property (unsafe_unretained) IBOutlet NSTextView *outputView;
@property NSString* apkPath;
@end

@implementation AIAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self freshDevices];
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename{
    self.apkPathView.stringValue = filename;
    _apkPath = filename;
    return YES;
}

- (IBAction)onInstallClick:(id)sender {
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(installApk) object:nil] start];
}

- (IBAction)onFreshDevicesClick:(id)sender {
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(freshDevices) object:nil] start];
}

- (void) installApk{
    NSString* deviceId = [[self.deviceListView selectedItem] title];
    NSString* res = [[AdbManager getInstance] install:_apkPath device:deviceId];
    
    [self displayMessage:res];
}


- (void) freshDevices{
    NSArray* devices = [[AdbManager getInstance] devices];
    
    [self.deviceListView removeAllItems];
    for(Device* device in devices){
        [self.deviceListView addItemWithTitle:device.id];
    }
    
    [self displayMessage:[devices componentsJoinedByString:@"\n"]];
}

- (void)displayMessage:(NSString*) message{
    self.outputView.string = [self.outputView.string stringByAppendingFormat:@"\n%@", message];
}

@end
