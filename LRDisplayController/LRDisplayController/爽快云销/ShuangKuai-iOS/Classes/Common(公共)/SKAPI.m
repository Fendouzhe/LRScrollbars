//
//  SKAPI.m
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/3/15.
//  Copyright © 2015 tech.unizone. All rights reserved.
//

#import "SKAPI.h"
#import "Utils.h"
#import "SMLoginViewController.h"
#import "TaskListModel.h"
#import "SMParticipant.h"
#import "QueryMissionListPostModel.h"
#import "QueryPromotionListPostModel.h"

//#define SKAPI_HTTPS_PREFIX             @"https://www.oschina.net/action/api/"
//#define SKAPI_PREFIX                   @"http://192.168.1.41/action/api/"

#define SK_ERROR_DOMAIN                        @"tech.unizone.shuangkuai"
#define SKAPI_HTTPS_PREFIX                     @"https://www.shuangkuai.co/api/"



//#define SKAPI_PREFIX                           @"http://192.168.1.40:8080/api/"
#define SKAPI_VERSION                          @"1.0"
#define SKAPI_PAY_PINGPP_CHARGE                @"/pay/pingpp/charge"
#define SKAPI_COMMON_INDUTAGS                  @"/common/indutags"
#define SKAPI_MY_AGREEMENT                     @"/my/agreement"
#define SKAPI_USER_BONUS_LIST                  @"/user/bonus/list"
#define SKAPI_USER_ACCOUNT_BIND                @"/user/account/bind"

#define SKAPI_FORGETSECRET_VERIFY              @"/request_verify"    // 普通发短信  （忘记密码，绑定银行卡）
#define SKAPI_REQUEST_VERIFY                   @"/sms/verify/request"   //注册
#define SKAPI_PASSWORD_MODIFY                  @"/password/modify"
#define SKAPI_VERIFY_SMS                       @"/verifysms"
#define SKAPI_TOKEN_REFRESH                    @"/token/refresh"
#define SKAPI_PRODUCT_SPEC                     @"/product/spec"
#define SKAPI_USER_LIST                        @"/user/list"
#define SKAPI_MY_TEAM_LIST                     @"/doTeam/list"

#define SKAPI_SCHEDULE_ADD                     @"/schedule/add"
#define SKAPI_SCHEDULE_PUBLISH                 @"/schedule/publish"
#define SKAPI_SCHEDULE_RECEIVE                 @"/schedule/receive"
#define SKAPI_SCHEDULE_ACCOMPLISH              @"/schedule/accomplish"
#define SKAPI_MISSION_LIST                     @"/schedule/List"
#define SKAPI_MISSION_INFORMATION              @"/schedule/teamTaskInfo"
#define SKAPI_MISSION_UPDATE                   @"/schedule/update"
#define SKAPI_MISSION_DELETE                   @"/schedule/delete"
#define SKAPI_MISSION_COMMENT_ADD              @"/scheduleDetail/add"
#define SKAPI_MISSION_COMMENT_DELETE           @"/scheduleDetail/delete"

#define SKAPI_TALENT_LIST                      @"/market/ranking"
#define SKAPI_TALENT_CHAMPION                  @"/homepage/marketExpert"
#define SKAPI_QUERY_FRIEND                     @"/buddy/list"

#define SKAPI_GET_UPLOAD_TOKEN                 @"get_upload_token"
#define SKAPI_MY_CHANGE_PASSWORD               @"/my/change_password"
#define SKAPI_MY_ORDER_LIST                    @"/my/order/list"
#define SKAPI_MY_ORDER_DETAIL                  @"/my/order/detail"
#define SKAPI_MY_ORDER_CLOSE                   @"/my/order/close"
#define SKAPI_MY_ORDER_FINISH                  @"/my/order/finish"
#define SKAPI_MY_ORDER_FILLTRACK               @"/my/order/filltrack"
#define SKAPI_MY_ORDER_TRACK_LIST              @"/my/order/track/list"
#define SKAPI_MY_ORDER_REMOVETRACK             @"/my/order/removetrack"
#define SKAPI_MY_ORDER_SETTLE                  @"/my/order/settle"
#define SKAPI_MY_CART_PUT                      @"/my/cart/put"
#define SKAPI_MY_CART_LIST                     @"/my/cart/list"
#define SKAPI_MY_CART_CALCULATE                @"/my/cart/calculate"
#define SKAPI_MY_CART_REMOVE                   @"/my/cart/remove"
#define SKAPI_BIND_CLIENTID                    @"/my/addDevice"
#define SKAPI_ADD_FEEDBACK                     @"/my/addFeedback"

#define SKAPI_MY_CART                          @"/my/cart"
#define SKAPI_MY_PROFILE_SEARCH                @"/my/profile/search"
#define SKAPI_MY_SIGNIN                        @"/my/signin"
#define SKAPI_MY_SIGNUP                        @"/my/signup"
#define SKAPI_MY_SIGNOUT                       @"/my/signout"
#define SKAPI_MY_UPLOAD_PORTRAIT               @"/my/upload_portrait"
#define SKAPI_MY_CHANGE_NAME                   @"/my/change_name"
#define SKAPI_MY_DOWNLOAD_PORTRAIT             @"/my/download_portrait"
#define SKAPI_MY_PROFILE                       @"/my/profile"
#define SKAPI_MY_FETCH_COMMISSION              @"/my/fetch_commission"
#define SKAPI_MY_STORAGE                       @"/my/storage/list"
#define SKAPI_MY_PROMOTION                     @"/my/promotion/list"
#define SKAPI_MY_STORAGE_REMOVE                @"/my/storage/remove"
#define SKAPI_MY_PROMOTION_REMOVE              @"/my/promotion/remove"
#define SKAPI_MY_COMMISSION_LIST               @"/my/commission/list"
#define SKAPI_MY_COMMISSION_PROFILE            @"/my/commission/profile"
#define SKAPI_MY_COMMISSION_PWD_VEFIFY         @"/my/commission/pwd/verify"
#define SKAPI_MY_COMMISSION_PWD_MODIFY         @"/my/commission/pwd/modify"
#define SKAPI_MY_FOLLOW_COMPANY_LIST           @"/my/follow/company/list"
#define SKAPI_MY_FOLLOW_COMPANY_IDLIST         @"/my/follow/company/idlist"
#define SKAPI_MY_PROFILE_EDIT                  @"/my/profile/edit"
#define SKAPI_MY_CARD_LIST                     @"/my/card/list"
#define SKAPI_MY_CARD_BIND                     @"/my/card/bind"
#define SKAPI_MY_Alipay_BIND                   @"/my/alipay/bind"
//#define SKAPI_MY_CARD_BINDNew                  @"/api/{version}/my/card/bind"

#define SKAPI_MY_CARD_UNBIND                   @"/my/card/unbind"
#define SKAPI_MY_COMMISSION_LOG_LIST           @"/my/commission/log/list"
#define SKAPI_MY_ADD_USERRELATION              @"/my/add/userRelation"
#define SKAPI_MY_KUAIDI_QUERY                  @"/my/kuaidi/query"
#define SKAPI_MY_COMMISSION                    @"/my/commission"
#define SKAPI_PICTURE_UPLOAD                   @"/picture/upload"
#define SKAPI_MESSAGE_LIST                     @"/message/list"

#define SKAPI_TOKEN_REFRESH                    @"/token/refresh"

#define SKAPI_FOLLOW_INDEX                     @"/follow/index"
#define SKAPI_FOLLOW_COMPANY                   @"/follow/company"
#define SKAPI_FOLLOW_COMPANY_LIST              @"/follow/company/list"
#define SKAPI_FOLLOW_COMPANY_DETAIL            @"/follow/company/detail"
#define SKAPI_FOLLOW_COMPANY_PRODUCT_LIST      @"/follow/company/product/list"
#define SKAPI_FOLLOW_COMPANY_PRODUCT_DETAIL    @"/follow/company/product/detail"
#define SKAPI_FOLLOW_COMPANY_NEWS_LIST         @"/follow/company/news/list"
#define SKAPI_FOLLOW_COMPANY_NEWS_DETAIL       @"/follow/company/news/detail"
#define SKAPI_FOLLOW_COMPANY_COUPON_LIST       @"/follow/company/coupon/list"
#define SKAPI_FOLLOW_OBJECT                    @"/follow/object"
#define SKAPI_FOLLOW_PRODUCT_LIST              @"/follow/product/list"
#define SKAPI_FOLLOW_PRODUCT_DETAIL            @"/follow/product/detail"
#define SKAPI_FOLLOW_COMPANY_ACTIVITY_LIST     @"/follow/company/activity/list"
#define SKAPI_FOLLOW_COMPANY_ACTIVITY_DETAIL   @"/follow/company/activity/detail"
#define SKAPI_FOLLOW_AD_LIST                   @"/follow/ad/list"
#define SKAPI_FOLLOW_QUERY                     @"/follow/query"

#define SKAPI_COMMUNICATION_SCHEDULE_LIST      @"/communication/schedule/list"
#define SKAPI_COMMUNICATION_SCHEDULE_DETAIL    @"/communication/schedule/detail"
#define SKAPI_COMMUNICATION_SCHEDULE_CREATE    @"/communication/schedule/create"
#define SKAPI_COMMUNICATION_SCHEDULE_UPDATE    @"/communication/schedule/"
#define SKAPI_COMMUNICATION_SCHEDULE_DELETE    @"/communication/schedule/{id}"
#define SKAPI_COMMUNICATION_WORKLOG_LIST       @"/communication/worklog/list"
#define SKAPI_COMMUNICATION_WORKLOG_DETAIL     @"/communication/worklog/detail"
#define SKAPI_COMMUNICATION_POUNCH_IN          @"/communication/pounchin"
#define SKAPI_COMMUNICATION_POUNCH_IN_LIST     @"/communication/pounchin_list"
#define SKAPI_COMMUNICATION_CUSTOMER_ADD       @"/communication/customer/add"
#define SKAPI_COMMUNICATION_SCHEDULE_ADD       @"/communication/schedule/create"
#define SKAPI_COMMUNICATION_COUPON_QUERY       @"/communication/coupon/query"
#define SKAPI_COMMUNICATION_COUPON_USE         @"/communication/coupon/use"

#define SKAPI_FAVORITES_PRODUCT_LIST           @"/collection/product/list"
#define SKAPI_FAVORITES_PROMOTION_LIST         @"/collection/promotion/list"
#define SKAPI_FAVORITES_PRODUCT_ADD            @"/collection/product/add"
#define SKAPI_FAVORITES_PROMOTION_ADD          @"/collection/promotion/add"
#define SKAPI_FAVORITES_STORAGE_CREATE         @"/collection/storage/create"
#define SKAPI_FAVORITES_STORAGE_UPDATE         @"/collection/storage/update"
#define SKAPI_FAVORITES_PROMOTION_CREATE       @"/collection/promotion/create"
#define SKAPI_FAVORITES_PRODUCT_REMOVE         @"/collection/product/remove"
#define SKAPI_FAVORITES_ACTIVITY_REMOVE        @"/collection/activity/remove"
#define SKAPI_FAVORITES_CREATE                 @"/collection/create"
#define SKAPI_FAVORITES_REMOVE                 @"/collection/remove"
#define SKAPI_FAVORITES_REMOVE2                @"/collection/remove2"
#define SKAPI_FAVORITES_ADD                    @"/collection/add"
#define SKAPI_FAVORITES_STORAGE_DETAIL         @"/collection/storage/detail"
#define SKAPI_FAVORITES_STORAGE_LIST           @"/collection/storage/list"
#define SKAPI_FAVORITES_BELONG                 @"/collection/belong"
#define SKAPI_FAVORITES_COUPON_SHARE           @"/collection/coupon/share"

#define SKAPI_CIRCLES_TWEET_PUBLISH            @"/circles/tweet/publish"
#define SKAPI_CIRCLES_TWEET_LIST               @"/circles/tweet/list"
#define SKAPI_CIRCLES_TWEET_DELETE             @"/circles/tweet/delete"
#define SKAPI_CIRCLES_TWEET_COMMENT_LIST       @"/circles/tweet/comment/list"
#define SKAPI_CIRCLES_TWEET_COMMENT_DELETE     @"/circles/tweet/comment/delete"
#define SKAPI_CIRCLES_TWEET_COMMENT            @"/circles/tweet/comment"
#define SKAPI_CIRCLES_TWEET_UPVOTE             @"/circles/tweet/upvote"
#define SKAPI_CIRCLES_TWEET_REPOST             @"/circles/tweet/repost"
#define SKAPI_CIRCLES_TWEET_DETAIL             @"/circles/tweet/detail"

#define SKAPI_MAP_SEARCH_REGEO                 @"/map/search/regeo"
#define SKAPI_MAP_SEARCH_KEYWORD               @"/map/search/keyword"

#define SKAPI_PAY_PINGPP_CHARGE                @"/pay/pingpp/charge"

#define SKAPI_PRODUCT_CLASS_LIST               @"/product/class/list"
#define SKAPI_PRODUCT_PHONE_LIST               @"/product/phone/list"
#define SKAPI_TEAMMATE_INFORAMATION            @"/partner/details"

#define SKAPI_ADD_FRIEND                       @"/my/Friends/add"
#define SKAPI_MESSAGE_OFFLINE_LIST             @"/message/offline/list"
#define SKAPI_RECEIPT_MESSAGE                  @"/message/findMessage"
#define SKAPI_FRIEND_MESSAGE_LIST              @"/message/friend/List"

#define SKAPI_CUSTOMER_ADD                     @"/customer/add"
#define SKAPI_CUSTOMER_LIST                    @"/customer/findList"
#define SKAPI_CUSTOMER_DELETE                  @"/customer/delete"
#define SKAPI_CUSTOMER_DETAILS                 @"/customer/details"
#define SKAPI_CUSTOMER_MODIFY                  @"/customer/modify"
#define SKAPI_CUSTOMER_TRACKINGLOG_SAVE        @"/customer/trackingLog/save"
#define SKAPI_CUSTOMER_TRACKINGLOG_DELETE      @"/customer/trackingLog/delete"

#define SKAPI_IM_GROUP_CREATE                  @"/rongCloud/group/create"
#define SKAPI_IM_GROUP_LIST                    @"/rongCloud/group/list"
#define SKAPI_IM_GROUP_DETAIL                  @"/rongCloud/group/detail"
#define SKAPI_IM_GROUP_INFO                    @"/rongCloud/group/info"
#define SKAPI_IM_GROUP_SETTING                 @"/rongCloud/group/setting"
//添加好友入群
#define SKAPI_IM_GROUP_JOIN                    @"/rongCloud/group/join"
//搜索好友
#define SKAPI_IM_GROUP_FRIEND                  @"/rongCloud/group/friend/find"
#define SKAPI_IM_GROUP_UPDATE                  @"/rongCloud/group/update"
#define SKAPI_IM_GROUP_MEMBER_DELETE           @"/rongCloud/group/member/delete"
#define SKAPI_IM_GROUP_MEMBER_QUIT             @"/rongCloud/group/member/quit"
#define SKAPI_IM_GROUP_DISMISS                 @"/rongCloud/group/dismiss"


//新订单接口
#define SKAPI_ORDER_MONEY_MIN                  @"/order/money/min"
#define SKAPI_ORDER_ADJUST_MONEY               @"/order/money/adjust"
#define SKAPI_ORDER_SHIPPINGFEE_SETTING        @"/order/logistics/setting"
#define SKAPI_ORDER_REMIND                     @"/order/remind"

#define SKAPI_MY_STATISTICS                    @"/my/statistics"

#define SKAPI_CUSTOMER_ORDER_LIST              @"/customer/salesorder/list"
#define SKAPI_CUSTOMER_TARGET_ADD              @"/customer/target/add"
#define SKAPI_CUSTOMER_TARGET_DELETE           @"/customer/target/delete"
#define SKAPI_CUSTOMER_TARGET_GET_LIST         @"/customer/target/get/list"

#pragma mark - 场景推广
#define SKAPI_PROMOTION_EVENTINVITATION_LIST   @"/promotion/master/list"

#define SKAPI_SHOPPING_SHARE  @"/mall/template"

#define SKAPI_POSTER_LIST                      @"/ad/list"
#define SKAPI_ARTICLE_LIST                     @"/news/list"

//推广接口
#define SKAPI_PROMOTION_GROUPBUYING_LIST       @"/groupbuy/master/list/complex"
#define SKAPI_SECKILL_LIST                     @"/seckill/master/list"

#define SKAPI_QRCODE_CREAT                     @"/weixin/mp/qrcode/create"

#define STATUS_OK                              0

@implementation SKAPI

static SKAPI *_apiCache = nil;
static AFHTTPSessionManager *manager = nil;

+ (id)shared {
    //单例的旧写法 非线程安全的实现
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _apiCache = [[SKAPI alloc] init];
        
//        NSURLSessionConfiguration *config = [[NSURLSessionConfiguration alloc] init];
//        config.timeoutIntervalForRequest = 15;
//        manager = [[AFHTTPSessionManager  alloc] initWithSessionConfiguration:config];
        
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 15;
        [_apiCache resetting];

        //设置复杂的模型
        [SalesOrder mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"products" : @"OrderProduct"};
        }];
    });
    return _apiCache;
}

- (AFHTTPSessionManager *)sessionManager{
    return manager;
}

- (void)appendToken{
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:KAccessToken];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-TOKEN"];
    
    //返回值使用json
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =
    [NSSet setWithObjects:@"application/json", @"text/html", nil];
    
}

- (void)resetting {
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //返回值使用json
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =
    [NSSet setWithObjects:@"application/json", @"text/html", nil];
    
}

- (void)remindErrorWithMsg:(NSString *)errorMsg cancelMsg:(NSString *)cancelMsg otherMsg:(NSString *)otherMsg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:self cancelButtonTitle:cancelMsg otherButtonTitles:otherMsg, nil];
    [alert show];
}

/**
 *  重新登录(如果服务器重启了，会出现 you need login first 报错，这时候，就默默的给他做一个登录操作，防止出现这个情况)
 */
- (void)relist{
    
    [self resetting];
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:KUserAccount];
    NSString *passWord = [[NSUserDefaults standardUserDefaults] objectForKey:KUserSecret];
    SMLog(@" 账号  %@  密码  %@",userAccount,passWord);
    //    [self signInWithAccount:userAccount andPassword:passWord block:^(User *user, NSError *error) {
    //        if (!error) {
    //            SMLog(@"重新登录成功");
    //        }else{
    //            SMLog(@"error  %@",error);
    //        }
    //    }];
    
#warning 要判断是微信登录还是普通登录
//    [self signInWithAccount:userAccount andPassword:passWord andSocial:@"" block:^(User *user, NSError *error) {
//        if (!error) {
//            SMLog(@"重新登录成功");
//        }else{
//            SMLog(@"重新登录失败");
//        }
//        
//    }];
    
    
    [self signInWithAccount:userAccount andPassword:passWord andSocial:@"" block:^(id result, NSError *error) {
        if (!error) {
            SMLog(@"重新登录成功");

            NSString *accessToken = [[result objectForKey:@"tokenInfo"] objectForKey:@"accessToken"];
            NSString *refreshToken = [[result objectForKey:@"tokenInfo"] objectForKey:@"refreshToken"];
                                      
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:KAccessToken];
            [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:KRefreshToken];
            [[SKAPI shared] appendToken];
        }else{
            SMLog(@"重新登录失败   %@",error);
            
        }
    }];
}

//- (void)tokenRefresh:(ResultBlock)block {
//    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_TOKEN_REFRESH];
//    NSDictionary *parameters = @{};
//    [manager GET:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
//        NSString *status = [responseObject valueForKey:@"status"];
//        if (STATUS_OK == [status intValue]) {
//            block(responseObject, nil);
//        } else if ([status intValue] == 401){//重启了服务器
//            [self relist];
//        } else {
//            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
//            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
//
//            block(nil, error);
//        }    } failure:^(NSURLSessionTask *operation, NSError *error) {
//            if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
//                [self relist];
//            }
//            block(nil, error);
//        }];
//}

- (void)shoppingShareType:(ResultBlock)block{
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_SHOPPING_SHARE];
    NSDictionary *parameters = @{};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
    
    
}

// account openid  password token
- (void)signInWithAccount:(NSString *)account andPassword:(NSString *)password
                andSocial:(NSString *)social block:(ResultBlock)block {
    if (account == nil || password == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    //退出登录返回的登录需要重置
    [self resetting];
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_SIGNIN];
    
    NSDictionary *parameters = @{@"account": account, @"password": password, @"social": social};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        
        NSString *status = [responseObject valueForKey:@"status"];
        
        NSLog(@"responseObject signInWithAccount  %@",responseObject);
//        NSLog(@"task.response = %@",task.currentRequest.allHTTPHeaderFields);
//        NSLog(@"HTTPRequestHeaders = %@",manager.requestSerializer.HTTPRequestHeaders);
        
        if (STATUS_OK == [status intValue] ) {
//            User *user = [User mj_objectWithKeyValues:[responseObject valueForKey:@"user"]];
//            user.isAuthenticated = TRUE;
//            block(user, nil);
            block(responseObject , nil);
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        SMLog(@"error  signInWithAccount = %@ ",error);
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)signUpWithAccount:(NSString *)account andPassword:(NSString *)password andVerifyCode:(NSString *)verifyCode block:(UserResultBlock)block {
    if (account == nil || password == nil || verifyCode == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_SIGNUP];
    NSDictionary *parameters = @{@"account": account, @"password": password, @"verifyCode": verifyCode};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue] ) {
            
            block(responseObject, nil);
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            block(responseObject, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)smsVerifyWithPhone:(NSString *)phone andVefifyCode:(NSString *)verifyCode block:(ResultBlock)block {
    if (phone == nil || verifyCode == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_VERIFY_SMS];
    NSDictionary *parameters = @{@"phone": phone, @"verifyCode": verifyCode};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue] ) {
            
            block(responseObject, nil);
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            block(responseObject, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)smsRequestVerifyWithPhone:(NSString *)phone block:(ResultBlock)block {
    if (phone == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_REQUEST_VERIFY];
    //NSDictionary *parameters = @{@"phone": phone};
    NSDictionary *parameters = @{@"phone":phone,
                                 @"type":@"signup"};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue] ) {
            
            block(responseObject, nil);
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            block(responseObject, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)forgetSecretWithPhone:(NSString *)phone block:(ResultBlock)block{
    
    if (phone == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FORGETSECRET_VERIFY];
    //NSDictionary *parameters = @{@"phone": phone};
    NSDictionary *parameters = @{@"phone":phone,
                                 @"type":@"signup"};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue] ) {
            
            block(responseObject, nil);
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            block(responseObject, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
    
}

- (void)signOut:(ResultBlock)block; {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_SIGNOUT];
    [manager POST:apiUrl.absoluteString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            block(responseObject, error);
        }
        SMLog(@"signOut = %@",responseObject);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
        
    }];
}

/************          ******************/
- (void)updatePortrait:(UIImage *)portrait block:(ResultBlock)block {
    if (portrait == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_UPLOAD_PORTRAIT];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp" forHTTPHeaderField:@"Accept"];
    [[SKAPI shared] appendToken];
    [manager POST:apiUrl.absoluteString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (portrait) {
            [formData appendPartWithFileData:[Utils compressImage:portrait] name:@"file" fileName:@"myportrait.png" mimeType:@"image/jpeg"];
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        }else if ([status intValue] == 401){//重启了服务器
            [self relist];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
    [self resetting];
}

- (void)changePassword:(NSString *)oldPassword andNewPassword:(NSString *)newPassword block:(ResultBlock)block {
    if (oldPassword == nil || newPassword == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_CHANGE_PASSWORD];
    NSDictionary *parameters = @{@"oldPwd": oldPassword, @"newPwd": newPassword};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        }else if ([status intValue] == 401){//重启了服务器
            [self relist];
        }else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryCompanyByName:(NSString *)name isRecommend:(BOOL)isRecommend andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FOLLOW_COMPANY_LIST];
    if (!name) {
        name = @"";
    }
    NSDictionary *parameters = @{@"name": name, @"page": [NSString stringWithFormat: @"%ld", page]
                                 , @"size": [NSString stringWithFormat: @"%ld", size]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id page = [responseObject valueForKey:@"page"];
            NSArray *companyArray = [Company mj_objectArrayWithKeyValuesArray:[page valueForKey:@"result"]];
            block(companyArray, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryCompanyById:(NSString *)companyId block:(CompanyResultBlock)block {
    if (companyId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FOLLOW_COMPANY_DETAIL];
    NSDictionary *parameters = @{@"companyId": companyId};
    [[SKAPI shared] appendToken];
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            Company *c = [Company mj_objectWithKeyValues:result];
            block(c, nil);
        } else if ([status intValue] == 401){//重启了服务器
            SMLog(@"queryCompanyById   401");
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        SMLog(@"error  queryCompanyById  %@",error);
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryProductByName:(NSString *)name andPage:(NSInteger)page andSize:(NSInteger)size andSortType:(PRODUCT_SORT_TYPE)sortType andClassId:(NSString *)classId andIsRecommend:(NSInteger)isRecommend block:(ArrayBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FOLLOW_PRODUCT_LIST];
    if (name==nil) {
        name = @"";
    }
    NSDictionary *parameters = @{@"name": name, @"page": [NSString stringWithFormat: @"%ld", page]
                                 , @"size": [NSString stringWithFormat: @"%ld", size]
                                 , @"sorttype": [NSString stringWithFormat: @"%u", sortType]
                                 , @"isRecommend" : [NSString stringWithFormat: @"%ld", isRecommend]
                                 , @"classId": classId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id page = [responseObject valueForKey:@"page"];
            NSArray *productArray = [Product mj_objectArrayWithKeyValuesArray:[page valueForKey:@"result"]];
            block(productArray, nil);
        } else if ([status intValue] == 401){//重启了服务器
            SMLog(@"[status intValue] == 401)");
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            if ([status intValue] == 403) {
                NSString * Account = [[NSUserDefaults standardUserDefaults] objectForKey:KUserAccount];
                NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:KUserSecret];
                
                //下面方法里面  不能抽出
                //                [[SKAPI shared] signInWithAccount:Account andPassword:password block:^(User *user, NSError *error) {
                //                    if (!error) {
                //                        SMLog(@"user = %@",user);
                //                    }else{
                //                        SMLog(@"error = %@",error);
                //                    }
                //                }];
                
#warning 要判断是微信登录还是普通登录
                [[SKAPI shared] signInWithAccount:Account andPassword:password andSocial:@"" block:^(User *user, NSError *error) {
                    
                }];
                
            }
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        SMLog(@"[error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode]    %zd",[error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode]);
        
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryProductById:(NSString *)productId block:(ProductResultBlock)block {
    
    if (productId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    [self appendToken];
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FOLLOW_PRODUCT_DETAIL];
    NSDictionary *parameters = @{@"productId": productId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        SMLog(@"manager.requestSerializer.HTTPRequestHeaders  %@",manager.requestSerializer.HTTPRequestHeaders);
        
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            Product *c = [Product mj_objectWithKeyValues:result];
            block(c, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryNewsByCompanyId:(NSString *)companyId andKeyword:(NSString *)keyword andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block {
    if (companyId == nil || keyword == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FOLLOW_COMPANY_NEWS_LIST];
    NSDictionary *parameters = @{@"companyId": companyId, @"keyword": keyword, @"page": [NSString stringWithFormat: @"%ld", page]
                                 , @"size": [NSString stringWithFormat: @"%ld", size]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id page = [responseObject valueForKey:@"page"];
            NSArray *newsArray = [News mj_objectArrayWithKeyValuesArray:[page valueForKey:@"result"]];
            block(newsArray, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryNewsById:(NSString *)newsId block:(NewsResultBlock)block {
    if (newsId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FOLLOW_COMPANY_NEWS_DETAIL];
    NSDictionary *parameters = @{@"newsId": newsId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            News *c = [News mj_objectWithKeyValues:result];
            block(c, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
    
}

- (void)queryActivityByCompanyId:(NSString *)companyId andKeyword:(NSString *)keyword andIsRecommend:(BOOL)bRecommend andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block {
    if (companyId == nil || keyword == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FOLLOW_COMPANY_ACTIVITY_LIST];
    NSInteger isRecommend = 0;
    if (bRecommend) {
        isRecommend = 1;
    }
    NSDictionary *parameters = @{@"companyId": companyId
                                 , @"keyword": keyword
                                 , @"isRecommend": [NSString stringWithFormat: @"%ld", isRecommend]
                                 , @"page": [NSString stringWithFormat: @"%ld", page]
                                 , @"size": [NSString stringWithFormat: @"%ld", size]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id page = [responseObject valueForKey:@"page"];
            NSArray *activityArray = [Activity mj_objectArrayWithKeyValuesArray:[page valueForKey:@"result"]];
            block(activityArray, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryActivityById:(NSString *)activityId block:(ActivityResultBlock)block {
    if (activityId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FOLLOW_COMPANY_ACTIVITY_DETAIL];
    NSDictionary *parameters = @{@"activityId": activityId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            Activity *a = [Activity mj_objectWithKeyValues:result];
            block(a, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
    
}

- (void)fetchCommission:(double)commission andBackCard:(NSString *)bankCard block:(ResultBlock)block {
    if (bankCard == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_FETCH_COMMISSION];
    NSDictionary *parameters = @{@"commission": [NSString stringWithFormat: @"%f", commission], @"bankCard": bankCard};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue] ) {
            
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            block(responseObject, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)pounchIn:(NSString *)address block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_COMMUNICATION_POUNCH_IN];
    if (address == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位异常" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSDictionary *parameters = @{@"address": address};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue] ) {
            
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            block(responseObject, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryPounchinByPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_COMMUNICATION_POUNCH_IN_LIST];
    NSDictionary *parameters = @{@"page": [NSString stringWithFormat: @"%ld", page]
                                 , @"size": [NSString stringWithFormat: @"%ld", size]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id page = [responseObject valueForKey:@"page"];
            NSArray *workLogArray = [WorkLog mj_objectArrayWithKeyValuesArray:[page valueForKey:@"result"]];
            block(workLogArray, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)createCustomer:(Customer *)customer block:(ResultBlock)block {
    if (customer == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CUSTOMER_ADD];
    NSDictionary *parameters = customer.mj_keyValues;
    
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue] ) {
            
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            block(responseObject, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)createSchedule:(Schedule *)schedule block:(ResultBlock)block {
    if (schedule == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_COMMUNICATION_SCHEDULE_ADD];
    NSDictionary *parameters = schedule.mj_keyValues;
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue] ) {
            
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            block(responseObject, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}


- (void)queryScheduleByPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_COMMUNICATION_SCHEDULE_LIST];
    NSDictionary *parameters = @{@"page": [NSString stringWithFormat: @"%ld", page]
                                 , @"size": [NSString stringWithFormat: @"%ld", size]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id page = [responseObject valueForKey:@"page"];
            NSArray *datas = [Schedule mj_objectArrayWithKeyValuesArray:[page valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//查询个人微推广列表
- (void)queryPromotion:(ArrayBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_PROMOTION];
    [manager POST:apiUrl.absoluteString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            NSArray *datas = [Favorites mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//查询个人微货架列表
- (void)queryStorage:(ArrayBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_STORAGE];
    [manager POST:apiUrl.absoluteString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            NSArray *datas = [Favorites mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)deleteStorage:(NSMutableArray *)favId block:(ResultBlock)block {
    if (favId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_STORAGE_REMOVE];
    NSDictionary *parameters = @{@"favId": favId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)deletePromotion:(NSString *)favId block:(ResultBlock)block {
    if (favId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_PROMOTION_REMOVE];
    NSDictionary *parameters = @{@"favId": favId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryCommissionByYear:(NSString *)year andMonth:(NSString *)month block:(ArrayBlock)block {
    if (year == nil || month == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_COMMISSION_LIST];
    NSDictionary *parameters = @{@"year": year, @"month": month};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        SMLog(@"responseObject  queryCommissionByYear   %@",responseObject);
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            
            NSArray *datas = [Commission mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"list"]];
            
            //            NSArray *datas = [Commission mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryOrderBySn:(NSString *)sn andStatus:(NSInteger)status andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_ORDER_LIST];
    if (!sn) {
        sn = @"";
    }
    NSDictionary *parameters = @{@"sn": sn, @"status": [NSString stringWithFormat: @"%ld", status]
                                 , @"page": [NSString stringWithFormat: @"%ld", page]
                                 , @"size": [NSString stringWithFormat: @"%ld", size]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        SMLog(@"responseObject  %@",responseObject);
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id page = [responseObject valueForKey:@"page"];
            
            NSArray *datas = [SalesOrder mj_objectArrayWithKeyValuesArray:[page valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}


- (void)queryOrderBySn:(NSString *)sn andStatus:(NSInteger)status andType:(NSInteger)type andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block
{
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_ORDER_LIST];
    if (!sn) {
        sn = @"";
    }
    
    NSDictionary *parameters;
    
    if (type == -100) {
        
        parameters = @{@"sn": sn, @"status": [NSString stringWithFormat: @"%ld", status]
                                     , @"page": [NSString stringWithFormat: @"%ld", page]
                                     , @"size": [NSString stringWithFormat: @"%ld", size]};
        
    }else
    {
        parameters = @{@"sn": sn, @"status": [NSString stringWithFormat: @"%ld", status]
                                     ,@"type": [NSString stringWithFormat: @"%ld", type]
                                    , @"page": [NSString stringWithFormat: @"%ld", page]
                                     , @"size": [NSString stringWithFormat: @"%ld", size]};
        
    }
    
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        SMLog(@"responseObject  %@",responseObject);
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id page = [responseObject valueForKey:@"page"];
            
            NSArray *datas = [SalesOrder mj_objectArrayWithKeyValuesArray:[page valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];

    
   
    
}



- (void)queryOrder:(NSString *)orderIdOrSn block:(ResultBlock)block {
    if (orderIdOrSn == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_ORDER_DETAIL];
    NSDictionary *parameters = @{@"orderId": [NSString stringWithFormat:@"%@",orderIdOrSn]};
    
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        
        SMLog(@"responseObject%@",responseObject);
        
        if (STATUS_OK == [status intValue]) {
            //NSArray *datas = [SalesOrder mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            SalesOrder *datas = [SalesOrder mj_objectWithKeyValues:[responseObject valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//关注企业
- (void)followCompany:(NSString *)companyId andType:(NSInteger)type block:(ResultBlock)block {
    if (companyId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FOLLOW_COMPANY];
    NSDictionary *parameters = @{@"companyId": companyId, @"followType": [NSString stringWithFormat: @"%ld", type]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//查询活动详细，通过活动唯一标识
//- (void)queryActivitysByPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block {
//    [self queryActivityByCompanyId:@"" andPage:page andSize:size block:^(NSArray *array, NSError *error) {
//        block(array, error);
//    }];
//}

//添加产品到我的微货架
- (void)addProduct:(NSString *)productId toMyStorage:(NSString *)favId block:(ResultBlock)block {
    if (productId == nil || favId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FAVORITES_PRODUCT_ADD];
    NSDictionary *parameters = @{@"productId": productId, @"favId": favId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//修改姓名
- (void)changeMyName:(NSString *)name block:(ResultBlock)block {
    if (name == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_CHANGE_NAME];
    NSDictionary *parameters = @{@"name": name};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//添加活动到我的微推广
- (void)addActivity:(NSString *)activityId toMyPromotion:(NSString *)favId block:(ResultBlock)block {
    
}

//查找我指定微货架里收藏的产品 favId 微货架的id
- (void)queryMyProductByFavId:(NSString *)favId block:(ArrayBlock)block {
    if (favId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FAVORITES_PRODUCT_LIST];
    NSDictionary *parameters = @{@"favId": favId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            
            NSArray *datas = [StorageProduct mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//从微货架中删除我收藏的产品
- (void)deleteMyProduct:(NSString *)detailId block:(ResultBlock)block {
    if (detailId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FAVORITES_PRODUCT_REMOVE];
    NSDictionary *parameters = @{@"detailId": detailId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//创建微货架模板 name模板名
- (void)createStorage:(NSString *)name block:(ResultBlock)block {
    if (name == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FAVORITES_STORAGE_CREATE];
    NSDictionary *parameters = @{@"name": name};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//更新微货架模板 name模板名
- (void)updateStorage:(NSString *)name andFavId:(NSString *)favId andImageToken:(NSString *)imageToken block:(ResultBlock)block {
    if (name == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FAVORITES_STORAGE_UPDATE];
    NSDictionary *parameters = @{@"name": name, @"favId": favId, @"imageToken": imageToken};
    [[SKAPI shared] appendToken];
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//创建微推广模板 name模板名
- (void)createPromotion:(NSString *)name block:(ResultBlock)block {
    if (name == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FAVORITES_PROMOTION_CREATE];
    NSDictionary *parameters = @{@"name": name};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//查询我关注的企业
- (void)queryMyFollowCompany:(NSString *)userId block:(ArrayBlock)block {
    if (userId == nil) {
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_FOLLOW_COMPANY_IDLIST];
    NSDictionary *parameters = @{@"userId": userId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            
            NSArray *datas = [NSString mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)publishTweet:(NSString *)content andLocation:(NSString *)location andDatas:(NSArray *)datas block:(ResultBlock)block {
    //if (location == nil) {
    //    location = @" ";
    //}
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CIRCLES_TWEET_PUBLISH];
    //    NSDictionary *parameters = @{@"content": content, @"address": location};
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"text/html,application/json,application/xhtml+xml,application/xml;q=0.9,image/webp" forHTTPHeaderField:@"Accept"];
    
    [[SKAPI shared] appendToken];
    __block int i = 0;
    // 参数
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    if (location == nil) {
        location = @"";
    }
    if (content == nil) {
        content = @"";
    }
    parameter[@"content"] = content;
    parameter[@"address"] = location;
    [manager POST:apiUrl.absoluteString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //下面代码也可以
        //        [formData appendPartWithFormData:[content dataUsingEncoding:NSUTF8StringEncoding] name:@"content"];
        //        [formData appendPartWithFormData:[location dataUsingEncoding:NSUTF8StringEncoding] name:@"address"];
        if (datas.count > 0) {
            for (UIImage *uploadImage in datas) {
                NSString *fileName = [NSString stringWithFormat:@"file%d.jpg", i];
                [formData appendPartWithFileData:[Utils compressImage:uploadImage] name:@"file"
                                        fileName:fileName mimeType:@"image/jpeg"];
            }
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        SMLog(@"responseObject   %@",responseObject);
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        }else if ([status intValue] == 401){//重启了服务器
            [self relist];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
    //[self resetting];
}

- (void)queryAd:(ArrayBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FOLLOW_AD_LIST];
    [manager POST:apiUrl.absoluteString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            
            NSArray *datas = [Ad mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)editProfile:(NSDictionary *)profileDic block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_PROFILE_EDIT];
    [manager POST:apiUrl.absoluteString parameters:profileDic success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryUserFollowCompany:(NSString *)userId andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block {
    if (userId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_FOLLOW_COMPANY_LIST];
    NSDictionary *parameters = @{@"userId": userId
                                 , @"page": [NSString stringWithFormat: @"%ld", page]
                                 , @"size": [NSString stringWithFormat: @"%ld", size]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id page = [responseObject valueForKey:@"page"];
            NSArray *companyArray = [Company mj_objectArrayWithKeyValuesArray:[page valueForKey:@"result"]];
            block(companyArray, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//根据经纬度查周围建筑
- (void)queryMapAround:(NSString *)location block:(ArrayBlock)block {
    if (location == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MAP_SEARCH_REGEO];
    NSDictionary *parameters = @{@"location": location};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            
            NSArray *datas = [MapLocation mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//查看爽快圈 userId 为nil或""时查看所有 userId不为空时，查userId下的爽快圈内容
- (void)queryTweet:(NSString *)userId andKeyword:(NSString *)keyword andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block {
    if (userId == nil || keyword == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CIRCLES_TWEET_LIST];
    NSDictionary *parameters = @{@"userId": userId, @"keyword": keyword
                                 , @"page": [NSString stringWithFormat: @"%ld", page]
                                 , @"size": [NSString stringWithFormat: @"%ld", size]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id page = [responseObject valueForKey:@"page"];
            NSArray *datas = [Tweet mj_objectArrayWithKeyValuesArray:[page valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//发表说说的评论
- (void)commentTweet:(NSInteger)tweetId andContent:(NSString *)content andToCommentId:(NSString *)toCommentId
         andAtUserId:(NSString *)atUserId block:(ResultBlock)block {
    if (content == nil || toCommentId == nil || atUserId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CIRCLES_TWEET_COMMENT];
    NSDictionary *parameters = @{@"tweetId": [NSString stringWithFormat: @"%ld", tweetId]
                                 , @"toCommentId": toCommentId
                                 , @"content": content
                                 , @"atUserId": atUserId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//删除我发表的评论
- (void)deleteMyComment:(NSInteger)commentId andTweetId:(NSInteger)tweetId block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CIRCLES_TWEET_COMMENT_DELETE];
    NSDictionary *parameters = @{@"tweetId": [NSString stringWithFormat: @"%ld", tweetId]
                                 , @"commentId": [NSString stringWithFormat: @"%ld", commentId]};
    
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//查看说说的评论数据
- (void)queryTweetComment:(NSInteger)tweetId block:(ArrayBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CIRCLES_TWEET_COMMENT_LIST];
    NSDictionary *parameters = @{@"tweetId": [NSString stringWithFormat: @"%ld", tweetId]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            NSArray *datas = [TweetComment mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//点赞
- (void)upvoteTweet:(NSInteger)tweetId upvote:(NSInteger)upvote block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CIRCLES_TWEET_UPVOTE];
    NSDictionary *parameters = @{@"tweetId": [NSString stringWithFormat: @"%ld", tweetId], @"upvote": [NSString stringWithFormat: @"%ld", upvote]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//转发
- (void)repostTweet:(NSInteger)tweetId andContent:(NSString *)content block:(ResultBlock)block {
    if (content == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CIRCLES_TWEET_REPOST];
    NSDictionary *parameters = @{@"tweetId": [NSString stringWithFormat: @"%ld", tweetId], @"content": content};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//删除我的说说
- (void)deleteMyTweet:(NSInteger)tweetId block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CIRCLES_TWEET_DELETE];
    NSDictionary *parameters = @{@"tweetId": [NSString stringWithFormat: @"%ld", tweetId]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//查我的银行卡
- (void)queryCard:(NSInteger)type block:(ArrayBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_CARD_LIST];
    NSDictionary *parameters = @{@"type":[NSNumber numberWithInteger:type]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            SMLog(@"responseObject valueForKey  queryCard %@",[responseObject valueForKey:@"result"]);
            NSArray *datas = [BankCard mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)bindCard:(NSString *)bandCard andIdCard:(NSString *)idCard andName:(NSString *)name andSubBank:(NSString *)subBank type:(NSInteger)type block:(ResultBlock)block{
    
    if (bandCard == nil || idCard == nil || name == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_CARD_BIND];
    NSDictionary *parameters = @{@"bankCard": bandCard, @"idCard": idCard, @"userName": name,@"subBank":subBank,@"type":[NSNumber numberWithInteger:type]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)bindAlipayAcount:(NSString *)acount userName:(NSString *)userName block:(ResultBlock)block{
    if (acount == nil || userName == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_Alipay_BIND];
    NSDictionary *parameters = @{@"bankCard": acount, @"userName": userName};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)bindCard:(NSString *)bandCard andIdCard:(NSString *)idCard andName:(NSString *)name block:(ResultBlock)block {
    if (bandCard == nil || idCard == nil || name == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_CARD_BIND];
    NSDictionary *parameters = @{@"bankCard": bandCard, @"idCard": idCard, @"userName": name};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)unbindCard:(NSString *)bandCard andType:(NSInteger)type block:(ResultBlock)block {
    if (bandCard == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_CARD_UNBIND];
    NSDictionary *parameters = @{@"bankCard": bandCard,@"type":[NSNumber numberWithInteger:type]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryCommissionLogByPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_COMMISSION_LOG_LIST];
    NSDictionary *parameters = @{@"page": [NSString stringWithFormat: @"%ld", page]
                                 , @"size": [NSString stringWithFormat: @"%ld", size]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id page = [responseObject valueForKey:@"page"];
            
            NSArray *datas = [CommissionLog mj_objectArrayWithKeyValuesArray:[page valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//查询优惠券
- (void)queryCoupon:(NSString *)code block:(ResultBlock)block {
    if (code == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_COMMUNICATION_COUPON_QUERY];
    NSDictionary *parameters = @{@"code": code};
    
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            Coupon *c = [Coupon mj_objectWithKeyValues:result];
            block(c, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//使用优惠券
- (void)useCoupon:(NSString *)code block:(ResultBlock)block {
    if (code == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_COMMUNICATION_COUPON_USE];
    NSDictionary *parameters = @{@"code": code};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//根据城市、关键字查询周围建筑
- (void)queryMapKeyword:(NSString *)keyword andCity:(NSString *)city andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block {
    if (keyword == nil || city == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MAP_SEARCH_KEYWORD];
    NSDictionary *parameters = @{@"keyword": keyword, @"city": city,
                                 @"page": [NSString stringWithFormat: @"%ld", page]
                                 , @"size": [NSString stringWithFormat: @"%ld", size]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            NSArray *datas = [MapLocation mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//查询优惠券活动
- (void)queryCompanyId:(NSString *)companyId andKeyword:(NSString *)keyword andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block {
    if (companyId == nil || keyword == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FOLLOW_COMPANY_COUPON_LIST];
    NSDictionary *parameters = @{@"companyId": companyId, @"keyword": keyword, @"page": [NSString stringWithFormat: @"%ld", page] , @"size": [NSString stringWithFormat: @"%ld", size]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id page = [responseObject valueForKey:@"page"];
            
            NSArray *datas = [Coupon mj_objectArrayWithKeyValuesArray:[page valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//查询用户资料
- (void)queryUserProfile:(NSString *)userId block:(ResultBlock)block {
    if (userId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_PROFILE];
    NSDictionary *parameters = @{@"userId": userId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            User *u = [User mj_objectWithKeyValues:result];
            block(u, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)pingppCharge:(NSString *)orderNo andChannel:(NSString *)channel block:(ResultBlock)block {
    if (orderNo == nil || channel == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_PAY_PINGPP_CHARGE];
    NSDictionary *parameters = @{@"orderNo": orderNo, @"channel": channel};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            block(result, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
            
            switch (error.code) {
                case 30002:             //不支持的支付渠道
                    [self remindErrorWithMsg:@"不支持的支付渠道" cancelMsg:@"确定" otherMsg:nil];
                    break;
                case 30003:             //微信公众号支付渠道必须传入openid
                    [self remindErrorWithMsg:@"微信公众号支付渠道必须传入openid" cancelMsg:@"确定" otherMsg:nil];
                    break;
                case 30004:             //支付回调参数异常
                    [self remindErrorWithMsg:@"支付回调参数异常" cancelMsg:@"确定" otherMsg:nil];
                    break;
                case 30005:             //重复支付的订单
                    [self remindErrorWithMsg:@"重复支付的订单" cancelMsg:@"确定" otherMsg:nil];
                    break;
                case 30006:             //支付了一张不存在的订单
                    [self remindErrorWithMsg:@"支付了一张不存在的订单" cancelMsg:@"确定" otherMsg:nil];
                    break;
                case 30007:             //未传入要支付的订单号
                    [self remindErrorWithMsg:@"未传入要支付的订单号" cancelMsg:@"确定" otherMsg:nil];
                    break;
                default:
                    break;
            }
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//修改佣金密码
- (void)modifyCommissionPwd:(NSString *)encCommissionPwd block:(ResultBlock)block {
    if (encCommissionPwd == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_COMMISSION_PWD_MODIFY];
    NSDictionary *parameters = @{@"cpwd": encCommissionPwd};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//校验佣金密码
- (void)verifyCommissionPwd:(NSString *)encCommissionPwd block:(ResultBlock)block {
    if (encCommissionPwd == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_COMMISSION_PWD_VEFIFY];
    NSDictionary *parameters = @{@"cpwd": encCommissionPwd};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//获取佣金统计数据 我的佣金资料那
- (void)queryCommissionProfile:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_COMMISSION_PROFILE];
    [manager POST:apiUrl.absoluteString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            //NSDictionary *dic = [NSDictionary mj_objectWithKeyValues:result];
            
            block(result, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryObject:(NSArray *)ids andType:(FOLLOW_TYPE)type block:(ResultBlock)block {
    if (ids == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FOLLOW_QUERY];
    NSDictionary *parameters = @{@"ids": ids, @"type": [NSString stringWithFormat: @"%u", type]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            block(result, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//查看某一条爽快圈
- (void)queryTweet:(NSInteger)tweetId block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CIRCLES_TWEET_DETAIL];
    NSDictionary *parameters = @{@"tweetId": [NSString stringWithFormat: @"%ld", tweetId]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            Tweet *o = [Tweet mj_objectWithKeyValues:result];
            block(o, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//保存一系列货架的东东进来
- (void)createItem2MyStorage:(NSString *)favId andName:(NSString *)name andProductIds:(NSArray *)productIds
              andActivityIds:(NSArray *)activityIds andCouponIds:(NSArray *)couponIds block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FAVORITES_CREATE];
    if (favId || name || productIds || activityIds || couponIds) {
        NSDictionary *parameters = @{@"favId": favId, @"favName": name
                                     , @"productIds": productIds, @"activityIds": activityIds
                                     , @"couponIds": couponIds};
        [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
            NSString *status = [responseObject valueForKey:@"status"];
            if (STATUS_OK == [status intValue]) {
                block(responseObject, nil);
            } else if ([status intValue] == 401){//重启了服务器
                [self relist];
            } else {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
                
                block(nil, error);
            }
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
                [self relist];
            }
            block(nil, error);
        }];
        
    }
}

//批量删除
- (void)deleteMyStorageItems:(NSArray *)ids block:(ResultBlock)block {
    if (ids == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FAVORITES_REMOVE];
    NSDictionary *parameters = @{@"itemIds": ids};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//查个人某个指定的微货架模板里的所有东东
- (void)queryMyStorageItems:(NSString *)favId block:(ArrayBlock)block {
    if (favId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FAVORITES_STORAGE_DETAIL];
    NSDictionary *parameters = @{@"favId": favId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            
            NSArray *datas = [FavoritesDetail mj_objectArrayWithKeyValuesArray:[result valueForKey:@"items"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)addItem:(NSString *)itemId toMyStorage:(NSArray *)favIds andType:(int)type block:(ResultBlock)block {
    if (itemId == nil || favIds == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FAVORITES_ADD];
    NSDictionary *parameters = @{@"itemId": itemId
                                 , @"favIds": favIds
                                 , @"type": [NSString stringWithFormat: @"%u", type]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)removeItem:(NSString *)itemId fromMyStorage:(NSArray *)favIds andType:(int)type block:(ResultBlock)block {
    if (itemId == nil || favIds == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FAVORITES_REMOVE2];
    NSDictionary *parameters = @{@"itemId": itemId
                                 , @"favIds": favIds
                                 , @"type": [NSString stringWithFormat: @"%u", type]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryFriend:(NSString *)keyword block:(ArrayBlock)block {
    if (keyword == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_QUERY_FRIEND];
    NSDictionary *parameters = @{@"keyword": keyword};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            NSArray *datas = [User mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//查询伙伴连线的爽快消息
- (void)querySystemMessageblock:(ArrayBlock)block{


}

//销售达人排行榜 type = 2本月 1本周 0本日
- (void)queryRanking:(NSInteger)type block:(ArrayBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_TALENT_LIST];
    NSDictionary *parameters = @{@"type": [NSString stringWithFormat: @"%ld", type]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            NSArray *datas = [User mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryChampion:(ArrayBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_TALENT_CHAMPION];
    NSDictionary *parameters = @{};
    [[SKAPI shared] appendToken];
    [manager GET:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            NSArray *datas = [User mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            SMLog(@"queryChampion   401");
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        SMLog(@"queryChampion  %@  ",error);
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)addFriend:(NSString *)uid andRemark:(NSString *)remark block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_ADD_FRIEND];
    NSDictionary *parameters = @{@"userdB": uid, @"remark": remark};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//接受/拒绝为好友
- (void)acceptFriend:(NSString *)friendId andMemo:(NSString *)memo andStatus:(NSInteger)status block:(ResultBlock)block {
    if (friendId == nil || memo == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_ADD_USERRELATION];
    NSDictionary *parameters = @{@"userId": friendId, @"memo": memo, @"status": [NSString stringWithFormat: @"%ld", status]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}
////9999
//- (void)tokenRefresh:(ResultBlock)block {
//    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_TOKEN_REFRESH];
//    NSDictionary *parameters = @{};
//    [manager GET:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
//        NSString *status = [responseObject valueForKey:@"status"];
//        if (STATUS_OK == [status intValue]) {
//            block(responseObject, nil);
//        } else if ([status intValue] == 401){//重启了服务器
//            [self relist];
//        } else {
//            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
//            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
//            
//            block(nil, error);
//        }
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//            if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
//                [self relist];
//            }
//            block(nil, error);
//    }];
//}

- (void)tokenRefresh:(NSString *)refreshToken result:(ResultBlock)block{
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_TOKEN_REFRESH];
    NSDictionary *parameters = @{@"refreshToken":refreshToken};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            SMLog(@"responseObject   %@     responseObject  class %@",responseObject,[responseObject class]);
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            SMLog(@"tokenRefresh   401");
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SMLog(@"error  tokenRefresh failure %@",error);
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
    
}

- (void)queryStorageByItem:(NSString *)itemId block:(ArrayBlock)block {
    if (itemId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FAVORITES_BELONG];
    NSDictionary *parameters = @{@"itemId": itemId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            NSArray *datas = [Favorites mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}


- (void)deleteMyStorageItems:(NSArray *)ids andFavId:(NSString *)favId andType:(NSInteger)type block:(ResultBlock)block {
    if (ids == nil || favId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FAVORITES_REMOVE];
    NSDictionary *parameters = @{@"ids": ids, @"type": [NSString stringWithFormat: @"%ld", type], @"favId": favId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)closeOrder:(NSString *)orderId block:(ResultBlock)block {
    if (orderId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_ORDER_CLOSE];
    NSDictionary *parameters = @{@"orderId": orderId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)finishOrder:(NSString *)orderId block:(ResultBlock)block {
    if (orderId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_ORDER_FINISH];
    NSDictionary *parameters = @{@"orderId": orderId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)kuaidiQuery:(NSString *)nu andCom:(NSString *)com block:(ResultBlock)block {
    if (nu == nil || com == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_KUAIDI_QUERY];
    NSDictionary *parameters = @{@"nu": nu, @"com": com};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id datas = [responseObject valueForKey:@"result"];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)modifyPassword:(NSString *)password block:(ResultBlock)block {
    if (password == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_PASSWORD_MODIFY];
    NSDictionary *parameters = @{@"password": password};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryUser:(NSString *)keyword andPage:(NSInteger)page andSize:(NSInteger)size block:(ResultBlock)block {
    if (keyword == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_USER_LIST];
    NSDictionary *parameters = @{@"keyword": keyword, @"page": [NSString stringWithFormat: @"%ld", page]
                                 , @"size": [NSString stringWithFormat: @"%ld", size]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        SMLog(@"%@",responseObject);
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            //            id page = [responseObject valueForKey:@"page"];
            //
            //            NSArray *datas = [User mj_objectArrayWithKeyValuesArray:[page valueForKey:@"result"]];
            //            block(datas, nil);
            block(responseObject,nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryInduTags:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_COMMON_INDUTAGS];
    NSDictionary *parameters = @{};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id datas = [responseObject valueForKey:@"result"];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
    
}

- (void)queryOrderTrackInfoById:(NSString *)orderId block:(ResultBlock)block {
    if (orderId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_ORDER_TRACK_LIST];
    NSDictionary *parameters = @{@"id": orderId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id datas = [responseObject valueForKey:@"result"];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)fillOrderTrackInfo:(NSString *)orderId andContent:(NSString *)content block:(ResultBlock)block {
    if (orderId == nil || content == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_ORDER_FILLTRACK];
    NSDictionary *parameters = @{@"id": orderId, @"context": content};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)shareCoupon:(NSString *)masterId block:(ResultBlock)block {
    if (masterId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FAVORITES_COUPON_SHARE];
    NSDictionary *parameters = @{@"masterId": masterId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)removeOrderTrackInfoById:(NSInteger)trackId andOrderId:(NSString *)orderId block:(ResultBlock)block {
    if (orderId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_ORDER_REMOVETRACK];
    NSDictionary *parameters = @{@"orderId": orderId
                                 , @"trackId": [NSString stringWithFormat: @"%ld", trackId]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)settleOrderByBuyer:(NSString *)buyerName
             andBuyerPhone:(NSString *)buyerPhone
                andAddress:(NSString *)address
               andBuyerTel:(NSString *)buyerTel
                   andMemo:(NSString *)memo
             andProductIds:(NSArray *)productIds
                 andAmount:(NSNumber *)amount
                  andExtra:(NSDictionary *)extra
                     block:(ResultBlock)block {
    if (buyerName == nil || buyerPhone == nil || address == nil || buyerTel == nil || memo == nil || productIds == nil) {
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_ORDER_SETTLE];
    
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    if (amount) {
        parameters = @{@"buyerName": buyerName
                       , @"buyerPhone": buyerPhone
                       , @"buyerAddress": address
                       , @"buyerTel": buyerTel
                       , @"memo": memo
                       , @"productIds": productIds
                       , @"amount": amount
                       , @"extra": extra};
    }else{
        parameters = @{@"buyerName": buyerName
                       , @"buyerPhone": buyerPhone
                       , @"buyerAddress": address
                       , @"buyerTel": buyerTel
                       , @"memo": memo
                       , @"productIds": productIds
                       , @"extra": extra};
    }
    
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
            
            switch (error.code) {
                case 20001:      //产品库存不足
                    [self remindErrorWithMsg:@"这款商品太受欢迎了，一经没库存啦" cancelMsg:@"确定" otherMsg:nil];
                    break;
                case 20002:      //没有传入要购买的产品
                    [self remindErrorWithMsg:@"请重新操作选中您要购买的商品" cancelMsg:@"确定" otherMsg:nil];
                    break;
                case 20003:      //未获取销售人员相关信息
                    [self remindErrorWithMsg:@"请确认您的帐号信息是否有登陆成功" cancelMsg:@"确定" otherMsg:nil];
                    break;
                case 20004:      //空订单，无法生成订单
                    [self remindErrorWithMsg:@"空订单，无法生成订单" cancelMsg:@"确定" otherMsg:nil];
                    break;
                case 20005:      //买家信息不足，无法生成订单
                    [self remindErrorWithMsg:@"买家信息不足，无法生成订单" cancelMsg:@"确定" otherMsg:nil];
                    break;
                case 20006:      //无效的查询条件
                    [self remindErrorWithMsg:@"无效的查询条件" cancelMsg:@"确定" otherMsg:nil];
                    break;
                case 20007:      //购买数量非法值，请填入购买数量
                    [self remindErrorWithMsg:@"购买数量非法值，请重新填入购买数量" cancelMsg:@"确定" otherMsg:nil];
                    break;
                case 20008:      //openid未传入，不支持的支付渠道
                    [self remindErrorWithMsg:@"不支持的支付渠道" cancelMsg:@"确定" otherMsg:nil];
                    break;
                case 20009:      //订单中产品已下架
                    [self remindErrorWithMsg:@"订单中的产品已下架" cancelMsg:@"确定" otherMsg:nil];
                    break;
                case 20010:      //订单中产品已过期或被删除
                    [self remindErrorWithMsg:@"订单中产品已过期或被删除" cancelMsg:@"确定" otherMsg:nil];
                    break;
                default:
                    break;
            }

        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)putCartByProductId:(NSString *)productId andAmount:(NSInteger)amount block:(ResultBlock)block {
    if (productId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_CART_PUT];
    NSDictionary *parameters = @{@"productId": productId
                                 , @"amount": [NSString stringWithFormat: @"%ld", amount]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryMyCart:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_CART_LIST];
    NSDictionary *parameters = @{};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            SMLog(@"responseObject  queryMyCart %@ ",[responseObject valueForKey:@"result"]);
            NSArray *datas = [Cart mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)calculateMyCartItems:(NSArray *)itemsInfo andIsCalcSf:(BOOL)isCalcSf block:(ResultBlock)block {
    if (itemsInfo == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_CART_CALCULATE];
    NSDictionary *parameters = @{@"itemsInfo": itemsInfo,@"isCalcSf":[NSNumber numberWithBool:isCalcSf]};
    //SMLog(@"itemsInfo = %@",itemsInfo);
    
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSData * data = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    SMLog(@"str =   %@",str);
    
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)removeMyCartItem:(NSArray *)ids block:(ResultBlock)block {
    if (ids == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_CART_REMOVE];
    NSDictionary *parameters = @{@"ids": ids};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}


//获取本月销售额，本月待审核佣金、本月已发放佣金、本月佣金、上月佣金
- (void)queryCommission:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_COMMISSION];
    NSDictionary *parameters = @{};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//bind clientid
- (void)bindClientId:(NSString *)clientId block:(ResultBlock)block {
    if (clientId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_BIND_CLIENTID];
    NSDictionary *parameters = @{@"deviceId": clientId};
    //[[SKAPI shared] appendToken];
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//忘记密码中的修改密码
- (void)forgetPasswordModify:(NSString *)password block:(ResultBlock)block {
    if (password == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_PASSWORD_MODIFY];
    NSDictionary *parameters = @{@"password": password};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//填写意见反馈
- (void)writeFeedback:(NSString *)content block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_ADD_FEEDBACK];
    NSDictionary *parameters = @{@"content": content};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//同意协议
- (void)agreement:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_AGREEMENT];
    NSDictionary *parameters = @{@"signed": @1};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//查询奖金接口 offset要取的数据大小，比如只取10条，则填10。lastTimestamp最后一条记录的时间戳，第一次取可以不传
- (void)queryBonus:(NSString *)yearMonth andOffset:(NSInteger)offset andLastTimestamp:(NSInteger)lastTimestamp block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_USER_BONUS_LIST];
    NSDictionary *parameters = @{@"ym":yearMonth,@"offset": [NSString stringWithFormat: @"%ld", offset], @"last_time":[NSString stringWithFormat: @"%ld", lastTimestamp]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            //            NSArray *datas = [Bonus mj_objectArrayWithKeyValuesArray:[result valueForKey:@"bonuses"]];
            block(result, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//查询消息接口 offset要取的数据大小，比如只取10条，则填10。lastTimestamp最后一条记录的时间戳，第一次取可以不传
- (void)queryMsg:(NSInteger)offset andLastTimestamp:(NSInteger)lastTimestamp block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MESSAGE_LIST];
    NSDictionary *parameters = @{@"offset": [NSString stringWithFormat: @"%ld", offset], @"last_time":[NSString stringWithFormat: @"%ld", lastTimestamp]};
    [[SKAPI shared] appendToken];
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            NSArray *datas = [Msg mj_objectArrayWithKeyValuesArray:[result valueForKey:@"messages"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            SMLog(@"queryMsg  401");
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        SMLog(@"error   queryMsg  %@",error);
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)uploadPic:(UIImage *)uploadImage block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_PICTURE_UPLOAD];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"text/html,application/json,application/xhtml+xml,application/xml;q=0.9,image/webp" forHTTPHeaderField:@"Accept"];
    __block int i = 0;
    // 参数
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"isEnc"] = @1;
    [[SKAPI shared] appendToken];
    [manager POST:apiUrl.absoluteString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *fileName = [NSString stringWithFormat:@"file%d.jpg", i];
        [formData appendPartWithFileData:[Utils compressImage:uploadImage] name:@"file"
                                fileName:fileName mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        
        SMLog(@"responseObject   %@",responseObject);
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        }else if ([status intValue] == 401){//重启了服务器
            [self relist];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // Check if error code is 401
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"UnauthorizedRequest" object:nil];
        block(nil, error);
    }];
    [self resetting];
}

- (void)queryProductClass:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_PRODUCT_CLASS_LIST];
    NSDictionary *parameters = @{};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            block(result, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//获取我的团队列表
- (void)queryMyTeamList:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_TEAM_LIST];
    NSDictionary *parameters = @{};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            NSArray *datas = [User mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

/*
 * 查某个产品下的规格，并返回库存、产品规格对应的价格、产品规格id(可理解为实际也是产品id)、
 * specName 规格名
 * productId 产品id
 *
 */
- (void)queryProductSpec:(NSString *)productId andSpecName:(NSString *)specName block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_PRODUCT_SPEC];
    NSDictionary *parameters = @{@"productId": productId, @"specName": specName};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            ProductSpec *ps = [result valueForKey:@"spec"];
            block(ps, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

/*
 * 电信选号
 * productId 产品id
 * keyword 模糊搜索关键字，用来查号码
 */
- (void)queryPhoneListByPage:(NSInteger)page andSize:(NSInteger)size andProductId:(NSString *)productId andKeyword:(NSString *)keyword block:(ResultBlock)block; {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_PRODUCT_PHONE_LIST];
    NSDictionary *parameters = @{@"productId": productId, @"keyword": keyword
                                 , @"page": [NSString stringWithFormat: @"%ld", page]
                                 , @"size": [NSString stringWithFormat: @"%ld", size]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        SMLog(@"responseObject   %@",responseObject);
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            //            id result = [responseObject valueForKey:@"result"][@"phones"][@"result"];
            id result = [responseObject valueForKey:@"result"];
            SMLog(@"[result class]   %@",[result class]);
            id ss = [[result valueForKey:@"phones"] valueForKey:@"result"];
            //            NSString *ss = [result valueForKey:@"phones"];
            block(ss, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryTeammateInfoByUserId:(NSString *)userId block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_TEAMMATE_INFORAMATION];
    NSDictionary *parameters = @{@"userId": userId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            block(result, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}
///请求新消息
- (void)queryOfflineMessages:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MESSAGE_OFFLINE_LIST];
    //NSDictionary *parameters = @{@"allowPush": @"0"};
    NSDictionary *parameters = @{@"allowPush": @(0)};//@{@"allowPush": @(1)};
    [[SKAPI shared] appendToken];
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            SMLog(@"error  queryOfflineMessages  401");
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        SMLog(@"error  queryOfflineMessages  %@",error);
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)receiptMessage:(NSArray *)messageIds block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_RECEIPT_MESSAGE];
    NSDictionary *parameters = @{@"messageId": messageIds};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)queryStorageList:(ResultBlock)block {
    
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FAVORITES_STORAGE_LIST];
    NSDictionary *parameters = @{};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            SMLog(@"responseObject   %@  result SKAPI_FAVORITES_STORAGE_LIST  %@",responseObject,result);
            block(result, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}
//爽快消息
- (void)queryFriendMessages:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_FRIEND_MESSAGE_LIST];
    NSDictionary *parameters = @{};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            //SMLog(@"result   %@",result);
            block(result, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)bindAccountByPhone:(NSString *)phone andOpenId:(NSString *)openId andAccessToken:(NSString *)accessToken andVerifyCode:(NSString *)verifyCode block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_USER_ACCOUNT_BIND];
    NSDictionary *parameters = @{@"phone": phone
                                 , @"openId": openId
                                 , @"accessToken": accessToken
                                 , @"verifyCode": verifyCode
                                 , @"catalog": @"wechat"};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)updateCustomer:(Customer *)customer block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CUSTOMER_MODIFY];
    NSDictionary *parameters = customer.mj_keyValues;
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)deleteCustomer:(NSString *)customerId block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CUSTOMER_DELETE];
    NSDictionary *parameters = @{@"id": customerId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)queryCustomerDetail:(NSString *)customerId block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CUSTOMER_DETAILS];
    NSDictionary *parameters = @{@"id": customerId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        
        SMLog(@"responseObject   queryCustomerDetail  %@",responseObject);
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

//- (void)queryCustomer:(NSString *)name andGrade:(NSInteger)grade andStatus:(NSInteger)status andLastTimeStamp:(NSInteger)lastTimeStamp andOffset:(NSInteger)offset block:(ResultBlock)block {
//    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CUSTOMER_LIST];
//
//    NSDictionary *parameters = @{@"fullname": name
//                                 , @"grade": [NSString stringWithFormat: @"%ld", grade]
//                                 , @"status": [NSString stringWithFormat: @"%ld", status]
//                                 , @"lastTimeStamp": [NSString stringWithFormat: @"%ld", lastTimeStamp]
//                                 , @"offset": [NSString stringWithFormat: @"%ld", offset]};
//    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
//        NSString *status = [responseObject valueForKey:@"status"];
//        if (STATUS_OK == [status intValue]) {
//            block(responseObject, nil);
//        } else if ([status intValue] == 401){//重启了服务器
//            [self relist];
//        } else {
//            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
//            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
//
//            block(nil, error);
//        }
//
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        block(nil, error);
//    }];
//}

- (void)queryCustomer:(NSString *)name
         andBuyRating:(NSInteger)buyRating
             andLevel:(NSInteger)level
            andTarget:(NSString *)target
     andLastTimeStamp:(NSInteger)lastTimeStamp
            andOffset:(NSInteger)offset
              andType:(NSInteger)type
                block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CUSTOMER_LIST];
    
    NSDictionary *parameters = @{@"name": name
                                 , @"target": target
                                 , @"level": [NSString stringWithFormat: @"%ld", level]
                                 , @"lastTimeStamp": [NSString stringWithFormat: @"%ld", lastTimeStamp]
                                 , @"offset": [NSString stringWithFormat: @"%ld", offset],@"type":[NSString stringWithFormat:@"%ld",type]
                                 ,@"buyRating":[NSString stringWithFormat: @"%ld", buyRating]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)writeCommentByCustomerId:(NSString *)customerId andContent:(NSString *)content block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CUSTOMER_TRACKINGLOG_SAVE];
    NSDictionary *parameters = @{@"customerId": customerId
                                 , @"content": content};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)deleteCommentByCustomerId:(NSString *)customerId andLogId:(NSString *)logId block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CUSTOMER_TRACKINGLOG_DELETE];
    NSDictionary *parameters = @{@"customerId": customerId
                                 , @"logId": logId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

- (NSURL *)fullApiPathWithSuffix:(NSString *)suffix {
    NSString *apiUrl = [NSString stringWithFormat:@"%@%@%@", SKAPI_PREFIX, SKAPI_VERSION, suffix];
    NSURL *url = [NSURL URLWithString:apiUrl];
    return url;
}

/**
 *创建群
 * intro 简介
 * imageToken 图片token
 * groupName 群名
 * userIds 要拉进群的用户id
 */
- (void)createGroup4IM:(NSString *)intro andImageToken:(NSString *)imageToken andGroupName:(NSString *)groupName andUserIds:(NSArray *)userIds block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_IM_GROUP_CREATE];
    NSDictionary *parameters = @{@"intro": intro
                                 , @"imageToken": imageToken
                                 , @"userIds": userIds
                                 , @"groupName": groupName};
    //打印请求头
    //SMLog(@"manager.requestSerializer - %@ manager.requestSerializer.HTTPRequestHeaders = %@",manager.requestSerializer,manager.requestSerializer.HTTPRequestHeaders);
    [[SKAPI shared] appendToken];
    //SMLog(@"manager.requestSerializer - %@ manager.requestSerializer.HTTPRequestHeaders = %@",manager.requestSerializer,manager.requestSerializer.HTTPRequestHeaders);
    
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        SMLog(@"responseObject = %@",responseObject);
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        //SMLog(@"NSURLSessionTask *operation, NSError *error = %@--error.code = %lu %@",error,error.code,error.domain);
        block(nil, error);
        
        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        SMLog(@"response.statusCode = %lu",response.statusCode);
        if (response.statusCode == 401) {
            [self relist];
        }
    }];
}

//群列表
- (void)queryGroupList4IM:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_IM_GROUP_LIST];
    NSDictionary *parameters = @{};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

//查群的详细信息 more true获取更多
- (void)queryGroupDetail4IM:(NSString *)groupId more:(bool)more block:(ResultBlock)block {
    groupId = groupId.length ? groupId : @"";
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_IM_GROUP_DETAIL];
    NSDictionary *parameters = @{@"groupId": groupId};
    if (more) {
        parameters = @{@"groupId": groupId, @"more": @"more"};
    }
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

//加入群
- (void)joinGroup4IM:(NSString *)groupId andGroupName:(NSString *)groupName andUserIds:(NSArray *)userIds block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_IM_GROUP_JOIN];
    NSDictionary *parameters = @{@"groupName": groupName, @"groupId": groupId, @"userIds": userIds};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

//退出群组
- (void)quitGroup4IM:(NSString *)groupId block:(ResultBlock)block {
    groupId = groupId.length ? groupId : @"";
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_IM_GROUP_MEMBER_QUIT];
    NSDictionary *parameters = @{@"groupId": groupId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

//解散群组
- (void)dismissGroup4IM:(NSString *)groupId block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_IM_GROUP_DISMISS];
    NSDictionary *parameters = @{@"groupId": groupId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

//删除群成员
- (void)deleteMember4IM:(NSString *)groupId andUserIds:(NSArray *)userIds block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_IM_GROUP_MEMBER_DELETE];
    NSDictionary *parameters = @{@"groupId": groupId, @"userIds": userIds};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

//查找群成员
- (void)findFriend4IM:(NSString *)name block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_IM_GROUP_FRIEND];
    NSDictionary *parameters = @{@"name": name};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}



/**
 * 查看应付金额可调整的最低值
 */
- (void)queryMinOrderPayMoney:(NSString *)orderId block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_ORDER_MONEY_MIN];
    NSDictionary *parameters = @{@"orderId": orderId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

/**
 * 修改订单价格
 * orderId 订单id
 * money 要修改的订单应付金额
 * 修改后会返回计算后的订单佣金
 * 应付金额调整数最低位 调用queryMinPayMoney 查看
 */
- (void)adjustOrderPayMoney:(NSString *)orderId andMoney:(NSNumber *)money block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_ORDER_ADJUST_MONEY];
    NSDictionary *parameters = @{@"orderId": orderId, @"money": money};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

/**
 * 设置物流
 * orderId 订单id
 * shippingFee 物流费用
 * 修改后会返回计算后的应付金额
 * 不需要物流 直接传0
 */
- (void)settingLogistics:(NSString *)orderId andShippingFee:(NSNumber *)shippingFee block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_ORDER_SHIPPINGFEE_SETTING];
    NSDictionary *parameters = @{@"orderId": orderId, @"shippingFee": shippingFee};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

//发货提醒
- (void)remindOrder:(NSString *)orderId block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_ORDER_REMIND];
    NSDictionary *parameters = @{@"orderId": orderId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}
//修改群信息
- (void)updateGroup:(NSString *)groupId andRoomName:(NSString *)roomName
           andIntro:(NSString *)intro andImageToken:(NSString *)imageToken block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_IM_GROUP_UPDATE];
    NSDictionary *parameters = @{@"groupId": groupId
                                 , @"roomName": roomName, @"intro": intro
                                 ,@"imageToken": imageToken};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}
//修改群头像
- (void)updateGroup:(NSString *)groupId imageToken:(NSString *)imageToken block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_IM_GROUP_UPDATE];
    NSDictionary *parameters = @{@"groupId": groupId
                                 ,@"imageToken": imageToken};
    [[SKAPI shared] appendToken];
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}
//修改在群里面的昵称
- (void)settingGroup:(NSString *)groupId andMessageStatus:(NSInteger)status andRemark:(NSString *)remark block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_IM_GROUP_SETTING];
    NSDictionary *parameters = @{@"groupId": groupId
                                 //, @"messageStatus": [NSString stringWithFormat: @"%ld", status]
                                 , @"remark": remark};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

//修改在群设置---消息免打扰
- (void)settingGroup:(NSString *)groupId andMessageStatus:(int)status block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_IM_GROUP_SETTING];
    if (!groupId) {
        return;
    }
    NSDictionary *parameters = @{@"groupId": groupId
                                 , @"messageStatus": [NSString stringWithFormat: @"%d", status]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}


- (void)queryDataStatistics:(NSArray *)types block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_STATISTICS];
    //NSDictionary *parameters = @{@"types": types};
    
    NSDictionary *parameters = @{@"ids": @[@{@"type":@1,@"id":@101},@{@"type":@2,@"id":@101},@{@"type":@3,@"id":@101}]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            block(result, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)queryHomeSection0DataWithUserId:(NSString *)userId block:(ResultBlock)block{
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MY_STATISTICS];
    
    NSDictionary *parameters = @{@"ids":@[@{@"type":@"1",@"id":@"101"},@{@"type":@"2",@"id":@"101"},@{@"type":@"3",@"id":@"101"}],
                                 @"sid":userId};
    [[SKAPI shared] appendToken];
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            id result = [responseObject valueForKey:@"result"];
            block(result, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)queryCustomerOrderByPhone:(NSString *)phone block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CUSTOMER_ORDER_LIST];
    NSDictionary *parameters = @{@"phone": phone};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)addTag:(NSString *)tagName block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CUSTOMER_TARGET_ADD];
    NSDictionary *parameters = @{@"name": tagName};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)deleteTag:(NSString *)targetId block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CUSTOMER_TARGET_DELETE];
    NSDictionary *parameters = @{@"targetId": targetId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        SMLog(@"responseObject  deleteTag  %@",responseObject);
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)queryCustomerTagByName:(NSString *)name block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_CUSTOMER_TARGET_GET_LIST];
    NSDictionary *parameters = @{@"name": @"sk"};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
    }];
}

/*添加新任务日程
 *字典里传 title 标题
 *      remark 备注
 *      schTime 日程时间
 *      remindTime 提醒时间
 *      //status 状态
 *      //remindType 提醒类型
 *      //type 日程类型
 *      users 参数类型数组array  数组内部元素 是参与人id 的字符串
 *      fatherId 父任务的id
 */
- (void)addMission:(NSDictionary *)missionINfo block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_SCHEDULE_ADD];
    [manager POST:apiUrl.absoluteString parameters:missionINfo success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

/**
 * 将任务修改完成
 */
- (void)accomplishMission:(NSString *)missionId block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_SCHEDULE_ACCOMPLISH];
    NSDictionary *parameters = @{@"id": missionId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

/**
 * 发布任务 对参与人进行推送
 */
- (void)publishMission:(NSString *)missionId block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_SCHEDULE_PUBLISH];
    NSDictionary *parameters = @{@"id": missionId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

/*修改新任务日程
 *字典里传
 *      id 服务器返回的日程的id
 *      title 标题
 *      remark 备注
 *      schTime 日程时间
 *      //remindTime 提醒时间
 *      //status 状态
 *      //remindType 提醒类型
 *      //type 日程类型
 *      users 选择的团队人的用户id，多个人以","隔开
 */
- (void)updateMission:(NSDictionary *)missionINfo block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MISSION_UPDATE];
    [manager POST:apiUrl.absoluteString parameters:missionINfo success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

/*
 * 删除任务日程
 * schId 日程id
 */
- (void)deleteMission:(NSString *)schId block:(ResultBlock)block {
    if (schId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MISSION_DELETE];
    NSDictionary *parameters = @{@"id": schId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

/**
 * 查看任务列表
 *
 * @param 我发布的、我接收的(type
 *            1我发布的 我接收的 0)
 * @param status
 *            状态 （ 未发布 0 未完成 1 已完成2 ）
 * @param keyword
 *            关键字收索（发布者名字，参与者名字，任务标题，任务大纲）
 */
- (void)queryMissionList:(NSString *)type andOffset:(NSInteger)offset andLastTimestamp:(NSString *)lastTimestamp andStatus:(NSString *)status andKeyword:(NSString *)keyword block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MISSION_LIST];
    
//    NSDictionary *parameters = @{@"type": [NSString stringWithFormat: @"%ld", type]
//                                 , @"keyword": keyword
//                                 , @"status": [NSString stringWithFormat: @"%ld", status]
//                                 , @"offset": [NSString stringWithFormat: @"%ld", offset]
//                                 , @"lastTimeStamp": [NSString stringWithFormat: @"%ld", lastTimestamp]};
    QueryMissionListPostModel *model = [[QueryMissionListPostModel alloc] init];
    model.type = type;
    model.offset = offset;
    model.lastTimeStamp = lastTimestamp;
    model.status = status;
    model.keyword = keyword;
    
//    NSDictionary *dic = model.mj_keyValues;
//    NSDictionary *dic1 = model.keyword;
    
    [manager POST:apiUrl.absoluteString parameters:model.mj_keyValues success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            SMLog(@"response =    %@",responseObject);
            [TaskListModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"usersList" : [SMParticipant class]
                         };
            }];
            NSArray *datas = [TaskListModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            block(datas, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

/*
 * 获取任务日程详情
 * schId 日程id
 */
- (void)queryMission:(NSString *)schId block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MISSION_INFORMATION];
    NSDictionary *parameters = @{@"id": schId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        //NSLog(@"responseObject 66666666= %@",responseObject);
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            Schedule *ss = [responseObject valueForKey:@"result"];
            block(ss, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

/*
 * 接收任务
 * schId 日程id
 */
- (void)receiveMission:(NSString *)schId block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_SCHEDULE_RECEIVE];
    NSDictionary *parameters = @{@"id": schId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            Schedule *ss = [responseObject valueForKey:@"result"];
            block(ss, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

/*
 * 添加任务日程的评论
 * scheId 任务的id
 * content 评论内容
 * type 类型
 *
 */
- (void)addMissionComment:(NSString *)schId andContent:(NSString *)content
                  andType:(NSInteger)type block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MISSION_COMMENT_ADD];
    NSDictionary *parameters = @{@"scheduleId": schId, @"content": content
                                 , @"type": [NSString stringWithFormat: @"%ld", type]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

/*
 * 删除任务日程评论
 * schId 任务的id
 * commentId 评论id
 *
 */
- (void)deleteMissionComment:(NSString *)schId
                andCommentId:(NSString *)commentId block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_MISSION_COMMENT_DELETE];
    NSDictionary *parameters = @{@"scheduleId": schId, @"id": commentId};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

/**推广
 * 活动邀请 列表
 *
 *@params offset 获取信息量长度
 *@params lastTimestamp 最后一个数据的最后更新时间
 */
- (void)queryPromotionEventsInvitationList:(NSInteger)offset andLastTimestamp:(NSInteger)lastTimestamp block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_PROMOTION_EVENTINVITATION_LIST];
    //    NSDictionary *parameters = @{@"offset": offset, @"lastTimeStamp": lastTimestamp};
    QueryPromotionListPostModel *model = [[QueryPromotionListPostModel alloc] init];
    model.offset = offset;
    model.lastTimeStamp = lastTimestamp;
    [manager POST:apiUrl.absoluteString parameters:model.mj_keyValues success:^(NSURLSessionTask *task, id responseObject) {
        //SMLog(@"活动邀请：%@",responseObject);
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            NSArray *datas = [PromotionMaster mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
            block(datas, nil);
            
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}


/**推广
 * 拼团促销 列表
 *
 *@params offset 获取信息量长度
 *@params lastTimestamp 最后一个数据的最后更新时间
 */
- (void)queryPromotionGroupBuyingList:(NSInteger)offset andLastTimestamp:(NSInteger)lastTimestamp block:(ResultBlock)block {
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_PROMOTION_GROUPBUYING_LIST];
    //    NSDictionary *parameters = @{@"offset": offset, @"lastTimeStamp": lastTimestamp};
    QueryPromotionListPostModel *model = [[QueryPromotionListPostModel alloc] init];
    model.offset = offset;
    model.lastTimeStamp = lastTimestamp;
    [manager POST:apiUrl.absoluteString parameters:model.mj_keyValues success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        SMLog(@"responseObject   queryPromotionGroupBuyingList  %@",responseObject);
        if (STATUS_OK == [status intValue]) {
//            NSArray *datas = [GroupBuyMaster mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"result"]];
//            block(datas, nil);
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

- (void)querySeckillList:(NSInteger)offset andLastTimestamp:(NSInteger)lastTimestamp block:(ResultBlock)block{
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_SECKILL_LIST];
    NSDictionary *parameters = @{@"lastTimeStamp":[NSNumber numberWithInteger:lastTimestamp], @"offset":[NSNumber numberWithInteger:offset]};
    
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]) {
            block(responseObject, nil);
        } else if ([status intValue] == 401){//重启了服务器
            [self relist];
        } else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil, error);
    }];
}

//查看海报列表    传参:companyId 企业ID  ，page 页数  ，size 数量  ，type 传入 1  （type为强制传1，且必须要传）
- (void)queryPosterListWithCompanyId:(NSString *)companyId page:(NSInteger)page andSize:(NSInteger)size andType:(NSInteger)type block:(ResultBlock)block{
    if (companyId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_POSTER_LIST];
    NSDictionary *parameters = @{@"companyId": companyId, @"page": [NSString stringWithFormat: @"%ld", page] , @"size": [NSString stringWithFormat: @"%ld", size],@"type":[NSString stringWithFormat:@"%zd",type]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]){
            //SMLog(@"海报列表 responseObject = %@",responseObject);
            NSArray *arr = [SMPosterList mj_objectArrayWithKeyValuesArray:[[responseObject valueForKey:@"result"] valueForKey:@"result"] ];
            block(arr,nil);
        }else if ([status intValue] == 401){//重启了服务器
            [self relist];
        }else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }      
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil,error);
    }];
    
}


//查看微文    传参:companyId 企业ID  ，page 页数  ，size 数量 
- (void)queryArticleListWithCompanyId:(NSString *)companyId page:(NSInteger)page andSize:(NSInteger)size block:(ResultBlock)block{
    if (companyId == nil){
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_ARTICLE_LIST];
    NSDictionary *parameters = @{@"companyId": companyId, @"page": [NSString stringWithFormat: @"%ld", page] , @"size": [NSString stringWithFormat: @"%ld", size]};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]){
            //SMLog(@"文章列表 responseObject = %@",responseObject);
            block(responseObject,nil);
        }else if ([status intValue] == 401){//重启了服务器
            [self relist];
        }else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil,error);
    }];
    
}


- (void)getWeiXinQrcodeWithCompanyId:(NSString *)companyId userIdStr:(NSString *)userIdStr block:(ResultBlock)block{
    if (companyId == nil || userIdStr == nil) {
        SMLog(@"传进来的参数为空，此接口直接返回，请先检查参数是否正确");
        return;
    }
    
    NSURL *apiUrl = [self fullApiPathWithSuffix:SKAPI_QRCODE_CREAT];
    NSDictionary *parameters = @{@"companyId": companyId,@"scene_str":userIdStr};
    [manager POST:apiUrl.absoluteString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *status = [responseObject valueForKey:@"status"];
        if (STATUS_OK == [status intValue]){
            NSString *ticket = [[[responseObject valueForKey:@"result"] valueForKey:@"ticket_info"] valueForKey:@"ticket"];
            SMLog(@"ticket %@",ticket);
            block(ticket,nil);
        }else if ([status intValue] == 401){//重启了服务器
            [self relist];
        }else {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:SK_ERROR_DOMAIN code:[status intValue] userInfo:userInfo];
            
            block(nil, error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
            [self relist];
        }
        block(nil,error);
    }];
    
}

@end
