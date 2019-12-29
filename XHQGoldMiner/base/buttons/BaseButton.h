//
//  BaseButton.h
//  XHQGoldMiner
//
//  Created by SeaBridge.Xiong on 2019/12/22.
//  Copyright © 2019 SeaBridge.Xiong. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^BtnPressedControlBlock)(void);

@protocol BaseButtonDelegate <NSObject>

@optional
- (void)baseButtonPressedWithBtnType:(NSInteger)btnType;
@end


@interface BaseButton : SKSpriteNode
@property (nonatomic, assign)NSInteger btnType;
@property (nonatomic, strong)SKTexture *nTexture;
@property (nonatomic, strong)SKTexture *pressedTexture;

//delegate
@property (nonatomic,weak) id<BaseButtonDelegate> delegate;
//block
@property (nonatomic, strong)BtnPressedControlBlock btnPressedControlBlock;
//init
- (BaseButton *)initWithNormalTexture:(SKTexture *)normalTexture PressedTexture:(SKTexture * _Nullable)pressedTexture Rotated:(BOOL)rotated;
@end

NS_ASSUME_NONNULL_END
