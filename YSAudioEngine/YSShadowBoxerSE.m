//
//  YSShadowBoxerSE.m
//  YSAudioEngine
//
//  Created by Yair Szarf on 3/5/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSShadowBoxerSE.h"

@interface YSShadowBoxerSE ()
{
    int previousNumber;
}

@property (strong, nonatomic) NSMutableDictionary * players;
@property (nonatomic) NSInteger playCount;
@property (nonatomic) NSInteger index;
@property (strong, nonatomic) NSOperationQueue * soundOperationQueue;


@end

@implementation YSShadowBoxerSE

+(YSShadowBoxerSE *) sharedSE{
    static dispatch_once_t pred;
    static YSShadowBoxerSE *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[YSShadowBoxerSE alloc] init];
        // Handle AudioSession
        
        if ([[AVAudioSession sharedInstance] isOtherAudioPlaying]) {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        } else {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        }
    });
    return shared;
}

- (NSMutableDictionary *) players
{
    if (!_players) {
        _players = [NSMutableDictionary new];
    }
    return _players;
}

- (NSOperationQueue *) soundOperationQueue
{
    if (!_soundOperationQueue) {
        _soundOperationQueue = [NSOperationQueue new];
    }
    return _soundOperationQueue;
}

- (void) prime
{
    [self loadPlayers];
}

- (void) reset
{
    self.index = 0;
}



- (void) playEvent:(YSEvent) event {
    NSString * eventKey;
    int rand = 1;
    
    while (rand == previousNumber) {
        rand = arc4random() % 5 + 1;
    }
    previousNumber = rand;

    
    switch (event) {
        case YSEventBell:
            eventKey = @"DoubleBell.mp3";
            break;
        case YSEventPunchGlove:
            
            eventKey = [NSString stringWithFormat:@"PunchGlove%d.mp3",rand];
            break;
        case YSEventPunchFace:
            eventKey = [NSString stringWithFormat:@"FacePunch%d.mp3",rand];
            break;
        case YSEventCrowd1:
            [self cheerLevel:1];
            break;
        case YSEventCrowd2:
            [self cheerLevel:2];
            break;
        case YSEventCrowd3:
            [self cheerLevel:3];
            break;
        default:
            break;
    }
    
    AVPlayer * player = [self.players objectForKey:eventKey];
    [player setVolume:1.0];
    [player play];
}

- (void) loadPlayers
{
    [self.soundOperationQueue addOperationWithBlock:^{
        
    
    NSURL * bundleURL = [[NSBundle mainBundle] bundleURL];
    NSArray * fileURLs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:bundleURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    for (int i = 0; i < fileURLs.count; i++) {
        NSURL * fileURL = fileURLs[i];
        if ([[fileURL pathExtension] isEqualToString:@"mp3"]){
            NSString * fileName = [fileURL lastPathComponent];
            NSURL * fileURL = [NSURL URLWithString:fileName relativeToURL:bundleURL];
            AVAudioPlayer * player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
            
            [self primePlayer:player];
            [self.players setValue:player forKey:fileName];
        }
    }
        
    }];
}


- (void) primePlayer: (AVAudioPlayer *) player
{
    [player prepareToPlay];
    [player setVolume:0];
    [player play];
}

-(void)startMusic
{
    AVAudioPlayer *player = [self.players valueForKey:@"Music.mp3"];
    player.volume = 0.8;
    player.numberOfLoops = -1;
    [player play];
}

- (void) stopMusic {
    [self.soundOperationQueue addOperationWithBlock:^{
        AVAudioPlayer *player = [self.players valueForKey:@"Music.mp3"];
        while (player.volume > 0.0) {
            player.volume = player.volume - 0.0000001;
        }
        [player stop];
    }];
}

- (void) startCrowd {
    AVAudioPlayer *player = [self.players valueForKey:@"LoopCrowd.mp3"];
    player.volume = 1.0;
    player.numberOfLoops = -1;
    [player play];
}


- (void) stopCrowd {
    [self.soundOperationQueue addOperationWithBlock:^{
        AVAudioPlayer *player = [self.players valueForKey:@"LoopCrowd.mp3"];
        while (player.volume > 0.0) {
            player.volume = player.volume - 0.0000001;
        }
        [player stop];
    }];
}

- (void) cheerLevel:(int) level
{
    if (level == 1) {
        AVAudioPlayer * crowd = [self.players valueForKey:@"CrowdApplause.mp3"];
        crowd.volume = 0.7;
        [crowd play];
    } else if (level == 2) {
        AVAudioPlayer * crowd = [self.players valueForKey:@"CrowdBeginApplause.mp3"];
        crowd.volume = 0.7;
        [crowd play];
        int rand = arc4random() % 5 +1;
        NSString * cheerKey = [NSString stringWithFormat:@"Cheer%d.mp3",rand];
        AVAudioPlayer * cheer = [self.players valueForKey:cheerKey];
        cheer.volume = 0.4;
        [cheer play];
    }else if (level == 3) {
        AVAudioPlayer * crowd = [self.players valueForKey:@"CrowdHeyHeyHey.mp3"];
        crowd.volume = 1.8;
        [crowd play];
        AVAudioPlayer * crowd2 = [self.players valueForKey:@"Crowdheeey.mp3"];
        crowd2.volume = 2.0;
        [crowd2 play];
        int rand = arc4random() % 5 +1;
        NSString * cheerKey = [NSString stringWithFormat:@"Cheer%d.mp3",rand];
        AVAudioPlayer * cheer = [self.players valueForKey:cheerKey];
        cheer.volume = 0.6;
        [cheer play];
    }
    
    
}

@end
