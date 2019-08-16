//
//  TuSDKEvaStatistics.h
//  TuSDKEva
//
//  Created by tutu on 2019/7/23.
//  Copyright © 2019 TuSdk. All rights reserved.
//

#ifndef TuSDKEvaStatistics_h
#define TuSDKEvaStatistics_h

typedef NS_ENUM(NSInteger, TuSDKEvaComponentType) {
    
    /**
     * 0x94  人脸融合库
     */
    
    /**
     * 加载模板
     */
    tkc_template_load = 0x950001,
    
    /**
     * 预览播放模板
     */
    tkc_template_preview = 0x950002,
    
    /**
     * 替换文字
     */
    tkc_replace_text = 0x950003,

    /**
     * 替换图片
     */
    tkc_replace_image = 0x950004,
    
    /**
     * 替换视频
     */
    tkc_replace_video = 0x950005,
    
    /**
     * 替换音乐
     */
    tkc_replace_music = 0x950006,
    
    /**
     * 替换图片/视频
     */
    tkc_replace_image_video = 0x950007,
    
    /**
     * 导出
     */
    tkc_export_video = 0x950008,

};


#endif /* TuSDKEvaStatistics_h */
