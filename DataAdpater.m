//
//  DataAdpater.m
//  Seying
//
//  Created by Fish on 13-1-15.
//  Copyright (c) 2013年 Fish. All rights reserved.
//

#import "DataAdpater.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import "StaticTools.h"
#import "ASIFormDataRequest.h"

@class ASIFormDataRequest;

@implementation DataAdpater

@synthesize dataToUI;
@synthesize s_url;
@synthesize autoLogin;
@synthesize userInfo;
@synthesize fbFriendArray;
@synthesize locations;
@synthesize loc1_index;
@synthesize loc2_index;
@synthesize post_photo_url;
@synthesize searchArray;
@synthesize nextSearchPage;
@synthesize vshoreMomentArray;
@synthesize vshoreSellingArray;
@synthesize vshoreSearchArray;
@synthesize nextSellingPage;
@synthesize nextMomentPage;
@synthesize commentArray;
@synthesize commentPage;
@synthesize muserinfo;
@synthesize blockList;
@synthesize tagArray;
@synthesize postTags;
@synthesize marketAllList;
@synthesize nextAllItemPage;
@synthesize marketMyList;
@synthesize nextMyItemPage;
@synthesize weshowList;
@synthesize nextWeshowPage;
@synthesize messageManager;
@synthesize friendList;
@synthesize queryItem;
@synthesize appPreference;
@synthesize latitude;
@synthesize longitude;
@synthesize searchUsers;

// dhw @synthesize mainView;

static DataAdpater* _share = NULL;

//单例
+(DataAdpater*)shard
{
	if (!_share) _share = [[DataAdpater alloc] init];
	return _share;
}

+(void)destroy
{
    if(_share)
    {
        [_share release];
        _share = NULL;
    }
}

-(id)init
{
    if (self = [super init])
    {
        dataToUI = NULL;

        self.s_url        = BASE_URL;
        autoLogin         = true;
        //----------------------------------------------
        //用户信息
        userInfo = [[UserInfo alloc] init];
        //facebook好友列表
        fbFriendArray = [[NSMutableArray alloc] init];
        //地区数组
        locations = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"location.plist" ofType:nil]];
        [locations retain];
        loc1_index = -1;
        loc2_index = -1;
        
        post_photo_url = nil;
        
        //搜索
        searchStatus = NO;
        searchArray = [[NSMutableArray alloc] init];
        nextSearchPage = 0;
        
        //首页数据
        vshoreSellingArray = [[NSMutableArray alloc] init];
        vshoreMomentArray  = [[NSMutableArray alloc] init];
        vshoreSearchArray  = [[NSMutableArray alloc] init];
        nextSellingPage = 0;
        nextMomentPage  = 0;
        
        //评论
        commentArray = [[NSMutableArray alloc] init];
        commentPage  = 0;
        
        muserinfo = nil;
        blockList = [[NSMutableArray alloc] init];
        tagArray  = [[NSMutableArray alloc] init];
        postTags  = nil;
        
        //market
        marketAllList = [[NSMutableArray alloc] init];
        nextAllItemPage = 0;
        
        //my item
        marketMyList  = [[NSMutableArray alloc] init];
        nextMyItemPage = 0;
        
        //weshow
        weshowList    = [[NSMutableArray alloc] init];
        nextWeshowPage= 0;
        
        //Message Manager
        messageManager = [[MessageManager alloc] init];
        getMsgTimer = nil;
        
        //friendList
        friendList = [[NSMutableArray alloc] init];
        
        //queryItem
        queryItem = [[ItemInfo alloc] init];
        
        //appPreference
        appPreference = [[AppPreference alloc] init];
        
        latitude  = -1;
        longitude = -1;
        
        //search users
        searchUsers = [[NSMutableArray alloc] init];
        
    // dhw    mainView = nil;
    }
    
    return self;
}

-(void)dealloc
{
    self.s_url = nil;
    
    [userInfo release];
    [fbFriendArray release];
    [locations release];
    
    [post_photo_url release];
    
    [searchArray release];
    
    [vshoreSellingArray release];
    [vshoreMomentArray release];
    [vshoreSearchArray release];
    
    [commentArray release];
    
    if (muserinfo) [muserinfo release];
    
    [blockList release];
    [tagArray release];
    
    if (postTags) [postTags release];
    
    [marketAllList release];
    [marketMyList release];
    
    [weshowList release];
    
    [messageManager closedb];
    [messageManager release];
    if (getMsgTimer)
        [getMsgTimer invalidate];
    
    [friendList release];
    [queryItem release];
    
    [appPreference release];
    
    [searchUsers release];
    
    [super dealloc];
}


//接收到数据
-(void)response:(ASIHTTPRequest*)request
{
    int cmd = request.tag;
    int status = 0;
    NSString* msg = @"";
    
    switch (cmd) {
        //注册
        case CMD_SIGNUP:
            [self response_signup:[request responseData] status:&status msg:&msg];
            break;
        //确认邮箱
        case CMD_CONFIRMEMAIL:
            [self response_confirmemail:[request responseData] status:&status msg:&msg];
            break;
        //facebook登录
        case CMD_FACEBOOKSIGNUP:
            [self response_facebooksignup:[request responseData] status:&status msg:&msg];
            break;
        //邮箱登录
        case CMD_LOGIN:
            [self response_login:[request responseData] status:&status msg:&msg];
            break;
        //忘记密码获得邮箱验证码
        case CMD_FPGETVCODE:
            [self response_fpgetcode:[request responseData] status:&status msg:&msg];
            break;
        //设置密码
        case CMD_SETPWD:
            [self response_setpwd:[request responseData] status:&status msg:&msg];
            break;
        //获取资料
        case CMD_GETPROFILE:
            [self response_getprofile:[request responseData] status:&status msg:&msg];
            break;
        //提交经纬度
        case CMD_LOCATION:
            [self response_location:[request responseData] status:&status msg:&msg];
            break;
        //保存用户信息
        case CMD_SAVEPROFILE:
            [self response_saveprofile:[request responseData] status:&status msg:&msg];
            break;
        //保存头像
        case CMD_SAVEPFPHOTO:
            [self response_savepfphoto:[request responseData] status:&status msg:&msg];
            break;
        //保存密码
        case CMD_CHANGEPWD:
            [self response_changepwd:[request responseData] status:&status msg:&msg];
            break;
        //发送Feedback
        case CMD_FEEDBACK:
            [self response_feedback:[request responseData] status:&status msg:&msg];
            break;
        //发送图片
        case CMD_SENDPHOTO:
            [self response_sendphoto:[request responseData] status:&status msg:&msg];
            break;
        //post数据
        case CMD_POST:
            [self response_post:[request responseData] status:&status msg:&msg];
            break;
        //VSHORE数据
        case CMD_VSHORE:
            [self response_vshore:[request responseData] status:&status msg:&msg];
            break;
        //评论数据
        case CMD_COMMENT:
            [self response_comment:[request responseData] status:&status msg:&msg];
            break;
        //发出评论
        case CMD_SENDCOMMENT:
            [self response_comment:[request responseData] status:&status msg:&msg];
            break;
        //post action
        case CMD_POSTACTION:
            [self response_postaction:[request responseData] status:&status msg:&msg];
            break;
        //add delete block
        case CMD_ADDDELBLOCK:
            [self response_adddeleteblock:[request responseData] status:&status msg:&msg];
            break;
        //用户信息
        case CMD_MUSERINFO:
            [self response_userinfo:[request responseData] status:&status msg:&msg];
            break;
        //remark
        case CMD_REMARK:
            [self response_remark:[request responseData] status:&status msg:&msg];
            break;
        //add tag
        case CMD_ADDTAG:
            [self response_addtag:[request responseData] status:&status msg:&msg];
            break;
        //获取blocklist
        case CMD_BLOCKLIST:
            [self response_blocklist:[request responseData] status:&status msg:&msg];
            break;
        //删除标签
        case CMD_REMOVETAG:
            [self response_removetag:[request responseData] status:&status msg:&msg];
            break;
        //获取用户标签
        case CMD_USERTAG:
            [self response_usertag:[request responseData] status:&status msg:&msg];
            break;
        //保存用户标签
        case CMD_SAVEUSERTAG:
            [self response_saveusertag:[request responseData] status:&status msg:&msg];
            break;
        //POSTTAGS
        case CMD_POSTTAGS:
            [self response_posttag:[request responseData] status:&status msg:&msg];
            break;
        //MSGS
        case CMD_MSGS:
            [self response_msgs:[request responseData] status:&status msg:&msg];
            break;
        //好友列表
        case CMD_FRIENDS:
            [self response_friends:[request responseData] status:&status msg:&msg];
            break;
        //接受好友
        case CMD_ACCEPT:
            [self response_accept:[request responseData] status:&status msg:&msg];
            break;
        //发送消息
        case CMD_SENDMSG:
            [self response_sendmessage:[request responseData] status:&status msg:&msg];
            break;
        //发送联系人
        case CMD_SENDCONTACT:
            [self response_sendcontact:[request responseData] status:&status msg:&msg];
            break;
        //获取帖子信息
        case CMD_GETITEM:
            [self response_getitem:[request responseData] status:&status msg:&msg];
            break;
        //设置app pref
        case CMD_SETAPPPREF:
            [self response_setappperf:[request responseData] status:&status msg:&msg];
            break;
        //获得设置
        case CMD_APPPREF:
            [self response_appperf:[request responseData] status:&status msg:&msg];
            break;
        //搜索用户
        case CMD_SEARCHUSER:
            [self response_searchuser:[request responseData] status:&status msg:&msg];
            break;
        //添加好友
        case CMD_ADDFRIEND:
            [self response_addfriend:[request responseData] status:&status msg:&msg];
            break;
        //删除账号
        case CMD_DELACCOUNT:
            [self response_delaccount:[request responseData] status:&status msg:&msg];
            break;
        //Report
        case CMD_REPORT:
            [self response_report:[request responseData] status:&status msg:&msg];
            break;
        
        default:
            break;
    }
    
    //通知UI
    if (dataToUI)
        [dataToUI responseDataToUI:cmd status:status msg:msg];
}

-(void)response_error:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
        
    int cmd = request.tag;
    if (dataToUI)
        [dataToUI responseDataToUI:cmd status:RES_FAIL msg:[error localizedDescription]];
}

//注册
-(void)request_signup
{
    //CMD_SIGNUP @"name=%@&pwd=%@&email=%@&sc=%@&cu=%@wp=%@"
    NSString* data = [NSString stringWithFormat:POST_SIGNUP,
                        [StaticTools urlEncode:userInfo.name],
                        [StaticTools md5Digest:userInfo.password],
                        [StaticTools urlEncode:userInfo.email],
                        [StaticTools isEmptyString:userInfo.highSchool]?@"":[StaticTools urlEncode:userInfo.highSchool],
                        [StaticTools isEmptyString:userInfo.college]?@"":[StaticTools urlEncode:userInfo.college],
                        [StaticTools isEmptyString:userInfo.workPlace]?@"":[StaticTools urlEncode:userInfo.workPlace],
                        nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_SIGNUP];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_SIGNUP;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_signup:(NSData*)data status:(int*) status  msg:(NSString**) msg
{
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            //用户ID
            userInfo.uid   = [[dict objectForKey:@"uid"] intValue];
            //token
            userInfo.token = [dict objectForKey:@"token"];
            
            [userInfo saveUserInfo];
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//验证邮箱
-(void) request_confirmemail:(NSString*)code src:(int)src
{
    //email=%@&code=%@&src=%d&uid=%d&token=%@&name=%@&pwd=%@&sex=%d&sc=%@&cu=%@wp=%@&phone=%@&loc1=%@&loc2=%@&loc3=%@&pic=%@
    NSString* data = [NSString stringWithFormat:POST_CONFIRMEMAIL,
                      [StaticTools urlEncode:userInfo.email],
                      code,
                      src,
                      userInfo.uid,
                      userInfo.token?userInfo.token:@"",
                      userInfo.name?[StaticTools urlEncode:userInfo.name]:@"",
                      userInfo.password?[StaticTools md5Digest:userInfo.password]:@"",
                      userInfo.sex,
                      [StaticTools isEmptyString:userInfo.highSchool]?@"":[StaticTools urlEncode:userInfo.highSchool],
                      [StaticTools isEmptyString:userInfo.college]?@"":[StaticTools urlEncode:userInfo.college],
                      [StaticTools isEmptyString:userInfo.workPlace]?@"":[StaticTools urlEncode:userInfo.workPlace],
                      [StaticTools isEmptyString:userInfo.phone]?@"":[StaticTools urlEncode:userInfo.phone],
                      [StaticTools isEmptyString:userInfo.loc1]?@"":[StaticTools urlEncode:userInfo.loc1],
                      [StaticTools isEmptyString:userInfo.loc2]?@"":[StaticTools urlEncode:userInfo.loc2],
                      [StaticTools isEmptyString:userInfo.loc3]?@"":[StaticTools urlEncode:userInfo.loc3],
                      [StaticTools isEmptyString:userInfo.pic]?@"":[StaticTools urlEncode:userInfo.pic],
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_CONFIRMEMAIL];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_CONFIRMEMAIL;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_confirmemail:(NSData*)data status:(int*) status  msg:(NSString**) msg
{
   // // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            //用户ID
            userInfo.uid   = [[dict objectForKey:@"uid"] intValue];
            //token
            userInfo.token = [dict objectForKey:@"token"];
            
            [userInfo saveUserInfo];
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//facebook登录
-(void) request_facebooksignup
{
    //组织生成json串
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:userInfo.facebook_id forKey:@"fbid"];
    [dict setObject:userInfo.name forKey:@"name"];
    [dict setObject:userInfo.email forKey:@"email"];
    [dict setObject:userInfo.pic forKey:@"pic"];
    
    NSMutableArray* array = [NSMutableArray array];
    for(int i=0;i<[fbFriendArray count];i++)
    {
        FriendInfo* friendinfo = [fbFriendArray objectAtIndex:i];
        
        NSMutableDictionary* _fbdict = [NSMutableDictionary dictionary];
        
        [_fbdict setObject:friendinfo.f_id   forKey:@"fbid"];
        [_fbdict setObject:friendinfo.f_name forKey:@"name"];
        [_fbdict setObject:friendinfo.f_pic  forKey:@"pic"];
        
        [array addObject:_fbdict];
    }
    
    [dict setObject:array forKey:@"items"];
    
    NSString *data = [[CJSONSerializer serializer] serializeDictionary:dict];
    
  //  // OutLog(@"%@",data);

    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_FACEBOOKSIGNUP];
    
  //  // OutLog(@"request_facebooksignup url: %@",url);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_FACEBOOKSIGNUP;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_facebooksignup:(NSData*)data status:(int*) status  msg:(NSString**) msg
{
  //  // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            //用户ID
            userInfo.uid   = [[dict objectForKey:@"uid"] intValue];
            //token
            userInfo.token = [dict objectForKey:@"token"];
            
            [userInfo saveUserInfo];
            
            [self request_getprofile];
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//邮箱登录
-(void) request_login:(NSString*)email pwd:(NSString*)pwd
{
    //CMD_LOGIN @"email=%@&pwd=%@"
    NSString* data = [NSString stringWithFormat:POST_LOGIN,
                      [StaticTools urlEncode:email],
                      [StaticTools md5Digest:pwd],
                      nil];
    
    userInfo.email = email;
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_LOGIN];
    
  //  // OutLog(@"request_login url: %@",url);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_LOGIN;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_login:(NSData*)data status:(int*) status  msg:(NSString**) msg
{
 //   // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            //用户ID
            userInfo.uid   = [[dict objectForKey:@"uid"] intValue];
            //token
            userInfo.token = [dict objectForKey:@"token"];
            //name
            userInfo.name  = [dict objectForKey:@"name"];
            //sex
            userInfo.sex   = [[dict objectForKey:@"sex"] intValue];
            //sc
            userInfo.highSchool = [dict objectForKey:@"sc"];
            //cu
            userInfo.college    = [dict objectForKey:@"cu"];
            //wp
            userInfo.workPlace  = [dict objectForKey:@"wp"];
            //pic
            userInfo.pic        = [dict objectForKey:@"pic"];
            //phone
            userInfo.phone      = [dict objectForKey:@"phone"];
            //loc1
            userInfo.loc1       = [dict objectForKey:@"loc1"];
            //loc2
            userInfo.loc2       = [dict objectForKey:@"loc2"];
            //loc3
            userInfo.loc3       = [dict objectForKey:@"loc3"];
            
            //注册远程信息
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge| UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
            messageManager.uid = self.userInfo.uid;
            [messageManager closedb];
            [messageManager opendb];
            [messageManager loadTimestamp];
            [messageManager getMessages];
            [self request_msgs];
            [self timing_getmsgs];
            
            [userInfo saveUserInfo];
            [[DataAdpater shard] request_vshore:0 type:1 keyword:nil order:0];
            [[DataAdpater shard] request_vshore:0 type:2 keyword:nil order:0];
            [[DataAdpater shard] request_vshore:0 type:3 keyword:nil order:0];
            [[DataAdpater shard] request_vshore:0 type:4 keyword:nil order:0];
            [[DataAdpater shard] request_vshore:0 type:5 keyword:nil order:0];
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//忘记密码获得邮箱验证码
-(void) request_fpgetcode:(NSString*)email
{
    //CMD_FPGETVCODE @"email=%@"
    NSString* data = [NSString stringWithFormat:POST_FPGETVCODE,
                      [StaticTools urlEncode:email],
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_FPGETVCODE];
    
//    // OutLog(@"request_fpgetcode url: %@",url);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_FPGETVCODE;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_fpgetcode:(NSData*)data status:(int*) status  msg:(NSString**) msg
{
 //   // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//设置密码
-(void) request_setpwd:(NSString*)email pwd:(NSString*)pwd
{
    //CMD_SETPWD @"email=%@&pwd=%@"
    NSString* data = [NSString stringWithFormat:POST_SETPWD,
                      [StaticTools urlEncode:email],
                      userInfo.uid,
                      userInfo.token,
                      [StaticTools md5Digest:pwd],
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_SETPWD];
    
 //   // OutLog(@"request_setpwd url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_SETPWD;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_setpwd:(NSData*)data status:(int*) status  msg:(NSString**) msg
{
  //  // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//获取个人资料
-(void) request_getprofile
{
    //注册远程信息
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge| UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    messageManager.uid = self.userInfo.uid;
    [messageManager closedb];
    [messageManager opendb];
    [messageManager loadTimestamp];
    [messageManager getMessages];
    [self request_msgs];
    [self timing_getmsgs];
    
    NSString* data = [NSString stringWithFormat:POST_GETPROFILE,userInfo.uid,userInfo.token,nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_GETPROFILE];
    
  //  // OutLog(@"request_getprofile url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_GETPROFILE;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_getprofile:(NSData*)data status:(int*) status  msg:(NSString**) msg
{
  //  // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    //保存数据
    NSString* path = [[StaticTools appDocDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"profile_%d.dat",self.userInfo.uid]];
    [data writeToFile:path atomically:YES];
    
    [self load_getprofile:data status:status msg:msg];
}

-(void) load_getprofile:(NSData*)data status:(int*) status  msg:(NSString**) msg
{
    if (data == nil) return;
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            //用户ID
            userInfo.uid   = [[dict objectForKey:@"uid"] intValue];
            //token
            userInfo.token = [dict objectForKey:@"token"];
            //name
            userInfo.name  = [dict objectForKey:@"name"];
            //email
            userInfo.email = [dict objectForKey:@"email"];
            //sex
            userInfo.sex   = [[dict objectForKey:@"sex"] intValue];
            //sc
            userInfo.highSchool = [dict objectForKey:@"sc"];
            //cu
            userInfo.college    = [dict objectForKey:@"cu"];
            //wp
            userInfo.workPlace  = [dict objectForKey:@"wp"];
            //pic
            userInfo.pic        = [dict objectForKey:@"pic"];
            //phone
            userInfo.phone      = [dict objectForKey:@"phone"];
            //loc1
            userInfo.loc1       = [dict objectForKey:@"loc1"];
            //loc2
            userInfo.loc2       = [dict objectForKey:@"loc2"];
            //loc3
            userInfo.loc3       = [dict objectForKey:@"loc3"];
            
            [userInfo saveUserInfo];
            
            [[DataAdpater shard] request_vshore:0 type:1 keyword:nil order:0];
            [[DataAdpater shard] request_vshore:0 type:2 keyword:nil order:0];
            [[DataAdpater shard] request_vshore:0 type:3 keyword:nil order:0];
            [[DataAdpater shard] request_vshore:0 type:4 keyword:nil order:0];
            [[DataAdpater shard] request_vshore:0 type:5 keyword:nil order:0];
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//提交经纬度
-(void) request_location:(NSString*)lat lon:(NSString*)lon
{
    NSString* data = [NSString stringWithFormat:POST_LOCATION,
                      userInfo.uid,
                      userInfo.token,
                      lat,
                      lon,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_LOCATION];
    
  //  // OutLog(@"request_location url: %@",url);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_LOCATION;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_location:(NSData*)data status:(int*) status  msg:(NSString**) msg
{
  //  // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//保存个人资料
-(void) request_saveprofile:(UserInfo*)user
{
    NSString* data = [NSString stringWithFormat:POST_SAVEPROFILE,
                      userInfo.uid,
                      userInfo.token?userInfo.token:@"",
                      user.name?[StaticTools urlEncode:user.name]:@"",
                      [StaticTools urlEncode:user.email],
                      user.sex,
                      [StaticTools isEmptyString:user.highSchool]?@"":[StaticTools urlEncode:user.highSchool],
                      [StaticTools isEmptyString:user.college]?@"":[StaticTools urlEncode:user.college],
                      [StaticTools isEmptyString:user.workPlace]?@"":[StaticTools urlEncode:user.workPlace],
                      [StaticTools isEmptyString:user.phone]?@"":[StaticTools urlEncode:user.phone],
                      [StaticTools isEmptyString:user.loc1]?@"":[StaticTools urlEncode:user.loc1],
                      [StaticTools isEmptyString:user.loc2]?@"":[StaticTools urlEncode:user.loc2],
                      [StaticTools isEmptyString:user.loc3]?@"":[StaticTools urlEncode:user.loc3],
                      [StaticTools isEmptyString:user.pic]?@"":[StaticTools urlEncode:user.pic],
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_SAVEPROFILE];
    
  //  // OutLog(@"request_saveprofile url: %@",data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_SAVEPROFILE;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_saveprofile:(NSData*)data status:(int*) status  msg:(NSString**) msg
{
  //  // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {

        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//保存个人头像
-(void) request_savepfphoto:(NSData*)imagedata
{
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_SAVEPFPHOTO];
    
  //  // OutLog(@"request_savepfphoto url: %@",url);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request addPostValue:[NSString stringWithFormat:@"%d",userInfo.uid] forKey:@"uid"];
    [request addPostValue:userInfo.token forKey:@"token"];
    [request addData:imagedata withFileName:@"upload.jpg" andContentType:@"image/jpeg" forKey:@"pic"];
    
    request.tag = CMD_SAVEPFPHOTO;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_savepfphoto:(NSData*)data status:(int*) status  msg:(NSString**) msg
{
  //  // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            //pic
            userInfo.pic = [dict objectForKey:@"pic"];
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//修改密码
-(void) request_changepwd:(NSString*)oldpwd newpwd:(NSString*)newpwd
{
    NSString* data = [NSString stringWithFormat:POST_CHANGEPWD,
                      userInfo.uid,
                      userInfo.token,
                      [StaticTools isEmptyString:oldpwd]?@"":[StaticTools md5Digest:oldpwd],
                      [StaticTools md5Digest:newpwd],
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_CHANGEPWD];
    
  //  // OutLog(@"request_changepwd url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_CHANGEPWD;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_changepwd:(NSData*)data status:(int*) status  msg:(NSString**) msg
{
  //  // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {

        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//发送feedback
-(void) request_feedback:(NSString*)text
{
    NSString* data = [NSString stringWithFormat:POST_FEEDBACK,
                      userInfo.uid,
                      userInfo.token,
                      [StaticTools urlEncode:text],
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_FEEDBACK];
    
  //  // OutLog(@"request_feedback url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_FEEDBACK;
    request.delegate = self;
    [request startAsynchronous];
    
}

-(void) response_feedback:(NSData*)data status:(int*) status  msg:(NSString**) msg
{
   // // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//发送图片
-(void) request_sendphoto:(NSData*)imagedata
{
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_SENDPHOTO];
    
   // // OutLog(@"request_sendphoto url: %@",url);
    
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request addPostValue:[NSString stringWithFormat:@"%d",userInfo.uid] forKey:@"uid"];
    [request addPostValue:userInfo.token forKey:@"token"];
    [request addData:imagedata withFileName:@"photo.jpg" andContentType:@"image/jpeg" forKey:@"pic"];
    
    request.tag = CMD_SENDPHOTO;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_sendphoto:(NSData*)data status:(int*) status  msg:(NSString**) msg
{
   // // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            //pic
            self.post_photo_url = [dict objectForKey:@"pic"];
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//发送数据
-(void) request_post:(PostData*)postdata
{
    //uid=%d&token=%@&flg=%d&pic1=%@&pic2=%@&pic3=%@&pic4=%@&title=%@&describe=%@&oprice=%@&lprice=%@&type1=%d...
    NSMutableString* data = [NSMutableString stringWithFormat:POST_POST,
                      userInfo.uid,
                      userInfo.token,
                      postdata.flag,
                      [StaticTools isEmptyString:postdata.pic1]?@"":postdata.pic1,
                      [StaticTools isEmptyString:postdata.pic2]?@"":postdata.pic2,
                      [StaticTools isEmptyString:postdata.pic3]?@"":postdata.pic3,
                      [StaticTools isEmptyString:postdata.pic4]?@"":postdata.pic4,
                      [StaticTools urlEncode:postdata.title],
                      [StaticTools urlEncode:postdata.describe],
                      [StaticTools urlEncode:postdata.oprice],
                      [StaticTools urlEncode:postdata.lprice],
                      postdata.contact,
                      postdata.free,
                      postdata.swap,
                      [StaticTools isEmptyString:postTags]?@"":[StaticTools urlEncode:postTags],
                      (latitude == -1)?@"":[NSString stringWithFormat:@"%f",latitude],
                      (longitude == -1)?@"":[NSString stringWithFormat:@"%f",longitude],
                      nil];
    
    //如果包含pid
    if (postdata.pid > 0)
        [data appendFormat:@"&pid=%d",postdata.pid];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_POST];
    
  // // OutLog(@"request_post url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_POST;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_post:(NSData*)data status:(int*) status  msg:(NSString**) msg
{
    // // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
 
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//获取首页数据
/*
0:Distnce
1:Newest
2:Oldest
3:Highest Price
4:Lowest Price
5:Male Sellers
6:Female Sellers
7:Free/Swap
*/
-(void) request_vshore:(int)page type:(int)flag keyword:(NSString*)key order:(int)ord
{
    //如果存在搜索关键字
    if (![StaticTools isEmptyString:key])
        searchStatus = YES;
    else
        searchStatus = NO;
    
    //uid=%@&token=%@&page=%d&flg=%d&key=%@&ord=%d&lat=%@&lon=%@
    NSString* data = [NSString stringWithFormat:POST_VSHORE,
                      userInfo.uid,
                      userInfo.token,
                      page,
                      flag,
                      [StaticTools isEmptyString:key]?@"":[StaticTools urlEncode:key],
                      ord,
                      (latitude == -1)?@"":[NSString stringWithFormat:@"%f",latitude],
                      (longitude == -1)?@"":[NSString stringWithFormat:@"%f",longitude],
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_VSHORE];
    
  //  // OutLog(@"request_vshore url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_VSHORE;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_vshore:(NSData*)data status:(int*) status  msg:(NSString**) msg
{
   // // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        int nextPage;
        if ([dict objectForKey:@"page"])
            nextPage = [[dict objectForKey:@"page"] intValue];
        else
            nextPage = -1;
        
        //判断当前页码
        int pagenum = [[dict objectForKey:@"pagenum"] intValue];
        
        int flag = [[dict objectForKey:@"flg"] intValue];
        
        int saveNextPage = -1;
        
        if (searchStatus)
        {
            saveNextPage = nextSearchPage;
            nextSearchPage = nextPage;
        }
        else
        {
            if(flag == 1)
            {
                saveNextPage    = nextSellingPage;
                nextSellingPage = nextPage;
            }
            else if (flag == 2)
            {
                saveNextPage    = nextMomentPage;
                nextMomentPage = nextPage;
            }
            else if (flag == 3)
            {
                saveNextPage    = nextWeshowPage;
                nextWeshowPage  = nextPage;
            }
            else if (flag == 4)
            {
                saveNextPage    = nextAllItemPage;
                nextAllItemPage = nextPage;
            }
            else if (flag == 5)
            {
                saveNextPage    = nextMyItemPage;
                nextMyItemPage  = nextPage;
            }
        }

        if (*status == RES_OK)
        {
            NSArray* array = [dict objectForKey:@"items"];
            for(int i=0;i<[array count];i++)
            {
                NSDictionary* itemDict = [array objectAtIndex:i];
                
                int pid = [[itemDict objectForKey:@"pid"] intValue];
                //判断第一页===========================================================
                if(i==0)
                {
                    //如果更新的是第一页
                    if (pagenum == 0)
                    {
                        if (searchStatus)
                        {
                            [searchArray removeAllObjects];
                        }
                        else
                        {
                            //保存第一页
                            NSString* path = [[StaticTools appDocDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"vshore%d_%d.dat",flag,self.userInfo.uid]];
                            [data writeToFile:path atomically:YES];
                            
                            if(flag == 1 && [vshoreSellingArray count] > 0)
                            {
                                ItemInfo* old_info = [vshoreSellingArray objectAtIndex:0];
                                if (old_info.pid == pid)
                                {
                                    nextSellingPage = saveNextPage;
                                    break;
                                }
                                else
                                    [vshoreSellingArray removeAllObjects];
                            }
                            else if (flag == 2 && [vshoreMomentArray count] > 0)
                            {
                                ItemInfo* old_info = [vshoreMomentArray objectAtIndex:0];
                                if (old_info.pid == pid)
                                {
                                    nextMomentPage = saveNextPage;
                                    break;
                                }
                                else
                                    [vshoreMomentArray removeAllObjects];
                            }
                            else if (flag == 3 && [weshowList count] > 0)
                            {
                                [weshowList removeAllObjects];
                            }
                            else if (flag == 4 && [marketAllList count] > 0)
                            {
                                [marketAllList removeAllObjects];
                            }
                            else if (flag == 5 && [marketMyList count] > 0)
                            {
                                [marketMyList removeAllObjects];
                            }
                        }
                    }
                }
                //===================================================================
                
                ItemInfo* item_info = [[ItemInfo alloc] init];
                
                item_info.pid  = pid;
                item_info.uid  = [[itemDict objectForKey:@"uid"] intValue];
                item_info.name = [itemDict objectForKey:@"name"];
                item_info.pic  = [itemDict objectForKey:@"pic"];
                item_info.date = [itemDict objectForKey:@"date"];
                item_info.type = [itemDict objectForKey:@"type"];
                item_info.title= [itemDict objectForKey:@"title"];
                item_info.oprice= [itemDict objectForKey:@"oprice"];
                item_info.price= [itemDict objectForKey:@"price"];
                item_info.desc = [itemDict objectForKey:@"desc"];
                item_info.pics = [itemDict objectForKey:@"pics"];
                item_info.like = [[itemDict objectForKey:@"like"] intValue];
                item_info.liked= [[itemDict objectForKey:@"liked"] intValue];
                item_info.comments = [[itemDict objectForKey:@"comments"] intValue];
                item_info.status = [[itemDict objectForKey:@"status"] intValue];
                
                if (searchStatus)
                {
                    [searchArray addObject:item_info];
                }
                else
                {
                    if (flag == 1)
                        [vshoreSellingArray addObject:item_info];
                    else if (flag == 2)
                        [vshoreMomentArray addObject:item_info];
                    else if (flag == 3)
                        [weshowList addObject:item_info];
                    else if (flag == 4)
                        [marketAllList addObject:item_info];
                    else if (flag == 5)
                        [marketMyList addObject:item_info];
                }
                
                [item_info release];
            }
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

-(void) load_vshore:(NSData*)data status:(int*)status msg:(NSString**)msg
{
    if (data == nil) return;
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        int nextPage;
        if ([dict objectForKey:@"page"])
        nextPage = [[dict objectForKey:@"page"] intValue];
        else
        nextPage = -1;
        
        //判断当前页码
        int pagenum = [[dict objectForKey:@"pagenum"] intValue];
        
        int flag = [[dict objectForKey:@"flg"] intValue];
        
        int saveNextPage = -1;
        
        if (searchStatus)
        {
            saveNextPage = nextSearchPage;
            nextSearchPage = nextPage;
        }
        else
        {
            if(flag == 1)
            {
                saveNextPage    = nextSellingPage;
                nextSellingPage = nextPage;
            }
            else if (flag == 2)
            {
                saveNextPage    = nextMomentPage;
                nextMomentPage = nextPage;
            }
            else if (flag == 3)
            {
                saveNextPage    = nextWeshowPage;
                nextWeshowPage  = nextPage;
            }
            else if (flag == 4)
            {
                saveNextPage    = nextAllItemPage;
                nextAllItemPage = nextPage;
            }
            else if (flag == 5)
            {
                saveNextPage    = nextMyItemPage;
                nextMyItemPage  = nextPage;
            }
        }
        
        if (*status == RES_OK)
        {
            NSArray* array = [dict objectForKey:@"items"];
            for(int i=0;i<[array count];i++)
            {
                NSDictionary* itemDict = [array objectAtIndex:i];
                
                int pid = [[itemDict objectForKey:@"pid"] intValue];
                //判断第一页===========================================================
                if(i==0)
                {
                    //如果更新的是第一页
                    if (pagenum == 0)
                    {
                        if (searchStatus)
                        {
                            [searchArray removeAllObjects];
                        }
                        else
                        {
                            if(flag == 1 && [vshoreSellingArray count] > 0)
                            {
                                ItemInfo* old_info = [vshoreSellingArray objectAtIndex:0];
                                if (old_info.pid == pid)
                                {
                                    nextSellingPage = saveNextPage;
                                    break;
                                }
                                else
                                [vshoreSellingArray removeAllObjects];
                            }
                            else if (flag == 2 && [vshoreMomentArray count] > 0)
                            {
                                ItemInfo* old_info = [vshoreMomentArray objectAtIndex:0];
                                if (old_info.pid == pid)
                                {
                                    nextMomentPage = saveNextPage;
                                    break;
                                }
                                else
                                [vshoreMomentArray removeAllObjects];
                            }
                            else if (flag == 3 && [weshowList count] > 0)
                            {
                                [weshowList removeAllObjects];
                            }
                            else if (flag == 4 && [marketAllList count] > 0)
                            {
                                [marketAllList removeAllObjects];
                            }
                            else if (flag == 5 && [marketMyList count] > 0)
                            {
                                [marketMyList removeAllObjects];
                            }
                        }
                    }
                }
                //===================================================================
                
                ItemInfo* item_info = [[ItemInfo alloc] init];
                
                item_info.pid  = pid;
                item_info.uid  = [[itemDict objectForKey:@"uid"] intValue];
                item_info.name = [itemDict objectForKey:@"name"];
                item_info.pic  = [itemDict objectForKey:@"pic"];
                item_info.date = [itemDict objectForKey:@"date"];
                item_info.type = [itemDict objectForKey:@"type"];
                item_info.title= [itemDict objectForKey:@"title"];
                item_info.oprice= [itemDict objectForKey:@"oprice"];
                item_info.price= [itemDict objectForKey:@"price"];
                item_info.desc = [itemDict objectForKey:@"desc"];
                item_info.pics = [itemDict objectForKey:@"pics"];
                item_info.like = [[itemDict objectForKey:@"like"] intValue];
                item_info.liked= [[itemDict objectForKey:@"liked"] intValue];
                item_info.comments = [[itemDict objectForKey:@"comments"] intValue];
                item_info.status = [[itemDict objectForKey:@"status"] intValue];
                
                if (searchStatus)
                {
                    [searchArray addObject:item_info];
                }
                else
                {
                    if (flag == 1)
                    [vshoreSellingArray addObject:item_info];
                    else if (flag == 2)
                    [vshoreMomentArray addObject:item_info];
                    else if (flag == 3)
                    [weshowList addObject:item_info];
                    else if (flag == 4)
                    [marketAllList addObject:item_info];
                    else if (flag == 5)
                    [marketMyList addObject:item_info];
                }
                
                [item_info release];
            }
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
    
}


//获取评论
-(void) request_comment:(int)page pid:(int)pid
{
    NSString* data = [NSString stringWithFormat:POST_COMMENT,
                      userInfo.uid,
                      userInfo.token,
                      page,
                      pid,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_COMMENT];
    
   // // OutLog(@"request_comment url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_COMMENT;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_comment:(NSData *)data status:(int *)status msg:(NSString **)msg
{
   // // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            if ([dict objectForKey:@"page"])
                commentPage = [[dict objectForKey:@"page"] intValue];
            else
                commentPage = -1;
            
            //判断当前页码
            int pagenum = [[dict objectForKey:@"pagenum"] intValue];
            
            if (pagenum == 0)
                [commentArray removeAllObjects];
            
            NSArray* array = [dict objectForKey:@"items"];
            
            if ([array count] == 0) commentPage = -1;
            
            for(int i=0;i<[array count];i++)
            {
                NSDictionary* itemDict = [array objectAtIndex:i];

                CommentInfo* comment = [[CommentInfo alloc] init];
                
                comment.cid  = [[itemDict objectForKey:@"cid"] intValue];
                comment.uid  = [[itemDict objectForKey:@"uid"] intValue];
                comment.name = [itemDict objectForKey:@"name"];
                comment.pic  = [itemDict objectForKey:@"pic"];
                comment.date = [itemDict objectForKey:@"date"];
                comment.msg  = [itemDict objectForKey:@"msg"];
                
                
                [commentArray addObject:comment];
                [comment release];
            }
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//发送评论
-(void) request_sendcomment:(int)pid text:(NSString*)text
{
    NSString* data = [NSString stringWithFormat:POST_SENDCOMMENT,
                      userInfo.uid,
                      userInfo.token,
                      pid,
                      text,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_SENDCOMMENT];
    
    // OutLog(@"request_sendcomment url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_SENDCOMMENT;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_sendcomment:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//like share
-(void) request_postaction:(int)pid flag:(int)flag
{
    NSString* data = [NSString stringWithFormat:POST_POSTACTION,
                      userInfo.uid,
                      userInfo.token,
                      pid,
                      flag,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_POSTACTION];
    
    // OutLog(@"request_postaction url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_POSTACTION;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_postaction:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//add delete block
-(void) request_adddeleteblock:(int)ouid flag:(int)flag
{
    NSString* data = [NSString stringWithFormat:POST_ADDDELBLOCK,
                      userInfo.uid,
                      userInfo.token,
                      ouid,
                      flag,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_ADDDELBLOCK];
    
    // OutLog(@"request_deleteblock url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_ADDDELBLOCK;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_adddeleteblock:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//获取用户一些信息
-(void) request_userinfo:(int)ouid
{
    NSString* data = [NSString stringWithFormat:POST_MUSERINFO,
                      userInfo.uid,
                      userInfo.token,
                      ouid,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_MUSERINFO];
    
    // OutLog(@"request_userinfo url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_MUSERINFO;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_userinfo:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            MUseInfo* info = [[MUseInfo alloc] init];
            self.muserinfo = info;
            
            self.muserinfo.flag     = [[dict objectForKey:@"flg"] intValue];
            self.muserinfo.uid      = [[dict objectForKey:@"ouid"] intValue];
            self.muserinfo.name     = [dict objectForKey:@"name"];
            self.muserinfo.pic      = [dict objectForKey:@"pic"];
            self.muserinfo.date     = [dict objectForKey:@"date"];
            self.muserinfo.loc      = [dict objectForKey:@"loc"];
            self.muserinfo.pics     = [dict objectForKey:@"pics"];
            self.muserinfo.pics1    = [dict objectForKey:@"pics1"];
            
            [info release];
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//remark
-(void) request_remark:(int)ouid alias:(NSString*)remark
{
    NSString* data = [NSString stringWithFormat:POST_REMARK,
                      userInfo.uid,
                      userInfo.token,
                      ouid,
                      [StaticTools urlEncode:remark],
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_REMARK];
    
    // OutLog(@"request_remark url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_REMARK;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_remark:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//添加标签
-(void) request_addtag:(NSString*)tag
{
    NSString* data = [NSString stringWithFormat:POST_ADDTAG,
                      userInfo.uid,
                      userInfo.token,
                      [StaticTools urlEncode:tag],
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_ADDTAG];
    
    // OutLog(@"request_addtag url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_ADDTAG;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_addtag:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//block列表
-(void) request_blocklist
{
    NSString* data = [NSString stringWithFormat:POST_BLOCKLIST,
                      userInfo.uid,
                      userInfo.token,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_BLOCKLIST];
    
    // OutLog(@"request_blocklist url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_BLOCKLIST;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_blocklist:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            [blockList removeAllObjects];
            
            NSArray* array = [dict objectForKey:@"items"];
            for(int i=0;i<[array count];i++)
            {
                NSDictionary* itemDict = [array objectAtIndex:i];
                
                MUseInfo* info = [[MUseInfo alloc] init];
                
                info.uid  = [[itemDict objectForKey:@"uid"] intValue];
                info.name = [itemDict objectForKey:@"name"];
                info.pic  = [itemDict objectForKey:@"pic"];
                
                [blockList addObject:info];
                [info release];
            }
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//删除标签
-(void) request_removetag:(NSString*)tag
{
    NSString* data = [NSString stringWithFormat:POST_REMOVETAG,
                      userInfo.uid,
                      userInfo.token,
                      [StaticTools urlEncode:tag],
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_REMOVETAG];
    
    // OutLog(@"request_removetag url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_REMOVETAG;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_removetag:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//获得标签
-(void) request_usertag:(int)ouid
{
    NSString* data = [NSString stringWithFormat:POST_USERTAG,
                      userInfo.uid,
                      userInfo.token,
                      ouid,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_USERTAG];
    
    // OutLog(@"request_usertag url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_USERTAG;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_usertag:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            [tagArray removeAllObjects];
            
            NSArray* array = [dict objectForKey:@"tags"];
            for(int i=0;i<[array count];i++)
            {
                NSDictionary* itemDict = [array objectAtIndex:i];
                
                TagInfo* info = [[TagInfo alloc] init];
                
                info.tagName = [StaticTools urlDecode:[itemDict objectForKey:@"tag"]];
                info.status  = [[itemDict objectForKey:@"flg"] intValue];
                
                [tagArray addObject:info];
                [info release];
            }
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}
    
//保存用户标签
-(void) request_saveusertag:(int)ouid tags:(NSString*)tags
{
    NSString* data = [NSString stringWithFormat:POST_SAVEUSERTAG,
                      userInfo.uid,
                      userInfo.token,
                      ouid,
                      [StaticTools isEmptyString:tags]?@"":[StaticTools urlEncode:tags],
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_SAVEUSERTAG];
    
    // OutLog(@"request_saveusertag url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_SAVEUSERTAG;
    request.delegate = self;
    [request startAsynchronous];
}
    
-(void) response_saveusertag:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//POST标签
-(void) request_posttag:(int)pid
{
    NSString* data = [NSString stringWithFormat:POST_POSTTAGS,
                      userInfo.uid,
                      userInfo.token,
                      pid,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_POSTTAGS];
    
    // OutLog(@"request_posttag url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_POSTTAGS;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_posttag:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            [tagArray removeAllObjects];
            
            NSArray* array = [dict objectForKey:@"tags"];
            for(int i=0;i<[array count];i++)
            {
                NSDictionary* itemDict = [array objectAtIndex:i];
                
                TagInfo* info = [[TagInfo alloc] init];
                
                info.tagName = [StaticTools urlDecode:[itemDict objectForKey:@"tag"]];
                info.status  = [[itemDict objectForKey:@"flg"] intValue];
                
                [tagArray addObject:info];
                [info release];
            }
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//获取消息
-(void) request_msgs
{
    NSString* data = [NSString stringWithFormat:POST_MSGS,
                      userInfo.uid,
                      userInfo.token,
                      messageManager.pd,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_MSGS];
    
    // OutLog(@"request_msgs url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_MSGS;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_msgs:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            //时间戳
            if([dict objectForKey:@"pd"])
            {
                messageManager.pd = [[dict objectForKey:@"pd"] intValue];
                [messageManager saveTimestamp];
            }
            
            int count = 0;
            
            //消息数据
            NSArray* array = [dict objectForKey:@"items"];
            for(int i=0;i<[array count];i++)
            {
                NSDictionary* itemDict = [array objectAtIndex:i];
                
                //消息id msgid;
                //发送人id fuid;
                //发送人nick fnick;
                //发送人头像 fheader;
                //发送人性别 fsex;
                //接收人id tuid;
                //接收人nick tnick;
                //接收人头像 theader;
                //接收人性别 tsex;
                //消息内容 msg;
                //音频文件url afile;
                //音频时间长度 asec;
                //图片url pfile
                //发送时间 time;
                //图片大图 pic;
                Message* message = [[Message alloc] init];
                message.msgid   = [[itemDict objectForKey:@"id"] intValue];
                message.fuid    = [[itemDict objectForKey:@"fuid"] intValue];
                message.fnick   = [itemDict objectForKey:@"fnick"];
                message.fheader = [itemDict objectForKey:@"fheader"];
                message.fsex    = [[itemDict objectForKey:@"fsex"] intValue];
                message.tuid    = [[itemDict objectForKey:@"tuid"] intValue];
                message.tnick   = [itemDict objectForKey:@"tnick"];
                message.theader = [itemDict objectForKey:@"theader"];
                message.tsex    = [[itemDict objectForKey:@"tsex"] intValue];
                message.type    = [[itemDict objectForKey:@"type"] intValue];
                message.msg     = [itemDict objectForKey:@"msg"];
                message.time    = [itemDict objectForKey:@"time"];
                message.loc     = [itemDict objectForKey:@"loc"];
                message.alen    = [[itemDict objectForKey:@"alen"] intValue];
                message.pic     = [itemDict objectForKey:@"pic"];
                
                [messageManager insertMessage:message];
                [message release];
                
                if (message.fuid != userInfo.uid)
                    count++;
            }
            
            if ([array count] == 0) *status = 1000;
//            else if (mainView)
  //              [mainView setMessageCount:count];
            
            [messageManager getMessages];
        }
    }
    else
    {
        *status = RES_FAIL;
        *msg    = @"Data Error!";
    }
}

//定时获取消息
-(void) timing_getmsgs
{
    if (getMsgTimer) [getMsgTimer invalidate];
    
    getMsgTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                   target:self
                                                 selector:@selector(msg_timer:)
                                                 userInfo:nil
                                                  repeats:YES];
    
}

-(void) stop_timing
{
    if (getMsgTimer) [getMsgTimer invalidate];
    getMsgTimer = nil;
}

-(void) msg_timer:(NSTimer*)timer
{
    [self request_msgs];
}

//获得好友列表
-(void) request_friends
{
    NSString* data = [NSString stringWithFormat:POST_FRIENDS,
                      userInfo.uid,
                      userInfo.token,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_FRIENDS];
    
    // OutLog(@"request_friends url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_FRIENDS;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_friends:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            [[DataAdpater shard].friendList removeAllObjects];
            
            //消息数据
            NSArray* array = [dict objectForKey:@"items"];
            for(int i=0;i<[array count];i++)
            {
                NSDictionary* itemDict = [array objectAtIndex:i];
                
                FriendInfo* fInfo = [[FriendInfo alloc] init];
                
                fInfo.f_uid  = [[itemDict objectForKey:@"uid"] intValue];
                fInfo.f_name = [itemDict objectForKey:@"name"];
                fInfo.f_pic  = [itemDict objectForKey:@"pic"];
                fInfo.f_id   = [itemDict objectForKey:@"fbid"];
                fInfo.f_phone= [itemDict objectForKey:@"phone"];
                
                [[DataAdpater shard].friendList addObject:fInfo];
                [fInfo release];
            }
        }
    }
}

//接受好友
-(void) request_accept:(int)ouid
{
    NSString* data = [NSString stringWithFormat:POST_ACCEPT,
                      userInfo.uid,
                      userInfo.token,
                      ouid,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_ACCEPT];
    
    // OutLog(@"request_accept url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_ACCEPT;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_accept:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            
        }
    }
}

//发送消息
-(void) request_sendmessage:(int)type to:(int)ouid msg:(NSString*)msg data:(NSData*)data
{
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_SENDMSG];
    
    // OutLog(@"request_sendmessage url: %@ %d",url,[data length]);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request addPostValue:[NSString stringWithFormat:@"%d",userInfo.uid] forKey:@"uid"];
    [request addPostValue:userInfo.token forKey:@"token"];
    [request addPostValue:[NSString stringWithFormat:@"%d",ouid] forKey:@"touid"];
    if(msg)
        [request addPostValue:[StaticTools urlEncode:msg] forKey:@"msg"];
    //图片
    if(type == 2)
    {
        if(data)
            [request addData:data withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:@"pfile"];

    }
    //音频
    else if (type == 3)
    {
        [request addPostValue:msg forKey:@"alen"];
        if(data)
            [request addData:data withFileName:@"audio.aac" andContentType:@"audio/aac" forKey:@"afile"];
    }
    
    request.tag = CMD_SENDMSG;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_sendmessage:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            
        }
    }
}

//提交联系人
-(void) request_sendcontact:(NSArray*)contacts
{
    //组织生成json串
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInt:self.userInfo.uid] forKey:@"uid"];
    [dict setObject:self.userInfo.token forKey:@"token"];
    
    NSMutableArray* array = [NSMutableArray array];
    
    for(int i=0;i<[contacts count];i++)
    {        
        ABRecordRef person = (ABRecordRef)CFBridgingRetain([contacts objectAtIndex:i]);
        NSDictionary* ab_dict = [self getABPeopleData:person];
        
        NSString* name = [ab_dict objectForKey:@"name"];
        
        NSMutableDictionary* _pcdict = [NSMutableDictionary dictionary];
        
        [_pcdict setObject:name forKey:@"name"];
        
        NSArray* phones = [ab_dict objectForKey:@"phone"];
        if ([phones count] > 0)
        {
            NSDictionary* phones_dict = [phones objectAtIndex:0];
            
            [_pcdict setObject:[phones_dict objectForKey:@"phoneNumber"] forKey:@"phone"];
            
            [array addObject:_pcdict];
        }
        
        CFBridgingRelease(person);
    }
    
   [dict setObject:array forKey:@"items"];
    
    NSString *data = [[CJSONSerializer serializer] serializeDictionary:dict];
    
    // OutLog(@"%@",data);
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_SENDCONTACT];
    
    // OutLog(@"request_sendcontact url: %@",url);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_SENDCONTACT;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_sendcontact:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            
        }
    }
}

//处理联系人数据
-(NSDictionary*)getABPeopleData:(ABRecordRef)person
{
	//字典数据
	NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
	
	//姓名-------------------------------------------------------------------
	NSString* name = @"No Name";
	CFStringRef nameref = ABRecordCopyCompositeName(person);
    if (nameref){
		name = [NSString stringWithString:(NSString*)nameref];
		CFRelease(nameref);
    }
	[dict setObject:name forKey:@"name"];
	//电话号码列表--------------------------------------------------------------
	NSMutableArray* phoneList = [[NSMutableArray alloc] init];
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    if (phones){
        int count = ABMultiValueGetCount(phones);
        for (CFIndex i = 0; i < count; i++) {            
            NSString *phoneLabel       = (NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
            NSString *phoneNumber      = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
			
			NSMutableDictionary* phonedict = [[NSMutableDictionary alloc] init];
            if (phoneLabel && phoneNumber)
            {
                [phonedict setObject:phoneLabel forKey:@"phoneLabel"];
                
                NSString* _phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
                [phonedict setObject:_phoneNumber forKey:@"phoneNumber"];
                
                //// OutLog(@"phone label (%@), number (%@)", phoneLabel, phoneNumber);
                
                [phoneList addObject:phonedict];
            }
			[phonedict release];
			
            [phoneLabel release];
            [phoneNumber release];
        }
    }
    CFRelease(phones);
	
	[dict setObject:phoneList forKey:@"phone"];
	[phoneList release];
    
	return [dict autorelease];
}

//获取帖子
-(void) request_getitem:(int)pid
{
    NSString* data = [NSString stringWithFormat:POST_GETITEM,
                      userInfo.uid,
                      userInfo.token,
                      pid,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_GETITEM];
    
    // OutLog(@"request_getitem url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_GETITEM;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_getitem:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            queryItem.pid  = [[dict objectForKey:@"pid"] intValue];
            queryItem.uid  = [[dict objectForKey:@"uid"] intValue];
            queryItem.name = [dict objectForKey:@"name"];
            queryItem.pic  = [dict objectForKey:@"pic"];
            queryItem.date = [dict objectForKey:@"date"];
            queryItem.type = [dict objectForKey:@"type"];
            queryItem.title= [dict objectForKey:@"title"];
            queryItem.oprice= [dict objectForKey:@"oprice"];
            queryItem.price= [dict objectForKey:@"price"];
            queryItem.desc = [dict objectForKey:@"desc"];
            queryItem.pics = [dict objectForKey:@"pics"];
            queryItem.like = [[dict objectForKey:@"like"] intValue];
            queryItem.liked= [[dict objectForKey:@"liked"] intValue];
            queryItem.comments = [[dict objectForKey:@"comments"] intValue];
            queryItem.status = [[dict objectForKey:@"status"] intValue];
        }
    }
}

//设置app per
-(void) request_setappperf:(int)flg value:(int)value start:(NSString*)start end:(NSString*)end
{
    NSString* data = [NSString stringWithFormat:POST_SETAPPPREF,
                      userInfo.uid,
                      userInfo.token,
                      flg,
                      value,
                      start,
                      end,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_SETAPPPREF];
    
    // OutLog(@"request_setappperf url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_SETAPPPREF;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_setappperf:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            
        }
    }
}

//获得设置
-(void) request_appperf
{
    NSString* data = [NSString stringWithFormat:POST_APPPREF,
                      userInfo.uid,
                      userInfo.token,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_APPPREF];
    
    // OutLog(@"requet_appperf url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_APPPREF;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_appperf:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            appPreference.new_message_alerts = [[dict objectForKey:@"v1"] intValue];
            appPreference.notifications_timing_start = [dict objectForKey:@"start"];
            appPreference.notifications_timing_end   = [dict objectForKey:@"end"];
            appPreference.new_selling_alerts = [[dict objectForKey:@"v3"] intValue];
            appPreference.visible_in_market  = [[dict objectForKey:@"v4"] intValue];
        }
    }
}

//发送推送devicetoken
-(void) request_senddevtoken:(NSString*)devtoken
{
    NSString* data = [NSString stringWithFormat:POST_DEVTOKEN,
                      userInfo.uid,
                      userInfo.token,
                      devtoken,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_DEVTOKEN];
    
    // OutLog(@"request_senddevtoken url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_DEVTOKEN;
    request.delegate = self;
    [request startAsynchronous];
}

//搜索好友
-(void) request_searchuser:(NSString*)key
{
    NSString* data = [NSString stringWithFormat:POST_SEARCHUSER,
                      userInfo.uid,
                      userInfo.token,
                      key,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_SEARCHUSER];
    
    // OutLog(@"request_searchfriend url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_SEARCHUSER;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_searchuser:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            [[DataAdpater shard].searchUsers removeAllObjects];
            
            //消息数据
            NSArray* array = [dict objectForKey:@"items"];
            for(int i=0;i<[array count];i++)
            {
                NSDictionary* itemDict = [array objectAtIndex:i];
                
                FriendInfo* fInfo = [[FriendInfo alloc] init];
                
                fInfo.f_uid  = [[itemDict objectForKey:@"uid"] intValue];
                fInfo.f_name = [itemDict objectForKey:@"name"];
                fInfo.f_pic  = [itemDict objectForKey:@"pic"];
                fInfo.f_id   = [itemDict objectForKey:@"fbid"];
                fInfo.f_phone= [itemDict objectForKey:@"phone"];
                
                [[DataAdpater shard].searchUsers addObject:fInfo];
                [fInfo release];
            }
        }
    }
}

//添加好友
-(void) request_addfriend:(NSString*)fbid phone:(NSString*)phone
{
    NSString* data = [NSString stringWithFormat:POST_ADDFRIEND,
                      userInfo.uid,
                      userInfo.token,
                      fbid,
                      phone,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_ADDFRIEND];
    
    // OutLog(@"request_addfriend url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_ADDFRIEND;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_addfriend:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {

        }
    }
}

//删除账号
-(void) request_delaccount:(int)flg
{
    NSString* data = [NSString stringWithFormat:POST_DELACCOUNT,
                      userInfo.uid,
                      userInfo.token,
                      flg,
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_DELACCOUNT];
    
    // OutLog(@"request_delaccount url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_DELACCOUNT;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_delaccount:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            
        }
    }
}

//报告
-(void) request_report:(int)pid content:(NSString*)content
{
    NSString* data = [NSString stringWithFormat:POST_REPORT,
                      userInfo.uid,
                      userInfo.token,
                      pid,
                      [StaticTools isEmptyString:content]?@"":[StaticTools urlEncode:content],
                      nil];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",self.s_url ,URL_REPORT];
    
    // OutLog(@"request_report url: %@ %@",url,data);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    [request appendPostData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    request.tag = CMD_REPORT;
    request.delegate = self;
    [request startAsynchronous];
}

-(void) response_report:(NSData *)data status:(int *)status msg:(NSString **)msg
{
    // OutLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    CJSONDeserializer* json = [CJSONDeserializer deserializer];
    NSDictionary*      dict = [json deserializeAsDictionary:data error:nil];
    
    //如果正常解析
    if (dict)
    {
        *status = [[dict objectForKey:@"ret"] intValue];
        *msg    = [dict objectForKey:@"tip"];
        
        if (*status == RES_OK)
        {
            
        }
    }
}

#pragma -
#pragma ASIHTTPRequest delegate
-(void)requestFinished:(ASIHTTPRequest*)request
{
    [self response:request];
}

-(void)requestFailed:(ASIHTTPRequest*)request
{
    [self response_error:request];
}

@end
