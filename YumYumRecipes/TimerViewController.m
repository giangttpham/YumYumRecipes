//
//  ViewController.m
//  CountdownTimer
//
//  Created by Tra` Beo' on 12/9/14.
//  Copyright (c) 2014 Giang Pham. All rights reserved.
//

#import "TimerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TimerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property NSTimer *countdownTimer;
@property int minuteCounter;
@property (weak, nonatomic) IBOutlet UITextField *hourTextfield;
@property (weak, nonatomic) IBOutlet UITextField *minuteTextfield;
@property AVAudioPlayer *alarmPlayer;

@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"xylophone-alarm" withExtension:@"mp3"];
    self.alarmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Green Background.jpg"]  ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTimer {
    self.minuteCounter = [self.hourTextfield.text intValue] * 60 + [self.minuteTextfield.text intValue];
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
}
- (IBAction)startTimmerBtnPressed:(id)sender {
    
    if ([self.hourTextfield.text isEqualToString: @""])
        self.hourTextfield.text = @"0";
    
    if ([self.minuteTextfield.text isEqualToString: @""])
        self.minuteTextfield.text = @"0";
    
    if ([self.minuteTextfield.text intValue] < 10)
        self.countdownLabel.text = [NSString stringWithFormat:@"%@:0%@",self.hourTextfield.text,self.minuteTextfield.text];
    else
        self.countdownLabel.text = [NSString stringWithFormat:@"%@:%@",self.hourTextfield.text,self.minuteTextfield.text];
    
    UIAlertView *emptyTimerAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please put in time interval" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    if ([self.hourTextfield.text  isEqualToString: @"0"] && [self.minuteTextfield.text isEqualToString:@"0"])
        [emptyTimerAlert show];
    else
        [self setTimer];
    
}

- (void)timerRun {
    self.minuteCounter -= 1;
    int hours = self.minuteCounter/60;
    int minutes = self.minuteCounter - (hours * 60);
    NSString *timerOutput;
    if (minutes < 10)
        timerOutput = [NSString stringWithFormat:@"%d:0%d",hours,minutes];
    else
        timerOutput = [NSString stringWithFormat:@"%d:%d",hours,minutes];
    
    self.countdownLabel.text = timerOutput;
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Timer Done"
                          message:@"Check your food!"
                          delegate:nil
                          cancelButtonTitle:@"Got it"
                          otherButtonTitles:nil];
    alert.delegate = self;
    if (self.minuteCounter == 0) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
        [alert show];
        [self.alarmPlayer play];
        
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        [self.alarmPlayer stop];
    }
    self.hourTextfield.text = @"";
    self.minuteTextfield.text = @"";
}
@end
