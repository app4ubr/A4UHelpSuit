//
//  ViewControllerModel.m
//  A4UHelpSuit-MacOS
//
//  Created by gringo  on 9/3/16.
//  Copyright © 2016 APP4U Sistemas de Informação Ltda. All rights reserved.
//

#import "ViewControllerModel.h"
#import "A4URESTHelper.h"

@interface ViewControllerModel () {
    
}

@end

@implementation ViewControllerModel

- (void)getThatJSONWithOutParams {
    [self getJSONWithoutParamsButWithCompletion:^(id result) {
        NSLog(@"The File: %@", result);
        if ([result[@"result"] isEqualToString:@"ok"]) {
            NSLog(@"Hey: Everything is here! Fantastic.");
            NSArray *items = result[@"data"];
            for (NSDictionary* aDictionary in items) {
                NSLog(@"Item : %@", aDictionary);
            }
        } else {
            NSLog(@"Hey: Something went wrong but at least you got the answer, right?");
        }
    } error:^(NSError *error) {
        NSLog(@"Oops: Not possible to reach your server :'( ");
    }];
}

- (void)getThatJSONWithParams {
    [self getJSONWithParams:@{@"max_number_of_animals":@"50"}
                 completion:^(id result) {
                     NSLog(@"The File: %@", result);
                     if ([result[@"result"] isEqualToString:@"ok"]) {
                         NSLog(@"Hey: Everything is here! Fantastic.");
                         NSArray *items = result[@"data"];
                         for (NSDictionary* aDictionary in items) {
                             NSLog(@"Item : %@", aDictionary);
                         }
                     } else {
                         NSLog(@"Hey: Something went wrong but at least you got the answer, right?");
                     }
    } error:^(NSError *error) {
        NSLog(@"Oops: Not possible to reach your server :'( ");
    }];
}

- (void)getJSONWithoutParamsButWithCompletion:(void(^)(id result))completionBlock
                    error:(void(^)(NSError *error))errorBlock {
    [[A4URESTHelper sharedHelper] alternativePostWithURL:@"http://www.app4u.com.br/gitable/rest_helper_example.json"
                                              completion:completionBlock
                                                   error:errorBlock];
}

- (void)getJSONWithParams:(NSDictionary*)params
               completion:(void(^)(id result))completionBlock
                    error:(void(^)(NSError *error))errorBlock {
    [[A4URESTHelper sharedHelper]POSTWithURL:@"http://www.app4u.com.br/gitable/rest_helper_example.php"
                                      params:params
                                  completion:completionBlock
                                       error:errorBlock];
}

@end
