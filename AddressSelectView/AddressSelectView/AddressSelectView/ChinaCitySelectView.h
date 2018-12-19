//
//  ChinaCitySelectView.h
//  ChinaCitySelect
//
//  Created by 刘康蕤 on 2017/7/31.
//  Copyright © 2017年 lkr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChinaCitySelectView : UIView

@property (nonatomic,copy)void (^selectCityBlock)(NSString *address,NSString *regionId);
/**展示或关闭*/
-(void)popShowOrCloseView:(BOOL)isOpen;

@end
