//
//  GaActivityView.h
//  GaDisplayManagerDemo
//
//  Created by GikkiAres on 2018/6/1.
//  Copyright © 2018 GikkiAres. All rights reserved.
//

#import <UIKit/UIKit.h>

//上面是Activity下面是Message的view.
@interface GaActivityMessageView : UIView

+ (instancetype)activityMessageViewWithMessage:(NSString *)message andFontSize:(CGFloat)fontSize;

@end
