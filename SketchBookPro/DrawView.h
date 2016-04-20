//
//  DrawView.h
//  SketchBookPro
//
//  Created by Janae on 15/12/18.
//  Copyright © 2015年 zhiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorPaletteView;
@interface DrawView : UIView<TLKSocketIOSignalingDelegate>
{
    NSMutableArray * _drawLines;
    ColorPaletteView * _colorPaletteView;
}
@property (strong, nonatomic) IBOutlet RTCEAGLVideoView *remoteView;
@property (strong, nonatomic) IBOutlet UIView *localView;
@property (strong, nonatomic) RTCVideoTrack *localVideoTrack;
@property (strong, nonatomic) RTCVideoTrack *remoteVideoTrack;
@end
