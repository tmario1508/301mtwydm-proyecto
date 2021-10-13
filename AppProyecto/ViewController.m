//
//  ViewController.m
//  AFNetWorkingParte2
//
//  Created by Felipe Hernandez on 13/04/17.
//  Copyright © 2017 Felipe Hernandez. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "Usuarios.h"
#import "Pedidos.h"
#import "AgregarUsuarioController.h"

@implementation ViewController

@synthesize numero = numero;
@synthesize color = color;

- (void)viewDidLoad {
    [super viewDidLoad];

    _Usuarios  = [[NSMutableArray alloc] init];
    _Pedidos  = [[NSMutableArray alloc] init];
    
    [self CargaDatos];
}


-(void) CargaDatos{

     [_Usuarios removeAllObjects];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //Entradas y salidas
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self InicializarProgress];
    
    
    [manager GET:@"https://jsonplaceholder.typicode.com/users" parameters:nil progress:nil
         success:^(NSURLSessionTask *task, id responseObject)
     {
         datosJson = (NSDictionary *) responseObject;
         
         for (NSObject* key in datosJson) {
             
             Usuarios *usuarios = [[Usuarios alloc] init];
             [usuarios setName:(NSString *)[key valueForKey:@"name"]];
             [usuarios setEmail:(NSString *)[key valueForKey:@"email"]];
             [usuarios setId:(NSString *)[key valueForKey:@"id"]];
             [usuarios setUsername:(NSString *)[key valueForKey:@"username"]];
             
             [_Usuarios addObject:usuarios];
         }
         
         //Esperar 5 segundos
         [NSThread sleepForTimeInterval:5.0f];
         
         [_Tabla reloadData];
         
         [self FinalizarProgress];
         
         //NSLog(@"JSON: %@", responseObject);
     } failure:^(NSURLSessionTask *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         [self FinalizarProgress];
     }];
}


-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView{
    return  [_Usuarios count];
}

-(id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    Usuarios *p = [_Usuarios objectAtIndex:row];
    NSString *identifier = [tableColumn identifier];
    NSString *columna = [p valueForKey:identifier];
    return columna;
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
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

- (IBAction)onEliminar:(id)sender {
    
    @try {
        
        NSInteger row  = [_Tabla selectedRow];
        
        if( row != -1){
            
            Usuarios *usuario = [_Usuarios objectAtIndex:row];
            //API
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
            
            AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
            [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            [self InicializarProgress];
            
            [manager DELETE:[NSString stringWithFormat:@"https://jsonplaceholder.typicode.com/users/%@",usuario.id]  parameters:nil
                    success:^(NSURLSessionTask *task, id responseObject)
             {
                 
                 [self MessageBox:[NSString stringWithFormat:@"%@",responseObject] andTitle:@"Eliminar usuario"];
                 //Esperar 5 segundos
                 
                 [self FinalizarProgress];
                 
                 [_Usuarios removeObjectAtIndex:row];
                 [_Tabla reloadData];
                 
                 //NSLog(@"JSON: %@", responseObject);
             } failure:^(NSURLSessionTask *operation, NSError *error) {
                 NSLog(@"Error: %@", error);
                 [self FinalizarProgress];
             }];
            
        }else{
            [self MessageBox:@"Selecciona una fila" andTitle:@"Tabla"];
            return;
        }
        
    } @catch (NSException *exception) {
        [self MessageBox:@"Error" andTitle:exception.reason];
    } @finally {
        NSLog(@"Finalizar");
    }
    
}

-(void)MessageBox:(NSString *)Message andTitle:(NSString *)Title{
    NSAlert *alerta = [[NSAlert alloc] init];
    [alerta addButtonWithTitle:@"Continuar"];
    [alerta setMessageText:Title];
    [alerta setInformativeText:Message];
    [alerta setAlertStyle:NSAlertStyleInformational];
    [alerta runModal];
}

-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([[segue identifier] isEqualToString:@"agregar"]) {
        
        AgregarUsuarioController *agregar = [segue destinationController];
        agregar.esNuevo  = YES;
        agregar.viewController =  self;
        
    }else if([[segue identifier] isEqualToString:@"modificar"]){
        
        @try {
            
            NSInteger row  = [_Tabla selectedRow];
            
            if( row != -1){
                
                Usuarios *usuario = [_Usuarios objectAtIndex:row];
                AgregarUsuarioController *agregar = [segue destinationController];
                agregar.usuarios = usuario;
                agregar.esNuevo  = NO;
                agregar.viewController =  self;
                
            }else{
                [self MessageBox:@"Selecciona una fila" andTitle:@"Tabla"];
                return;
            }
            
        } @catch (NSException *exception) {
            [self MessageBox:@"Error" andTitle:exception.reason];
        } @finally {
            NSLog(@"Finalizar");
        }
        
        
    }
}
@end
