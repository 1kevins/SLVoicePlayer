//
//  AppDelegate.m
//  SLVoicePlayer
//
//  Created by kevin on 16/8/8.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import "AppDelegate.h"
#import <HysteriaPlayer.h>
#import "YTPlayerViewController.h"

#import "mainViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //初始化播放器
    [HysteriaPlayer sharedInstance];
    //初始化播放器控制器
    YTPlayerViewController *YTPlayer = [YTPlayerViewController shareInstance];
    self.window.rootViewController =[[UINavigationController alloc]initWithRootViewController:[[mainViewController alloc]init]];
    
    // 远程控制 (耳机 / 外设)
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // Override point for customization after application launch.
    return YES;
}
- (BOOL)canBecomeFirstResponder { return YES; }

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    HysteriaPlayer *player = [HysteriaPlayer sharedInstance];
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [player pausePlayerForcibly:NO];
                [player play];
                break;
            case UIEventSubtypeRemoteControlPause:
                [player pausePlayerForcibly:YES];
                [player pause];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause://
                if ([player isPlaying]){
                    [player pausePlayerForcibly:YES];
                    [player pause];
                }
                else {
                    [player pausePlayerForcibly:NO];
                    [player play];
                }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [player playNext];
                [player play];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [player playPrevious];
                [player play];
                break;
            default:
                break;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
