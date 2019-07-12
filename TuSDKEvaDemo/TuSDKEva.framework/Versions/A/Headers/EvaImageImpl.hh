#ifndef EVAIMAGEIMPL_HH
#define EVAIMAGEIMPL_HH
/********************************************************
	* @file		: EvaImageImpl.hh	
	* @project	: eva
	* @author	: ligh
	* @date		: 2019-5-18 21:06:13
	* @brief	: 
	* @details	: 
*********************************************************/

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TuSDKEvaImport.h"
#import "EvaImageClipHolder.h"

#include "EvaImage.hh"


namespace tutu
{
	class EvaImageImpl : public EvaImage
	{
	public:
		EvaImageImpl(SLGPUImageFramebuffer* frameBuffer);
		~EvaImageImpl();
    private:
        SLGPUImageFramebuffer *_frameBuffer;
	public:
		static std::shared_ptr<EvaImageImpl> make(SLGPUImageFramebuffer* frameBuffer);
	public:
		/** destroy */
		virtual void destroy() override;

		// texture对象 GL_TEXTURE_2D
		virtual uint32_t target() override;
		// 获取textureID
		virtual uint32_t texture() override;
		// texture格式 GL_RGBA8
		virtual uint32_t internalFormat() override;
	};

	typedef std::shared_ptr<EvaImageImpl> EvaImageImplPtr;
}

#endif // !EVAIMAGEIMPL_HH

