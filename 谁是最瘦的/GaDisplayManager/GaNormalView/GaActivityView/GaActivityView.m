//
//  GaActivityView.m
//  GaDisplayManagerDemo
//
//  Created by GikkiAres on 2018/6/1.
//  Copyright © 2018 GikkiAres. All rights reserved.
//

#import "GaActivityView.h"
#import "GaMessageLayer.h"
#import "UIView+GaUtility.h"

@implementation GaActivityView

//ActivityView是最底层的总体view
//activity就是那个转圈东西.
+ (instancetype)activityView{
    
    //文字框和实际边框的边距.
    CGFloat padding = 20;
    
    CGFloat widthActivity = 70;

    
    CGFloat widthActivityView = widthActivity+2*padding;

    CGRect boundsActivityView = CGRectMake(0, 0, widthActivityView, widthActivityView);
    
    GaActivityView *activityView = [[GaActivityView alloc]initWithFrame:boundsActivityView];
    
    //创建的view默认是黑色的.
    activityView.backgroundColor = [UIColor blackColor];
    
    
    //indicator view
      UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0,widthActivity, widthActivity)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = activityView.selfCenter;
    [indicator startAnimating];
    [activityView addSubview:indicator];
    
    return activityView;
}



@end
