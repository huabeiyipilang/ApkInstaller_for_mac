//
//  AdbManager.m
//  ApkInstaller
//
//  Created by Carl Li on 14-8-23.
//  Copyright (c) 2014年 Carl Li. All rights reserved.
//

#import "AdbManager.h"
#import "Device.h"

@interface AdbManager(){
}
@property (nonatomic)  NSString* adbPath;
@end

@implementation AdbManager

static AdbManager* sInstance = nil;

+ (AdbManager*) getInstance{
    if (sInstance == nil) {
        sInstance = [[AdbManager alloc] init];
        sInstance.adbPath = [[NSBundle mainBundle] pathForResource:@"adb" ofType:@""];
    }
    return sInstance;
}

- (void)setAdbPath:(NSString*) path{
    _adbPath = path;
}

- (BOOL)adbAvailable{
    return [[NSFileManager defaultManager] fileExistsAtPath:_adbPath isDirectory:NO];
}


- (NSString*) install:(NSString*) path device:(NSString*)deviceId{
    
    if(path == nil || path.length == 0){
        return @"No apk file path";
    }
    
    if(deviceId == nil || deviceId.length == 0){
        return @"No device selected";
    }
    
    NSTask* task = [[NSTask alloc] init];
    [task setLaunchPath:_adbPath];
    
    NSArray* args = [NSArray arrayWithObjects:@"-s", deviceId, @"install", path, nil];
    [task setArguments:args];
    
    NSPipe* pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    
    NSFileHandle* handle = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData* data = [handle readDataToEndOfFile];
    
    NSString* res = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return res;
}

- (NSArray*) devices{
    
    NSTask* task = [[NSTask alloc] init];
    [task setLaunchPath:_adbPath];
    
    NSArray* args = [NSArray arrayWithObjects:@"devices", nil];
    [task setArguments:args];
    
    NSPipe* pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    
    NSFileHandle* handle = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData* data = [handle readDataToEndOfFile];
    
    NSString* res = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray* lines = [res componentsSeparatedByString:@"\n"];
    
    NSMutableArray* devices = [[NSMutableArray alloc] init];
    int count = lines.count;
    BOOL startDeviceLine = NO;
    for(int i = 1; i < count; i++){
        NSString* line = [lines objectAtIndex:i];
        if(!startDeviceLine){
            startDeviceLine = [line hasPrefix:@"List of devices attached"];
            continue;
        }
        
        if(line != nil && line.length > 0){
            Device* device = [[Device alloc] init];
            device.id = [[line componentsSeparatedByString:@"	"] objectAtIndex:0];
            [devices addObject:device];
        }
    }
    return devices;
}

@end
