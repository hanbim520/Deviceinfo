//
//  IOSDevice.m
//  DeviceInfo
//
//  Created by zhanghaijun on 2018/10/31.
//  Copyright © 2018 zhanghaijun. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import "IOSDevice.h"
#import "Reachability.h"

@interface IOSDevice()
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;

@end

@implementation IOSDevice
- (void)Init {
    _statusString  = @"";
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = @"www.apple.com";
    //   NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
    //   self.TextView.text = [NSString stringWithFormat:remoteHostLabelFormatString, remoteHostName];
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
}
/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.hostReachability)
    {
        BOOL connectionRequired = [reachability connectionRequired];
        
        
        NSString* baseLabelText = @"";
        
        if (connectionRequired)
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.", @"Reachability text if a connection is required");
        }
        else
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a connection is not required");
        }
        //  self.TextView.text  = baseLabelText;
    }
    
    if (reachability == self.internetReachability)
    {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        BOOL connectionRequired = [reachability connectionRequired];
        
        switch (netStatus)
        {
            case NotReachable:        {
                _statusString = @"Unreachable";
                
                /*
                 Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
                 */
                connectionRequired = NO;
                break;
            }
                
            case ReachableViaWWAN:        {
                
                // 获取手机网络类型
                CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
                
                NSString *currentStatus = info.currentRadioAccessTechnology;
                
                if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                    
                    _statusString = @"GPRS";
                }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                    
                    _statusString = @"2.75G EDGE";
                }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                    
                    _statusString = @"3G";
                }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                    
                    _statusString = @"3.5G HSDPA";
                }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                    
                    _statusString = @"3.5G HSUPA";
                }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                    
                    _statusString = @"2G";
                }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                    
                    _statusString = @"3G";
                }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                    
                    _statusString = @"3G";
                }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                    
                    _statusString = @"3G";
                }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                    
                    _statusString = @"HRPD";
                }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                    
                    _statusString = @"4G";
                }
                break;
            }
            case ReachableViaWiFi:        {
                _statusString= NSLocalizedString(@"Reachable WiFi", @"");
                
                break;
            }
        }
        NSLog(@"当前网络类型为: %@" ,_statusString);
        
    }
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end


 #if defined(_cplusplus)
 extern "C"{
 #endif
 IOSDevice *iOSManger = nil;
 
 void Init()
 {
 if(iOSManger == nil)
 {
 iOSManger = [[IOSDevice alloc]init];
 [iOSManger Init];
 }
 }
 const char* GetIOSNetworkType()
 {
     if(iOSManger == nil)
     {
         Init();
     }
     return strdup([iOSManger.statusString UTF8String]);
 }
 int CTGetSignalStrength(); // private method (not in the header) of Core Telephony
 const int GetIOSNetworkStrength()
 {
     int signalStrength = CTGetSignalStrength();
     return signalStrength;
 }
 
 #if defined(_cplusplus)
 }
 #endif
 
