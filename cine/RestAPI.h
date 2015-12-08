//
//  RestAPI.h
//  cine
//
//  Created by Guyi on 15/12/6.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#ifndef RestAPI_h
#define RestAPI_h

#define WeChatAppId @"wxa3eacc1c86a717bc"
#define WeChatSecretKey @"b5bf245970b2a451fb8cebf8a6dff0c1"
#define QQAppId @"1104788666"
#define QQAppKey @"dOVWmsD7bW0zlyTV"
#define WeiboAppId @"2548122881"
#define WeiboAppKey @"ba37a6eb3018590b0d75da733c4998f8"

#define RGBCOLOR(r, g, b) [UIColor colorWithRed : (r) / 255.0 green : (g) / 255.0 blue : (b) / 255.0 alpha : 1]
#define RGBACOLOR(r, g, b, a) [UIColor colorWithRed : (r) / 255.0 green : (g) / 255.0 blue : (b) / 255.0 alpha : (a)]

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define USER_AUTH_API @"http://fl.limijiaoyin.com:1337/auth"
#define ME_API @"http://fl.limijiaoyin.com:1337/me"
#define SHUOXI_API @"http://fl.limijiaoyin.com:1337/story"
#define DINGGE_API @"http://fl.limijiaoyin.com:1337/post"



#endif /* RestAPI_h */
