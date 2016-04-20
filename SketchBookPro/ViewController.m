//
//  ViewController.m
//  SketchBookPro
//
//  Created by Baiping on 20/04/2016.
//  Copyright © Baiping Yang. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"

#import "TLKSocketIOSignaling.h"
#import "TLKMediaStream.h"
#import "RTCMediaStream.h"
#import "RTCEAGLVideoView.h"
#import "RTCVideoTrack.h"
#import "RTCAVFoundationVideoSource.h"

@interface ViewController () <RTCEAGLVideoViewDelegate>

@property (strong, nonatomic) TLKSocketIOSignaling* signaling;


@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    DrawView * aView = [[DrawView alloc]initWithFrame:CGRectMake(0, 50,  CGRectGetWidth(self.view.frame), [self.view bounds].size.height-50)];
    [aView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:aView];
    
    CGRect rect1 = CGRectMake(10, 20, 30, 30);
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setFrame:rect1];
    [self.view addSubview:button1];
    [button1 setTitle:@"Undo" forState:UIControlStateNormal];
    [button1 addTarget:aView action:@selector(romoveClean:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rect2 = CGRectMake(CGRectGetWidth(self.view.frame)-40, 20, 30, 30);
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setFrame:rect2];
    [self.view addSubview:button2];
    [button2 setTitle:@"Clear" forState:UIControlStateNormal];
    [button2 addTarget:aView action:@selector(romoveLine:) forControlEvents:UIControlEventTouchUpInside];
	
	
	self.signaling = [[TLKSocketIOSignaling alloc] initWithVideo:YES];
    //TLKSocketIOSignalingDelegate provides signaling notifications
    self.signaling.delegate = aView;
    [self.signaling connectToServer:@"signaling.simplewebrtc.com" port:80 secure:NO success:^{
        [self.signaling joinRoom:@"ios-demo" success:^{
            NSLog(@"join success");
        } failure:^{
            NSLog(@"join failure");
        }];
        NSLog(@"connect success");
    } failure:^(NSError* error) {
        NSLog(@"connect failure");
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - RTCEAGLVideoViewDelegate

-(void)videoView:(RTCEAGLVideoView *)videoView didChangeVideoSize:(CGSize)size {
    NSLog(@"videoView ?");
}

@end
