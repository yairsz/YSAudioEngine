//
//  YSPlinkoSE.m
//  YSAudioEngine
//
//  Created by Yair Szarf on 2/26/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSIotaSE.h"


//
//#define TRIADS @[@[@"C",@"E", @"G"],@[@"D",@"F", @"A"],\
//                 @[@"E",@"G", @"B"],@[@"F",@"A", @"C"],\
//                 @[@"G",@"B", @"D"],@[@"A",@"C",@"E"],\
//                 @[@"B",@"D",@"F"]]

#define MAJOR @[@[@"C",@"D",@"E",@"F",@"G",@"A",@"B"]]
#define POINTS_100 @[@"C5",@"D5",@"E5",@"F5",@"G5",@"A5",@"B5",@"C6"]
#define POINTS_50 @[@"C4",@"E4",@"G4",@"C4"]
#define POINTS_25 @[@"C3",@"C4"]
#define POINTS_5 @[@"C2",@"C3"]
#define LOOSE @[@"C3",@"G2",@"D2",@"C2"]

#define INTERVAL 0.07


@interface YSIotaSE ()

@property (strong, nonatomic) NSMutableDictionary * players;
@property (nonatomic) NSInteger playCount;
@property (nonatomic) NSMutableArray * notes;
@property (nonatomic) NSInteger index;

@end

@implementation YSIotaSE

+(YSIotaSE *) sharedSE{
    static dispatch_once_t pred;
    static YSIotaSE *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[YSIotaSE alloc] init];
        // Handle AudioSession
 
        if ([[AVAudioSession sharedInstance] isOtherAudioPlaying]) {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        } else {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        }
    });
    return shared;
}

- (void) prime
{
    [self loadPlayers];
}

- (void) reset
{
    self.index = 0;
}

- (void) playHit
{
    AVAudioPlayer * player = [self.players objectForKey:self.notes[self.index]];
    [player setVolume:1.0];
    [player play];
    self.index ++;
    if (self.index == self.notes.count) self.index -= 7;
    
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
        NSArray * baseScale = MAJOR;
        for (int i = 0; i < 5; i++ ) {
            [_notes addObjectsFromArray:baseScale[i % baseScale.count]];
        }
        for (int i = 0; i < _notes.count; i++ ) {
            NSString * note = _notes[i];
            _notes[i] = [NSString stringWithFormat:@"%@%d",note, (int) (i / 7) + 2];
        }
    }
    return _notes;
}

- (void) playEvent:(YSIotaSEEvent) event {
    NSArray * notesArray;
    switch (event) {
        case YSIotaSEEventLoose:
            notesArray = LOOSE;
            break;
        case YSIotaSEEvent5:
            notesArray = LOOSE;
            break;
        case YSIotaSEEvent25:
            notesArray = POINTS_25;
            break;
        case YSIotaSEEvent50:
            notesArray = POINTS_50;
            break;
        case YSIotaSEEvent100:
            notesArray = POINTS_100;
            break;
        default:
            break;
    }
    
        for (NSInteger i = 0; i< notesArray.count; i++) {
            AVPlayer * notePlayer = [self.players objectForKey:notesArray[i]];
            SEL theSelector = @selector(playPLayer:);
            NSMethodSignature * signature = [YSIotaSE instanceMethodSignatureForSelector:theSelector];
            NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setSelector:@selector(playPLayer:)];
            [invocation setSelector:theSelector];
            [invocation setTarget:self];
            [invocation setArgument:&notePlayer atIndex:2];
            [NSTimer scheduledTimerWithTimeInterval:INTERVAL*i invocation:invocation repeats:NO];
        }
}

- (void) playPLayer: (AVAudioPlayer*) player
{
    [player setVolume:1.0];
    [player play];
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
