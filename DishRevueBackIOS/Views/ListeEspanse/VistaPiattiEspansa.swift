//
//  GenericModelList.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 23/09/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage


struct PreCallVistaPiattiEspansa: View {
    
    @State private var localStateMenu:MenuModel
    @Binding private var globalBindingMenu:MenuModel
    let menuArchiviato: MenuModel
    let rowViewSize:RowSize
    
    let bindingType: ItemBindingType
    let backgroundColorView:Color
    let destinationPath:DestinationPath

    init(
        currentMenu: MenuModel,
        rowViewSize:RowSize,
        backgroundColorView: Color,
        destinationPath: DestinationPath) {
            
        _localStateMenu = State(wrappedValue: currentMenu)
        self.menuArchiviato = currentMenu
        self.rowViewSize = rowViewSize
        self.bindingType = .localState
        self.backgroundColorView = backgroundColorView
        self.destinationPath = destinationPath
            
        _globalBindingMenu = .constant(currentMenu) // la init ma non la usiamo
    }
    
    init(
        currentMenu: Binding<MenuModel>,
        rowViewSize:RowSize,
        backgroundColorView: Color,
        destinationPath: DestinationPath) {
            
        _globalBindingMenu = currentMenu
           
        self.menuArchiviato = currentMenu.wrappedValue
        self.rowViewSize = rowViewSize
        self.bindingType = .globalBinding
        self.backgroundColorView = backgroundColorView
        self.destinationPath = destinationPath
            
        _localStateMenu = State(wrappedValue: currentMenu.wrappedValue) // la init ma non la usiamo
    }
    
   
     enum ItemBindingType {
        case globalBinding,localState
    }
    
    var body: some View {
        
        switch bindingType {
            
        case .globalBinding:
            
            CSZStackVB(
                title: "Seleziona Piatti",
                titlePosition: .bodyEmbed([.horizontal,.top],15),
                backgroundColorView: backgroundColorView) {
                VistaPiattiEspansa(
                    currentMenu: $globalBindingMenu,
                    rowViewSize: rowViewSize,
                    backgroundColorView: backgroundColorView,
                    destinationPath: destinationPath)
               // .csHpadding()
            }
            
        case .localState:
            
            CSZStackVB(
                title: localStateMenu.intestazione,
                backgroundColorView: backgroundColorView) {
                VistaPiattiEspansa(
                    currentMenu: $localStateMenu,
                    menuArchiviato: menuArchiviato,
                    rowViewSize: rowViewSize,
                    backgroundColorView: backgroundColorView,
                    destinationPath: destinationPath)
                .csHpadding()
               //.padding(.horizontal)
            }
        }
        
    }
    
    // Nested VistaPiatti espansa
    
    private struct VistaPiattiEspansa: View {
        
        @EnvironmentObject var viewModel:AccounterVM
        
        @Binding private var currentMenu: MenuModel
        let rowViewSize:RowSize
        let backgroundColorView: Color
        let destinationPath:DestinationPath
        
        let valoreArchiviato:[String]
        let statusArchiviato:StatusModel
        let showButtonBar:Bool
        
        init(
            currentMenu: Binding<MenuModel>,
            menuArchiviato:MenuModel? = nil,
            rowViewSize:RowSize,
            backgroundColorView: Color,
            destinationPath:DestinationPath) {
         
            _currentMenu = currentMenu
                if let valueArchiviato = menuArchiviato {
                    self.valoreArchiviato = valueArchiviato.rifDishIn
                    self.statusArchiviato = valueArchiviato.status
                    self.showButtonBar = true
                } else {
                    self.valoreArchiviato = []
                    self.statusArchiviato = .bozza()
                    self.showButtonBar = false
                }
            
           // self.valoreArchiviato = currentMenu.wrappedValue.rifDishIn
           // self.statusArchiviato = currentMenu.wrappedValue.status
            self.rowViewSize = rowViewSize
            self.backgroundColorView = backgroundColorView
            self.destinationPath = destinationPath
        }
        
        @State private var filterCategoria:CategoriaMenu = .defaultValue
        @State private var filterPercorso:DishModel.PercorsoProdotto = .preparazioneFood
        
        var body: some View {
            
                VStack(alignment:.leading) {
                    
                    let container:[DishModel] = {
                       
                        var allDish:[DishModel] = []
                        
                        if self.filterCategoria == .defaultValue {
                            allDish = self.viewModel.cloudData.allMyDish
                        } else {
                            
                            allDish = self.viewModel.cloudData.allMyDish.filter({
                                $0.categoriaMenu == self.filterCategoria.id
                                })
                        }
                        
                        allDish.sort(by: {
                            
                            (currentMenu.rifDishIn.contains($0.id).description,$1.intestazione) > (currentMenu.rifDishIn.contains($1.id).description, $0.intestazione)
                        })
                        
                        return allDish
                    }()
                    
                        HStack(spacing:4) {
                            
                            Text("Status:")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                                .foregroundColor(.seaTurtle_2)
                            CSEtichetta(
                                text: currentMenu.status.simpleDescription(),
                                textColor: Color.white,
                                image: currentMenu.status.imageAssociated(),
                                imageColor: currentMenu.status.transitionStateColor(),
                                imageSize: .large,
                                backgroundColor: Color.white, backgroundOpacity: 0.2).fixedSize()
                            Spacer()
                            
                            CS_PickerWithDefault(selection: $filterCategoria, customLabel: "Tutti", dataContainer: self.viewModel.cloudData.allMyCategories)

                        }

                  //  }
                    let placeHolder:String = {
                      
                        if filterCategoria == .defaultValue {
                            return "Preparazioni & Prodotti"
                        } else {
                            return filterCategoria.simpleDescription()
                        }
                    }()

                    CSLabel_1Button(placeHolder: placeHolder, imageNameOrEmojy: filterCategoria.imageAssociated(), backgroundColor: Color.black)
                    
                    ScrollView(showsIndicators:false) {
                        
                        VStack {
                            
                            ForEach(container) { dishModel in
        
                                let containTheDish = currentMenu.rifDishIn.contains(dishModel.id)
                                
                                dishModel.returnModelRowView(rowSize: rowViewSize)
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
                                                   
                                                   self.addRemoveDishLocally(idPiatto: dishModel.id)
                                                 /*  self.viewModel.manageInOutPiattoDaMenuModel(idPiatto: dishModel.id, menuDaEditare: currentMenu) */
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
                    
                    if showButtonBar {
                        
                        BottomView_DLBIVSubView(
                            isDeActive: disableCondition()) {
                            description()
                            } resetAction: {
                                self.currentMenu.rifDishIn = valoreArchiviato
                            } saveAction: {
                                self.saveAction()
                            }
                    } else {
                        
                        CSDivider()
                    }

                    
                //    CSDivider()
                    
                }
               // .padding(.horizontal)

          //  } // chiusa CSzStack //deprecata 18.01
        }
        
        // Method

        private func saveAction() {
            self.viewModel.updateItemModel(itemModel: currentMenu,destinationPath: destinationPath)
        }
        
        private func disableCondition() -> Bool {
            self.currentMenu.rifDishIn == valoreArchiviato
        }
        
        private func description() -> (breve:Text,estesa:Text) {
            
            let allDishCount = self.viewModel.cloudData.allMyDish.count
            let dishInAtTheBeginning = valoreArchiviato.count
            
            let currentDishIn = currentMenu.rifDishIn.count
            let plusMinus = currentDishIn - dishInAtTheBeginning
            let plusMinusSymbol = plusMinus >= 0 ? "+" : ""
            let plusMinusString = plusMinus >= 0 ? "Aggiunti" : "Rimossi"
            
            let stringaBreve = "Piatti Totali: \(allDishCount)\nPiatti in Menu: \(currentDishIn) (\(plusMinusSymbol)\(plusMinus))"
           
            let stringaEstesa = "Updating -\(currentMenu.intestazione)-\nPiatti in precedenza: \(dishInAtTheBeginning)\nPiatti adesso: \(currentDishIn)\n\(plusMinusString): \(plusMinus)"
            
            return (Text(stringaBreve),Text(stringaEstesa))
            
        }
        
        private func addRemoveDishLocally(idPiatto:String) {
            
            if self.currentMenu.rifDishIn.contains(idPiatto) {
                self.currentMenu.rifDishIn.removeAll(where: {$0 == idPiatto})
                updateStatus()
            } else {
                self.currentMenu.rifDishIn.append(idPiatto)
                updateStatus()
            }
        
            // Innesto 01.12.22
            func updateStatus() {
                
                guard !currentMenu.tipologia.isDiSistema(),
                      statusArchiviato.checkStatusTransition(check: .disponibile) else { return }
                
                if currentMenu.allDishActive(viewModel: self.viewModel).isEmpty {
                    currentMenu.status = currentMenu.status.changeStatusTransition(changeIn: .inPausa)
                } else {
                    currentMenu.status = currentMenu.status.changeStatusTransition(changeIn: .disponibile)
                }
            }
           
        }
    }
    
}

struct VistaPiattiEspansa_Previews: PreviewProvider {
    
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
    
    @State static var dishItem4: DishModel = {
        
        var newDish = DishModel()
        newDish.intestazione = "Trofie al Pesto"
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
    
    @State static var dishItem5: DishModel = {
        
        var newDish = DishModel()
        newDish.intestazione = "Spaghetti Cacio e Pepe"
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
    
    @State static var dishItem6: DishModel = {
        
        var newDish = DishModel()
        newDish.intestazione = "Anellini al forno"
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
    
   @State static var menuSample: MenuModel = {

         var menu = MenuModel()
         menu.intestazione = "Agosto Menu"
         menu.tipologia = .fisso(persone: .due, costo: "18")
        // menu.tipologia = .allaCarta
         menu.isAvaibleWhen = .dataEsatta
         menu.giorniDelServizio = [.lunedi]
       //  menu.dishInDEPRECATO = [dishItem3]
         menu.rifDishIn = [dishItem3.id]
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
   
    /*
    static var menuDelGiorno:MenuModel = MenuModel(tipologia: .allaCarta(.delGiorno))
    static var menuDelloChef:MenuModel = MenuModel(tipologia: .allaCarta(.delloChef)) */
    static var menuDelGiorno:MenuModel = MenuModel(tipologiaDiSistema: .delGiorno)
    static var menuDelloChef:MenuModel = MenuModel(tipologiaDiSistema: .delloChef)
    
    
    @State static var viewModel: AccounterVM = {
         
        var vm = AccounterVM()
         vm.cloudData.allMyDish = [dishItem3,dishItem4,dishItem5,dishItem6]
         vm.cloudData.allMyIngredients = [ingredientSample,ingredientSample2,ingredientSample3,ingredientSample4]
         vm.cloudData.allMyMenu = [menuDelloChef,menuDelGiorno,menuSample,menuSample3,menuSample2]
         return vm
     }()
    

    
    static var previews: some View {
        NavigationStack {
         
            PreCallVistaPiattiEspansa(
                currentMenu: menuSample,
                rowViewSize: .normale(),
                backgroundColorView: .seaTurtle_1,
                destinationPath: .menuList)
            
        }.environmentObject(viewModel)
            
    }
}
