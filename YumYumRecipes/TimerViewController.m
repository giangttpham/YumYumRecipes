//
//  ViewController.m
//  CountdownTimer
//
//  Created by Giang Pham on 12/9/14.
//  Copyright (c) 2014 Giang Pham. All rights reserved.
//

#import "TimerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TimerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UITextField *hourTextfield;
@property (weak, nonatomic) IBOutlet UITextField *minuteTextfield;
@property NSTimer *countdownTimer;
@property int minuteCounter;
@property AVAudioPlayer *alarmPlayer;
@property UIGestureRecognizer *tapper;
@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"xylophone-alarm" withExtension:@"mp3"];
    self.alarmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green-background.jpg"]  ];
    self.tapper = [[UITapGestureRecognizer alloc]
                   initWithTarget:self action:@selector(handleSingleTap:)];
    self.tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.tapper];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTimer {
    self.minuteCounter = [self.hourTextfield.text intValue] * 60 + [self.minuteTextfield.text intValue];
    //set timer on interval of 1minute
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
}

- (IBAction)startTimmerBtnPressed:(id)sender {
    //get time from user input
    if ([self.hourTextfield.text isEqualToString: @""])
        self.hourTextfield.text = @"0";
    
    if ([self.minuteTextfield.text isEqualToString: @""])
        self.minuteTextfield.text = @"0";
    
    if ([self.minuteTextfield.text intValue] < 10)
        self.countdownLabel.text = [NSString stringWithFormat:@"%@:0%@",self.hourTextfield.text,self.minuteTextfield.text];
    else
        self.countdownLabel.text = [NSString stringWithFormat:@"%@:%@",self.hourTextfield.text,self.minuteTextfield.text];
    
    UIAlertView *emptyTimerAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please put in time interval" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    //if no time was entered, show alert or else, start timer
    if ([self.hourTextfield.text  isEqualToString: @"0"] && [self.minuteTextfield.text isEqualToString:@"0"])
        [emptyTimerAlert show];
    else
        [self setTimer];
    
}

- (void)timerRun {
    //calculate time left
    self.minuteCounter -= 1;
    int hours = self.minuteCounter/60;
    int minutes = self.minuteCounter - (hours * 60);
    NSString *timerOutput;
    if (minutes < 10)
        timerOutput = [NSString stringWithFormat:@"%d:0%d",hours,minutes];
    else
        timerOutput = [NSString stringWithFormat:@"%d:%d",hours,minutes];
    
    //display time
    self.countdownLabel.text = timerOutput;
    
    //alert user when time is over and play sound
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

//if user clisk ok on alert, turn off sound
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        [self.alarmPlayer stop];
    }
    self.hourTextfield.text = @"";
    self.minuteTextfield.text = @"";
}

//turn off keyboard if tap outside of text view
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

@end
