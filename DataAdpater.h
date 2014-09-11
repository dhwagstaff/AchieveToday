//
//  DataAdpater.h
//  Seying
//
//  Created by Fish on 13-1-15.
//  Copyright (c) 2013年 Fish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
//#import "ASIFormDataRequest.h"
#import "DataDef.h"
#import <AddressBookUI/AddressBookUI.h>

//退出时间提醒
#define NOUSE_NOTI 259200
//订单重试次数
#define ORDER_RETRY_COUNT 8

//#define BASE_URL @"http://jrc.hutudan.com/vshore/"
#define BASE_URL @"http://victoryshore.com/vshore/"

#define RES_OK    1
#define RES_FAIL  0
#define RES_EXITLOGIN -1

//命令字
//注册
#define CMD_SIGNUP  0x01
#define URL_SIGNUP  @"signup.php"
#define POST_SIGNUP @"name=%@&pwd=%@&email=%@&sc=%@&cu=%@wp=%@"

//确认邮箱
#define CMD_CONFIRMEMAIL  0x02
#define URL_CONFIRMEMAIL  @"confirm_email.php"
#define POST_CONFIRMEMAIL @"email=%@&code=%@&src=%d&uid=%d&token=%@&name=%@&pwd=%@&sex=%d&sc=%@&cu=%@wp=%@&phone=%@&loc1=%@&loc2=%@&loc3=%@&pic=%@"

//facebook登录
#define CMD_FACEBOOKSIGNUP 0x03
#define URL_FACEBOOKSIGNUP @"fb.php"

//邮箱登录
#define CMD_LOGIN   0x04
#define URL_LOGIN   @"login.php"
#define POST_LOGIN  @"email=%@&pwd=%@"

//忘记密码获得邮箱验证码
#define CMD_FPGETVCODE  0x05
#define URL_FPGETVCODE  @"get_code.php"
#define POST_FPGETVCODE @"email=%@"

//设置密码
#define CMD_SETPWD   0x06
#define URL_SETPWD   @"create_pwd.php"
#define POST_SETPWD  @"email=%@&uid=%d&token=%@&pwd=%@"

//获取个人资料
#define CMD_GETPROFILE  0x07
#define URL_GETPROFILE  @"profile.php"
#define POST_GETPROFILE @"uid=%d&token=%@"

//提交经纬度
#define CMD_LOCATION   0x08
#define URL_LOCATION   @"coordinates.php"
#define POST_LOCATION  @"uid=%d&token=%@&lat=%@&lon=%@"

//保存个人资料
#define CMD_SAVEPROFILE   0x09
#define URL_SAVEPROFILE   @"save_profile.php"
#define POST_SAVEPROFILE  @"uid=%d&token=%@&name=%@&email=%@&sex=%d&sc=%@&cu=%@&wp=%@&phone=%@&loc1=%@&loc2=%@&loc3=%@&pic=%@"

//发送个人头像
#define CMD_SAVEPFPHOTO   0x10
#define URL_SAVEPFPHOTO   @"save_profile_foto.php"

//修改密码
#define CMD_CHANGEPWD     0x11
#define URL_CHANGEPWD     @"change_pwd.php"
#define POST_CHANGEPWD    @"uid=%d&token=%@&opwd=%@&pwd=%@"

//发送feedback
#define CMD_FEEDBACK      0x12
#define URL_FEEDBACK      @"feedback.php"
#define POST_FEEDBACK     @"uid=%d&token=%@&text=%@"

//发送图片
#define CMD_SENDPHOTO     0x13
#define URL_SENDPHOTO     @"post_foto.php"

//Post
#define CMD_POST          0x14
#define URL_POST          @"post.php"
#define POST_POST         @"uid=%d&token=%@&flg=%d&pic1=%@&pic2=%@&pic3=%@&pic4=%@&title=%@&describe=%@&oprice=%@&lprice=%@&type1=%d&type2=%d&type3=%d&tags=%@&lat=%@&lon=%@"

//获取首页数据
#define CMD_VSHORE        0x15
#define CMD_VSHORE_SEARCH 0x151
#define URL_VSHORE        @"vshore.php"
#define POST_VSHORE       @"uid=%d&token=%@&page=%d&flg=%d&key=%@&ord=%d&lat=%@&lon=%@"

//获取评论数据
#define CMD_COMMENT       0x16
#define URL_COMMENT       @"comments.php"
#define POST_COMMENT      @"uid=%d&token=%@&page=%d&pid=%d"

//发送评论
#define CMD_SENDCOMMENT   0x17
#define URL_SENDCOMMENT   @"comment.php"
#define POST_SENDCOMMENT  @"uid=%d&token=%@&pid=%d&text=%@"

//like/share/delete/sold...
#define CMD_POSTACTION    0x18
#define URL_POSTACTION    @"post_action.php"
#define POST_POSTACTION   @"uid=%d&token=%@&pid=%d&flg=%d"

//add/delete/block
#define CMD_ADDDELBLOCK   0x19
#define URL_ADDDELBLOCK   @"add_delete_block.php"
#define POST_ADDDELBLOCK  @"uid=%d&token=%@&ouid=%d&flg=%d"

//获取用户信息
#define CMD_MUSERINFO     0x1a
#define URL_MUSERINFO     @"user.php"
#define POST_MUSERINFO    @"uid=%d&token=%@&ouid=%d"

//remark
#define CMD_REMARK        0x1b
#define URL_REMARK        @"user_remark.php"
#define POST_REMARK       @"uid=%d&token=%@&ouid=%d&remark=%@"

//add tag
#define CMD_ADDTAG        0x1c
#define URL_ADDTAG        @"add_tag.php"
#define POST_ADDTAG       @"uid=%d&token=%@&tag=%@"

//block list
#define CMD_BLOCKLIST     0x1d
#define URL_BLOCKLIST     @"blocklist.php"
#define POST_BLOCKLIST    @"uid=%d&token=%@"

//remove tag
#define CMD_REMOVETAG     0x1e
#define URL_REMOVETAG     @"del_tag.php"
#define POST_REMOVETAG    @"uid=%d&token=%@&tag=%@"

//user tag
#define CMD_USERTAG       0x1f
#define URL_USERTAG       @"user_tags.php"
#define POST_USERTAG      @"uid=%d&token=%@&ouid=%d"

//save user tag
#define CMD_SAVEUSERTAG   0x20
#define URL_SAVEUSERTAG   @"user_tags_save.php"
#define POST_SAVEUSERTAG  @"uid=%d&token=%@&ouid=%d&tags=%@"

//post tags
#define CMD_POSTTAGS      0x21
#define URL_POSTTAGS      @"post_tags.php"
#define POST_POSTTAGS     @"uid=%d&token=%@&pid=%d"

//获取消息
#define CMD_MSGS          0x22
#define URL_MSGS          @"msgs.php"
#define POST_MSGS         @"uid=%d&token=%@&pd=%d"

//好友列表
#define CMD_FRIENDS       0x23
#define URL_FRIENDS       @"friends.php"
#define POST_FRIENDS      @"uid=%d&token=%@"

//好友接受
#define CMD_ACCEPT        0x24
#define URL_ACCEPT        @"accept.php"
#define POST_ACCEPT       @"uid=%d&token=%@&ouid=%d"

//发送消息
#define CMD_SENDMSG       0x25
#define URL_SENDMSG       @"sendmsg.php"

//发送联系人列表
#define CMD_SENDCONTACT   0x26
#define URL_SENDCONTACT   @"contacts.php"

//获取item信息
#define CMD_GETITEM       0x27
#define URL_GETITEM       @"item.php"
#define POST_GETITEM      @"uid=%d&token=%@&pid=%d"

//设置
#define CMD_SETAPPPREF    0x28
#define URL_SETAPPPREF    @"preferences.php"
#define POST_SETAPPPREF   @"uid=%d&token=%@&flg=%d&value=%d&start=%@&end=%@"

//获取设置
#define CMD_APPPREF       0x29
#define URL_APPPREF       @"preferences_result.php"
#define POST_APPPREF      @"uid=%d&token=%@"

//发送DeviceToken
#define CMD_DEVTOKEN      0x2a
#define URL_DEVTOKEN      @"device.php"
#define POST_DEVTOKEN     @"uid=%d&token=%@&dtoken=%@"

//添加好友
#define CMD_ADDFRIEND     0x2b
#define URL_ADDFRIEND     @"add_friend.php"
#define POST_ADDFRIEND    @"uid=%d&token=%@&fbid=%@&phone=%@"

//搜索用户
#define CMD_SEARCHUSER    0x2c
#define URL_SEARCHUSER    @"search_users.php"
#define POST_SEARCHUSER   @"uid=%d&token=%@&key=%@"

//删除账号
#define CMD_DELACCOUNT   0x2d
#define URL_DELACCOUNT   @"del_account.php"
#define POST_DELACCOUNT  @"uid=%d&token=%@&flg=%d"

//报告
#define CMD_REPORT       0x2e
#define URL_REPORT       @"report.php"
#define POST_REPORT      @"uid=%d&token=%@&pid=%d&content=%@"


//数据到UI处理
@protocol DataToUIAdpater 

-(void)responseDataToUI:(int)cmd status:(int)status msg:(NSString*)msg;

@end 

@interface DataAdpater : NSObject<ASIHTTPRequestDelegate>
{
@public
    id<DataToUIAdpater> dataToUI;
    
    //基础URL
    NSString*     s_url;

    
    //自动登录状态
    BOOL          autoLogin;

    
    //---------------------------------------
    //用户信息
    UserInfo*     userInfo;
    //facebook好友列表
    NSMutableArray* fbFriendArray;
    
    //地区信息
    NSArray*        locations;
    int             loc1_index;
    int             loc2_index;
    
    //上传图片的url
    NSString*       post_photo_url;
    
    //搜索数据
    BOOL            searchStatus;
    NSMutableArray* searchArray;
    int             nextSearchPage;
    
    //获取首页内容
    NSMutableArray* vshoreSellingArray;
    NSMutableArray* vshoreMomentArray;
    NSMutableArray* vshoreSearchArray;
    //页码
    int             nextSellingPage;
    int             nextMomentPage;
    
    //获取评论内容
    NSMutableArray*  commentArray;
    //评论页码
    int              commentPage;
    
    //用户信息
    MUseInfo*        muserinfo;
    //block列表
    NSMutableArray*  blockList;
    //标签数组
    NSMutableArray*  tagArray;
    //POST选中的标签
    NSString*        postTags;
    //marketAll
    NSMutableArray*  marketAllList;
    int              nextAllItemPage;
    
    //marketMyItem
    NSMutableArray*  marketMyList;
    int              nextMyItemPage;
    
    //weshow
    NSMutableArray*  weshowList;
    int              nextWeshowPage;
    
    //消息数据
    MessageManager*  messageManager;
    
    //定时器
    NSTimer*         getMsgTimer;
    
    //好友列表
    NSMutableArray*  friendList;
    
    //ItemInfo
    ItemInfo*        queryItem;
    
    //设置数据
    AppPreference*   appPreference;
    
    //经纬度
    float            latitude;
    float            longitude;
    
    //搜索用户
    NSMutableArray*  searchUsers;
    
    //
// dhw    MainViewController*  mainView;
}
@property(nonatomic,assign) id<DataToUIAdpater> dataToUI;
@property(nonatomic,retain) NSString*           s_url;
@property(nonatomic)        BOOL                autoLogin;
@property(nonatomic,assign) UserInfo*           userInfo;
@property(nonatomic,assign) NSMutableArray*     fbFriendArray;
@property(nonatomic,assign) NSArray*            locations;
@property(nonatomic)        int                 loc1_index;
@property(nonatomic)        int                 loc2_index;
@property(nonatomic,retain) NSString*           post_photo_url;

@property(nonatomic,assign) NSMutableArray*     searchArray;
@property(nonatomic)        int                 nextSearchPage;

@property(nonatomic,assign) NSMutableArray*     vshoreMomentArray;
@property(nonatomic,assign) NSMutableArray*     vshoreSellingArray;
@property(nonatomic,assign) NSMutableArray*     vshoreSearchArray;
@property(nonatomic)        int                 nextSellingPage;
@property(nonatomic)        int                 nextMomentPage;
@property(nonatomic,assign) NSMutableArray*     commentArray;
@property(nonatomic)        int                 commentPage;
@property(nonatomic,retain) MUseInfo*           muserinfo;
@property(nonatomic,assign) NSMutableArray*     blockList;
@property(nonatomic,assign) NSMutableArray*     tagArray;
@property(nonatomic,retain) NSString*           postTags;
@property(nonatomic,assign) NSMutableArray*     marketAllList;
@property(nonatomic)        int                 nextAllItemPage;
@property(nonatomic,assign) NSMutableArray*     marketMyList;
@property(nonatomic)        int                 nextMyItemPage;
@property(nonatomic,assign) NSMutableArray*     weshowList;
@property(nonatomic)        int                 nextWeshowPage;
@property(nonatomic,assign) MessageManager*     messageManager;
@property(nonatomic,assign) NSMutableArray*     friendList;
@property(nonatomic,assign) ItemInfo*           queryItem;
@property(nonatomic,assign) AppPreference*      appPreference;
@property(nonatomic)        float               latitude;
@property(nonatomic)        float               longitude;
@property(nonatomic,assign) NSMutableArray*     searchUsers;

// dhw @property(nonatomic,assign) MainViewController*  mainView;

+(DataAdpater*)shard;
+(void)destroy;

-(id)init;
-(void)dealloc;

//接收到数据
-(void)response:(ASIHTTPRequest*)request;
-(void)response_error:(ASIHTTPRequest *)request;

//sign up
-(void) request_signup;
-(void) response_signup:(NSData*)data status:(int*) status  msg:(NSString**) msg;

//验证邮箱
-(void) request_confirmemail:(NSString*)code src:(int)src;
-(void) response_confirmemail:(NSData*)data status:(int*) status  msg:(NSString**) msg;

//facebook登录
-(void) request_facebooksignup;
-(void) response_facebooksignup:(NSData*)data status:(int*) status  msg:(NSString**) msg;

//邮箱登录
-(void) request_login:(NSString*)email pwd:(NSString*)pwd;
-(void) response_login:(NSData*)data status:(int*) status  msg:(NSString**) msg;

//忘记密码获得邮箱验证码
-(void) request_fpgetcode:(NSString*)email;
-(void) response_fpgetcode:(NSData*)data status:(int*) status  msg:(NSString**) msg;

//设置密码
-(void) request_setpwd:(NSString*)email pwd:(NSString*)pwd;
-(void) response_setpwd:(NSData*)data status:(int*) status  msg:(NSString**) msg;

//获取个人资料
-(void) request_getprofile;
-(void) response_getprofile:(NSData*)data status:(int*) status  msg:(NSString**) msg;
-(void) load_getprofile:(NSData*)data status:(int*) status  msg:(NSString**) msg;

//提交经纬度
-(void) request_location:(NSString*)lat lon:(NSString*)lon;
-(void) response_location:(NSData*)data status:(int*) status  msg:(NSString**) msg;

//保存个人资料
-(void) request_saveprofile:(UserInfo*)user;
-(void) response_saveprofile:(NSData*)data status:(int*) status  msg:(NSString**) msg;

//保存个人头像
-(void) request_savepfphoto:(NSData*)imagedata;
-(void) response_savepfphoto:(NSData*)data status:(int*) status  msg:(NSString**) msg;

//修改密码
-(void) request_changepwd:(NSString*)oldpwd newpwd:(NSString*)newpwd;
-(void) response_changepwd:(NSData*)data status:(int*) status  msg:(NSString**) msg;

//发送feedback
-(void) request_feedback:(NSString*)text;
-(void) response_feedback:(NSData*)data status:(int*) status  msg:(NSString**) msg;

//发送图片
-(void) request_sendphoto:(NSData*)imagedata;
-(void) response_sendphoto:(NSData*)data status:(int*) status  msg:(NSString**) msg;

//发送数据
-(void) request_post:(PostData*)postdata;
-(void) response_post:(NSData*)data status:(int*) status  msg:(NSString**) msg;

//获取首页数据
-(void) request_vshore:(int)page type:(int)flag keyword:(NSString*)key order:(int)ord;
-(void) response_vshore:(NSData*)data status:(int*) status  msg:(NSString**) msg;
-(void) load_vshore:(NSData*)data status:(int*)status msg:(NSString**)msg;

//获取评论
-(void) request_comment:(int)page pid:(int)pid;
-(void) response_comment:(NSData *)data status:(int *)status msg:(NSString **)msg;

//发送评论
-(void) request_sendcomment:(int)pid text:(NSString*)text;
-(void) response_sendcomment:(NSData *)data status:(int *)status msg:(NSString **)msg;

//like share
-(void) request_postaction:(int)pid flag:(int)flag;
-(void) response_postaction:(NSData *)data status:(int *)status msg:(NSString **)msg;

//add delete block
-(void) request_adddeleteblock:(int)ouid flag:(int)flag;
-(void) response_adddeleteblock:(NSData *)data status:(int *)status msg:(NSString **)msg;

//获取用户一些信息
-(void) request_userinfo:(int)ouid;
-(void) response_userinfo:(NSData *)data status:(int *)status msg:(NSString **)msg;

//remark
-(void) request_remark:(int)ouid alias:(NSString*)remark;
-(void) response_remark:(NSData *)data status:(int *)status msg:(NSString **)msg;

//添加标签
-(void) request_addtag:(NSString*)tag;
-(void) response_addtag:(NSData *)data status:(int *)status msg:(NSString **)msg;

//block列表
-(void) request_blocklist;
-(void) response_blocklist:(NSData *)data status:(int *)status msg:(NSString **)msg;

//删除标签
-(void) request_removetag:(NSString*)tag;
-(void) response_removetag:(NSData *)data status:(int *)status msg:(NSString **)msg;

//获得标签
-(void) request_usertag:(int)ouid;
-(void) response_usertag:(NSData *)data status:(int *)status msg:(NSString **)msg;
    
//保存用户标签
-(void) request_saveusertag:(int)ouid tags:(NSString*)tags;
-(void) response_saveusertag:(NSData *)data status:(int *)status msg:(NSString **)msg;

//POST标签
-(void) request_posttag:(int)pid;
-(void) response_posttag:(NSData *)data status:(int *)status msg:(NSString **)msg;

//获取消息
-(void) request_msgs;
-(void) response_msgs:(NSData *)data status:(int *)status msg:(NSString **)msg;

//定时获取消息
-(void) timing_getmsgs;
-(void) stop_timing;

//获得好友列表
-(void) request_friends;
-(void) response_friends:(NSData *)data status:(int *)status msg:(NSString **)msg;

//接受好友
-(void) request_accept:(int)ouid;
-(void) response_accept:(NSData *)data status:(int *)status msg:(NSString **)msg;

//发送消息
-(void) request_sendmessage:(int)type to:(int)ouid msg:(NSString*)msg data:(NSData*)data;
-(void) response_sendmessage:(NSData *)data status:(int *)status msg:(NSString **)msg;

//提交联系人
-(void) request_sendcontact:(NSArray*)contacts;
-(void) response_sendcontact:(NSData *)data status:(int *)status msg:(NSString **)msg;

//获取联系人数据
-(NSDictionary*)getABPeopleData:(ABRecordRef)person;

//获取帖子
-(void) request_getitem:(int)pid;
-(void) response_getitem:(NSData *)data status:(int *)status msg:(NSString **)msg;

//设置app per
-(void) request_setappperf:(int)flg value:(int)value start:(NSString*)start end:(NSString*)end;
-(void) response_setappperf:(NSData *)data status:(int *)status msg:(NSString **)msg;

//获得设置
-(void) request_appperf;
-(void) response_appperf:(NSData *)data status:(int *)status msg:(NSString **)msg;

//发送推送devicetoken
-(void) request_senddevtoken:(NSString*)devtoken;

//搜索好友
-(void) request_searchuser:(NSString*)key;
-(void) response_searchuser:(NSData *)data status:(int *)status msg:(NSString **)msg;

//添加好友
-(void) request_addfriend:(NSString*)fbid phone:(NSString*)phone;
-(void) response_addfriend:(NSData *)data status:(int *)status msg:(NSString **)msg;

//删除账号
-(void) request_delaccount:(int)flg;
-(void) response_delaccount:(NSData *)data status:(int *)status msg:(NSString **)msg;

//报告
-(void) request_report:(int)pid content:(NSString*)content;
-(void) response_report:(NSData *)data status:(int *)status msg:(NSString **)msg;

@end
