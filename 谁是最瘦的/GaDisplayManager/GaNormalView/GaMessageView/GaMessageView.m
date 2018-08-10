//
//  GaMessageView.m
//  GaDisplayManagerDemo
//
//  Created by GikkiAres on 2018/5/31.
//  Copyright © 2018 GikkiAres. All rights reserved.
//

#import "GaMessageView.h"
#import "GaMessageLayer.h"
#import "UIView+GaUtility.h"

@implementation GaMessageView

+ (instancetype)messageViewWithMessage:(NSString *)message andFontSize:(CGFloat)fontSize{
    
    //layer显示的字体
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    //文字框和实际边框的边距.
    CGFloat padding = 20;
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    
    NSDictionary *dicFontAttribute = @{
                                       NSFontAttributeName:font,
                                       NSParagraphStyleAttributeName:style
                                       };
    //计算的规则,就是首先看指定宽度的一行能不能装下,如果可以,返回一行的高度,和适合的宽度.
    //如果一行宽度大于指定宽度,那么一行放不下,返回的宽度是指定的宽度;
    CGRect rcText = [message boundingRectWithSize:CGSizeMake(200, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dicFontAttribute context:nil];
    
    CGRect boundsMessageView = CGRectMake(0, 0, rcText.size.width+padding*2, rcText.size.height+padding*2);
    
    GaMessageView *messageView = [[GaMessageView alloc]initWithFrame:boundsMessageView];
    //创建的view默认是黑色的.
    messageView.backgroundColor = [UIColor blackColor];
    //0.7的透明度,看起来效果好.,为什么设置alpha没用,设置颜色的alpha才有用呢.
    //    messageView.alpha = 0.2;

    
//    CALayer *layerBackground = [CALayer layer];
//    layerBackground.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4].CGColor;
//    layerBackground.frame = boundsMessageView;
//    [messageView.layer addSublayer:layerBackground];
    
    
    
    GaMessageLayer *messageLayer = [GaMessageLayer layer];
    messageLayer.frame = rcText;
    messageLayer.backgroundColor = [UIColor clearColor].CGColor;
    messageLayer.position = messageView.selfCenter;
    [messageView.layer addSublayer:messageLayer];
    
//    CABasicAnimation *cAnimation = [CABasicAnimation animationWithKeyPath:@"title"];
//    cAnimation.duration = 0.001;
//    cAnimation.toValue = message;
//    [messageLayer addAnimation:cAnimation forKey:@"captionAnimation"];
    


    
    //新建的layer要display才能刷新显示.
    messageLayer.title = message;
    messageLayer.font = font;
    //立即调用layer的drawInContext方法来进行绘制文字.
    [messageLayer display];

    
    
    

    return messageView;
}



@end
