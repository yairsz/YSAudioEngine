//
//  YSViewController.m
//  YSAudioEngine
//
//  Created by Yair Szarf on 2/26/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSViewController.h"
#import "YSShadowBoxerSE.h"

@interface YSViewController (){
    BOOL playing;
    int counter;
}
@property (strong, nonatomic) YSShadowBoxerSE *se;
@property (strong, nonatomic) NSTimer * playTimer;

@end

@implementation YSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.se = [YSShadowBoxerSE sharedSE];
    [self.se prime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startHits:(UIButton *)sender {
//    if (playing) {
//        [self.playTimer invalidate];
//        [self.se reset];
//    }
//    else {
//        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hit) userInfo:nil repeats:YES];
//    }
//    playing = !playing;
    
    
    
    switch (arc4random() % 2) {

        case 0:
            [self.se playEvent:YSEventPunchGlove];
            break;
        case 1:
            [self.se playEvent:YSEventPunchFace];
            break;
        default:
            break;
    }
    
}
- (IBAction) bell:(id)sender{
    [self.se playEvent:YSEventBell];
    [self.se startCrowd];
}

- (IBAction) startCrowd:(id)sender{
    [self.se startCrowd];
}

- (IBAction) stopCrowd:(id)sender{
    [self.se stopCrowd];
}

- (IBAction) startMusic:(id)sender{
    [self.se startMusic];
}

- (IBAction) stopMusic:(id)sender{
    [self.se stopMusic];
}
- (IBAction) crowd1:(id)sender{
    [self.se playEvent:YSEventCrowd1];
}
- (IBAction) crowd2:(id)sender{
    [self.se playEvent:YSEventCrowd2];
}
- (IBAction) crowd3:(id)sender{
    [self.se playEvent:YSEventCrowd3];
}

- (IBAction)stopAll:(id)sender{
    [self.se stopAll];
}

@end
