//
//  TuSDKEvaErrorCode.h
//  TuSDKEva
//
//  Created by sprint on 2020/1/8.
//  Copyright © 2020 TuSdk. All rights reserved.
//

#ifndef TuSDKEvaErrorCode_h
#define TuSDKEvaErrorCode_h

/// TuSDKEvaError
typedef NS_ENUM(NSUInteger, TuSDKEvaError)
{  
    /* 1010000 开头 权限错误码 */
    TuSDKEvaErrorPermisionNone = 1010000,       //无任何权限
    TuSDKEvaErrorPermisionLessImage,            //缺少支持形状图层
    TuSDKEvaErrorPermisionLessText,             //缺少支持文字图层
    TuSDKEvaErrorPermisionLessAudio,            //缺少支持音频图层
    TuSDKEvaErrorPermisionLessVideo,            //缺少支持视频图层
    TuSDKEvaErrorPermisionLessShape,            //缺少支持形状图层
    TuSDKEvaErrorPermisionLess3D,               //缺少支持3D变换
    TuSDKEvaErrorPermisionLessMask,             //缺少支持蒙版
    TuSDKEvaErrorPermisionLessEffect,           //缺少支持蒙版
    TuSDKEvaErrorPermisionLessBlendMode,        //缺少支持混合模式

    
    /* 1020000 开头 未知图层或者特效错误码 */
    TuSDKEvaErrorUnkownLayer = 1020000,        //未知的图层类型
    TuSDKEvaErrorUnkownEffect,                 //未知的特效
    TuSDKEvaErrorUnkownLayerStyle,             //未知的图层样式
};

#endif /* TuSDKEvaErrorCode_h */
