//
//  YSPlinkoSE.m
//  YSAudioEngine
//
//  Created by Yair Szarf on 2/26/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSIotaSE.h"

#define TRIADS @[@[@"C",@"E", @"G"],@[@"D",@"F", @"A"],\
                 @[@"E",@"G", @"B"],@[@"F",@"A", @"C"],\
                 @[@"G",@"B", @"D"],@[@"A",@"C",@"E"]]

@interface YSIotaSE ()

@property (strong, nonatomic) NSMutableDictionary * players;
@property (nonatomic) NSInteger playCount;
@property (nonatomic) NSMutableArray * notes;

@end

@implementation YSIotaSE

+(YSIotaSE *) sharedSE{
    static dispatch_once_t pred;
    static YSIotaSE *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[YSIotaSE alloc] init];
    });
    return shared;
}

- (void) prime
{
    [self loadPlayers];
    
}

- (void) playHit
{
    AVAudioPlayer * player = [self.players objectForKey:[self.notes lastObject]];
    [player setVolume:1.0];
    [player play];
    [self.notes removeLastObject];
    
}

- (NSMutableDictionary *) players
{
    if (!_players) {
        _players = [NSMutableDictionary new];
    }
    return _players;
}

- (NSMutableArray * ) notes
{
    if (!_notes) {
        _notes = [NSMutableArray new];
    }
    if (_notes.count == 0) {
        NSArray * triads = TRIADS;
        [_notes addObjectsFromArray:triads[arc4random() % triads.count]];
        [_notes addObjectsFromArray:triads[arc4random() % triads.count]];
        [_notes addObjectsFromArray:triads[arc4random() % triads.count]];
        
        for (int i = 0; i < _notes.count; i++ ) {
            NSString * note = _notes[i];
            _notes[i] = [NSString stringWithFormat:@"%@%d",note,((arc4random() % 3) +2 )];
        }
    }
    return _notes;
}

- (void) loadPlayers
{
    NSURL * bundleURL = [[NSBundle mainBundle] bundleURL];
    NSArray * fileURLs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:bundleURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    for (int i = 0; i < fileURLs.count; i++) {
        NSURL * fileURL = fileURLs[i];
        if ([[fileURL pathExtension] isEqualToString:@"mp3"]){
            NSString * fileName = [fileURL lastPathComponent];
            NSString * noteName = [[fileName componentsSeparatedByString:@"_"] firstObject];
            NSURL * fileURL = [NSURL URLWithString:fileName relativeToURL:bundleURL];
            AVAudioPlayer * player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
            [self primePlayer:player];
            [self.players setValue:player forKey:noteName];
        }
    }
}

- (void) primePlayer: (AVAudioPlayer *) player
{
    [player prepareToPlay];
    [player setVolume:0];
    [player play];
}



@end
