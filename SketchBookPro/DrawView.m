//
//  DrawView.m
//  SketchBookPro
//
//  Created by Janae on 15/12/18.
//  Copyright © 2015年 zhiyuan. All rights reserved.
//

#import "DrawView.h"
#import "ColorPaletteView.h"
#import "LineEntity.h"
#import "TLKSocketIOSignaling.h"
#import "TLKMediaStream.h"
#import "RTCMediaStream.h"
#import "RTCEAGLVideoView.h"
#import "RTCVideoTrack.h"
@implementation DrawView()<TLKSocketIOSignalingDelegate>

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self dataSourceInitializetion];
        [self UILayout];
    }
    return self;
}

- (void)dataSourceInitializetion
{
    _drawLines = [[NSMutableArray alloc]init];

}

- (void)UILayout
{
    _colorPaletteView = [[ColorPaletteView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-140, CGRectGetWidth(self.frame), 140)];
    [self addSubview:_colorPaletteView];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    int wCount = (int)[_drawLines count];
    for (int i = 0; i < wCount; i++) {
        LineEntity * line = [_drawLines objectAtIndex:i];
        UIColor * rColor = [line color];
        
        CGContextSetStrokeColorWithColor(context, [rColor CGColor]);
        CGContextSetLineWidth(context, [line width]);
        
        int points = (int)[line.points count];
        for (int j = 0; j < points - 1; j++) {
            CGPoint p1 = [(NSValue *)[line.points objectAtIndex:j]CGPointValue];
            CGPoint p2 = [[line.points objectAtIndex:j + 1]CGPointValue];
            CGContextMoveToPoint(context, p1.x, p1.y);
            CGContextAddLineToPoint(context, p2.x, p2.y);
        }
        CGContextStrokePath(context);
    }
    
}
- (void)romoveClean:(id)sender{
    [_drawLines removeLastObject];
    [self setNeedsDisplay];
}

- (void)romoveLine:(id)sender{
    [_drawLines removeAllObjects];
    [self setNeedsDisplay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    LineEntity * line = [[LineEntity alloc] initWithColor:_colorPaletteView.seletedColor width:_colorPaletteView.seletedWidth];
    [_drawLines addObject:line];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    LineEntity * line = [_drawLines lastObject];
    
    UITouch * aTouch = [touches anyObject];
    CGPoint aPoint = [aTouch locationInView:self];
    NSValue * vPoint = [NSValue valueWithCGPoint:aPoint];
    [line.points addObject:vPoint];
    [self setNeedsDisplay];
    
}

#pragma mark - TLKSocketIOSignalingDelegate

- (void)socketIOSignaling:(TLKSocketIOSignaling *)socketIOSignaling addedStream:(TLKMediaStream *)stream {
    NSLog(@"addedStream");

    RTCVideoTrack *remoteVideoTrack = stream.stream.videoTracks[0];

    if(self.remoteVideoTrack) {
        [self.remoteVideoTrack removeRenderer:self.remoteView];
        self.remoteVideoTrack = nil;
        [self.remoteView renderFrame:nil];
    }
    
    self.remoteVideoTrack = remoteVideoTrack;
    [self.remoteVideoTrack addRenderer:self.remoteView];

}

-(void)serverRequiresPassword:(TLKSocketIOSignaling*)server{
    NSLog(@"serverRequiresPassword");
}
-(void)removedStream:(TLKMediaStream*)stream{
    NSLog(@"removedStream");
}
-(void)peer:(NSString*)peer toggledAudioMute:(BOOL)mute{
    NSLog(@"toggledAudioMute");
}
-(void)peer:(NSString*)peer toggledVideoMute:(BOOL)mute{
    NSLog(@"toggledVideoMute");
}
-(void)lockChange:(BOOL)locked{
    NSLog(@"locked");
}

@end
