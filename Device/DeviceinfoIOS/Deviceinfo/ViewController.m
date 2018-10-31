//
//  ViewController.m
//  Deviceinfo
//
//  Created by zhanghaijun on 2018/10/31.
//  Copyright © 2018 zhanghaijun. All rights reserved.
//

#import "ViewController.h"
#import "IOSDevice.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *TextView;

@end

@implementation ViewController
IOSDevice *iOSManger = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    
    if(iOSManger == nil)
        iOSManger = [[IOSDevice alloc]init];
    [iOSManger Init];
    
    
}
- (void) reachabilityChanged:(NSNotification *)note
{
   self.TextView.text = iOSManger.statusString ;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}
@end
