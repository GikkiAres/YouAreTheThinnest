//
//  GaLogMacro.h
//  GMMCMeeting
//
//  Created by GikkiAres on 27/12/2017.
//  Copyright © 2017 RG-IOS-DEV-002. All rights reserved.
//

#ifndef GaLogMacro_h
#define GaLogMacro_h

typedef NS_OPTIONS(NSUInteger,GaLogLevel) {
    //不显示调试信息.
    GaLogLevelNone = 0,
    
    //GaDisplayManager的调试信息.
    GaLogLevelGaDisplay = 1,
    
    //显示所有的调试信息.
    GaLogLevelAll = 0xFFFFFFFF
};

//控制显示什么调试信息,可以放在配置文件中.
#define DisplayLogLevel GaLogLevelAll

#ifdef DEBUG
#define GaLog(CurrentLogLevel,ftmt,...) \
if((DisplayLogLevel)&CurrentLogLevel) {\
printf("%s\n\n",[[NSString stringWithFormat:(ftmt), ##__VA_ARGS__] UTF8String]);\
}
#else
#define GaLog(...)
#endif

//NSLog(ftmt,##__VA_ARGS__);

#endif /* GaLogMacro_h */
