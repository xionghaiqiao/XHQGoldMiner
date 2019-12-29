//
//  SoundTool.m
//  MiFIConfigTools
//
//  Created by tiger on 2019/5/27.
//  Copyright © 2019 tiger. All rights reserved.
//

#import "SoundTool.h"
#import <AVFoundation/AVFoundation.h>

#define kMusicMuted             @"musicMuted"
#define kSoundMuted             @"soundMuted"
#define kBgMusicURLName         @"backMusic.mp3"

@interface SoundTool ()
{
    NSMutableDictionary *_soundIDs;
}

@end

@implementation SoundTool
singleton_implementation(SoundTool)

#pragma mark - 初始化
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
        [self loadBgMusic];
        [self loadSound];
        
        NSUserDefaults *dataDefault = [NSUserDefaults standardUserDefaults];
        _isSoundMute   = [dataDefault boolForKey:kSoundMuted];
        _isBgMusicMute = [dataDefault boolForKey:kMusicMuted];
        
    }
    return self;
}

#pragma mark - 加载背景音乐和音效
//加载音效
- (void)loadSound
{
    _soundIDs = [NSMutableDictionary dictionary];
    SystemSoundID soundId;
    
    //得到音效文件路径
    NSURL *bundlePath = [[NSBundle mainBundle]URLForResource:@"sound" withExtension:@"bundle"];
    //路径的bundle
    NSBundle *soundBundle = [NSBundle bundleWithURL:bundlePath];
    //得到路径下所有的文件路径+文件名
    NSArray *soundArray = [soundBundle URLsForResourcesWithExtension:@"mp3" subdirectory:nil];
    
    for (NSURL *soundURL in soundArray)
    {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &soundId);
        //得到路径名后面的文件名
        NSString *str = [soundURL.path lastPathComponent];
        //放入字典
        [_soundIDs setObject:@(soundId) forKey:str];
    }
    
}
//加载背景音乐
- (void)loadBgMusic
{
    NSString *path = [[NSBundle mainBundle]pathForResource:kBgMusicURLName ofType:nil];
    NSURL *url = [NSURL URLWithString:path];
    _bgMusicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [_bgMusicPlayer prepareToPlay];
    _bgMusicPlayer.numberOfLoops = -1;
    
}

#pragma mark - 播放音乐和音效
- (void)playBgMusic
{
    NSLog(@"当前音乐静音状态%d",_isBgMusicMute);
    if (_isBgMusicMute) return;
    NSLog(@"ready to play background music");
    [_bgMusicPlayer play];
}

- (void)playSoundByName:(NSString *)name
{
    NSLog(@"当前音效静音状态%d",_isSoundMute);
    if (_isSoundMute) return;
    SystemSoundID soundID = [_soundIDs[name] unsignedIntValue];
    AudioServicesPlaySystemSound(soundID);
}

- (void)changeBgMusic:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:nil];
    NSURL *url = [NSURL URLWithString:path];
    _bgMusicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [_bgMusicPlayer prepareToPlay];
    _bgMusicPlayer.numberOfLoops = -1;
}

#pragma  mark - 设置音乐和音效是否开关

- (void)setBgMusicMuted:(BOOL)isMuted
{
    _isBgMusicMute = isMuted;
    NSLog(@"设置音乐静音状态%d",_isBgMusicMute);
    if (_isBgMusicMute)
    {
        [_bgMusicPlayer stop];
    }
    else
    {
        [_bgMusicPlayer play];
    }
    [[NSUserDefaults standardUserDefaults] setBool:_isBgMusicMute forKey:kMusicMuted];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)setSoundMuted:(BOOL)isMuted
{
    _isSoundMute = isMuted;
    NSLog(@"s设置效静音状态%d",_isSoundMute);
    [[NSUserDefaults standardUserDefaults] setBool:_isSoundMute forKey:kSoundMuted];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
