//
//  UserDataManager.m
//  XHQGoldMiner
//
//  Created by apple on 2019/12/25.
//  Copyright © 2019 apple. All rights reserved.
//

#import "UserDataManager.h"
@implementation UserDataManager
singleton_implementation(UserDataManager)

- (void)saveUserData
{
    [[NSUserDefaults standardUserDefaults]setInteger:self.totalMoney forKey:@"totalMoney"];
    [[NSUserDefaults standardUserDefaults]setInteger:self.stageNumber forKey:@"stageNumber"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getUserData];
    }
    return self;
}

- (void)getUserData
{
    self.totalMoney = [[NSUserDefaults standardUserDefaults]integerForKey:@"totalMoney"];
    self.stageNumber = [[NSUserDefaults standardUserDefaults]integerForKey:@"stageNumber"];
}

@end
