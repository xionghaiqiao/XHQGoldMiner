//
//  ConfigMenu.h
//  XHQGoldMiner
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 apple. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
NS_ASSUME_NONNULL_BEGIN
@class BaseButton;
@interface ConfigMenu : SKSpriteNode
@property (nonatomic, strong)BaseButton *closeButton;//需要设置代理
- (void)configAllMenus;
@end

NS_ASSUME_NONNULL_END
