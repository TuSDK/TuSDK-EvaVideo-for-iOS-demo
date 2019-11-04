#pragma once
#ifndef EVAIMAGE_HH
#define EVAIMAGE_HH
/********************************************************
	* @file		: EvaImage.hh	
	* @project	: Evanimation
	* @author	: Clear	
	* @date		: 2019-5-18 21:09:43
	* @brief	: 图片接口
	* @details	: 
*********************************************************/

#include <memory>
#include <stdint.h>

namespace tutu
{
	class EvaImage
	{
	public:
		/** destroy */
		virtual void destroy() = 0;

		// texture对象 GL_TEXTURE_2D
		virtual uint32_t target() = 0;
		// 获取textureID
		virtual uint32_t texture() = 0;
		// texture格式 GL_RGBA8
		virtual uint32_t internalFormat() = 0;
	};

	typedef std::shared_ptr<EvaImage> EvaImagePtr;
}

#endif // !EVAIMAGE_HH

