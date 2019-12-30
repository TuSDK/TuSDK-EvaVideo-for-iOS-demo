//
//  TuSDKEvaMediaAsset.h
//  TuSDKEva
//
//  Created by KK on 2019/12/16.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "EvaAsset.hh"

NS_ASSUME_NONNULL_BEGIN
@class TuSDKEvaTemplate;

/**
 资源类型
 @since v1.2.2
 */
typedef enum TuSDKEvaMediaAssetType: NSUInteger {
    TuSDKEvaMediaAssetTypeUNKnown = 0, // 未知
    TuSDKEvaMediaAssetTypeImage, // 图片资源
    TuSDKEvaMediaAssetTypeVideo, // 视频
} TuSDKEvaMediaAssetType;

@interface TuSDKEvaMediaAsset : NSObject

/**
资源初始化
@param evaImageAsset 图片资源
@since v1.2.2
*/
- (instancetype)initWithImageAsset:(tutu::EvaImageAssetPtr)evaImageAsset evaTemplate:(TuSDKEvaTemplate *)evaTemplate;


/**
资源初始化
@param evaVideoAsset 视频资源
@since v1.2.2
*/
- (instancetype)initWithVideoAsset:(tutu::EvaVideoAssetPtr)evaVideoAsset evaTemplate:(TuSDKEvaTemplate *)evaTemplate;

/**
 开始帧
 @since v1.2.2
 */
@property (nonatomic, assign) int startFrame;

/**
 结束帧
 @since v1.2.2
 */
@property (nonatomic, assign) int endFrame;

/**
 宽度
 @since v1.2.2
 */
@property (nonatomic, assign) int width;

/**
 高度
 @since v1.2.2
 */
@property (nonatomic, assign) int height;

/**
 时长
 @since v1.2.2
 */
@property (nonatomic, assign) double duration;

/**
 视频资源的开始时间
 @since v1.2.2
 */
@property (nonatomic, assign) double videoStart;

/**
 属性名称
 @since v1.2.2
 */
@property (nonatomic, strong) NSString *name;

/**
 唯一标识
 @since v1.2.2
 */
@property (nonatomic, strong) NSString *fid;

/**
 文件名称
 @since v1.2.2
 */
@property (nonatomic, strong) NSString *fileName;

/**
 路径名称
 @since v1.2.2
 */
@property (nonatomic, strong) NSString *dirName;


/**
 默认资源类型
 @since v1.2.2
 */
@property (nonatomic, assign, readonly) TuSDKEvaMediaAssetType defaultMediaType;

/**
 默认的视频文字路径, 只有视频才有
 @since v1.2.2
 */
@property (nonatomic, strong, readonly) NSURL *defaultVideoPath;

@end

NS_ASSUME_NONNULL_END
