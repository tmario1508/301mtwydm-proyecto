//
//  AgregarPedidoController.m
//  AppProyecto
//
//  Created by mario on 10/12/21.
//  Copyright © 2021 Felipe Hernandez. All rights reserved.
//

#import "AgregarUsuarioController.h"
#import "AFNetworking.h"

@interface AgregarUsuarioController () {
    NSString* User_ID;
    ViewController *view;
}

@end

@implementation AgregarUsuarioController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    view = [[ViewController alloc] init];
   
    view =  _viewController;
   
   
   if (_usuarios != nil) {
       
       if (_esNuevo ==  NO) {
           
           User_ID = _usuarios.id;
           [_txtNombre setStringValue:_usuarios.name];
           [_txtNameUser setStringValue:_usuarios.username];
           [_txtEmail setStringValue:_usuarios.email];
           _onGuardar.enabled = NO;
           
       }else{
           _onEditar.enabled  =  NO;
       }
       
   }else{
       _onEditar.enabled  =  NO;
   }
   
    [_progressIndicator setHidden:YES];
}

- (IBAction)onEdit:(id)sender {
    @try {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        //Entradas y salidas
        
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        manager.requestSerializer = serializer;
        
        
        [self InicializarProgress];
        
        NSDictionary *parameters = @{@"id": User_ID,
                                     @"name":_txtNombre.stringValue,
                                     @"username": _txtNameUser.stringValue,
                                     @"email": _txtEmail.stringValue
        };
        
        [manager PUT:@"https://jsonplaceholder.typicode.com/users" parameters:parameters
             success:^(NSURLSessionTask *task, id responseObject)
         {
             
             //Esperar 5 segundos
             [NSThread sleepForTimeInterval:5.0f];
             
             [self FinalizarProgress];
             
             NSLog(@"JSON: %@", responseObject);
             
             //[_lblInformacion setStringValue:responseObject];
             
             [view CargaDatos];
             
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             
             [self FinalizarProgress];
         }];
        
    } @catch (NSException *exception) {
        NSLog(@"Error %@",exception.reason);
    } @finally {
        NSLog(@"Finaizar");
    }

}

- (IBAction)onGuardar:(id)sender {
    @try {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        //Entradas y salidas
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        manager.requestSerializer = serializer;
        
        
        [self InicializarProgress];
        
        NSDictionary *parameters = @{@"id": @"0",
                                     @"name":_txtNombre.stringValue,
                                     @"username": _txtNameUser.stringValue,
                                     @"email":_txtEmail.stringValue,
        };
        
        
        [manager POST:@"https://jsonplaceholder.typicode.com/users" parameters:parameters progress:nil
              success:^(NSURLSessionTask *task, id responseObject)
         {
             
             //Esperar 5 segundos
             [NSThread sleepForTimeInterval:5.0f];
             
             [self FinalizarProgress];
             
             NSLog(@"JSON: %@", responseObject);
             
             //[_lblInformacion setStringValue:responseObject];
             
             [view CargaDatos];
             
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             
             [self FinalizarProgress];
         }];
        
    } @catch (NSException *exception) {
        NSLog(@"Error %@",exception.reason);
    } @finally {
        NSLog(@"Finaizar");
    }
}

-(void) InicializarProgress{
    
    [_progressIndicator setHidden:NO];
    [_progressIndicator setIndeterminate:YES];
    [_progressIndicator setUsesThreadedAnimation:YES];
    [_progressIndicator startAnimation:nil];
}


-(void) FinalizarProgress{
    [_progressIndicator stopAnimation:nil];
    [_progressIndicator setHidden:YES];
}

@end
