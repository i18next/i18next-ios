//
//  I18NextLoader.h
//  i18next
//
//  Created by Jean Regisser on 07/11/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "I18Next.h"

@interface I18NextLoader : NSObject

- (instancetype)initWithOptions:(I18NextOptions*)options;

- (void)loadLangs:(NSArray*)langs namespaces:(NSArray*)namespaces
       completion:(void (^)(NSDictionary* store, NSError* error))completionBlock;

- (void)cancel;

@end
