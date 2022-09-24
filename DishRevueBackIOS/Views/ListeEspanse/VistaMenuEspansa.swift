//
//  GenericModelList.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 23/09/22.
//

import SwiftUI


struct VistaMenuEspansa: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let currentDish: DishModel
    let backgroundColorView: Color
    
    var body: some View {
        
        CSZStackVB(title: currentDish.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {
                
                var container:(full:[MenuModel],onlyDishInCount:Int) = {
                
                    var step1 = self.viewModel.allMyMenu.filter({
                        $0.tipologia != .delGiorno &&
                        $0.tipologia != .delloChef
                    })
                    
                    let onlyDishIn = step1.filter({$0.rifDishIn.contains(currentDish.id)}).count
                    
                    step1.sort(by: {
                        ($0.rifDishIn.contains(currentDish.id).description,$1.intestazione) > ($1.rifDishIn.contains(currentDish.id).description,$0.intestazione)
                    })
                    
                    return (step1,onlyDishIn)
                }()
                
                
                VStack(alignment:.leading) {
                    
                    HStack(spacing:4) {
                        
                        Text("Status Piatto:")
                        
                        CSEtichetta(text: currentDish.status.simpleDescription(), textColor: Color.white, image: currentDish.status.imageAssociated(), imageColor: currentDish.status.transitionStateColor(), imageSize: .large, backgroundColor: Color.white, backgroundOpacity: 0.2)
                    }
                    
                    Text("Menu contenenti il Piatto: \(container.onlyDishInCount)")
                    Text("Menu Totali: \(container.full.count)")
            
                }
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundColor(Color("SeaTurtlePalette_2"))
                
                ScrollView(showsIndicators:false) {
                    
                    VStack {
                        
                        ForEach(container.full) { model in
    
                            let containTheDish = model.rifDishIn.contains(currentDish.id)
                            
                            model.returnModelRowView()
                                .opacity(containTheDish ? 1.0 : 0.6)
                                .overlay(alignment: .bottomTrailing) {
                                    
                                    CSButton_image(
                                       activationBool: containTheDish,
                                       frontImage: "trash",
                                       backImage: "plus",
                                       imageScale: .medium,
                                       backColor: .red,
                                       frontColor: .blue) {
                                           withAnimation {
                                               self.viewModel.manageInOutPiattoDaMenu(idPiatto: currentDish.id, menuDaEditare: model)
                                           }
                                                       }
                                       .padding(5)
                                       .background {
                                            Color.white.opacity(0.5)
                                               .clipShape(Circle())
                                               .shadow(radius: 5.0)
                                               //.frame(width: 30, height: 30)
                                       }
                                       
               
                                }
                        }
                    }
                }
                
                
                CSDivider()
                
            }
            .padding(.horizontal)

        }
    }
    
    // Method

}

struct VistaMenuEspansa_Previews: PreviewProvider {
    
    @State static var ingredientSample =  IngredientModel(
        intestazione: "Guanciale Nero",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .biologico,
        provenienza: .defaultValue,
        allergeni: [.glutine],
        origine: .animale,
        status: .completo(.disponibile)
    )
    
    @State static var ingredientSample2 =  IngredientModel(
        intestazione: "Merluzzo",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .surgelato,
        produzione: .biologico,
        provenienza: .italia,
        allergeni: [.pesce],
        origine: .animale,
        status: .bozza(.disponibile)
            )
    
    @State static var ingredientSample3 =  IngredientModel(
        intestazione: "Basilico",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .biologico,
        provenienza: .restoDelMondo,
        allergeni: [],
        origine: .vegetale,
        status: .bozza(.inPausa))
    
    @State static var ingredientSample4 =  IngredientModel(
        intestazione: "Mozzarella di Bufala",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .congelato,
        produzione: .convenzionale,
        provenienza: .europa,
        allergeni: [.latte_e_derivati],
        origine: .animale,
        status: .bozza(.inPausa)
    )
    
    @State static var dishItem3: DishModel = {
        
        var newDish = DishModel()
        newDish.intestazione = "Bucatini alla Matriciana"
        newDish.status = .bozza(.disponibile)
        newDish.ingredientiPrincipali = [ingredientSample4.id,ingredientSample3.id,ingredientSample.id]
        newDish.ingredientiSecondari = [ingredientSample2.id]
        newDish.elencoIngredientiOff = [ingredientSample4.id:ingredientSample.id]
        let price:DishFormat = {
            var pr = DishFormat(type: .mandatory)
            pr.label = "Porzione"
            pr.price = "22.5"
            return pr
        }()
        let price1:DishFormat = {
            var pr = DishFormat(type: .opzionale)
            pr.label = "1/2 Porzione"
            pr.price = "10.5"
            return pr
        }()
        newDish.pricingPiatto = [price,price1]
        
        return newDish
    }()
    
     static var menuSample: MenuModel = {

         var menu = MenuModel()
         menu.intestazione = "Agosto Menu"
         menu.tipologia = .fisso(persone: .due, costo: "18")
        // menu.tipologia = .allaCarta
         menu.isAvaibleWhen = .dataEsatta
         menu.giorniDelServizio = [.lunedi]
       //  menu.dishInDEPRECATO = [dishItem3]
        // menu.rifDishIn = [dishItem3.id]
         menu.status = .bozza(.archiviato)
         
         return menu
     }()
     
     static var menuSample2: MenuModel = {
        
         var menu = MenuModel()
         menu.intestazione = "Luglio Menu"
         menu.tipologia = .allaCarta
         menu.rifDishIn = [dishItem3.id]
       //  menu.tipologia = .allaCarta
         menu.giorniDelServizio = [.domenica]
       //  menu.dishInDEPRECATO = [dishItem3]
         menu.status = .completo(.inPausa)
         
         return menu
     }()
     
     static var menuSample3: MenuModel = {
        
         var menu = MenuModel()
         menu.intestazione = "Gennaio Menu"
         menu.tipologia = .fisso(persone: .uno, costo: "18.5")
       //  menu.tipologia = .allaCarta
         menu.giorniDelServizio = [.domenica]
         menu.rifDishIn = [dishItem3.id]
        // menu.dishInDEPRECATO = [dishItem3]
         menu.status = .completo(.inPausa)
         
         return menu
     }()
     
     static var menuDelGiorno:MenuModel = MenuModel(tipologia: .delGiorno)
     static var menuDelloChef:MenuModel = MenuModel(tipologia: .delloChef)
    
    
    @State static var viewModel: AccounterVM = {
         
        var vm = AccounterVM()
         vm.allMyDish = [dishItem3]
         vm.allMyIngredients = [ingredientSample,ingredientSample2,ingredientSample3,ingredientSample4]
        vm.allMyMenu = [menuDelloChef,menuDelGiorno,menuSample,menuSample3,menuSample2]
         return vm
     }()
    
    static var allMenu:[MenuModel] = {
       
        viewModel.allMyMenu.filter({
            $0.tipologia != .delGiorno &&
            $0.tipologia != .delloChef &&
            $0.rifDishIn.contains(dishItem3.id)
        })
    }()
    
    static var previews: some View {
        NavigationStack {
            VistaMenuEspansa(currentDish: dishItem3, backgroundColorView: Color("SeaTurtlePalette_1"))
        }.environmentObject(viewModel)
            
    }
}
