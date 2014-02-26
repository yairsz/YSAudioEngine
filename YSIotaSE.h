//
//  YSPlinkoSE.h
//  YSAudioEngine
//
//  Created by Yair Szarf on 2/26/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface YSIotaSE : NSObject

+ (YSIotaSE *) sharedSE;

- (void) prime;
- (void) playHit;

@end
