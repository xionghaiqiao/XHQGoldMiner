//
//  ShowSuccessOrFailLayer.h
//  XHQGoldMiner
//
//  Created by apple on 2019/12/22.
//  Copyright © 2019 apple. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowSuccessOrFailLayer : SKNode
- (instancetype)initWithResult:(BOOL)isPass;
@end

NS_ASSUME_NONNULL_END
