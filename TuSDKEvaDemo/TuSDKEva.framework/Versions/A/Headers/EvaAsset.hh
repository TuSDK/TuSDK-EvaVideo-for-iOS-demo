#ifndef EVAASSET_HH
#define EVAASSET_HH
/********************************************************
	* @file		: EvaAsset.hh	
	* @project	: Evanimation
	* @author	: Clear	
	* @date		: 2019-7-5 20:07:49
	* @brief	: 
	* @details	: 
*********************************************************/

#include <cstdio>
#include <functional>
#include <iostream>
#include <map>
#include <memory>
#include <stdint.h>
#include <string>
#include <vector>

struct SkRect;

namespace tutu
{
	class EvaAsset
	{
	public:
		// 所属层名称
		std::string name;
		// 开始帧
		float startFrame{ -1.0f };
		// 结束关键帧
		float endFrame{ -1.0f };
	};

	typedef std::shared_ptr<EvaAsset> EvaAssetPtr;

	//////////////////////////////////////////////////////////////////////////

	// 图片资源
	class EvaImageAsset : public EvaAsset
	{
	public:
		// 图片的宽度
		uint32_t width{ 0 };
		// 图片的高度
		uint32_t height{ 0 };
		// 图片唯一识别的id，图层获取图片的标识
		std::string fid;
		// 图片的名称 例：img_0.png
		std::string fileName;
		// 图片的路径，实际并未使用 例：images/
		std::string dirName;
	public:
		std::string toString();
	};

	// 图片资源
	typedef std::shared_ptr<EvaImageAsset> EvaImageAssetPtr;

	//////////////////////////////////////////////////////////////////////////

	// 音频资源
	class EvaAudioAsset : public EvaAsset
	{
	public:
		// 音频唯一识别的id，图层获取音频的标识
		std::string fid;
		// 音频的名称 例：img_0.png
		std::string fileName;
		// 音频的路径，实际并未使用 例：audios/
		std::string dirName;
		// 播放时长 秒
		double duration{ 0.0f };
	public:
		std::string toString();

	};

	// 音频资源
	typedef std::shared_ptr<EvaAudioAsset> EvaAudioAssetPtr;

	//////////////////////////////////////////////////////////////////////////

	// 文字对齐方式
	enum class EvaJustification {
		kLEFT_ALIGN,			// 0 左对齐
		kRIGHT_ALIGN,			// 1 右对齐
		kCENTER,				// 2 居中对齐
		kFULL_LASTLINE_LEFT,	// 3 最后一行左对齐
		kFULL_LASTLINE_RIGHT,	// 4 最后一行右对齐
		kFULL_LASTLINE_CENTER,	// 5 最后一行居中对齐
		kFULL_LASTLINE_FULL		// 6 两端对齐
	};

	// 文字数据
	class EvaDocumentData : public EvaAsset
	{
	public:
		// 文本
		std::wstring text;
		// 字体名称
		std::string fontName;
		// 字号
		double size = 0;
		// 文字对齐方式
		tutu::EvaJustification justification = tutu::EvaJustification::kLEFT_ALIGN;
		// 字间距
		int tracking = 0;
		// 行高
		double lineHeight = 0;
		// 基线
		double baselineShift = 0;
		// 颜色
		uint32_t color = 0;
		// 描边颜色
		uint32_t strokeColor = 0;
		// 描边宽
		double strokeWidth = 0;
		// 是否填充描边
		bool strokeOverFill = false;
		// 文字范围
		std::shared_ptr<SkRect> boxText;
	};

	// 文字数据
	typedef std::shared_ptr<EvaDocumentData> EvaDocumentDataPtr;
}

#endif // !EVAASSET_HH

