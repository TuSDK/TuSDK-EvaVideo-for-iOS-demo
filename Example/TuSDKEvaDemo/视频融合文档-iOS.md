# 视频融合文档 - iOS

### 此次更新及注意事项
#### 兼容Alpha通道视频（即mask视频特效）

- API 代码
```objective-c
// 00 查看模板是否支持通道视频添加
// 模板类：TuSDKEvaTemplate下的imageAssetManager属性下，有个API
- (BOOL)canAddMaskVideo;

// 如果为true，即可调用下面的API进行添加
- (void)addMaskVideo:(NSURL *)maskVideoUrl;
```

- API示例
在类 EVAPreviewViewController 中
```objective-c
TuSDKEvaTemplate *evaTemplate ···
// 添加mask视频，视频文件名称和模板名称对应
if ([evaTemplate.imageAssetManager canAddMaskVideo]) {
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_fileName ofType:@"mp4"]];
    [evaTemplate.imageAssetManager addMaskVideo:url];
}

```

- API注意事项
**替换时机，需要在模板对象创建后，播放前进行替换**


#### TuSDKEvaTemplate创建时注意事项
在模板对象创建后，需要查看是否为空，如果为nil，不能进行下一步操作
此调整是为了兼容传入的模板路径无效的情况，路径无效，模板会创建失败，避免后面的操作造成的crash
示例代码：在类 EVAPreviewViewController 中
```objective-c
TuSDKEvaTemplate *evaTemplate = [TuSDKEvaTemplate initWithEvaBundlePath:_evaPath];
if (evaTemplate == nil) {
    [[TuSDK shared].messageHub showError:@"  模板有误   "];
    if (self.loadTempleError) {
        self.loadTempleError();
    }
    return;
}
```


### 库与资源依赖

#### 库依赖

- TuSDK.framework
- TuSDKVideo.framework
- libyuv.framework
- TuSDKEva.framework

#### 系统库依赖
- libresolv.tbd
- libiconv.tbd


#### 资源依赖

- TuSDK.bundle文件 (权限认证在这里，需要开通对应的[权限]([https://tutucloud.com](https://tutucloud.com/))，导出拥有使用权限的包)



### 初始化

- 头文件引入

需要在使用功能的类中导入`#import "TuSDKFramework.h"`, 此文件可以从Demo中拿到，或者直接自己写一个引用文件，进行依赖

- 初始化SDK

在引用`#import "TuSDKFramework.h"`的`.m`文件中，需要将后缀改成`.mm`
在`AppDelegate.mm`中的`didFinishLaunchingWithOptions`方法中初始化SDK

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [TuSDK initSdkWithAppKey:@"8d0ad6cca31401a7-04-ewdjn1"];
    // 可选: 设置日志输出级别 (默认不输出)
    [TuSDK setLogLevel:lsqLogLevelDEBUG];
    return YES;
}
```



### 使用

#### 模板加载

模板加载使用的是`TuSDKEvaTemplate`类，这个类管理了模板资源的所有API。
- 模板加载
```objective-c

/**
根据 evaBundlePath 初始化

evaBundlePath 资源路径
@since v1.0.0
*/
+ (instancetype)initWithEvaBundlePath:(NSString *)evaBundlePath;

```

- 模板配置选项
加载好模板`TuSDKEvaTemplate`后，可以通过配置对其进行限制。
```objective-c
/**
模板配置选项

@since v1.0.0
*/
@property (nonatomic, strong) TuSDKEvaTemplateOptions *options;
```
目前支持的选项配置有两个，一个是可替换的最大视频数量，另一个是模板中加载图片时的压缩比(紧限于对源模板中的图片进行压缩)
具体参数如下：
```objective-c
/**
AE 模板 选项
@since v1.0.0
*/
@interface TuSDKEvaTemplateOptions : NSObject

/**
视频可替换的最大数量, 默认9个

@since v1.0.0
*/
@property (nonatomic, assign) NSInteger replaceMaxVideoCount;

// 注意，这个API已经剔除了，不再使用
/**
图片渲染时图片的压缩比，用于适配低配置的手机尤其是6p及以下，默认是1.0

@since v1.0.0
*/
@property (nonatomic, assign) float scale;

@end
```


#### 模板播放

资源加载完后需要进行播放预览，这个的API在类`TuSDKEvaPlayer`中，只需要将上一步执行完后获取的`TuSDKEvaTemplate`对方放进来即可。

- 播放器初始化API

```objective-c
/**
初始化

@param evaTemplate AE 模板
@return TuSDKEvaPlayer
@since v1.0.0
*/
- (instancetype)initWithEvaTemplate:(TuSDKEvaTemplate *)evaTemplate inHolderView:(UIView *)holderView;
```

- 播放器加载代理回调
加载代理设置API
```objective-c
/**
EvaPlayer 加载资源事件委托
@since     v1.0.0
*/
@property (nonatomic,weak) id<TuSDKEvaPlayerLoadDelegate> _Nullable loadDelegate;
```

代理回调API
```objective-c
@protocol TuSDKEvaPlayerLoadDelegate <NSObject>

/**
进度改变事件

@param player 当前播放器
@param percent (0 - 1)
@since v1.0.0
*/
- (void)evaPlayer:(TuSDKEvaPlayer *_Nonnull)player loadProgressChanged:(CGFloat)percent;

/**
播放器状态改变事件

@param player 当前播放器
@param status 当前播放器状态
@since      v1.0.0
*/
- (void)evaPlayer:(TuSDKEvaPlayer *_Nonnull)player loadStatusChanged:(TuSDKMediaPlayerLoadStatus)status;

@end
```

- 播放器状态控制API

```objective-c
/**
加载播放器
@since  v3.0
*/
- (void)load; // 需要在初始化播放器后进行调研

/**
* 开始播放
* @since  v3.0
*/
- (void)play;

/**
* 暂停播放
* @since  v3.0
*/
- (void)pause;

/**
* 停止播放
* @since  v3.0
*/
- (void)stop;

/**
* 将当前回放时间设置为指定的时间
* @since  v3.0
*/
- (void)seekToTime:(CMTime)outputTime;

```

- 播放器播放状态进度回调
播放进度代理设置API
```objective-c
/**
EvaPlayer 事件委托
@since     v1.0.0
*/
@property (nonatomic,weak) id<TuSDKEvaPlayerDelegate> _Nullable delegate;


```
播放进度代理回调
```objective-c
#pragma mark TuSDKEvaPlayerDelegate

@protocol TuSDKEvaPlayerDelegate <NSObject>

@required

/**
进度改变事件

@param player 当前播放器
@param percent (0 - 1)
@param outputTime 当前帧所在持续时间
@since v1.0.0
*/
- (void)evaPlayer:(TuSDKEvaPlayer *_Nonnull)player progressChanged:(CGFloat)percent outputTime:(CMTime)outputTime;

/**
播放器状态改变事件

@param player 当前播放器
@param status 当前播放器状态
@since      v1.0.0
*/
- (void)evaPlayer:(TuSDKEvaPlayer *_Nonnull)player statusChanged:(TuSDKMediaPlayerStatus)status;

@end
```


- 重新加载模板
如果模板资源被替换了，想要预览，或者模板资源被替换后又重置回初始状态，那这个API就很有用。

```objective-c
/**
重新加载模板.
如果替换了模板内容需要调用 reloadTemplate 重新加载模板内容
@since  v1.0.0
*/
- (void)reloadTemplate;

```


- 播放器代理回调API

```objective-c
/**
进度改变事件

@param player 当前播放器
@param percent (0 - 1)
@param outputTime 当前帧所在持续时间
@since v1.0.0
*/
- (void)evaPlayer:(TuSDKEvaPlayer *_Nonnull)player progressChanged:(CGFloat)percent outputTime:(CMTime)outputTime;

/**
播放器状态改变事件

@param player 当前播放器
@param status 当前播放器状态
@since      v1.0.0
*/
- (void)evaPlayer:(TuSDKEvaPlayer *_Nonnull)player statusChanged:(TuSDKMediaPlayerStatus)status;
```

具体的使用可以查看Demo中对API的调用，更多其他功能，可以查看SDK中头文件中暴露的API


#### 资源替换(重点)

前面模板加载的时候有提到`TuSDKEvaTemplate`类，这个类管理了模板的所有资源，所以资源替换也是通过它来实现的。

资源替换的步骤大致是三步：查看可替换的资源；选择替换的资源；生效替换的资源。具体使用如下

- 查看可替换的资源
可替换的资源分为四类：`文字资源`、`图片资源`、`视频资源`以及`音频资源`，在`TuSDKEvaTemplate`中分别通过三个管理器进行资源管理：`textAssetManager`、`imageAssetManager`、`audioAssetManager`，其中imageAssetManager管理着图片和视频。获取示例：

```objective-c
// 文字资源
texts = [NSMutableArray arrayWithArray:self.evaTemplate.textAssetManager.placeholderAssets];
// 图片/视频资源
medias = [NSMutableArray arrayWithArray:self.evaTemplate.imageAssetManager.placeholderAssets];
// 背景音乐资源
audios = [NSMutableArray arrayWithArray:self.evaTemplate.audioAssetManager.placeholderAssets];
```
在我们的Demo中，我们将其放在了一个数组中，并根据帧时间进行排序：
```objective-c
// 资源排序
_orgResources = [NSMutableArray array];
[_orgResources addObjectsFromArray:_evaTemplate.textAssetManager.placeholderAssets];
[_orgResources addObjectsFromArray:_evaTemplate.imageAssetManager.placeholderAssets];
[_orgResources sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    NSInteger start1 = 0.0, start2 = 0.0;
    if ([obj1 isKindOfClass:[TuSDKEvaImageAsset class]]) {
        TuSDKEvaImageAsset *image = (TuSDKEvaImageAsset *)obj1;
        start1 = image.inputEvaImageAssetPtr->startFrame;
    } else if ([obj1 isKindOfClass:[TuSDKEvaTextAsset class]]) {
        TuSDKEvaTextAsset *text = (TuSDKEvaTextAsset *)obj1;
        start1 = text.inputEvaTextAssetPtr->startFrame;
    }
    if ([obj2 isKindOfClass:[TuSDKEvaImageAsset class]]) {
        TuSDKEvaImageAsset *image = (TuSDKEvaImageAsset *)obj2;
        start2 = image.inputEvaImageAssetPtr->startFrame;
    } else if ([obj2 isKindOfClass:[TuSDKEvaTextAsset class]]) {
        TuSDKEvaTextAsset *text = (TuSDKEvaTextAsset *)obj2;
        start2 = text.inputEvaTextAssetPtr->startFrame;
    }
    return [[NSNumber numberWithInteger:start1] compare:[NSNumber numberWithInteger:start2]];
}];
```


- 选择替换的资源

通过上一步我们已经知道了可以被替换的资源，那么在选择替换资源上，选择要被替换资源的类型：文字、图片、视频或者音频（可参考Demo中的步骤）。准备好要替换的资源后，进入下一步。


- 资源替换，并生效
无论是文字、图片、视频还是音频资源，其对象中都有对应的API进行替换。


- 替换背景音乐(如果可以替换)

```objective-c
// 从TuSDKEvaTemplate中拿到背景音乐资源对象，替换掉里面的路径即可
audio.assetURL = [NSURL fileURLWithPath:self.selectedMusicPath];
```


- 替换文字

```objective-c
// 从TuSDKEvaTemplate中拿到文本信息, 
// text是上一步拿到的文本资源对象TuSDKEvaTextAsset，其有text的API
text.text = text;
```


- 替换图片或视频

```objective-c
// 从TuSDKEvaTemplate中拿到图片或视频资源对象，替换掉里面的路径即可
// image是上一步拿到的文本资源对象TuSDKEvaImageAsset，其有assetURL的API
image.assetURL = ((TuSDKEvaImageAsset *)self->_originImages[idx]).assetURL;
```

- 替换后效果预览

之前介绍过资源的播放，这里再简单介绍下资源替换后的预览播放，调用下面的API即可：

```objective-c
// _evaTemplate 是重新创建的，里面的资源也被替换过的
[_evaPlayer reloadTemplate];
```

- 替换后重置
替换资源后不满意需要重置回初始化状态，可用以下API

将所有占位资源重置回原始状态
```objective-c
/**
重置模板占位资源
@since v1.0.0
*/
- (void)resetTemplate;

```
将部分资源重置回原始状态，分别在`TuSDKEvaTextAssetManager`、`TuSDKEvaImageAssetManager`、`TuSDKEvaAudioAssetManager`
```objective-c
/**
还原占位资源，放弃修改项
@since v1.0.0
*/
- (void)resetPlaceholderAssets;
```
可以通过`template`中的`imageAssetManager`、`textAssetManager`、`audioAssetManager`进行单个设置。


#### 视频导出

替换后，预览没问题后，如果想要导出成视频，可用`TuSDKEvaExportSession`这个类API实现。

- 导出视频类的创建

```objective-c
/**
初始化

@param evaTemplate AE 模板
@return TuSDKEvaExportSession
@since v1.0.0
*/
- (instancetype)initWithEvaTemplate:(TuSDKEvaTemplate *)evaTemplate exportOutputSettings:(nullable TuSDKEvaExportSessionSettings * )exportOutputSettings;
```



- 导出视频类的配置(配置导出后的视频格式等信息)

```objective-c
// 导出配置
TuSDKEvaExportSessionSettings *exportSettings = [[TuSDKEvaExportSessionSettings alloc] init];
// 输出路径
//    exportSettings.outputURL
// 是否保存到相册 -- 默认YES
exportSettings.saveToAlbum = YES;
// 导出视频的尺寸
//    exportSettings.outputSize = CGSizeMake(720, 1280);

// 导出视频的质量
//    exportSettings.outputFileType = lsqFileTypeQuickTimeMovie;

// 导出文件类型
//    exportSettings.outputVideoQuality =

// 设置水印
exportSettings.waterMarkImage = [UIImage imageNamed:@"sample_watermark"];
exportSettings.waterMarkPosition = lsqWaterMarkTopRight;

_session = [[TuSDKEvaExportSession alloc] initWithEvaTemplate:_evaTemplate exportOutputSettings:exportSettings];

```



- 导出视频类的代理信息(监听导出的进度和状态)

```objective-c
#pragma mark - 导出
/**
进度改变事件

@param exportSession TuSDKEvaExportSession
@param percent (0 - 1)
@param outputTime 当前帧所在持续时间
@since      v1.0.0
*/
- (void)mediaEvaExportSession:(TuSDKEvaExportSession *_Nonnull)exportSession progressChanged:(CGFloat)percent outputTime:(CMTime)outputTime;{
    [[TuSDK shared].messageHub showProgress:percent status:[NSString stringWithFormat:@"正在导出 %.0f%%",percent*100]];
}

/**
播放器状态改变事件

@param exportSession 当前
@param status 当前导出状态
@since      v1.0.0
*/
- (void)mediaEvaExportSession:(TuSDKEvaExportSession *_Nonnull)exportSession statusChanged:(TuSDKMediaExportSessionStatus)status;{
    switch (status) {
        case TuSDKMediaExportSessionStatusCancelled:
        _saving = NO;
        [[TuSDK shared].messageHub showError:@"已取消导出"];
        break;
        case TuSDKMediaExportSessionStatusFailed:
        _saving = NO;
        [[TuSDK shared].messageHub showError:@"导出失败"];
        break;
        case TuSDKMediaExportSessionStatusCompleted:
        _saving = NO;
        [[TuSDK shared].messageHub showSuccess:@"导出完成"];
        break;
        case TuSDKMediaExportSessionStatusUnknown:
        _saving = NO;
        [[TuSDK shared].messageHub dismiss];
        default:
        break;
    }
}
```


### 播放器释放
建议在控制器的`dealloc`方法中进行播放器的暂停和释放：
```objective-c
if (_evaPlayer) {
    [_evaPlayer stop];
    [_evaPlayer destory];
    self.evaPlayer = nil;
}
```


### 其他

- 使用前需要先获取权限，拿到与bundle ID 一致的授权Key和TuSDK.bundle资源
- Demo中的zip资源包不可用于商用，有版权约束的
- zip资源包的生成请看对应的文档
- 其他更详细的API请看SDK中头文件中的API
- 如果报`memory not found`，将引入`TuSDKFramework.h`或直接引入了`#import <TuSDKEva/TuSDKEva.h>`的文件后缀改成`.mm`即可


