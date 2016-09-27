//
//  SKAPI.h
//  ShuangKuai-iOS
//
//  Created by liyongjie on 12/3/15.
//  Copyright © 2015 com.shuangkuaimai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "User.h"
#import "News.h"
#import "Company.h"
#import "Product.h"
#import "WorkLog.h"
#import "Activity.h"
#import "Customer.h"
#import "Schedule.h"
#import "Favorites.h"
#import "Commission.h"
#import "SalesOrder.h"
#import "OrderProduct.h"
#import "StorageProduct.h"
#import "Ad.h"
#import "MapLocation.h"
#import "Tweet.h"
#import "TweetComment.h"
#import "BankCard.h"
#import "CommissionLog.h"
#import "Coupon.h"
#import "FavoritesDetail.h"
#import "Cart.h"
#import "Msg.h"
#import "Bonus.h"
#import "ProductSpec.h"
#import "ScheduleDetail.h"
#import "PushModel.h"
#import "RecentSalesOrder.h"
#import "Information.h"
#import "Tag.h"
#import "GroupBuyMaster.h"
#import "QueryPromotionListPostModel.h"
#import "PromotionMaster.h"
#import "SMSeckill.h"
#import "SMPosterList.h"

//#define SKAPI_PREFIX                           @"http://www.shuangkuai.co:1224/api/"
//#define SKAPI_PREFIX                           @"http://www.shuangkuai.co:1224/api/"
//#define SKAPI_PREFIX                           @"http://www.shuangkuai.co:1234/api/"
//#define SKAPI_PREFIX                           @"http://120.76.156.35:8080/api/"


//#define SKAPI_PREFIX                           @"http://test.shuangkuai.co:8080/api/"
//#define SKAPI_PREFIX_SHARE                           @"http://m.shuangkuai.co/shuangkuai_app/"


//#define SKAPI_PREFIX_SHARE                           @"http://m.shuangkuai.co/shuangkuai_app/"
#define SKAPI_FOOTER_SHARE @"sk_product_detail.html";

@interface SKAPI : UIView

typedef void (^UserResultBlock)(User *user, NSError *error);
typedef void (^CompanyResultBlock)(Company *company, NSError *error);
typedef void (^ProductResultBlock)(Product *product, NSError *error);
typedef void (^NewsResultBlock)(News *news, NSError *error);
typedef void (^ActivityResultBlock)(Activity *activity, NSError *error);
typedef void (^FavoritesResultBlock)(Favorites *fav, NSError *error);
typedef void (^ResultBlock)(id result, NSError *error);
typedef void (^ArrayBlock)(NSArray *array, NSError *error);

@property(nonatomic ,strong)AFHTTPSessionManager *sessionManager;

/**
 全部产品界面的排序
 */
typedef enum {
    SortType_Default, //默认
    SortType_Price_Asc, //价格从小到大
    SortType_Price_Desc, //价格从大到小
    SortType_Sales, //销量
    SortType_Commission_Asc,//佣金从小到大
    SortType_Commission_Desc, //佣金从大到小
    SortType_Commission_News //新品
} PRODUCT_SORT_TYPE;

/**
 全部产品界面的排序
 */
typedef enum {
    Type_Product, //产品
    Type_Activity, //活动
    Type_Coupon //优惠券
} FOLLOW_TYPE;

+ (id)shared;

- (void)appendToken;

- (void)resetting;

//登陆  account  openID   password  token   social   @"wechat"
- (void)signInWithAccount:(NSString *)account andPassword:(NSString *)password
                andSocial:(NSString *)social block:(ResultBlock)block;

//重新登录获取token
- (void)relist;

//注册
- (void)signUpWithAccount:(NSString *)account andPassword:(NSString *)password andVerifyCode:(NSString *)verifyCode block:(UserResultBlock)block;

//手机请求验证码  注册
- (void)smsRequestVerifyWithPhone:(NSString *)phone block:(ResultBlock)block;

//手机请求验证码  忘记密码
- (void)forgetSecretWithPhone:(NSString *)phone block:(ResultBlock)block;

//验证码校验
- (void)smsVerifyWithPhone:(NSString *)phone andVefifyCode:(NSString *)verifyCode block:(ResultBlock)block;

//退出账号
- (void)signOut:(ResultBlock)block;

//更新头像
- (void)updatePortrait:(UIImage *)portrait block:(ResultBlock)block;

//修改密码
- (void)changePassword:(NSString *)oldPassword andNewPassword:(NSString *)newPassword block:(ResultBlock)block;


//打卡签到
- (void)pounchIn:(NSString *)address block:(ResultBlock)block;

//打卡历史记录
- (void)queryPounchinByPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block;



//查询企业数据列表 name 可以为nil page 页数 size 每页个数
- (void)queryCompanyByName:(NSString *)name isRecommend:(BOOL)isRecommend andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block;

//查询企业详细资料 企业内部唯一标识   暂时可不用
- (void)queryCompanyById:(NSString *)id block:(CompanyResultBlock)block;

//查询产品数据列表 name可以为nil page 页数 size 每页大小  Recommend 1就是推荐商品，0是普通商品
- (void)queryProductByName:(NSString *)name andPage:(NSInteger)page andSize:(NSInteger)size andSortType:(PRODUCT_SORT_TYPE)sortType andClassId:(NSString *)classId andIsRecommend:(NSInteger)isRecommend block:(ArrayBlock)block;

//查询产品详细资料 产品内部唯一标识
- (void)queryProductById:(NSString *)id block:(ProductResultBlock)block;

//查询企业的新闻 companyId企业内部唯一标识 page 页数 size 每页大小
- (void)queryNewsByCompanyId:(NSString *)companyId andKeyword:(NSString *)keyword andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block;

//查询新闻详细数据 新闻数据内部唯一标识
- (void)queryNewsById:(NSString *)newsId block:(NewsResultBlock)block;

//*************//
//查询活动列表数据，通过企业唯一标识 page 页数 size 每页大小
- (void)queryActivityByCompanyId:(NSString *)companyId andKeyword:(NSString *)keyword andIsRecommend:(BOOL)bRecommend andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block;

//查询活动详细，通过活动唯一标识
- (void)queryActivityById:(NSString *)activityId block:(ActivityResultBlock)block;



//创建日程保存到服务器端
- (void)createSchedule:(Schedule *)customer block:(ResultBlock)block;

//个人日程记录list
- (void)queryScheduleByPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block;



/******************* 微货架相关接口  *******************/
//查询个人微货架列表
- (void)queryStorage:(ArrayBlock)block;

//删除个人中心我的微货架模板 传id 删除模板后则整个微货架里收藏的东西都会被删除
- (void)deleteStorage:(NSMutableArray *)favId block:(ResultBlock)block;

//添加产品到我的微货架 will delete don't use
//- (void)addProduct:(NSString *)productId toMyStorage:(NSString *)favId block:(ResultBlock)block;

//查找我指定微货架里收藏的产品 favId 微货架的id will delete don't use
//- (void)queryMyProductByFavId:(NSString *)favId block:(ArrayBlock)block;

//从微货架中删除我收藏的产品 will delete , don't use   不用了
- (void)deleteMyProduct:(NSString *)detailId block:(ResultBlock)block;

//创建微货架模板 name模板名 will delete, don't use
- (void)createStorage:(NSString *)name block:(ResultBlock)block;

////更新微货架模板 name模板名 will delete, don't use
//- (void)updateStorage:(NSString *)name block:(ResultBlock)block;

//保存一系列货架的东东进来   名字直接传 @""
- (void)createItem2MyStorage:(NSString *)favId andName:(NSString *)name andProductIds:(NSArray *)productIds
              andActivityIds:(NSArray *)activityIds andCouponIds:(NSArray *)couponIds block:(ResultBlock)block;

//itemId 产品id/活动id/优惠券id的数组 favId 货架模板id type 0产品 1活动 2优惠券，用于告诉服务器删除的id数组是产品
- (void)deleteMyStorageItems:(NSArray *)itemIds andFavId:(NSString *)favId andType:(NSInteger)type block:(ResultBlock)block;

//批量删除我微货架里的东东的id array    没用的
- (void)deleteMyStorageItems:(NSArray *)ids block:(ResultBlock)block;

//查个人某个指定的微货架模板里的所有东东
- (void)queryMyStorageItems:(NSString *)favId block:(ArrayBlock)block;

//添加东东到我的微货架模板里 objectId添加的东东的id  favId我的微货架模板id type类型0产品、1活动、2优惠
- (void)addItem:(NSString *)itemId toMyStorage:(NSArray *)favIds andType:(int)type block:(ResultBlock)block;
//从多个模板中删除某个东东 itemId可以是产品id/活动id/优惠券id type类型0产品、1活动、2优惠 favIds模板id数组
- (void)removeItem:(NSString *)itemId fromMyStorage:(NSArray *)favIds andType:(int)type block:(ResultBlock)block;

/**********************微推广相关接口******************************/


//删除个人中心我的微推广模板 传id
- (void)deletePromotion:(NSString *)favId block:(ResultBlock)block;

//添加活动到我的微推广
- (void)addActivity:(NSString *)activityId toMyPromotion:(NSString *)favId block:(ResultBlock)block;

//创建微推广模板 name模板名
- (void)createPromotion:(NSString *)name block:(ResultBlock)block;

//查询个人微推广列表
- (void)queryPromotion:(ArrayBlock)block;




/**********************  佣金相关接口   ******************************/
//获取佣金结算里面佣金记录
- (void)queryCommissionByYear:(NSString *)year andMonth:(NSString *)month block:(ArrayBlock)block;

//提取佣金
- (void)fetchCommission:(double)commission andBackCard:(NSString *)bankCard block:(ResultBlock)block;





//企业 传一个企业id
- (void)followCompany:(NSString *)companyId andType:(NSInteger)type block:(ResultBlock)block;

//查询活动详细，通过活动唯一标识
- (void)queryActivitysByPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block;

//查询订单 sn订单号 sn传nil或""返回自己的所有订单
- (void)queryOrderBySn:(NSString *)sn andStatus:(NSInteger)status andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block;

//查询订单 sn订单号 sn传nil或""返回自己的所有订单,根据type字段返回不同的订单信息
- (void)queryOrderBySn:(NSString *)sn andStatus:(NSInteger)status andType:(NSInteger)type andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block;

//查询订单明细数据 传orderid或sn订单编号都可
- (void)queryOrder:(NSString *)orderIdOrSn block:(ResultBlock)block;

//查询伙伴关注的企业 未实现
- (void)queryMyFollowCompanyByUserId:(NSString *)userId andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block;









//修改姓名
- (void)changeMyName:(NSString *)name block:(ResultBlock)block;

//查询我关注的企业
- (void)queryMyFollowCompany:(NSString *)userId block:(ArrayBlock)block;

//首页轮播广告
- (void)queryAd:(ArrayBlock)block;

/**
 * 修改用户资料
 * @param userProfile 用户资料
 * 修改哪些资料往dictory里添加，可同时改多个
 * 修改名字传           NSDictionary *parameters = @{@"name": @"张三"};
 * 修改简介传           @{@"intro": @"我是一只小小小小鸟"};
 * 修改性别传           @{@"gender": @"1"}; 1男 2女
 * 修改所在地址传        @{@"address": @"广州保利中汇"};
 * 修改所在公司传       @{@"companyName": @"广州宇中网络科技有限公司"}
 * 修改固定电话传      @{@"telephone": @"18947859689"}
 * 修改行业分类资料      @{@"induTag": @"xxx"}
 * 修改工作号码
 */
- (void)editProfile:(NSDictionary *)profileDic block:(ResultBlock)block;

//查出某用户关注了的企业 userId 用户id
- (void)queryUserFollowCompany:(NSString *)userId andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block;

//根据经纬度查周围建筑
- (void)queryMapAround:(NSString *)location block:(ArrayBlock)block;


//根据城市、关键字查询周围建筑
- (void)queryMapKeyword:(NSString *)keyword andCity:(NSString *)city andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block;



/********************   爽快圈  *************************/
//爽快圈发表说说   datas 数组里面装的是 UIImage 类型数据
- (void)publishTweet:(NSString *)content andLocation:(NSString *)location andDatas:(NSArray *)datas block:(ResultBlock)block;

//删除我的说说
- (void)deleteMyTweet:(NSInteger)tweetId block:(ResultBlock)block;

//查看爽快圈 userId 为nil或""时查看所有 userId不为空时，查userId下的爽快圈内容
- (void)queryTweet:(NSString *)userId andKeyword:(NSString *)keyword andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block;

//查看某一条爽快圈
- (void)queryTweet:(NSInteger)tweetId block:(ResultBlock)block;

/**
 *  发表说说的评论
 *
 *  @param tweetId     每条微博对应的id
 *  @param content     评论内容
 *  @param toCommentId 每条评论对象对应的id （评论别人的评论  如果不是评论别人 则传@""）
 *  @param atUserId    在评论别人时，传别人的id（如果不是评论别人 则传@""）
 *  @param block
 */
- (void)commentTweet:(NSInteger)tweetId andContent:(NSString *)content andToCommentId:(NSString *)toCommentId
         andAtUserId:(NSString *)atUserId block:(ResultBlock)block;

//删除我发表的评论
- (void)deleteMyComment:(NSInteger)commentId andTweetId:(NSInteger)tweetId block:(ResultBlock)block;

//查看说说的评论数据
- (void)queryTweetComment:(NSInteger)tweetId block:(ArrayBlock)block;

//点赞  tweetId当前微博id   upvote  0是取消  1是点
- (void)upvoteTweet:(NSInteger)tweetId upvote:(NSInteger)upvote block:(ResultBlock)block;

//转发  tweetId－> tweet里面的 id 属性  ， content －>转发时，附带写上去的那句话
- (void)repostTweet:(NSInteger)tweetId andContent:(NSString *)content block:(ResultBlock)block;

//查用户资料
- (void)queryUserProfile:(NSString *)userId block:(ResultBlock)block;





//查我绑定了哪些银行卡  支付宝
- (void)queryCard:(NSInteger)type block:(ArrayBlock)block;

////绑定银行卡
//- (void)bindCard:(NSString *)bandCard andIdCard:(NSString *)idCard andName:(NSString *)name block:(ResultBlock)block;

//绑定银行卡 新加支付宝后 更改的
- (void)bindCard:(NSString *)bandCard andIdCard:(NSString *)idCard andName:(NSString *)name andSubBank:(NSString *)subBank type:(NSInteger)type block:(ResultBlock)block;

//解除我的银行卡 //类型 1银行卡 2 支付宝
- (void)unbindCard:(NSString *)bandCard andType:(NSInteger)type block:(ResultBlock)block;

//绑定支付宝
- (void)bindAlipayAcount:(NSString *)acount userName:(NSString *)userName block:(ResultBlock)block;

//查我的佣金提现记录
- (void)queryCommissionLogByPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block;

//修改佣金密码
- (void)modifyCommissionPwd:(NSString *)encCommissionPwd block:(ResultBlock)block;

//校验佣金密码
- (void)verifyCommissionPwd:(NSString *)encCommissionPwd block:(ResultBlock)block;

//获取我的佣金统计数据
- (void)queryCommissionProfile:(ResultBlock)block;

//查询优惠券 code优惠券码
- (void)queryCoupon:(NSString *)code block:(ResultBlock)block;

//使用优惠券 code优惠券码
- (void)useCoupon:(NSString *)code block:(ResultBlock)block;

//查询优惠券活动
- (void)queryCompanyId:(NSString *)companyId andKeyword:(NSString *)keyword andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block;

//查看海报列表    传参:companyId 企业ID  ，page 页数  ，size 数量  ，type 传入 1  （type为强制传1，且必须要传）
- (void)queryPosterListWithCompanyId:(NSString *)companyId page:(NSInteger)page andSize:(NSInteger)size andType:(NSInteger)type block:(ResultBlock)block;
//查看微文    传参:companyId 企业ID  ，page 页数  ，size 数量
- (void)queryArticleListWithCompanyId:(NSString *)companyId page:(NSInteger)page andSize:(NSInteger)size block:(ResultBlock)block;

//根据id数组查 产品/活动/优惠券 数据数组
- (void)queryObject:(NSArray *)ids andType:(FOLLOW_TYPE)type block:(ResultBlock)block;


//查我的朋友或通讯录   keyword:自己好友或者通讯录中的好友名字，或者电话,如果传空字符串，就是察看自己所有的好友列表
- (void)queryFriend:(NSString *)keyword block:(ArrayBlock)block;

//查询伙伴连线的爽快消息
- (void)querySystemMessageblock:(ArrayBlock)block;

//添加朋友 friendId 对方的userid(uuid);  memo保留字，以后用于添加朋友后给其加备注名(后台暂时没做处理，可以直接传空字符串); status 1添加为朋友 0解除朋友状态 ;
- (void)acceptFriend:(NSString *)friendId andMemo:(NSString *)memo andStatus:(NSInteger)status block:(ResultBlock)block;


//只显示本月冠军本周本日的销售达人
- (void)queryChampion:(ArrayBlock)block;
//销售达人排行榜 type = 2本月 1本周 0本日

- (void)queryRanking:(NSInteger)type block:(ArrayBlock)block;
//通过产品id/优惠券id/活动id 反查所在哪些模板上，并显示模板名、模板中当前产品数/活动数/优惠券数
- (void)queryStorageByItem:(NSString *)itemId block:(ArrayBlock)block;
//保持和服务器通信调用的方法，最好构建定时器每20分钟保持和服务器通信，以维持session有效状态
//- (void)tokenRefresh:(ResultBlock)block;
- (void)tokenRefresh:(NSString *)refreshToken result:(ResultBlock)block;

//关闭订单
- (void)closeOrder:(NSString *)orderId block:(ResultBlock)block;
//完成订单
- (void)finishOrder:(NSString *)orderId block:(ResultBlock)block;

//查用户数据库 keyword 好友手机号或好友名
- (void)queryUser:(NSString *)keyword andPage:(NSInteger)page andSize:(NSInteger)size block:(ArrayBlock)block;
//查快递的数据
- (void)kuaidiQuery:(NSString *)nu andCom:(NSString *)com block:(ResultBlock)block;

- (void)modifyPassword:(NSString *)password block:(ResultBlock)block;

//返回行业分类的数据
- (void)queryInduTags:(ResultBlock)block;
//查询跟踪信息
- (void)queryOrderTrackInfoById:(NSString *)orderId block:(ResultBlock)block;
//填充跟踪信息
- (void)fillOrderTrackInfo:(NSString *)orderId andContent:(NSString *)content block:(ResultBlock)block;

//从优惠券中随机获取一张优惠码 masterId优惠券主表的的id
- (void)shareCoupon:(NSString *)masterId block:(ResultBlock)block;

- (void)removeOrderTrackInfoById:(NSInteger)trackId andOrderId:(NSString *)orderId block:(ResultBlock)block;

//结算接口 buyerName买家姓名  buyerPhone买家手机号  address买家地址   buyerTel买家电话号  memo留言  productIds要结算的产品的id,


//放要买的东西到购物车   productId 产品id    amount产品数量
- (void)putCartByProductId:(NSString *)productId andAmount:(NSInteger)amount block:(ResultBlock)block;

//查我的购物车的东东
- (void)queryMyCart:(ResultBlock)block;

/**
 * 计算购物车里的价格
 * @param ids 购物车里的东东的id数组
 * 接收参数类型List，List里装有的map，map里包括productId, amount, selected三个key productId产品的id, amount数量 selected是否选中 1选中0未选
 * 例：[{"productId":"1","amount":1,"selected":1},{"productId":"2","amount":1,"selected":1}
 * 				  ,{"productId":"3","amount":1,"selected":1},{"productId":"4","amount":10,"selected":0}]
     isCalcSf  确认支付界面传yes  购物车界面传 no
 */
- (void)calculateMyCartItems:(NSArray *)itemsInfo andIsCalcSf:(BOOL)isCalcSf block:(ResultBlock)block;

//删除购物车里的东东 ids 购物车里的东东的id数组
- (void)removeMyCartItem:(NSArray *)ids block:(ResultBlock)block;

//调用pingpp的支付请求功能 orderNo 订单编号
- (void)pingppCharge:(NSString *)orderNo andChannel:(NSString *)channel block:(ResultBlock)block;

//获取本月销售额，本月待审核佣金、本月已发放佣金、本月佣金、上月佣金
- (void)queryCommission:(ResultBlock)block;

//绑定clientId
- (void)bindClientId:(NSString *)clientId block:(ResultBlock)block;

//忘记密码中的修改密码
- (void)forgetPasswordModify:(NSString *)password block:(ResultBlock)block;

//填写意见反馈
- (void)writeFeedback:(NSString *)content block:(ResultBlock)block;

//同意协议的接口
- (void)agreement:(ResultBlock)block;

//查询奖金接口 offset要取的数据大小，比如只取10条，则填10。lastTimestamp最后一条记录的时间戳，第一次取可以不传
- (void)queryBonus:(NSString *)yearMonth andOffset:(NSInteger)offset andLastTimestamp:(NSInteger)lastTimestamp block:(ResultBlock)block;

//查询消息接口 offset要取的数据大小，比如只取10条，则填10。lastTimestamp最后一条记录的时间戳，第一次取可以不传
- (void)queryMsg:(NSInteger)offset andLastTimestamp:(NSInteger)lastTimestamp block:(ResultBlock)block;

//上传图片返回一个token
- (void)uploadPic:(UIImage *)uploadImage block:(ResultBlock)block;

//@param extra 特殊商品要传的值，暂时先处理电信的
//              extra.put("doc1_token", "xx")//正面照
//              extra.put("doc2_token", "xx")//反面照
//              extra.put("doc3_token", "xx")//手持照
//              extra.put("idCard", "xx")//身份证号，最好加密
//              extra.put("real_name", "xx")//姓名
//              extra.put("phone", "xxxx")//手机号
- (void)settleOrderByBuyer:(NSString *)buyerName
             andBuyerPhone:(NSString *)buyerPhone
                andAddress:(NSString *)address
               andBuyerTel:(NSString *)buyerTel
                   andMemo:(NSString *)memo
             andProductIds:(NSArray *)productIds
                 andAmount:(NSNumber *)amount
                  andExtra:(NSDictionary *)extra
                     block:(ResultBlock)block;

/*
 返回，把用户选择的商品规格以 @"xxx/xxxx/xxxx"格式返回给后台
 * 查某个产品下的规格，并返回库存、产品规格对应的价格、产品规格id(可理解为实际也是产品id)、
 * specName 规格名
 * productId 产品id
 *
 */
- (void)queryProductSpec:(NSString *)productId andSpecName:(NSString *)specName block:(ResultBlock)block;


//查出产品分类
- (void)queryProductClass:(ResultBlock)block;

//获取我的团队列表
- (void)queryMyTeamList:(ResultBlock)block;


/*
 * 电信选号
 * productId 产品id
 * keyword 模糊搜索关键字，用来查号码
 */
- (void)queryPhoneListByPage:(NSInteger)page andSize:(NSInteger)size andProductId:(NSString *)productId andKeyword:(NSString *)keyword block:(ResultBlock)block;

//查询合伙人详情
- (void)queryTeammateInfoByUserId:(NSString *)userId block:(ResultBlock)block;

//添加朋友
- (void)addFriend:(NSString *)uid andRemark:(NSString *)remark block:(ResultBlock)block;

- (void)queryOfflineMessages:(ResultBlock)block;

- (void)receiptMessage:(NSArray *)messageIds block:(ResultBlock)block;
//爽快消息
- (void)queryFriendMessages:(ResultBlock)block;

//登录时绑定手机号
- (void)bindAccountByPhone:(NSString *)phone andOpenId:(NSString *)openId andAccessToken:(NSString *)accessToken andVerifyCode:(NSString *)verifyCode block:(ResultBlock)block;
//
- (void)queryStorageList:(ResultBlock)block;

//改柜台名字和图片
- (void)updateStorage:(NSString *)name andFavId:(NSString *)favId andImageToken:(NSString *)imageToken block:(ResultBlock)block;


#pragma mark - 客户信息
//创建客户信息保存到服务器端
- (void)createCustomer:(Customer *)customer block:(ResultBlock)block;

//修改客户详情
- (void)updateCustomer:(Customer *)customer block:(ResultBlock)block;

//删除客户
- (void)deleteCustomer:(NSString *)customerId block:(ResultBlock)block;

//查看客户详情   //返回两组信息。 一组是
- (void)queryCustomerDetail:(NSString *)customerId block:(ResultBlock)block;

//搜索客户   offset要拿多少条数据
//- (void)queryCustomer:(NSString *)name andGrade:(NSInteger)grade andStatus:(NSInteger)status andLastTimeStamp:(NSInteger)lastTimeStamp andOffset:(NSInteger)offset block:(ResultBlock)block;

// name 名字    rating 意向等级  012分别代表ABC  level 客户等级      target标签  lastTimeStamp 最后一条数据的时间戳  offset 拿多少条  type 订单数量排序，0是从大到小，1是从小到大(老客户才有订单排序，新客户直接传-1)
- (void)queryCustomer:(NSString *)name
         andBuyRating:(NSInteger)buyRating
             andLevel:(NSInteger)level // 值 vip,大型客户,中型客户,小型客户 0,1,2,3
            andTarget:(NSString *)target //分隔符","
     andLastTimeStamp:(NSInteger)lastTimeStamp //时间戳
            andOffset:(NSInteger)offset //单次最大数据量
              andType:(NSInteger)type //type 订单数量排序，0是从大到小，1是从小到大(老客户才有订单排序，新客户直接传-1)
                block:(ResultBlock)block;

//评论某条客户 customerId 客户数据的id content 评论内容
- (void)writeCommentByCustomerId:(NSString *)customerId andContent:(NSString *)content block:(ResultBlock)block;

//删除用户的某条评论 customerId 客户数据的id  评论的id
- (void)deleteCommentByCustomerId:(NSString *)customerId andLogId:(NSString *)logId block:(ResultBlock)block;

#pragma mark - 群聊

/**
 *创建群
 * intro 简介
 * imageToken 图片token
 * groupName 群名
 * userIds 要拉进群的用户id
 */
- (void)createGroup4IM:(NSString *)intro andImageToken:(NSString *)imageToken andGroupName:(NSString *)groupName andUserIds:(NSArray *)userIds block:(ResultBlock)block;
//查群列表
- (void)queryGroupList4IM:(ResultBlock)block;
//查群的详细信息 more true获取更多
- (void)queryGroupDetail4IM:(NSString *)groupId more:(bool)more block:(ResultBlock)block;
//加入群
- (void)joinGroup4IM:(NSString *)groupId andGroupName:(NSString *)groupName andUserIds:(NSArray *)userIds block:(ResultBlock)block;
//查找群成员
- (void)findFriend4IM:(NSString *)name block:(ResultBlock)block;
//退出群 传组id
- (void)quitGroup4IM:(NSString *)groupId block:(ResultBlock)block;
//解散群 传组id
- (void)dismissGroup4IM:(NSString *)groupId block:(ResultBlock)block;
//删除群成员 组id 用户id 数组
- (void)deleteMember4IM:(NSString *)groupId andUserIds:(NSArray *)userIds block:(ResultBlock)block;


/**
 * 设置物流
 * orderId 订单id
 * shippingFee 物流费用
 * 修改后会返回计算后的应付金额
 * 不需要物流 直接传0
 */
- (void)settingLogistics:(NSString *)orderId andShippingFee:(NSNumber *)shippingFee block:(ResultBlock)block;

/**
 * 修改订单价格
 * orderId 订单id
 * money 要修改的订单应付金额
 * 修改后会返回计算后的订单佣金
 * 应付金额调整数最低位 调用queryMinPayMoney 查看
 */
- (void)adjustOrderPayMoney:(NSString *)orderId andMoney:(NSNumber *)money block:(ResultBlock)block;

/**
 * 查看应付金额可调整的最低值
 */
- (void)queryMinOrderPayMoney:(NSString *)orderId block:(ResultBlock)block;

// 发货提醒
- (void)remindOrder:(NSString *)orderId block:(ResultBlock)block;

/**
 *  群组设置 修改群备注 消息免打扰
 *
 *  @param groupId
 *  @param status  0是屏蔽，1是接收
 *  @param remark  群备注
 *  @param block   返回结果
 */
- (void)settingGroup:(NSString *)groupId andMessageStatus:(NSInteger)status andRemark:(NSString *)remark block:(ResultBlock)block;

//消息免打扰
- (void)settingGroup:(NSString *)groupId andMessageStatus:(int)status block:(ResultBlock)block;

/**
 *  修改群组信息 roomName群名 intro 简介 imageToken上传的群的图片的token userIds组员id
 *
 *  @param groupId    groupId
 *  @param roomName   群名
 *  @param intro      群简介
 *  @param imageToken 上传的群的图片的token,如果不改图片就直接传nil
 *  @param userids    userids
 *  @param block      返回值
 */
- (void)updateGroup:(NSString *)groupId andRoomName:(NSString *)roomName
           andIntro:(NSString *)intro andImageToken:(NSString *)imageToken block:(ResultBlock)block;

/**
 *  修改群头像
 *
 *  @param groupId    groupId
 *  @param imageToken 上传的群的图片的token,如果不改图片就直接传nil
 */
- (void)updateGroup:(NSString *)groupId imageToken:(NSString *)imageToken block:(ResultBlock)block;

/**
 *  首页最上面的统计数据，今日收入，今日订单等等统计数据
 *
 *  @param types
 *  @param block
 */
- (void)queryDataStatistics:(NSArray *)types block:(ResultBlock)block;

/**
 *  新版首页最上面的统计数据，今日收入，本周收入等等统计数据
 *
 *  @param types
 *  @param block
 */
- (void)queryHomeSection0DataWithUserId:(NSString *)userId block:(ResultBlock)block;

//查客户订单 通过手机号
- (void)queryCustomerOrderByPhone:(NSString *)phone block:(ResultBlock)block;

//删除标签   name 传对应标签的id
- (void)deleteTag:(NSString *)targetId block:(ResultBlock)block;
//通过标签查客户 name 标签名 （传空 就是查询所有标签）
- (void)queryCustomerTagByName:(NSString *)name block:(ResultBlock)block;
//添加客户标签
- (void)addTag:(NSString *)tagName block:(ResultBlock)block;

- (void)shoppingShareType:(ResultBlock)block;




/*添加新任务日程
 *字典里传 title 标题
 *      remark 备注
 *      schTime 日程时间
 *      //remindTime 提醒时间
 *      //status 状态
 *      //remindType 提醒类型
 *      //type 日程类型
 *      users 参数类型数组array  数组内部元素 是参与人id 的字符串
        fatherId 父任务的id  //父任务Id 只有在操作子任务的时候才传。 在操作父任务的时候，千万不要传父任务id
 */
- (void)addMission:(NSDictionary *)missionINfo block:(ResultBlock)block;

/**
 * 发布任务 对参与人进行推送
 */
- (void)publishMission:(NSString *)missionId block:(ResultBlock)block;



/*修改任务日程
 *字典里传
 *      id 服务器返回的日程的id(当前任务的id,)
 *      title 标题
 *      remark 备注
 *      schTime 日程时间
 *      //remindTime 提醒时间
 *      //status 状态
 *      //remindType 提醒类型
 *      //type 日程类型
 *      users 选择的团队人的用户id，多个人以","隔开
 *      fatherId 父任务的id
 */
- (void)updateMission:(NSDictionary *)missionINfo block:(ResultBlock)block;

/*
 * 删除任务日程
 * schId 日程id
 */
- (void)deleteMission:(NSString *) schId block:(ResultBlock)block;

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
- (void)queryMissionList:(NSString *)type andOffset:(NSInteger)offset andLastTimestamp:(NSString *)lastTimestamp andStatus:(NSString *)status andKeyword:(NSString *)keyword block:(ResultBlock)block;
/*
 * 获取任务日程详情
 * schId 日程id
 */
- (void)queryMission:(NSString *)schId block:(ResultBlock)block;

/*
 * 接收任务
 * schId 日程id
 */
- (void)receiveMission:(NSString *)schId block:(ResultBlock)block;

/*
 * 添加任务日程的评论
 * scheId 任务的id
 * content 评论内容
 * type 类型
 *
 */
- (void)addMissionComment:(NSString *)schId andContent:(NSString *)content
                  andType:(NSInteger)type block:(ResultBlock)block;

/*
 * 删除任务日程评论
 * schId 任务的id
 * commentId 评论id
 *
 */
- (void)deleteMissionComment:(NSString *)schId
                andCommentId:(NSString *)commentId block:(ResultBlock)block;

//将任务修改完成 missionId 任务的id
- (void)accomplishMission:(NSString *)missionId block:(ResultBlock)block;




/**推广
 *  活动邀请 列表
 */
- (void)queryPromotionEventsInvitationList:(NSInteger)offset andLastTimestamp:(NSInteger)lastTimestamp block:(ResultBlock)block;

/**推广
 * 拼团促销 列表
 */
- (void)queryPromotionGroupBuyingList:(NSInteger)offset andLastTimestamp:(NSInteger)lastTimestamp block:(ResultBlock)block;

/**推广
 * 秒杀 列表
 */
- (void)querySeckillList:(NSInteger)offset andLastTimestamp:(NSInteger)lastTimestamp block:(ResultBlock)block;

- (void)getWeiXinQrcodeWithCompanyId:(NSString *)companyId userIdStr:(NSString *)userIdStr block:(ResultBlock)block;

@end
