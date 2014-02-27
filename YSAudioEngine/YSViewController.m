//
//  YSViewController.m
//  YSAudioEngine
//
//  Created by Yair Szarf on 2/26/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSViewController.h"
#import "YSIotaSE.h"

@interface YSViewController (){
    BOOL playing;
    int counter;
}
@property (strong, nonatomic) YSIotaSE *se;
@property (strong, nonatomic) NSTimer * playTimer;

@end

@implementation YSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.se = [YSIotaSE sharedSE];
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
    switch (counter % 4) {
        case 0:
            [self.se playEvent:YSIotaSEEvent50];
            break;
        case 1:
            [self.se playEvent:YSIotaSEEvent100];
            break;
        case 2:
            [self.se playEvent:YSIotaSEEvent25];
            break;
        case 3:
            [self.se playEvent:YSIotaSEEventLoose];
            break;
            
        default:
            break;
    }
    
    counter++;
    
    
    
    
    
    
}

- (void) hit {
    [self.se playHit];
}

@end
