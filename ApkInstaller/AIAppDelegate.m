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
@property (weak) IBOutlet NSButton *freshDeviceButton;
@property (weak) IBOutlet NSButton *installButton;
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
    self.outputView.string = [self.outputView.string stringByAppendingFormat:@"\n%@", @"Start install..."];
    [self onCommandStart];
    NSString* deviceId = [[self.deviceListView selectedItem] title];
    NSString* res = [[AdbManager getInstance] install:_apkPath device:deviceId];
    
    [self onCommandFinish:res];
}


- (void) freshDevices{
    [self onCommandStart];
    NSArray* devices = [[AdbManager getInstance] devices];
    
    [self.deviceListView removeAllItems];
    for(Device* device in devices){
        [self.deviceListView addItemWithTitle:device.id];
    }
    
    [self onCommandFinish:[devices componentsJoinedByString:@"\n"]];
}

- (void) onCommandStart{
    [self.freshDeviceButton setEnabled:NO];
    [self.installButton setEnabled:NO];
    [self.deviceListView setEnabled:NO];
}

- (void) onCommandFinish:(NSString*) result{
    [self.freshDeviceButton setEnabled:YES];
    [self.installButton setEnabled:YES];
    [self.deviceListView setEnabled:YES];
    
    self.outputView.string = [self.outputView.string stringByAppendingFormat:@"\n%@", result];
}

@end
