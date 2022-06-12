//
//  NuovoMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 15/03/22.
//

import SwiftUI

struct NuovoMenuMainView: View {

    @EnvironmentObject var viewModel: AccounterVM
    @State var nuovoMenu: MenuModel = MenuModel()
  //  @Binding var dismissView:Bool?
    @State private var nuovaIntestazioneMenu: String = ""
    @State private var openDishList: Bool? = false
    
    let backgroundColorView: Color
    
   /* init(editMenu:MenuModel? = MenuModel(), dismissView: Binding<Bool?>? = nil, backgroundColorView: Color) {
        
        _dismissView = dismissView ?? .constant(nil)
        _nuovoMenu = State(wrappedValue: editMenu!)
        
        self.backgroundColorView = backgroundColorView
            
    } */
    
    var isThereAReasonToDisable: (tipologia:Bool, programmazione: Bool) {

      let disableTipologia = self.nuovoMenu.intestazione == ""
      let disableProgrammazione = self.nuovoMenu.tipologia == .defaultValue
        
      return (disableTipologia,disableProgrammazione)
    }
 
    var body: some View {
        
        CSZStackVB(title: "Nuovo Menu", backgroundColorView: backgroundColorView) {
            
          //  backgroundColorView.opacity(0.9).ignoresSafeArea()
            
            VStack {
                
              /*  TopBar_3BoolPlusDismiss(title: nuovoMenu.intestazione != "" ? nuovoMenu.intestazione : "Crea Menu", exitButton: $dismissView, exitButtonTitle: "Chiudi")
                    .padding(.horizontal) */
     
            /*    TopBar_3BoolPlusDismiss(title: nuovoMenu.intestazione != "" ? nuovoMenu.intestazione : "Crea Menu", enableEnvironmentDismiss: true)
                    .padding()
                    .background(Color.cyan)
                
                Spacer()
                 */
              //  ZStack {
                    
                CSDivider()
                
                    ScrollView {
                        
                        VStack(alignment: .leading) {
                            
                            IntestazioneNuovoOggetto_Generic(placeHolderItemName: "Menu (Interno)", imageLabel: "doc.badge.plus", coloreContainer: Color.red, itemModel: $nuovoMenu)
                            
                            CSLabel_1Button(placeHolder: "Tipologia", imageNameOrEmojy: "dollarsign.circle", backgroundColor: Color.black)
                            
                            SpecificTipologiaNuovoMenu_SubView(newMenu: $nuovoMenu)
                                .opacity(isThereAReasonToDisable.tipologia ? 0.6 : 1.0)
                                .disabled(isThereAReasonToDisable.tipologia)

                           
                            
                            CSLabel_1Picker(placeHolder: "Programmazione", imageName: "calendar.badge.clock", backgroundColor: Color.black, availabilityMenu: self.$nuovoMenu.isAvaibleWhen, conditionToDisablePicker: isThereAReasonToDisable.programmazione)
                                
                            CorpoProgrammazioneMenu_SubView(nuovoMenu: $nuovoMenu)

                          //  Spacer()
                            
                            CSLabel_2Button(placeHolder: "Piatti", imageName: "circle", backgroundColor: Color.black, toggleBottoneTEXT: $openDishList, testoBottoneTEXT: "Vedi")
                               // .opacity(0.4)
                               // .disabled(true)
                            ForEach(nuovoMenu.dishIn) { dish in
                                
                                Text(dish.intestazione)
                            }
                            
                            BottomNuovoMenu_SubView(nuovoMenu: $nuovoMenu){self.scheduleANewMenu()}
             
                        }.padding(.horizontal)
                        
                        
                    } // Chiusa ScrollView
                    .disabled(openDishList!)
                    
                    if openDishList! {
                        
                        SelettoreMyModel<_,DishModel>(
                            itemModel: $nuovoMenu,
                            allModelList:ModelList.menuDishList ,
                            closeButton: $openDishList)
                        .zIndex(1)
                        
                    }
                    
                    
             //  } // Chiusa ZStack Interno
                
          
                
             //   Spacer()
                
                CSDivider()
            }
            
           
            
            
           /* .padding(.top)
            .background(RoundedRectangle(cornerRadius: 20.0).fill(Color.cyan.opacity(0.9)).shadow(radius: 5.0))
            .contrast(1.2)
            .brightness(0.08) */
        }
        .csAlertModifier(isPresented: $viewModel.showAlert, item: viewModel.alertItem)

    }
    
    // Method
    
    private func scheduleANewMenu() {
            
        self.viewModel.createOrUpdateItemModel(itemModel: self.nuovoMenu)
        
        print("Nome Menu: \(self.nuovoMenu.intestazione)")
        print("data Inizio:\(self.nuovoMenu.dataInizio.ISO8601Format())")
        print("data Fine: \(self.nuovoMenu.dataFine.ISO8601Format())")
        print("nei giorni di: \(self.nuovoMenu.giorniDelServizio.description)")
        print("dalle \(self.nuovoMenu.oraInizio.ISO8601Format()) alle \(self.nuovoMenu.oraFine.ISO8601Format())")
        
        
       print("Salvare MenuModel nel firebase e/o nell'elenco dei Menu in un ViewModel")
    }
}


/* struct NuovoMenuMainView: View {

    @EnvironmentObject var viewModel: AccounterVM
    @State private var nuovoMenu: MenuModel
    @Binding var dismissView:Bool?
    @State private var nuovaIntestazioneMenu: String = ""
    
    init(editMenu:MenuModel? = MenuModel(), dismissView: Binding<Bool?>? = nil) {
        
        _dismissView = dismissView ?? .constant(nil)
        _nuovoMenu = State(wrappedValue: editMenu!)
            
    }
    
    var isThereAReasonToDisable: (tipologia:Bool, programmazione: Bool) {

      let disableTipologia = self.nuovoMenu.intestazione == ""
      let disableProgrammazione = self.nuovoMenu.tipologia == .defaultValue
        
      return (disableTipologia,disableProgrammazione)
    }
 
    var body: some View {
        
        VStack {
            
            TopBar_3BoolPlusDismiss(title: nuovoMenu.intestazione != "" ? nuovoMenu.intestazione : "Crea Menu", exitButton: $dismissView, exitButtonTitle: "Chiudi")
                .padding(.horizontal)
 
            VStack(alignment: .leading) {
                
                IntestazioneNuovoOggetto_Generic(placeHolderItemName: "Menu (Interno)", imageLabel: "doc.badge.plus", coloreContainer: Color.red, itemModel: $nuovoMenu)
                
                CSLabel_1Button(placeHolder: "Tipologia", imageName: "dollarsign.circle", backgroundColor: Color.black)
                
                SpecificTipologiaNuovoMenu_SubView(newMenu: $nuovoMenu)
                    .opacity(isThereAReasonToDisable.tipologia ? 0.6 : 1.0)
                    .disabled(isThereAReasonToDisable.tipologia)

                CSLabel_2Button(placeHolder: "Ristoranti", imageName: "circle", backgroundColor: Color.black, toggleBottoneTEXT: .constant(false), testoBottoneTEXT: "Scegli")
                    .opacity(0.4)
                    .disabled(true)
                
                CSLabel_1Picker(placeHolder: "Programmazione", imageName: "calendar.badge.clock", backgroundColor: Color.black, availabilityMenu: self.$nuovoMenu.isAvaibleWhen, conditionToDisablePicker: isThereAReasonToDisable.programmazione)
                    
                CorpoProgrammazioneMenu_SubView(nuovoMenu: $nuovoMenu)

                BottomNuovoMenu_SubView(nuovoMenu: $nuovoMenu){self.scheduleANewMenu()}
 
            }.padding(.horizontal)
            
            
        }
        .padding(.top)
        .background(RoundedRectangle(cornerRadius: 20.0).fill(Color.cyan.opacity(0.9)).shadow(radius: 5.0))
        .contrast(1.2)
        .brightness(0.08)
       // .csAlertModifier(isPresented: $viewModel.showAlert, item: viewModel.alertItem)
       /*.alert(item:$viewModel.alertItem) { alert -> Alert in
           Alert(
             title: Text(alert.title),
             message: Text(alert.message)
           )
         }*/ // non funziona
    }
    
    // Method
    
    private func scheduleANewMenu() {
            
        self.viewModel.createOrEditItemModel(itemModel: self.nuovoMenu)
        
        print("Nome Menu: \(self.nuovoMenu.intestazione)")
        print("data Inizio:\(self.nuovoMenu.dataInizio.ISO8601Format())")
        print("data Fine: \(self.nuovoMenu.dataFine.ISO8601Format())")
        print("nei giorni di: \(self.nuovoMenu.giorniDelServizio.description)")
        print("dalle \(self.nuovoMenu.oraInizio.ISO8601Format()) alle \(self.nuovoMenu.oraFine.ISO8601Format())")
        
        
       print("Salvare MenuModel nel firebase e/o nell'elenco dei Menu in un ViewModel")
    }
} */ // BAckUp 28.04


/*
struct NuovoMenuMainView_Previews: PreviewProvider {
    static var previews: some View {
        NuovoMenuMainView(dismissView: .constant(true), backgroundColorView: Color.cyan)
    }
}

*/
