//
//  AgregarPedidoController.h
//  AppProyecto
//
//  Created by mario on 10/12/21.
//  Copyright © 2021 Felipe Hernandez. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Pedidos.h"
#import "ViewController.h"
#import "Usuarios.h"

@interface AgregarUsuarioController : NSViewController

@property (nonatomic,retain) ViewController* viewController;
@property BOOL esNuevo;
@property (nonatomic,retain) Pedidos *pedidos;
@property (nonatomic, retain) Usuarios *usuarios;
@property (strong) IBOutlet NSTextField *txtNombre;
@property (strong) IBOutlet NSTextField *txtNameUser;
@property (strong) IBOutlet NSTextField *txtEmail;


@property (strong) IBOutlet NSButton *onEditar;
@property (strong) IBOutlet NSButton *onGuardar;
@property (strong) IBOutlet NSProgressIndicator *progressIndicator;


- (IBAction)onGuardar:(id)sender;
- (IBAction)onEdit:(id)sender;

-(void) InicializarProgress;
-(void) FinalizarProgress;

@end

