//
//  UserDataManager.h
//  XHQGoldMiner
//
//  Created by apple on 2019/12/25.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserDataManager : NSObject
singleton_interface(UserDataManager)

@property (nonatomic,assign)NSInteger totalMoney;
@property (nonatomic,assign)NSInteger stageNumber;

- (void)saveUserData;
- (void)getUserData;
@end

NS_ASSUME_NONNULL_END
