//
//  YSShadowBoxerSE.h
//  YSAudioEngine
//
//  Created by Yair Szarf on 3/5/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


typedef enum YSEvent {
    YSEventBell = 0,
    YSEventPunchGlove,
    YSEventPunchFace,
    YSEventCrowd1,
    YSEventCrowd2,
    YSEventCrowd3
} YSEvent;

@interface YSShadowBoxerSE : NSObject

+ (YSShadowBoxerSE *) sharedSE;

-(void) startMusic;
-(void) stopMusic;

- (void) playEvent: (YSEvent) event;

- (void) prime;

- (void) startCrowd;

- (void) stopCrowd;

- (void) stopAll;

@end
