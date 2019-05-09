//
//  EMapgoSpeech.h
//  EMapgoPOI
//
//  Created by 王晓磊 on 2019/3/19.
//  Copyright © 2019 MaRui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMapgoSpeech : NSObject

//语音播放对象的单例
+(EMapgoSpeech *)instance;

/*!
 *  创建用户语音配置<br>
 *  注册应用请前往语音云开发者网站。<br>
 *  网站：http://www.xfyun.cn
 *
 *  @param params 启动参数，必须保证appid参数传入，示例：appid=123456
 *
 */
+ (void) createUtility:(NSString *) params;

/*!
 *  设置合成参数
 *
 *  | 参数             | 描述                                               |
 *  |-----------------|----------------------------------------------------|
 *  | speed           | 合成语速,取值范围 0~100                               |
 *  | volume          | 合成的音量,取值范围 0~100                             |
 *  | voice_name      | 默认为”xiaoyan”；可以设置的参数列表可参考个性化发音人列表   |
 *  | sample_rate     | 采样率:目前支持的采样率设置有 16000 和 8000。            |
 *  | tts_audio_path  | 音频文件名 设置此参数后，将会自动保存合成的音频文件。<br>路径为Documents/(指定值)。不设置或者设置为nil，则不保存音频。|
 *  | params          | 扩展参数: 对于一些特殊的参数可在此设置。                  |
 *
 *  @param value 参数取值
 *  @param key   合成参数
 *
 *  @return 设置成功返回YES，失败返回NO
 */
-(BOOL) setParameter:(NSString *) value forKey:(NSString*)key;

/*!
 *  开始合成(播放)<br>
 *  调用此函数进行合成，如果发生错误会回调错误`onCompleted`
 *
 *  @param text 合成的文本,最大的字节数为1k
 */
- (void) startSpeaking:(NSString *)text;

/*!
 *  发音人
 *
 *  云端支持如下发音人：<br>
 *  对于网络TTS的发音人角色，不同引擎类型支持的发音人不同，使用中请注意选择。<br>
 *
 *  |  发音人   |  参数             |
 *  |:--------:|:----------------:|
 *  |  小燕     |   xiaoyan        |
 *  |  小宇     |   xiaoyu         |
 *  |  凯瑟琳   |   catherine      |
 *  |  亨利     |   henry          |
 *  |  玛丽     |   vimary         |
 *  |  小研     |   vixy           |
 *  |  小琪     |   vixq           |
 *  |  小峰     |   vixf           |
 *  |  小梅     |   vixl           |
 *  |  小莉     |   vixq           |
 *  |  小蓉     |   vixr           |
 *  |  小芸     |   vixyun         |
 *  |  小坤     |   vixk           |
 *  |  小强     |   vixqa          |
 *  |  小莹     |   vixyin         |
 *  |  小新     |   vixx           |
 *  |  楠楠     |   vinn           |
 *  |  老孙     |   vils           |
 *
 *  @return 发音人key
 */
+(NSString*)VOICE_NAME;

/*!
 * 发音人ID key。
 *
 * @return 发音人ID key
 */
+(NSString*)VOICE_ID;

/*!
 * 发音人语种 key。
 *
 * 参数值：0:Auto 1:中文 2英文 ，默认 0.
 *
 * @return 发音人ID key
 */
+(NSString*)VOICE_LANG;

/*!
 *  音量<br>
 *  范围（0~100） 默认值:50
 *
 *  @return 音量key
 */
+(NSString*)VOLUME ;


/*!
 *  获取合成参数
 *
 *  @param key 参数key
 *
 *  @return 参数值
 */
-(NSString*) parameterForKey:(NSString *)key;

/*!
 *  暂停播放<br>
 *  暂停播放之后，合成不会暂停，仍会继续，如果发生错误则会回调错误`onCompleted`
 */
- (void) pauseSpeaking;

/*!
 *  恢复播放
 */
- (void) resumeSpeaking;

/*!
 *  停止播放并停止合成
 */
- (void) stopSpeaking;

/*!
 *  是否正在播放
 */
@property (nonatomic, readonly) BOOL isSpeaking;

@end

NS_ASSUME_NONNULL_END
