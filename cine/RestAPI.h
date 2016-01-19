//
//  RestAPI.h
//  cine
//
//  Created by Guyi on 15/12/6.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#ifndef RestAPI_h
#define RestAPI_h

#define WeChatAppId @"wx162adbaff9d09e9c"
#define WeChatSecretKey @"811935bf619838ac59dd1fb98223e36e"
#define QQAppId @"1104788666"
#define QQAppKey @"dOVWmsD7bW0zlyTV"
#define WeiboAppId @"2548122881"
#define WeiboAppKey @"ba37a6eb3018590b0d75da733c4998f8"

#define RGBCOLOR(r, g, b) [UIColor colorWithRed : (r) / 255.0 green : (g) / 255.0 blue : (b) / 255.0 alpha : 1]
#define RGBACOLOR(r, g, b, a) [UIColor colorWithRed : (r) / 255.0 green : (g) / 255.0 blue : (b) / 255.0 alpha : (a)]

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define BASE_API @"http://cine-admin.limijiaoyin.com"
#define USER_AUTH_API @"http://cine-admin.limijiaoyin.com/auth"
#define ACTIVITY_API @"http://cine-admin.limijiaoyin.com/activity"
#define SHUOXI_API @"http://cine-admin.limijiaoyin.com/story"
#define DINGGE_API @"http://cine-admin.limijiaoyin.com/post"
#define MOVIE_API @"http://cine-admin.limijiaoyin.com/movie"
#define TAG_API @"http://cine-admin.limijiaoyin.com/tag"
#define REVIEW_API @"http://cine-admin.limijiaoyin.com/review"
#define REC_API @"http://cine-admin.limijiaoyin.com/recommend"
#define COMMENT_API @"http://cine-admin.limijiaoyin.com/comment"
#define QINIU_API @"http://cine-admin.limijiaoyin.com/qiniuUploadToken"
#define FEEDBACK_API @"http://cine-admin.limijiaoyin.com/feedback"
#define Jubao_API @"http://cine-admin.limijiaoyin.com/report"


#endif /* RestAPI_h */
