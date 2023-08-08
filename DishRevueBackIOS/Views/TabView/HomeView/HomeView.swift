//
//  HomeView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI
import UIKit
import MyPackView_L0
import MyFoodiePackage
import MyFilterPackage

struct HomeView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass // gli ipad e il macOS hanno una regularWidth, mentre gli iphone una compactWidth // vedi Nota 23.06.23
    
    @ObservedObject var authProcess: AuthPasswordLess
    @EnvironmentObject var viewModel: AccounterVM
    
    let tabSelection: DestinationPath
    let backgroundColorView: Color

    @State private var wannaAddNewProperty:Bool = false
    
    var screenHeight: CGFloat = UIScreen.main.bounds.height
    
   // @Binding var controlProxyReset:Bool
    
    var body: some View {

        NavigationStack(path:$viewModel.homeViewPath) {
      
        let userValue:(name:String,role:String,currentProperty:String) = {
            
            let propertyData = self.viewModel.currentProperty
                let role = propertyData.user.ruolo.rawValue
                let userName = propertyData.user.userName
                let prop = propertyData.cloudData.info?.intestazione ?? "no property in"
                
                return (userName,role,prop)
                
            }()
           /* CSZStackVB(title:authProcess.currentUser?.userDisplayName ?? "Home", backgroundColorView: backgroundColorView) {*/
            
            CSZStackVB(title: userValue.name, backgroundColorView: backgroundColorView) {

                VStack(alignment: .leading,spacing:.vStackBoxSpacing) {
                  //  VStack(spacing:.vStackBoxSpacing) {

                    ScrollViewReader { proxy in
                        
                   //     VStack(alignment:.leading) {
                   
    
                        VStack(alignment:.leading) {
                            Text("\(userValue.role): \(userValue.currentProperty)")
                                .italic()
                                .font(.caption2)
                                .foregroundColor(.black)
                                .opacity(0.75)
                            vbTopView()
                                .padding(10)
                                .background {
                                    Color.seaTurtle_2
                                        .opacity(0.4)
                                        .cornerRadius(5.0)
                                }
                        }
                        
                        ScrollView(showsIndicators:false) {
                            
                            PullToRefresh(coordinateSpaceName: "HomeViewMainScroll") {
                                self.viewModel.objectWillChange.send()
                                // manda l'update del view model e questo permette di aggiornare l'ora nel monitor ma anche i menu che nel fratttempo sono entrati in servizio
                                
                            }
                            
                            VStack(alignment: .leading,spacing:.vStackBoxSpacing) {
                                
                                MonitorServizio()
                                    .padding(.bottom,1)
                                    .id(0)
                                
                                
                                VStack(alignment:.leading,spacing: .vStackBoxSpacing) {
                                    MenuDiSistema_BoxView(menuDiSistema: .delGiorno)
                                    
                                    MenuDiSistema_BoxView(menuDiSistema: .delloChef)
                                    //  Spacer()
                                }.background {
                                    //  Color.red
                                }
                                
                                //  MonitorServizioGlobale()//Global
                                
                                CSZStackVB_Framed(/*frameWidth:650,*/backgroundOpacity: 0.05,shadowColor: .clear) {
                                    // Nota 01.03 ScheduleServizio
                                
                                        ScheduleServizio()
                                            .padding(5)
                                    
                                    //.background { Color.white.opacity(0.4)}
                                    
                                }
                                //  .background { Color.yellow.opacity(0.6)}
                                
                                MonitorReview()
                                    .padding(.bottom,1)
                                
                                let allPrepRated = compilaArrayPreparazioni()
                                
                                TopRated_SubView(
                                    allRated: allPrepRated,
                                    destinationPathView: .vistaRecensioniEspansa,
                                    label: "Preparazioni Top Rated",
                                    linkTitle: "Tutte")
                                //  .padding(.bottom,5)
                                
                                let (allMenuRated,allRifMenu) = compilaArrayMenu()
                                
                                TopRated_SubView(
                                    allRated: allMenuRated,
                                    destinationPathView: .listaGenericaMenu(
                                        _containerRif: allRifMenu,
                                        _label: "Menu Rated(Prov)"),
                                    label: "Menu Top Rated",
                                    linkTitle: "Tutti")
                                .padding(.bottom,5)
                            } // VStack End
                            
                        } // chiusa scrollView
                        //.id(1)
                        .coordinateSpace(name: "HomeViewMainScroll")
                        .onChange(of: self.viewModel.resetScroll) { _ in
                            if self.tabSelection == .homeView {
                                withAnimation {
                                    proxy.scrollTo(0,anchor: .top)
                                }
                            }
                        }
                        
                //    } // vstack Interno ScrollReader
                        
                    } // chiusa scrollViewReader
                   
                    CSDivider()
                    
                }  //.padding(.horizontal)
                .csHpadding()
            }// chiusa ZStack
            .navigationDestination(for: DestinationPathView.self, destination: { destination in
                destination.destinationAdress(backgroundColorView: backgroundColorView, destinationPath: .homeView, readOnlyViewModel: viewModel)
            })
         /*  .navigationDestination(for: PropertyModel.self, destination: { property in
                EditingPropertyModel(itemModel: property, backgroundColorView: backgroundColorView)
            }) */
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
   
    
                   /* NavigationLink(value: DestinationPathView.accountSetup(authProcess)) {
                        Image(systemName: "person.fill")
                            .foregroundColor(Color.seaTurtle_2)
                    }*/
                    
                   /* CSButton_image(frontImage: "person.fill", imageScale: .large, frontColor: .seaTurtle_2) {
                        csSetupButton()
                    }*/
                    
                    Menu {
                        
                       /* Button {
                            csSetupButton()
                        } label: {
                            HStack {
                                Image(systemName: "circle")
                                Text("Setup")
                            }
                        } */

                        NavigationLink(value: DestinationPathView.accountSetup(self.authProcess)) {
                            
                            HStack {
                                Image(systemName: "circle")
                                Text("Setup")
                                    }
                          
                                }
                        
                        Button {
                            //
                        } label: {
                            HStack {
                                Image(systemName: "circle")
                                Text("Logout")
                            }
                        }
                        
                        Button("Pubblica") {
                            // temporaneo
                            
                            if let property = self.viewModel.currentProperty.cloudData.info {
                                
                                self.viewModel.dbCompiler.publishGenericOnFirebase(collection: .propertyCollection, refKey: property.id, element: self.viewModel.currentProperty.cloudData)
                                
                            }
      
                        }
                        
                        
                    } label: {
                        
                        Image(systemName: "person.fill")
                            .imageScale(.large)
                            .foregroundColor(.seaTurtle_2)
                        
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    NavigationLink(value: DestinationPathView.propertyList) {
                        
                        HStack(alignment:.lastTextBaseline,spacing:2) {
                            Image(systemName: "house")
                                .imageScale(.medium)
                            Text("Proprietà")
                                .fontWeight(.bold)
                          //  Image(systemName: "rectangle.portrait.and.arrow.right")
                           
                        }
                        .foregroundColor(.seaTurtle_4)
                    }
                    
                    
                }
            }
          
        }
  
    }
    // Method
    
    
   /* private func csSetupButton() {
        
        guard self.authProcess.currentUser != nil else {
             return self.authProcess.openSignInView = true
           
        }
        
        self.viewModel.addToThePath(
            destinationPath: .homeView,
            destinationView: .accountSetup(self.authProcess))
        
       /* self.viewModel.homeViewPath.append(DestinationPathView.accountSetup(self.authProcess)) */
        
    } */ // deprecata 26.07
    
    private func compilaArrayPreparazioni() -> [DishModel] {
        
        //let tutteLePreparazioni = self.viewModel.allMyDish.filter({$0.percorsoProdotto != .prodottoFinito})
        //update 09.07.23
        let tutteLePreparazioni = self.viewModel.currentProperty.cloudData.db.allMyDish.filter({
            !$0.rifReviews.isEmpty &&
            $0.percorsoProdotto != .prodottoFinito
            
        })
        // end update
        let topRated = tutteLePreparazioni.sorted(by: {
            $0.topRatedValue(readOnlyVM: self.viewModel) > $1.topRatedValue(readOnlyVM: self.viewModel)
        })
                
        return topRated
        
    }
    
    private func compilaArrayMenu() -> (model:[MenuModel],rif:[String]) {
        
        let allMenu = self.viewModel.currentProperty.cloudData.db.allMyMenu.filter({$0.mediaValorePiattiInMenu(readOnlyVM: self.viewModel) > 0.0 })
        
        let allSorted = allMenu.sorted(by: {
            $0.mediaValorePiattiInMenu(readOnlyVM: self.viewModel) > $1.mediaValorePiattiInMenu(readOnlyVM: self.viewModel)
        })
        
        let allRif = allSorted.map({$0.id})
        
        return (allSorted,allRif)
        
    } // Le func di compilazione possono essere in futuro spostate nel viewModel e rese generiche. Attendiamo di fare le liste e i sistemi di filtraggio. Queste qui possono unirsi e conformarsi ai sistemi di filtraggio


    @ViewBuilder private func vbTopView() -> some View {
        
        let isCompactWidth = self.horizontalSizeClass == .compact
        
        let layout = isCompactWidth ? AnyLayout(VStackLayout(alignment:.leading,spacing:10)) : AnyLayout(HStackLayout(alignment:.center))
       
       // VStack(alignment:.leading) {
       // HStack(alignment:.center) {
        layout {
            
            HStack {
                
                addNewModel()
                
             //   Spacer()
                Divider()
                    .fixedSize()
                
                NavigationLink(value: DestinationPathView.categoriaMenu) {
                
                    
                    HStack(alignment:.lastTextBaseline,spacing:3) {
                        Image(systemName: "list.bullet.clipboard")
                            .imageScale(.small)
                        Text("Categorie")
                            .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                        
                    }
                    .foregroundColor(.seaTurtle_3)
                      //  .padding(5)
                       /* .background {
                            Color.seaTurtle_1
                                .opacity(0.9)
                                .blur(radius: 10.0)
                                .cornerRadius(5.0)
                        } */
                     
                }
                
              //  Spacer()
                
                Divider()
                    .fixedSize()
                
                NavigationLink(value: DestinationPathView.moduloImportazioneVeloce) {
                    
                //    HStack(spacing:2) {
                        
                        Text("⚡️Import⚡️")
                            .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                      //  Text("[🍽🧂]")
                        //    .font(.subheadline)
                        
                 //   }
                            .foregroundColor(.seaTurtle_3)
                   /* .padding(5)
                    .background {
                        Color.seaTurtle_1
                            .opacity(0.9)
                            .blur(radius: 10.0)
                            .cornerRadius(5.0)
                    }*/
                }
                
            }
            //.lineLimit(1)
            //.padding(.bottom,5)
           // .padding(.vertical,5)
           // .padding(.horizontal,5)
            
            if !isCompactWidth {
                Divider()
                    .fixedSize()
            }
                
            
            HStack {
                
                NavigationLink(value: DestinationPathView.listaDellaSpesa) {
                
                    HStack(alignment:.lastTextBaseline,spacing:2) {
                        Image(systemName: "cart")
                            .imageScale(.medium)
                            .foregroundColor(.seaTurtle_3)
                        Text("Lista della Spesa")
                            .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                    }
                    .foregroundColor(.seaTurtle_3)
                  /*  .padding(5)
                    .background {
                        Color.seaTurtle_1
                            .opacity(0.9)
                            .blur(radius: 10.0)
                            .cornerRadius(5.0)
                    } */
                }
                
              //  Spacer()
                
                Divider()
                    .fixedSize()
                
                let propertyDestination:DestinationPathView? = {
                    
                    let allProp = self.viewModel.currentProperty.cloudData.db.allMyProperties
                    
                    guard !allProp.isEmpty else { return nil }
                    
                    let model = allProp[0]
                    return DestinationPathView.property(model)

                    }()
                
                NavigationLink(value: propertyDestination) {
                    
                        HStack(alignment:.lastTextBaseline,spacing:2) {
                            Image(systemName: "house")
                                .imageScale(.medium)
                            Text("Edit")
                                .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                        }
                        .foregroundColor(.seaTurtle_3)
                    }
                    .opacity(propertyDestination == nil ? 0.5 : 1.0)
              
 
                
                Spacer()
            
                let trashDestination:DestinationPathView? = {
                    
                    let isTrashEmpty = self.viewModel.remoteStorage.modelRif_deleted.isEmpty
                    
                    guard !isTrashEmpty else { return nil }
                    
                    return DestinationPathView.elencoModelDeleted

                    }()
                
                
                NavigationLink(value: trashDestination) {
                    Image(systemName: "trash")
                          .imageScale(.medium)
                          .foregroundColor(.seaTurtle_4)
                }
                .opacity(trashDestination == nil ? 0.5 : 1.0)
                
            
            }
           // .lineLimit(1)
            //.frame(width:UIScreen.main.bounds.width - 40)
        }
    }
    
    private func nuovePreparazioni() -> (food:DishModel,drink:DishModel,pf:DishModel) {
        
        let newDish = DishModel()
        
        let newDrink = {
           var new = DishModel()
            new.percorsoProdotto = .preparazioneBeverage
            return new
        }()
        let newPF = {
           var new = DishModel()
            new.percorsoProdotto = .prodottoFinito
            return new
        }()
        
        return (newDish,newDrink,newPF)
    }
    
    @ViewBuilder private func addNewModel() -> some View {
        
        let newDish = DishModel()
        let newING = IngredientModel()
        let newMenu = MenuModel()
        
        Menu {
            
            NavigationButtonGeneric(item: newING)
            NavigationButtonGeneric(item: newDish)
            NavigationButtonGeneric(item: newMenu)

        } label: {
            Text("[+] Aggiungi")
                .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                .foregroundColor(.seaTurtle_3)
        }
       /* .padding(5)
        .background {
            Color.seaTurtle_1
                .opacity(0.9)
                .blur(radius: 10.0)
                .cornerRadius(5.0)
        } */

        
        
    }

}

struct HomeView_Previews: PreviewProvider {
 
    @State static var viewModel = testAccount
    
    static var previews: some View {
        
        NavigationStack {
            
            HomeView(
                authProcess: AuthPasswordLess(),
                tabSelection: .homeView,
                backgroundColorView: .seaTurtle_1)
          //  .previewDevice(PreviewDevice(rawValue: "Mac"))
           
          
        }.environmentObject(testAccount)
           // .previewDevice("iPhone 8")
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
        
        NavigationStack {
            
            HomeView(
                authProcess: AuthPasswordLess(),
                tabSelection: .homeView,
                backgroundColorView: .seaTurtle_1)
          //  .previewDevice(PreviewDevice(rawValue: "Mac"))
           
          
        }.environmentObject(testAccount)
           // .previewDevice("iPhone 8")
            .previewDevice(PreviewDevice(rawValue: "12.9” iPad Pro"))

    }
}

struct MenuDiSistema_BoxView:View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    let menuDiSistema:TipologiaMenu.DiSistema
    
    var body: some View {
        
        VStack(alignment:.leading,spacing:.vStackLabelBodySpacing) {
            
            let menuDS = self.viewModel.trovaMenuDiSistema(menuDiSistema: menuDiSistema)
            
           // let tipologia:TipologiaMenu = menuDiSistema.returnTipologiaMenu()
           
            CSLabel_conVB(
                placeHolder: "\(menuDiSistema.shortDescription())",
                imageNameOrEmojy: menuDiSistema.imageAssociated(),
                backgroundColor: .seaTurtle_2,
                backgroundOpacity: menuDS != nil ? 1.0 : 0.2) {
                   
                    HStack {
                        
                        if menuDS == nil {
                            
                            Button {
                                
                              //  let newDS = MenuModel(tipologia: tipologia)
                                let newDS = MenuModel(tipologiaDiSistema: menuDiSistema)
                                withAnimation {
                                    self.viewModel.switchFraCreaEUpdateModel(itemModel: newDS)
                                }
                            } label: {
                                Text("Abilita")
                                    .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                                    .foregroundColor(.seaTurtle_3)
                                    .shadow(radius: 5.0)
                            }
                            
                        } else {
                            
                            let dishIn = menuDS!.rifDishIn.count
                            let allDish = viewModel.currentProperty.cloudData.db.allMyDish.count
                            
                            NavigationLink(value: DestinationPathView.vistaPiattiEspansa(menuDS!)) {
                                
                                HStack(spacing:0) {
                                    Text("Espandi(\(dishIn)/\(allDish))")
                                        .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                                        
                                    Image(systemName: "arrow.up.right.square")
                                        .imageScale(.medium)
                                    
                                }
                                .foregroundColor(.seaTurtle_3)
                                .shadow(radius: 5.0)
                                .opacity(allDish == 0 ? 0.4 : 1.0)
                                    
                                    
                            }.disabled(allDish == 0)
                            
                            Spacer()
                            
                            CSButton_image(
                                frontImage: "x.circle",
                                imageScale: .medium,
                                frontColor: .seaTurtle_4) {
                                   // self.viewModel.deleteItemModel(itemModel: menuDS)
                                    withAnimation {
                                        menuDS?.manageModelDelete(viewModel: self.viewModel)
                                    }
                                }
                                .shadow(color: .seaTurtle_4, radius: 1.0)
                                .padding(.trailing)
                         //   Spacer()
                            
                        }
                    }
                    
                }
            
            if menuDS != nil {
                
                HStack {
           
                        if menuDS!.rifDishIn.isEmpty {
                            
                            Text("\(menuDiSistema.shortDescription()) Vuoto")
                                .italic()
                                .font(.headline)
                                .foregroundColor(.seaTurtle_2)
                            
                        } else {
                            
                            ScrollView(.horizontal,showsIndicators: false ) {
                                
                                HStack {
                                    
                                    ForEach(menuDS!.rifDishIn,id:\.self) { idPiatto in
                                           
                                        if let piatto = self.viewModel.modelFromId(id: idPiatto, modelPath: \.currentProperty.cloudData.db.allMyDish) {
                                               
                                             //  DishModel_RowView(item: piatto, rowSize: .sintetico)
                                               GenericItemModel_RowViewMask(
                                                model: piatto,
                                                rowSize: .sintetico) {
                                                   
                                                    Button {
                                                        
                                                        viewModel.manageInOutPiattoDaMenuDiSistema(idPiatto: idPiatto, menuDiSistema: menuDiSistema)

                                                    } label: {
                                                        HStack{
                                                            
                                                            Text("Rimuovi da \(menuDiSistema.simpleDescription()) ")
                                                           
                                                        }
                                                    }
                                                    
                                                    
                                                }
              
                                           }
         
                                       }
                                }
                            }
                        }

                }
            }
        
        } // chiusa VStack Madre

    }
}

struct NavigationButtonGeneric<M:MyProStatusPack_L1>:View where M.DPV == DestinationPathView {
    
    @EnvironmentObject var viewModel: AccounterVM
    let item: M
    
    var body: some View {
    
       // let(_,_,nome,image) = item.basicModelInfoInstanceAccess()
        let (incipit,nome,image) = self.infoItem()
        
        Button {
            viewModel.addToThePath(destinationPath: .homeView, destinationView: item.pathDestination())
        } label: {
            HStack {
                Text("\(incipit) \(nome)")
                Image(systemName: image)
             
            }
        }

    }
    
    // Method
    
    private func infoItem() -> (incipit:String,nome:String,image:String) {
        
        let incipit:String
        let nome:String
        let image:String
        
        if let localItem = item as? DishModel {
            
                incipit = "Nuova"
                nome = "Preparazione"
                image = localItem.basicModelInfoInstanceAccess().imageAssociated
                
  
        } else {
            
            incipit = "Nuovo"
            (_,_,nome,image) = item.basicModelInfoInstanceAccess()
            
        }
        
        return (incipit,nome,image)
        
    }
    
}

struct TopRated_SubView<M:MyProVisualPack_L1>:View where M.RS == RowSize, M.VM == AccounterVM {
    
    @EnvironmentObject var viewModel:AccounterVM
    let allRated:[M]
    let destinationPathView:DestinationPathView
    let label:String
    let linkTitle:String
    
    var body: some View {
        
        VStack(alignment:.leading,spacing:.vStackLabelBodySpacing) {

            let topThree = self.allRated.prefix(3).enumerated()
            let disabled = self.allRated.isEmpty
            
            CSLabel_conVB(
                placeHolder: label,
                imageNameOrEmojy: "medal",
                backgroundColor: .seaTurtle_2,
                backgroundOpacity: disabled ? 0.2 : 1.0) {
                    
                    NavigationLink(value:destinationPathView) {
                        
                        HStack(spacing:2) {
                            Text(linkTitle)
                                .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                                
                            Image(systemName: "arrow.up.right.square")
                                .imageScale(.medium)
                            
                        }
                        .foregroundColor(.seaTurtle_3)
                        .shadow(radius: 5.0)
                        .opacity(disabled ? 0.4 : 1.0)
                            
                            
                    }.disabled(disabled)
                }
            
            VStack(spacing:.vStackBoxSpacing) {
                
                ForEach(Array(topThree),id:\.element) {position,element in

                    HStack {
                     //   element.returnModelRowView(rowSize: .sintetico)
                       GenericItemModel_RowViewMask(
                        model: element,
                        rowSize: .sintetico) {
                            element.vbMenuInterattivoModuloCustom(viewModel: self.viewModel, navigationPath: \.homeViewPath)
                        }
                        
                        Text(csRatingMedalReward(position: position))
                            .font(.largeTitle)

                    }
                    
                }
            }
            
        }
        
        
    }
}
