//
//  GaMessageView.h
//  GaDisplayManagerDemo
//
//  Created by GikkiAres on 2018/5/31.
//  Copyright © 2018 GikkiAres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GaMessageLayer.h"

@interface GaMessageView : UIView

////layer要显示的title文字
//@property (nonatomic,strong)NSString *title;
////layer显示的字体
//@property (nonatomic,strong) UIFont *font;
////文字刚好的大小与实际显示大小的边距.
//@property (nonatomic,assign) CGFloat padding;

+ (instancetype)messageViewWithMessage:(NSString *)message andFontSize:(CGFloat)fontSize;
@end
