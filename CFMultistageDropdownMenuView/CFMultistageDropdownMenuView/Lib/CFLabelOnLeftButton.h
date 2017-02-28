//
//  CFLabelOnLeftButton.h
//  CFDropDownMenuView
//
//  Created by Peak on 17/2/28.
//  Copyright © 2017年 Peak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFLabelOnLeftButton : UIButton

+ (instancetype)createButtonWithImageName:(NSString *)imgName title:(NSString *)title titleColor:(UIColor *)titleColor frame:(CGRect)btnFrame target:(id)target action:(SEL)action;

@end
