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
    if (playing) { [self.playTimer invalidate]; }
    else {
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(hit) userInfo:nil repeats:YES];
    }
    playing = !playing;
}

- (void) hit {
    [self.se playHit];
}

@end
