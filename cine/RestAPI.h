//
//  RestAPI.h
//  cine
//
//  Created by Guyi on 15/12/6.
//  Copyright © 2015年 yiguid. All rights reserved.
//

#ifndef RestAPI_h
#define RestAPI_h

#define WeChatAppId @"wxc71775bb0d1da2d8"
#define WeChatSecretKey @"d4624c36b6795d1d99dcf0547af5443d"

#define QQAppId @"1104941642"
#define QQAppKey @"VgG9nTX5XPLOyAmq"

#define WeiboAppId @"2131361387"
#define WeiboAppKey @"84c5dc0e052e795916dd04227b6fb6c9"

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
#define TAG_Rec_API @"http://cine-admin.limijiaoyin.com/specialtag"
#define REVIEW_API @"http://cine-admin.limijiaoyin.com/review"
#define REC_API @"http://cine-admin.limijiaoyin.com/recommend"
#define COMMENT_API @"http://cine-admin.limijiaoyin.com/comment"
#define QINIU_API @"http://cine-admin.limijiaoyin.com/qiniuUploadToken"
#define FEEDBACK_API @"http://cine-admin.limijiaoyin.com/feedback"
#define Jubao_API @"http://cine-admin.limijiaoyin.com/report"


#endif /* RestAPI_h */
