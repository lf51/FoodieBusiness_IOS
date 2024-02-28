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
                    self.statusArchiviato = .bozza//(.inPausa)
                    self.showButtonBar = false
                }
            
            self.rowViewSize = rowViewSize
            self.backgroundColorView = backgroundColorView
            self.destinationPath = destinationPath
        }
        
        @State private var filterCategoria:CategoriaMenu?
        @State private var filterPercorso:ProductAdress?
        
        var body: some View {
            
                VStack(alignment:.leading) {
                    
                    let hideEditing:Bool = {
                       // per creare una lista plain non modificabile. In futuro questo valore possiamo farlo passare dall'init.
                       let isDiSist = self.currentMenu.tipologia.isDiSistema()
                       let isOnAir = self.currentMenu.isOnAirValue().today
                       return isDiSist && !isOnAir
                    }()
                    
                   /* let container:[ProductModel] = {
                       
                        var allDish:[ProductModel] = []
                        
                        if self.filterCategoria == .defaultValue {
                            allDish = self.viewModel.db.allMyDish
                        } else {
                            
                            allDish = self.viewModel.db.allMyDish.filter({
                                $0.categoriaMenu == self.filterCategoria.id
                                })
                        }
                        
                        allDish.sort(by: {
                            
                            (currentMenu.rifDishIn.contains($0.id).description,$1.intestazione) > (currentMenu.rifDishIn.contains($1.id).description, $0.intestazione)
                        })
                        
                        return allDish
                    }()*/
                    
                    let container:[ProductModel] = {
                       
                        var allProduct = self.viewModel.db.allMyDish
                        
                        if let filterPercorso {
                            
                           allProduct = allProduct.filter({$0.adress == filterPercorso})
                        }
                        
                        if let filterCategoria {
                            
                           allProduct = allProduct.filter({
                                $0.categoriaMenu == filterCategoria.id
                                })
                            
                        }
                    
                        allProduct.sort(by: {
                            
                            (currentMenu.rifDishIn.contains($0.id).description,$1.intestazione) > (currentMenu.rifDishIn.contains($1.id).description, $0.intestazione)
                        })
                        
                        return allProduct
                    }()
                    
                        HStack(spacing:4) {
                            
                            let status = self.currentMenu.getStatusTransition(viewModel: self.viewModel)
                            
                           /* Text("Status:")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                                .foregroundStyle(Color.seaTurtle_2)*/
                            
                            CSEtichetta(
                                text: status.simpleDescription(),
                                textColor: Color.white,
                                image: currentMenu.status.imageAssociated(),
                                imageColor: status.colorAssociated(),
                                imageSize: .large,
                                backgroundColor: Color.white, backgroundOpacity: 0.2).fixedSize()
                            Spacer()
                            
                            adressPicker()
                                  .fixedSize()
                            
                          /* adressPicker()
                                .fixedSize()
                            Spacer()
                            categoriesPicker()
                                .fixedSize()*/
                            
                           /* CS_PickerWithDefault(
                                selection: $filterCategoria,
                                customLabel: "Tutti",
                                dataContainer: self.viewModel.db.allMyCategories)*/

                        }
                    
                   /* let placeHolder:String = {
                      
                        if let filterCategoria {
                            return filterCategoria.simpleDescription()
                        } else {
                           
                            return "Preparazioni & Prodotti"
                        }
                    }()

                    CSLabel_1Button(
                        placeHolder: placeHolder,
                        imageNameOrEmojy: filterCategoria?.imageAssociated(),
                        backgroundColor: Color.black) */
              
                    
                 /*   HStack {
                        
                        categoriesPicker()
                            .fixedSize()
                        
                        Spacer()
                        
                        let dishIn = self.currentMenu.rifDishIn.count
                        Text("In:\(dishIn)")
                            .font(.system(.subheadline, design: .monospaced,weight: .light))
                        
                        let media = self.currentMenu.mediaValorePiattiInMenu(readOnlyVM: self.viewModel)
                        let strinMedia = String(format: "%.1f",media)
                        Text("\(Image(systemName: "medal")):\(strinMedia)")
                    }*/
                    
                    HStack {
                        
                        categoriesPicker()
                            .fixedSize()
                        
                        Spacer()
                        let dishIn = self.currentMenu.rifDishIn.count
                        
                        let media = self.currentMenu.mediaValorePiattiInMenu(readOnlyVM: self.viewModel)
                        let strinMedia = String(format: "%.1f",media)
                        
                        CSEtichetta( // 21.09
                            text: strinMedia,
                            fontStyle: .body,
                            fontWeight: .semibold,
                            textColor: Color.yellow.opacity(0.7),
                            image: "medal.fill",
                            imageColor: Color.yellow.opacity(0.8),
                            imageSize:.large,
                            backgroundColor: Color.green.opacity(0.4),
                            backgroundOpacity: 1.0)
                        
                        
                        CSEtichetta( // 21.09
                            text: "\(dishIn)",
                            fontStyle: .body,
                            fontWeight: .semibold,
                            textColor: Color.seaTurtle_4,
                            image: "fork.knife.circle",
                            imageColor: Color.seaTurtle_4,
                            imageSize: .large,
                            backgroundColor: Color.seaTurtle_2,
                            backgroundOpacity: 1.0)
               
                    }
                    
                    
                    
                    
                    ScrollView(showsIndicators:false) {
                        
                        VStack {
                            
                            ForEach(container) { productModel in
        
                     
                                let containTheDish = currentMenu.rifDishIn.contains(productModel.id)
           
                                productModel.returnModelRowView(rowSize: rowViewSize)
                                    .opacity(containTheDish ? 1.0 : 0.4)
                                    .overlay(alignment: .bottomTrailing) {
                                        
                                        if !hideEditing {
                                            // Se true mostriamo una lista plain non modificabile
                                            CSButton_image(
                                               activationBool: containTheDish,
                                               frontImage: "trash",
                                               backImage: "plus",
                                               imageScale: .medium,
                                               backColor: .red,
                                               frontColor: .blue) {
                                                   withAnimation {
                                                       
                                                       self.addRemoveDishLocally(model: productModel)
     
                                                   }
                                                               }
                                               .padding(5)
                                               .background {
                                                   Color.white.opacity(containTheDish ? 0.5 : 1.0)
                                                       .clipShape(Circle())
                                                       .shadow(radius: 5.0)
                                               }
                                        }
                                    }
                            }
                        }
                    }
                    
                    if showButtonBar && !hideEditing {
                        
                      /*  BottomView_DLBIVSubView(
                            isDeActive: disableCondition()) {
                            description()
                            } resetAction: {
                                self.currentMenu.rifDishIn = valoreArchiviato
                            } saveAction: {
                                self.saveAction()
                            }*/
                        
                        BottomDialogView {
                            self.description()
                        } disableConditions: {
                            self.disableCondition()
                        } secondaryAction: {
                            self.currentMenu.rifDishIn = valoreArchiviato
                        } primaryDialogAction: {
                            self.saveButtonDialogView()
                        }
  
                    } else {
                        
                        CSDivider()
                    }

                    
                //    CSDivider()
                    
                }
               // .padding(.horizontal)

          //  } // chiusa CSzStack //deprecata 18.01
        }
        
        // ViewBuilder
        
        @ViewBuilder private func adressPicker() -> some View {
            
            let dataContainer = ProductAdress.allCases
            let container:[ProductModel] = self.viewModel.db.allMyDish
            let categoriaFiltro = filterCategoria?.id
            
            let containerCount = container.filter({
                let condition = categoriaFiltro == nil ? true : ($0.categoriaMenu == categoriaFiltro)
                return condition
            }).count
            
            HStack(spacing:0) {
                
                let image:(String,Color)? = filterPercorso?.imageAssociated()
                csVbSwitchImageText(string: image?.0,size: .large)
                    .foregroundColor(image?.1)
                
                Picker(selection:$filterPercorso) {
                             
                    Text("All Type (\(containerCount))")
                        .tag(nil as ProductAdress?)
                    
                        ForEach(dataContainer, id:\.self) {filter in

                            let count = container.filter({
                                
                                let condition_2 = categoriaFiltro == nil ? true : ($0.categoriaMenu == categoriaFiltro)
                                
                               return $0.adress == filter &&
                                condition_2
                            }).count
                            
                            Text("\(filter.simpleDescription()) (\(count))")
                                .tag(filter as ProductAdress?)
                                
                        }
                              
                } label: {}
                          .pickerStyle(MenuPickerStyle())
                          .accentColor(Color.black)
                          
                
            }
            .padding(.leading,5)
            .background(
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color.white.opacity(0.5))
            )

        }
        
        @ViewBuilder private func categoriesPicker() -> some View {
            
            let dataContainer = self.viewModel.db.allMyCategories
            let container = self.viewModel.db.allMyDish
            let adressFilter = filterPercorso
            
            let containerCount = container.filter({
                let condition = adressFilter == nil ? true : ($0.adress == adressFilter!)
                return condition
            }).count
            
            HStack(spacing:0) {
                
                let image = filterCategoria?.image
                csVbSwitchImageText(string: image,size: .large)
                    
                Picker(selection:$filterCategoria) {
                             
                    Text("All Categories (\(containerCount))")
                        .tag(nil as CategoriaMenu?)
                    
                        ForEach(dataContainer, id:\.self) {filter in

                            let count = container.filter({
                                
                                let condition_2 = adressFilter == nil ? true : ($0.adress == adressFilter!)
                                
                               return $0.categoriaMenu == filter.id &&
                                        condition_2
                                
                            }).count
                            
                            Text("\(filter.simpleDescription()) (\(count))")
                                .tag(filter as CategoriaMenu?)
                                
                        }
                              
                } label: {}
                          .pickerStyle(MenuPickerStyle())
                          .accentColor(Color.seaTurtle_4)
            }
            .padding(.leading,5)
            .background(
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color.black.opacity(0.2))
            )

              
        }
        
        @ViewBuilder private func saveButtonDialogView() -> some View {
     
            csBuilderDialogButton {
                DialogButtonElement(
                    label: .saveEsc) {
                        self.saveAction()
                    }
            }
        }
        
        // Method

        private func saveAction() {

           /* self.viewModel.createOrUpdateModelOnSub(
                itemModel: currentMenu,
                refreshPath: destinationPath) */ // deprecata
            
            // Funziona su i piattiEspansi e quindi salviamo solo le modifiche al rif dei Piatti. Quando è inbound nel nuovoMenuMainView questa funzione non è eseguita e le modifiche riguardono il currentMenu a livello StateLocally
            
            // B2B7
            //C6C4
            
            Task {
                do {
                    
                    DispatchQueue.main.async {
                        
                        viewModel.isLoading = true
                    }
                    
                    let value = self.currentMenu.rifDishIn
                    let key = MenuModel.CodingKeys.rifDishIn.rawValue
                    let path = [key:value]
                    
                    try await viewModel.updateSingleField(
                        docId: self.currentMenu.id,
                         sub: .allMyMenu,
                         path: path,
                         refreshPath: true)
                    
                } catch let error {
                    
                    DispatchQueue.main.async {
                        
                        viewModel.isLoading = nil
                        viewModel.alertItem = AlertModel(
                            title: "Errore",
                            message: "\(error.localizedDescription)")
                        
                    }
                    
                }
            }
            
        }
        
        private func disableCondition() -> (general:Bool?,primary:Bool,secondary:Bool?) {
           let general = self.currentMenu.rifDishIn == valoreArchiviato
            
            return(general,false,nil)
        }
        
        private func description() -> (breve:Text,estesa:Text) {
            
            let allDishCount = self.viewModel.db.allMyDish.count
            let dishInAtTheBeginning = valoreArchiviato.count
            
            let currentDishIn = currentMenu.rifDishIn.count
            let plusMinus = currentDishIn - dishInAtTheBeginning
            let plusMinusSymbol = plusMinus >= 0 ? "+" : ""
            let plusMinusString = plusMinus >= 0 ? "Aggiunti" : "Rimossi"
            
            let stringaBreve = "Piatti Totali: \(allDishCount)\nPiatti in Menu: \(currentDishIn) (\(plusMinusSymbol)\(plusMinus))"
           
            let stringaEstesa = "Updating -\(currentMenu.intestazione)-\nPiatti in precedenza: \(dishInAtTheBeginning)\nPiatti adesso: \(currentDishIn)\n\(plusMinusString): \(plusMinus)"
            
            return (Text(stringaBreve),Text(stringaEstesa))
            
        }
        
        private func addRemoveDishLocally(model:ProductModel) {
            
            do {
                
                try validateAction(for: model)
                executionAction(for: model.id)
                
            } catch let error {
                
               // self.viewModel.alertItem = AlertModel(
                 //   title: "Azione Bloccata",
                 //   message: error.localizedDescription)
                self.viewModel.logMessage = error.localizedDescription
                // usiamo il log perchè l'alert cozza con il popOver del selezionaPiatti in nuovoMenuMainView
            }
        
        }
        
        private func validateAction(for model:ProductModel) throws {
            
            let isArchiviato = model.getStatusTransition(viewModel: self.viewModel) == .archiviato
            
            if isArchiviato {
                
               throw CS_ErroreGenericoCustom.erroreGenerico(
                    modelName: model.intestazione,
                    problem: "Non può essere inserito in menu.",
                    reason: "È un prodotto archiviato.")
            }
            
        }
        
        private func executionAction(for modelId:String) {
            
            if self.currentMenu.rifDishIn.contains(modelId) {
                self.currentMenu.rifDishIn.removeAll(where: {$0 == modelId})
            } else {
                self.currentMenu.rifDishIn.append(modelId)
            
            }
        }
        
    }
    
}
/*
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
    
    @State static var dishItem3: ProductModel = {
        
        var newDish = ProductModel()
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
    
    @State static var dishItem4: ProductModel = {
        
        var newDish = ProductModel()
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
    
    @State static var dishItem5: ProductModel = {
        
        var newDish = ProductModel()
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
    
    @State static var dishItem6: ProductModel = {
        
        var newDish = ProductModel()
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
         
        let user = UserRoleModel()
       var vm = AccounterVM(userManager: UserManager(userAuthUID: "TEST_USER_UID"))//AccounterVM(userAuth: user)
         vm.db.allMyDish = [dishItem3,dishItem4,dishItem5,dishItem6]
         vm.db.allMyIngredients = [ingredientSample,ingredientSample2,ingredientSample3,ingredientSample4]
         vm.db.allMyMenu = [menuDelloChef,menuDelGiorno,menuSample,menuSample3,menuSample2]
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
}*/
