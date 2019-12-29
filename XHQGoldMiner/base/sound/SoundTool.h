//
//  SoundTool.h
//  MiFIConfigTools
//
//  Created by tiger on 2019/5/27.
//  Copyright © 2019 tiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@class  AVAudioPlayer;
NS_ASSUME_NONNULL_BEGIN

@interface SoundTool : NSObject
singleton_interface(SoundTool);

@property(nonatomic, strong)AVAudioPlayer *bgMusicPlayer;   //播放背景音乐
@property(nonatomic, assign)BOOL isBgMusicMute;               //是否背景音乐打开/关闭
@property(nonatomic, assign)BOOL isSoundMute;                 //是否音效打开/关闭

- (void)playBgMusic;                                        //播放背景音乐
- (void)changeBgMusic:(NSString *)name;                     //根据文件换背景音乐
- (void)playSoundByName:(NSString *)name;

- (void)setBgMusicMuted:(BOOL)isMuted;
- (void)setSoundMuted:(BOOL)isMuted;

@end

NS_ASSUME_NONNULL_END
