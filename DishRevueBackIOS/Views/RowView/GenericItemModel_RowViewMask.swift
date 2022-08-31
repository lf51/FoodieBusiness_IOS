//
//  GenericItemModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/06/22.
//

import SwiftUI

/// Lasciando il valore di default (nil) nel navigationPath, il contenuto custom del modello non verrà visualizzato.
struct GenericItemModel_RowViewMask<M:MyModelProtocol,Content:View>:View {
    
    @EnvironmentObject var viewModel: AccounterVM
    let model: M
    var pushImage: String = "square.and.pencil"
    var navigationPath: ReferenceWritableKeyPath<AccounterVM,NavigationPath>? = nil
    @ViewBuilder var interactiveMenuContent: Content
   
    var body: some View {
        
        model.returnModelRowView()
           .overlay(alignment: .bottomTrailing) {
                // l'overlay crea un zStack implicito
            /*   Circle()
                   .frame(width: 35, height: 35)
                   .foregroundColor(Color("SeaTurtlePalette_1")) */
               
                Menu {
                    
                    interactiveMenuContent
                    if navigationPath != nil {
                        model.customInteractiveMenu(viewModel: viewModel, navigationPath: navigationPath!)
                    }
                    
                } label: {
                    Image(systemName:pushImage)
                        .imageScale(.large)
                        .foregroundColor(Color("SeaTurtlePalette_4"))
                        .padding(.all,5)
                        .background {
                            Color("SeaTurtlePalette_1")
                                .shadow(radius: 20.0)
                                .cornerRadius(5.0)
                        }
                       /* .background(content: {
                            Circle()
                                .frame(width: 35, height: 35)
                                .foregroundColor(Color("SeaTurtlePalette_1"))
                        }) */
                }
             //   .offset(x:3,y:0)
          
            }
        /* Nota 22.08 - Vedere Note vocali 21.08 : Siamo tornati alla configurazione originale, che non ci piace perchè l'overlay non sta "fermo" al suo posto, ma può cambiare posizione e anche di tanto a seconda della grandezza dello schermo. Se lo schermo è difatti inferiore alla grandezza passata alla schedine (di default 400), la schedina sarà ridotta alla larghezza dello schermo minus 20, questo però non è recepito dall'overlay che andrà a posizionarsi sulla larghezza passata alla View. Per risolvere il problema apriamo una finestra nel CSZStackVB_Framed di tipo optional, e passiamo quando serve una view che andrà a posizionarsi in overlay nel bottomTrailing. In questo modo il posizionamente viene sempre rispettato e abbiamo anche il vantaggio di poter dare al "bottone" una grandezza dinamica. Lo svantaggio è che dobbiamo andare ad intervenire su diverse view, e allora, dato che dovremo intervenire in modo massiccio sulle liste (per altri motivi), attendiamo di tornare ad intervenire sulle liste e con la situazione chiara apportiamo anche queste eventuali modifiche, che fatte ora rischiano di dover essere sovrascritte, come tante volte già capitato in questi 8 mesi di lavoro.*/
        
    }
}

/*
/// Lasciando il valore di default (nil) nel navigationPath, il contenuto custom del modello non verrà visualizzato.
struct GenericItemModel_RowViewMask<M:MyModelProtocol,Content:View>:View {
    
    @EnvironmentObject var viewModel: AccounterVM
    let model: M
    var pushImage: String = "square.and.pencil"
    var navigationPath: ReferenceWritableKeyPath<AccounterVM,NavigationPath>? = nil
    @ViewBuilder var interactiveMenuContent: Content
   
    var body: some View {
        
        model.returnModelRowView()
            
           .overlay(alignment: .bottomTrailing) {
                
                Menu {
                    
                    interactiveMenuContent
                    if navigationPath != nil {
                        model.customInteractiveMenu(viewModel: viewModel, navigationPath: navigationPath!)
                    }
                    
                } label: {
                    Image(systemName:pushImage)
                        .imageScale(.large)
                        .foregroundColor(Color("SeaTurtlePalette_2"))
                        .background(content: {
                            Circle()
                                .frame(width: 35, height: 35)
                                .foregroundColor(Color("SeaTurtlePalette_1"))
                        })
                }
             //   .offset(x:3,y:0)
          
            }
    }
} */ //BackUP 21.08 -> il posizionamento dell'overlay varia in base alla grandezza della ZStack Madre. Quando lo schermo riduce, entra in gioco il maxWidth del CSZStackVB_Framed e allora l'overlay cambia posizione perchè si orienta al valore del width passato e non a quello effettivo


/*
/// Lasciando il valore di default (nil) nel navigationPath, il contenuto custom del modello non verrà visualizzato.
struct GenericItemModel_RowViewMask<M:MyModelProtocol,Content:View>:View {
    
    @EnvironmentObject var viewModel: AccounterVM
    let model: M
    var imageToPush: String = "square.and.pencil"
    var navigationPath: ReferenceWritableKeyPath<AccounterVM,NavigationPath>? = nil
    @ViewBuilder var interactiveMenuContent: Content
   
    var body: some View {
             
        model.returnModelRowView()
            .overlay(alignment: .bottomTrailing) {
                
                Menu {
                    
                    interactiveMenuContent
                    
                    if navigationPath != nil {
                        model.customInteractiveMenu(viewModel: viewModel, navigationPath: navigationPath!)
                    }
                    
                } label: {
                    Image(systemName: imageToPush)
                        .imageScale(.large)
                        .foregroundColor(Color("SeaTurtlePalette_3"))
                    
                }.offset(x:10,y:15)
                
            }
    }
} */ // Deprecata 17.08 -> Ritorno ad un Menu con Label la row, ma con un'azione primaria, di modo che il menu si apra su un long press


/*
struct GenericItemModel_RowViewMask<M:MyModelProtocol,Content:View>:View {
    
    @EnvironmentObject var viewModel: AccounterVM
    let model: M
    let navigationPath: ReferenceWritableKeyPath<AccounterVM,NavigationPath>
    @ViewBuilder var interactiveMenuContent: Content
   
    var body: some View {
                
        Menu {
            
            interactiveMenuContent
            model.customInteractiveMenu(viewModel: viewModel, navigationPath: navigationPath )
 
        } label: {

            //csVbSwitchModelRowView(item: model)
            model.returnModelRowView()
           
        }
    }

} */// deprecata 17.08 -> Sostituita con un Menu messo in Overlay


/*
struct GenericItemModel_RowViewMask<M:MyModelProtocol,Content:View>:View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var model: M
    let backgroundColorView: Color
    @ViewBuilder var interactiveMenuContent: Content
   
  
    
    var body: some View {
                
        Menu {
               interactiveMenuContent
            Text("Linea TEST")
        
        } label: {

      csVbSwitchModelRowView(itemModel: $model)
           
        }
    }

} */ // Deprecata 28.06 per trasformazione da Binding<M> a M


struct GenericItemModel_RowViewMask_Previews: PreviewProvider {
    
    @State static var ingredientSample =  IngredientModel(
        intestazione: "Guanciale Nero",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .convenzionale,
        provenienza: .restoDelMondo,
        allergeni: [.glutine],
        origine: .animale,
        status: .completo(.archiviato),
        idIngredienteDiRiserva: "merluzzo"
    )
    
    @State static var ingredientSample2 =  IngredientModel(
        intestazione: "Merluzzo",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .surgelato,
        produzione: .convenzionale,
        provenienza: .italia,
        allergeni: [.pesce],
        origine: .animale,
        status: .completo(.inPausa),
        idIngredienteDiRiserva: "guancialenero"
            )
    
    @State static var ingredientSample3 =  IngredientModel(
        intestazione: "Basilico",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .biologico,
        provenienza: .restoDelMondo,
        allergeni: [],
        origine: .vegetale,
        status: .completo(.disponibile))
    
    @State static var ingredientSample4 =  IngredientModel(
        intestazione: "Mozzarella di Bufala",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .congelato,
        produzione: .convenzionale,
        provenienza: .europa,
        allergeni: [.latte_e_derivati,.anidride_solforosa_e_solfiti,.arachidi_e_derivati,.crostacei],
        origine: .animale,
        status: .nuovo,
        idIngredienteDiRiserva: "basilico")
    
    static var dishItem3: DishModel = {
        
        var newDish = DishModel()
        newDish.intestazione = "Bucatini alla Matriciana"
        newDish.status = .completo(.inPausa)
        newDish.ingredientiPrincipali = [ingredientSample4.id,ingredientSample.id]
        newDish.ingredientiSecondari = [ingredientSample2.id]
        let price:DishFormat = {
            var pr = DishFormat(type: .mandatory)
            pr.price = "22.5"
            return pr
        }()
        newDish.pricingPiatto = [price]
        
        return newDish
    }()
    
    static var menuSample: MenuModel = {
       
        var menu = MenuModel()
        menu.intestazione = "Pranzo della Domenica di Agosto"
        menu.tipologia = .fisso(persone: .due, costo: "18.5")
      //  menu.tipologia = .allaCarta
        menu.giorniDelServizio = [.domenica]
        menu.dishIn = [dishItem3]
        menu.status = .completo(.inPausa)
        
        return menu
    }()
    
    static var menuSample2: MenuModel = {
       
        var menu = MenuModel()
        menu.intestazione = "Pranzo della Domenica"
        menu.tipologia = .allaCarta
      //  menu.tipologia = .allaCarta
        menu.giorniDelServizio = [.domenica]
        menu.dishIn = [dishItem3]
        menu.status = .completo(.inPausa)
        
        return menu
    }()
    
    static var menuSample3: MenuModel = {
       
        var menu = MenuModel()
        menu.intestazione = "Pranzo della"
        menu.tipologia = .fisso(persone: .uno, costo: "18.5")
      //  menu.tipologia = .allaCarta
        menu.giorniDelServizio = [.domenica]
        menu.dishIn = [dishItem3]
        menu.status = .completo(.inPausa)
        
        return menu
    }()
    
    static var previews: some View {
       
        ZStack {
            
            Color("SeaTurtlePalette_1").ignoresSafeArea()
            
            ScrollView {
                
                VStack {
                    
                   GenericItemModel_RowViewMask(model: menuSample) {
                        
                        Text("Test")
                    }
                    
                    GenericItemModel_RowViewMask(model: menuSample2) {
                         
                         Text("Test")
                     }
                    
                    GenericItemModel_RowViewMask(model: menuSample3) {
                         
                         Text("Test")
                     }
                    
                    GenericItemModel_RowViewMask(model: dishItem3) {
                        
                        Text("Test")
                    }
                    
                    GenericItemModel_RowViewMask(model: ingredientSample ) {
                        
                        Text("Test")
                    }
                   
                    
                 
                  
                    
                }
                
                
                
            }
            
            
            
            
        }.environmentObject(AccounterVM())
    }
}


/*
/// ViewBuilder - Modifica lo Status di un Model Generico, passando da completo(.pubblico) a completo(.inPausa) e viceversa
@ViewBuilder func vbStatusButton<M:MyModelStatusConformity>(model:Binding<M>) -> some View {
    
    let localModel = model.wrappedValue
    
    if localModel.status == .completo(.pubblico) {
        
        Button {
            model.wrappedValue.status = .completo(.inPausa)
        } label: {
            HStack {
                Text("Metti in Pausa")
                Image(systemName: "pause.circle")
            }
        }
        
    } else if localModel.status == .completo(.inPausa) {
        
        Button {
            model.wrappedValue.status = .completo(.pubblico)
        } label: {
            HStack {
                Text("Pubblica")
                Image(systemName: "play.circle")
            
            }
        }
        
        
    }
    
    
    
    
    
} */ // 28.06 Deprecata


