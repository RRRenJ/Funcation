//
//  JPFConfige.h
//  JPFuncationSDK
//
//  Created by 任敬 on 2021/11/3.
//

#ifndef JPFConfige_h
#define JPFConfige_h

#define JPF_SCR_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define JPF_SCR_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//状态栏高度
#define JPF_STATUS_HEIGHT  [UIApplication sharedApplication].statusBarFrame.size.height
//是否是刘海屏
#define JPF_IS_BANGSCREEN  JPF_STATUS_HEIGHT > 20.0f

#define JPF_NAVIGATION_HEIGHT  (JPF_STATUS_HEIGHT + 44.0f)

#define JPF_BOTTOM_HEIGHT (JPF_IS_BANGSCREEN ? 34.0f : 0.0f)

#define JPF_TABBAR_HEIGHT (JPF_BOTTOM_HEIGHT + 49.0f)

#endif /* JPFConfige_h */
