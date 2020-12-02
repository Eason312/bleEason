//
//  WelcomeView.m
//  weiboPlusSignDemo
//
//  Created by 李小强 on 2017/4/19.
//  Copyright © 2017年 李小强. All rights reserved.
//

#import "WelcomeView.h"


@interface WelcomeView ()
@property (weak, nonatomic) IBOutlet UIImageView *weiboImage;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end


@implementation WelcomeView
+ (instancetype)weicomeView{
    return [[NSBundle mainBundle] loadNibNamed:@"WelcomeView" owner:nil options:nil][0];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    self.image.hidden =YES;
    self.label.hidden = YES;
    
    self.image.transform = CGAffineTransformMakeTranslation(0, 50);
    [UIView animateWithDuration:0 animations:^{
        self.weiboImage.alpha = 0;
    } completion:^(BOOL finished) {
        self.image.hidden = NO;
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.image.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            _label.alpha = 0;
            _label.hidden = NO;
            // 文字慢慢显示
            
            [UIView animateWithDuration:3 animations:^{
                _label.alpha = 1;
                
            } completion:^(BOOL finished) {
                
                [self removeFromSuperview];
                
            }];
            
        }];
        
    }];

}
@end
