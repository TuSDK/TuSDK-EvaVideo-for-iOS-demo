#ifndef EVA_FONT_HH
#define EVA_FONT_HH

#include <memory>
#include <iostream>
#include <cstdio>
#include <stdint.h>
#include <string>
#include <map>
#include <vector>

namespace tutu
{
	class EvaShapeGroup;

	// 字体
	class EvaFontInfo
	{
	public:
		// 字体样式
		enum TypeStyle
		{
			NORMAL,
			BOLD,
			ITALIC,
			BOLD_ITALIC
		};
	public:
		// 字体
		std::string family;
		// 名称
		std::string name;
		// 样式
		TypeStyle style{ NORMAL };
		// 字体文件名称 例：方正行楷_GBK.ttf
		std::string fileName;
		// 字体文件 例：images/
		std::string dirName;
		// 字高
		float ascent{ 0.0f };
	};

	// 字体
	typedef std::shared_ptr<EvaFontInfo> EvaFontInfoPtr;

	/***********************************************************/
	// 文字转曲形状对象
	class EvaFontCharacter
	{
	public:
		// 形状组
		std::vector<std::shared_ptr<EvaShapeGroup>> shapes;
		// 字符
		std::wstring character;
		// 大小
		double size{ 0 };
		// 宽度
		double width{ 0 };
		// 样式
		EvaFontInfo::TypeStyle style{ EvaFontInfo::NORMAL };
		// 字体
		std::string fontFamily;
		// 计算Hash
		size_t hashCode();
	public:
		// 计算Hash
		static size_t hashFor(const std::wstring& character, const std::string& fontFamily, EvaFontInfo::TypeStyle style);
	};

	// 文字
	typedef std::shared_ptr<EvaFontCharacter> EvaFontCharacterPtr;
}
#endif // !EVA_FONT_HH
