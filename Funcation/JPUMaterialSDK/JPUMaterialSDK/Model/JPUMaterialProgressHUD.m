//
//  JPUMaterialProgressHUD.m
//  EditVideoText
//
//  Created by foundao on 2021/9/23.
//

#import "JPUMaterialProgressHUD.h"
#import "MBProgressHUD.h"
#import "JPUMaterialSingleton.h"
@interface JPUMaterialProgressHUD()
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,assign) BOOL  isLoading;//防止重复加载

@end
@implementation JPUMaterialProgressHUD
static JPUMaterialProgressHUD *singtle = nil;
+(instancetype)sharedHUD
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singtle = [[self alloc]init];
    });
    return singtle;
}

- (void)show
{
    
    if ( self.isLoading) {
        return;
    }
    self.isLoading = YES;
    [self initHUD];
        
}

- (void)initHUD
{
    UIView *view = [[UIApplication sharedApplication]keyWindow];
    self.hud = [MBProgressHUD showHUDAddedTo:view  animated:YES];
    self.hud.removeFromSuperViewOnHide = YES;
    self.hud.backgroundColor =[UIColor colorWithWhite:0.f alpha:.1f] ;
    
}

- (void)hide
{
    self.isLoading = NO;
    [self.hud hideAnimated:YES];
}


- (void)showHint:(NSString *)hintStr
{
        
    self.hud = [MBProgressHUD showHUDAddedTo: [[UIApplication sharedApplication]keyWindow] animated:YES];
    self.hud.bezelView.color =[[JPUMaterialSingleton singleton] jpu_material_colorWithHex:0x333333 alpha:1];
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.mode = MBProgressHUDModeText;
    self.hud.label.text = hintStr;
    self.hud.label.font =  [UIFont systemFontOfSize:12];
    self.hud.label.textColor = UIColor.whiteColor;
    self.hud.margin = 15;
    [self.hud hideAnimated:YES afterDelay:2];
    
}

- (void)showProgress:(NSString *)str
{
    if ( self.isLoading) {
        return;
    }
    
    [self initHUD];
    self.hud.label.text = str;
}

@end
