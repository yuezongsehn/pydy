//
//  YPutPictureView.h
//  shopsN
//
//  Created by imac on 2016/12/8.
//  Copyright © 2016年 联系QQ:1084356436. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YPutPictureViewDelegate <NSObject>

-(void)addPhoto;

@end

@interface YPutPictureView : UIView

@property (strong,nonatomic) NSMutableArray *imageArr;

@property (weak,nonatomic) id<YPutPictureViewDelegate>delegate;

@end
