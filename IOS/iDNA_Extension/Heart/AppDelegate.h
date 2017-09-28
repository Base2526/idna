//
//  AppDelegate.h
//  Heart
//
//  Created by somkid simajarn on 8/25/2559 BE.
//  Copyright © 2559 Klovers.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBar.h"

@import Firebase;
@import FirebaseMessaging;
@import FirebaseDatabase;

#import "HJObjManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MainTabBar *tabBar;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) HJObjManager *obj_Manager;

@property (strong, nonatomic) FIRDatabaseReference *ref;




@end

