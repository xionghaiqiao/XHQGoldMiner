//
//  global.h
//  XHQGoldMiner
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 apple. All rights reserved.
//

#ifndef global_h
#define global_h

#define kScreenWidth     960
#define kScreenHeight    640


#define kHookCategory    1
#define kSceneCategory   2
#define kGoldCategory    4
#define kStoneCategory   8

// Score
#define kSmallGoldScore     100
#define kMiddleGoldScore    200
#define kBigGoldScore       400
#define kSmallStoneScore    25
#define kMiddleStoneScore   50
#define kBigStoneScore      75
#define kDiamondScore       500
#define kSkeletonScore      10
#define kBagScore (arc4random_uniform(200) + 50)

// Speed
#define kNormalRopeSpeed        4
#define kSmallGoldBackSpeed     3.0
#define kMiddleGolBackSpeed     2.0
#define kBigGoldBackSpeed       1.0
#define kSmallStoneBackSpeed    3.0
#define kMiddleStoneBackSpeed   2.0
#define kBigStoneBackSpeed      1.0
#define kBagBackSpeed           3
#define kDiamondSpeed           3
#define kSkeltonSpeed           3

#define kBombPrice              200
#define kPowerPrice             300
#define kGoodStonePrice         200
#define kBookPrice              100


//button type
#define kButtonTypeCloseConfigMenu  1
#define kButtonTypeShowConfigMenu   2

#define kButtonTypeOther            10


#define kBombInfo       @"Explosives. After purchasing, when you find a heavy and small amount of items, press the upper explosive to blow up the items to save time. The effect is the next level"

#define kPowerInfo      @"Power Potion. After purchase, power will increase in the next level, and the speed of pulling back will increase by 20% after catching the item."

#define kGoodStoneInfo  @"High-quality ore. The price of buying diamonds in the next level after purchase will become 3 times the original price, but there is no guarantee that there will be diamonds in the next level ~ the effect is the next level"

#define kBookInfo       @"Book of ore collection. The price of the next ore after purchase will be 3 times the original price, and its effect is the next."

typedef enum _StoneType
{
    kSmallGold = 0,
    kMiddleGold,
    kBigGold,
    kSmallStone,
    kMiddleStone,
    kBigStone,
    kDiamond,
    kSkeleton,
    kStoneTypeMax = 8
}StoneType;

#define kSmallGoldTexture @"gold-0-0.png"
#define kSmallGoldPulloutTexture @"pulled-gold-1-0.png"

#define kMiddleGoldTexture @"gold-0-0.png"
#define kMiddleGoldPulloutTexture @"pulled-gold-1-0.png"

#define kBigGoldTexture @"gold-0-1.png"
#define kBigGoldPulloutTexture @"pulled-gold-0-0.png"

#define kSmallStoneTexture @"stone-0.png"

#define kMiddleStoneTexture @"stone-1.png"

#define kBigStoneTexture @"stone-0.png"

#define kDiamondTexture @"diamond.png"
#define kSkeltonTexture @"bone.png"



#define kOrigionRopeHeight 70

typedef struct _SceneParam
{
    BOOL isBuyBomb;
    BOOL isBuyPower;
    BOOL isBuyGoodStone;
    BOOL isBuyBook;
}BuyProductIndex;


#endif /* global_h */
