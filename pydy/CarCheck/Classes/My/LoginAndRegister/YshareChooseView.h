//
//  YshareChooseView.h
//  shopsN
//
//  Created by imac on 2016/12/5.
//  Copyright © 2016年 联系QQ:1084356436. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YshareChooseViewDelegate <NSObject>

-(void)chooseShare:(NSInteger)sender;

@end

@interface YshareChooseView : UIView

@property (weak,nonatomic) id<YshareChooseViewDelegate>delegate;

@end
