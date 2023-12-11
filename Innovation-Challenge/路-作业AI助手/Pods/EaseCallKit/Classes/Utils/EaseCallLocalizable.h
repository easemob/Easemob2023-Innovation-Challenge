//
//  EaseCallLocalizable.h
//  Pods
//
//  Created by lixiaoming on 2021/12/9.
//

#ifndef EaseCallLocalizable_h
#define EaseCallLocalizable_h
#define EaseCallLocalizableString(key,comment) ^{\
NSBundle* bundle = [NSBundle bundleForClass:[EaseCallManager class]];\
return NSLocalizedStringFromTableInBundle(key, nil, bundle, comment);\
}()

#endif /* EaseCallLocalizable_h */
