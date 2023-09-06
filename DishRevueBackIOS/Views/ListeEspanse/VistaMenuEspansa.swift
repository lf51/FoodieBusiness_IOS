//
//  GenericModelList.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 23/09/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

struct VistaMenuEspansa: View {
    
    @EnvironmentObject var viewModel:AccounterVM
   // @ObservedObject var viewModel:AccounterVM
    
    let currentDish: DishModel
    let backgroundColorView: Color
    
    @State private var allMenu:[MenuModel]
    let valoreArchiviato:[MenuModel]
  //  let onlyDishInCount:Int
    
    init(currentDish:DishModel,backgroundColorView:Color,viewModel:AccounterVM) {
        
        self.currentDish = currentDish
        self.backgroundColorView = backgroundColorView
        
        let allMenuMinus = viewModel.allMenuMinusDiSistemaPlusContain(idPiatto: currentDish.id).0
        _allMenu = State(wrappedValue: allMenuMinus)
        
        self.valoreArchiviato = allMenuMinus.filter({$0.rifDishIn.contains(currentDish.id)})
    //    self.onlyDishInCount = onlyIn
        
    }
    
    var body: some View {
        
        CSZStackVB(title: currentDish.intestazione, backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {
                
                let container:[MenuModel] = {

                    var all:[MenuModel] = self.allMenu
                    
                    all.sort(by: {
                        ($0.rifDishIn.contains(currentDish.id).description,$1.intestazione) > ($1.rifDishIn.contains(currentDish.id).description,$0.intestazione)
                    })
                    
                    return all
                }()
                
                    HStack(spacing:4) {
                        
                        Text("Status Piatto:")
                        
                        CSEtichetta(text: currentDish.status.simpleDescription(), textColor: Color.white, image: currentDish.status.imageAssociated(), imageColor: currentDish.status.transitionStateColor(), imageSize: .large, backgroundColor: Color.white, backgroundOpacity: 0.2)
                    }
                    
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundStyle(Color.seaTurtle_2)
                
                ScrollView(showsIndicators:false) {
                    
                    VStack {
                        
                        ForEach(container) { model in
    
                            let containTheDish = model.rifDishIn.contains(currentDish.id)
                            
                            model.returnModelRowView(rowSize: .normale())
                                .opacity(containTheDish ? 1.0 : 0.4)
                                .overlay(alignment: .bottomTrailing) {
                                    
                                    CSButton_image(
                                       activationBool: containTheDish,
                                       frontImage: "trash",
                                       backImage: "plus",
                                       imageScale: .medium,
                                       backColor: .red,
                                       frontColor: .blue) {
                                           withAnimation {
                                               
                                               addRemoveDishLocally(localMenu: model)
                                             
                                           }
                                                       }
                                       .padding(5)
                                       .background {
                                           Color.white.opacity(containTheDish ? 0.5 : 1.0)
                                               .clipShape(Circle())
                                               .shadow(radius: 5.0)
                                               //.frame(width: 30, height: 30)
                                       }
                                       
               
                                }
                        }
                    }
                }
                
                
              BottomView_DLBIVSubView(
                isDeActive: self.disableCondition() ) {
                    self.description()
                } resetAction: {
                    self.resetAction()
                } saveAction: {
                    self.saveAction()
                }

                
            }
            .csHpadding()
          //  .padding(.horizontal)

        }
    }
    
    // Method
    
    private func saveAction() {
        
       // se vogliamo dobbiamo qui filtrare la collection e passare soltanto i menu modificati
        self.viewModel.updateItemModelCollection(items: self.allMenu, destinationPath: .dishList)
       
    }
    
    private func resetAction() {
        self.allMenu = self.viewModel.allMenuMinusDiSistemaPlusContain(idPiatto: currentDish.id).0
    }
    
    private func disableCondition() -> Bool {
       let current = self.allMenu.filter({$0.rifDishIn.contains(currentDish.id)})
        return current == valoreArchiviato
    }
    
    private func description() -> (breve:Text,estesa:Text) {
        
        let allMenuCount = self.allMenu.count
        let menuContainingDish:[MenuModel] = self.allMenu.filter({$0.rifDishIn.contains(currentDish.id)})
        
        let plusMinus = menuContainingDish.count - valoreArchiviato.count
        let plusMinusSymbol = plusMinus >= 0 ? "+" : ""
        let plusMinusString = plusMinus >= 0 ? "Aggiunti" : "Rimossi"
        
        let stringaBreve = "Menu Totali: \(allMenuCount)\nMenu contenenti il piatto: \(menuContainingDish.count) (\(plusMinusSymbol)\(plusMinus))"
        let stringaEstesa = "Updating -\(currentDish.intestazione)-\nIncluso in precendenza in: \(valoreArchiviato.count) menu\nAdesso incluso in: \(menuContainingDish.count) menu\n\(plusMinusString): \(plusMinus) menu"
        return (Text(stringaBreve),Text(stringaEstesa))
    }
    
    private func addRemoveDishLocally(localMenu: MenuModel) {

        var currentMenu = localMenu
        
        if localMenu.rifDishIn.contains(currentDish.id) {
            currentMenu.rifDishIn.removeAll(where: {$0 == currentDish.id})
            updateStatus()
        } else {
            currentMenu.rifDishIn.append(currentDish.id)
            updateStatus()
        }
        
        // Innest0 0.12.22
        
        func updateStatus() {
            
            guard !localMenu.tipologia.isDiSistema() else { return }
            
            let localModelArchiviato = self.valoreArchiviato.first { $0.id == localMenu.id}
            
            guard localModelArchiviato != nil,
                  localModelArchiviato!.status.checkStatusTransition(check: .disponibile) else { return }
            
            if currentMenu.allDishActive(viewModel: self.viewModel).isEmpty {
                currentMenu.status = currentMenu.status.changeStatusTransition(changeIn: .inPausa)
            } else {
                currentMenu.status = currentMenu.status.changeStatusTransition(changeIn: .disponibile)
            }
        }
        // fine Innesto
        
        if let index = self.allMenu.firstIndex(where: {$0.id == currentMenu.id}) {
            self.allMenu[index] = currentMenu
            print("addRemoveDishLocally - ListaEspansaMenu")
        }
    }
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
         menu.tipologia = .allaCarta()
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
     
    /*static var menuDelGiorno:MenuModel = MenuModel(tipologia: .allaCarta(.delGiorno))
    static var menuDelloChef:MenuModel = MenuModel(tipologia: .allaCarta(.delloChef)) */
    static var menuDelGiorno:MenuModel = MenuModel(tipologiaDiSistema: .delGiorno)
    static var menuDelloChef:MenuModel = MenuModel(tipologiaDiSistema: .delloChef)
    
    
    @State static var viewModel: AccounterVM = {
         
        let user = UserRoleModel()
        var vm = AccounterVM(from: initServiceObject)//AccounterVM(userAuth: user)
         vm.db.allMyDish = [dishItem3]
         vm.db.allMyIngredients = [ingredientSample,ingredientSample2,ingredientSample3,ingredientSample4]
         vm.db.allMyMenu = [menuDelloChef,menuDelGiorno,menuSample,menuSample3,menuSample2]
         return vm
     }()
    
    static var allMenu:[MenuModel] = {
       
        viewModel.db.allMyMenu.filter({
            $0.tipologia != .allaCarta(.delGiorno) &&
            $0.tipologia != .allaCarta(.delloChef) &&
            $0.rifDishIn.contains(dishItem3.id)
        })
    }()
    
    static var previews: some View {
        NavigationStack {
            VistaMenuEspansa(currentDish: dishItem3, backgroundColorView: Color.seaTurtle_1, viewModel: viewModel)
        }.environmentObject(viewModel)
            
    }
}
