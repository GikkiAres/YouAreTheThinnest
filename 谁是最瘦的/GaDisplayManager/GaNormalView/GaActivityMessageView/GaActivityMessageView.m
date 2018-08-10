//
//  GaActivityView.m
//  GaDisplayManagerDemo
//
//  Created by GikkiAres on 2018/6/1.
//  Copyright © 2018 GikkiAres. All rights reserved.
//

#import "GaActivityMessageView.h"
#import "GaMessageLayer.h"

@implementation GaActivityMessageView


//ActivityView是最底层的总体view
//activity就是那个转圈东西.
+ (instancetype)activityMessageViewWithMessage:(NSString *)message andFontSize:(CGFloat)fontSize{
    
    //layer显示的字体
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    //文字框和实际边框的边距.
    CGFloat padding = 20;
    //文字和转圈的间距
    CGFloat spacing = 0;
    CGFloat widthActivity = 70;


    
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
    
    CGFloat widthActivityView = rcText.size.width+2*padding;
    CGFloat heightActivityView = rcText.size.height+widthActivity+2*padding+spacing;
    
    CGRect boundsActivityView = CGRectMake(0, 0, widthActivityView, heightActivityView);
    
    GaActivityMessageView *activityView = [[GaActivityMessageView alloc]initWithFrame:boundsActivityView];
    //创建的view默认是黑色的.
    activityView.backgroundColor = [UIColor blackColor];
    
    
    //indicator view
      UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0,widthActivity, widthActivity)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.frame = CGRectMake((widthActivityView-widthActivity)*0.5, padding, widthActivity, widthActivity);
    [indicator startAnimating];
    [activityView addSubview:indicator];
    
    //message
    GaMessageLayer *messageLayer = [GaMessageLayer layer];
    messageLayer.frame = rcText;
    
    messageLayer.position = CGPointMake(widthActivityView/2, padding+widthActivity+spacing+rcText.size.height/2);
    
    [activityView.layer addSublayer:messageLayer];
    
    //新建的layer要display才能刷新显示.
    messageLayer.title = message;
    messageLayer.font = font;
    
//    messageLayer.backgroundColor = [UIColor greenColor].CGColor;
    //立即调用layer的drawInContext方法来进行绘制文字.
    [messageLayer display];
    
    return activityView;
}



@end
