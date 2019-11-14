
### 核心接口

核心的接口类说明如下

接口类名 | 功能 | 备注 
:-- | :-- | :-- 
TuSDKEvaTemplate | 负责EVA模板的加载 | 预览、资源替换、导出等 
TuSDKEvaPlayer | 负责EVA模板的播放| 无替换、替换资源后的预览 
TuSDKEvaExportSession | 负责EVA模板的导出 | 无替换、替换资源后导出视频 
TuSDKEvaImageAssetManager | 负责EVA模板中的图片、视频导资源管理| 可替换 
TuSDKEvaTextAssetManager | 负责EVA模板中的文字资源管理| 可替换
TuSDKEvaAudioAssetManager | 负责EVA模板中的音频资源管理| 目前只支持一个背景音乐
TuSDKEvaFontAssetManager | 负责EVA模板中的字体资源管理| 目前不支持替换
TuSDKEvaImageAsset | 承载EVA模板中的单个图片/视频资源| 多个，TuSDKEvaImageAssetManager管理
TuSDKEvaTextAsset | 承载EVA模板导中的单个文字资源| 多个，由TuSDKEvaTextAssetManager管理
TuSDKEvaAudioAsset | 承载EVA模板中的单个音频资源| 一个，TuSDKEvaAudioAssetManager


