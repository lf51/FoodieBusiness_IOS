//
//  SelettoreIngrediente_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/02/22.
//

import SwiftUI
import MyFoodiePackage
///Selettore Generico di MyModelProtocol. I [ModelList] hanno un un limite max (teorico/grafico) di 4 liste, di cui almeno una per tipo (container destinazione o container fonte), e un limite min di 2 (una per tipo). Il value dei keypath deve portare ad un array.

// 09.02.23 Deprecato definitivamente. Non più usato - Cancellabile
struct SelettoreMyModel<M1:MyProStarterPack_L1,M2:MyProStarterPack_L1>: View where M2.VM == AccounterVM {
    // M1 passa da MyModelProtocol a MyProStarterPackL0
    // M2 passa da MyModelProtocol a MyProStarterPackL1
    
    
    @EnvironmentObject var viewModel: AccounterVM
  
    @Binding var itemModel: M1
    let allModelList: [ModelList]
    @Binding var closeButton: Bool
    let backgroundColorView: Color
    
    var actionTitle: String
    var action: (() -> Void)? = nil

    @State private var modelListCorrente: String = ""
    
    private var viewModelList: [ModelList] = []
    private var itemModelList: [ModelList] = []
    
    @State private var temporaryDestinationModelContainer: [String:[M2]] = [:]
    
    let currentViewHeight: CGFloat
    
    init(itemModel: Binding<M1>, allModelList: [ModelList], closeButton:Binding<Bool>, backgroundColorView:Color, actionTitle:String = "", action: (() -> Void)? = nil)  {
        
        _itemModel = itemModel

        self.allModelList = allModelList
        _closeButton = closeButton
        self.backgroundColorView = Color("SeaTurtlePalette_2")//backgroundColorView.opacity(0.8)
        self.actionTitle = actionTitle
        self.action = action
        
        self.currentViewHeight = UIScreen.main.bounds.height
        
        let currentList:String
       
        (self.viewModelList, self.itemModelList, currentList) = splitModelList(allModelList: allModelList)
        
        _modelListCorrente = State(initialValue: currentList)
    
    }

    private var isButtonDisabled: Bool {
 
        for itemList in itemModelList {
            
            if itemList.returnAssociatedValue().0 == self.modelListCorrente { return true }
            
        }
     
        for (_,container) in temporaryDestinationModelContainer {
            
            if !container.isEmpty {return false}
            
        }
        return true
    }
 
    var body: some View {

        VStack(alignment: .leading) {
            
            HStack {
 
                if action != nil {
                    
                    CSButton_large(
                        title: actionTitle,
                        accentColor: Color.white,
                        backgroundColor: backgroundColorView,
                        cornerRadius: 20.0,
                        corners:.bottomRight,
                        paddingValue: 5.0) { self.action!() }
                    
                } else {
                    
                    CSButton_large(
                        title: actionTitle,
                        accentColor: Color.white,
                        backgroundColor: backgroundColorView,
                        cornerRadius: 20.0,
                        corners:.bottomRight,
                        paddingValue: 5.0) {  }
                        .hidden()
                }
                
                CSButton_large(
                    title: "Chiudi",
                    accentColor: Color.red,
                    backgroundColor: backgroundColorView,
                    cornerRadius: 20.0,
                    corners:.bottomLeft,
                    paddingValue: 5.0) { self.closeButton.toggle() }
             
            }
   
            SwitchItemModelContainer<_,M2>(itemModel:$itemModel,itemModelList: itemModelList, modelListCorrente: $modelListCorrente)
                .padding(.horizontal)
            
            SwitchViewModelContainer(viewModelList: viewModelList, modelListCorrente: $modelListCorrente)
                .padding()
                .background(backgroundColorView)
                
            CurrentModelListView<_, M2>(itemModel: $itemModel, modelListCorrente: $modelListCorrente, allModelList: allModelList, itemModelList: itemModelList, temporaryDestinationModelList: $temporaryDestinationModelContainer)
            // .refreshable -> per aggiornare
            
            CSButton_large(title: "Aggiungi", accentColor: Color.white, backgroundColor: backgroundColorView, cornerRadius: 0.0) {
                
                self.addModelToItemContainer()
                
                }
                .disabled(isButtonDisabled)
        }
       // .background(Color.yellow.cornerRadius(20.0).shadow(radius: 5.0))
        .background(Color.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 20.0)
        )
        .frame(width: (currentViewHeight * 0.40))
        .frame(height: currentViewHeight * 0.60 )
        .shadow(radius: 5.0)
       
  
    }
    
    // Methodi & Oggetti
    
    private func addModelToItemContainer() {
        
        for list in self.itemModelList {
            
            let (title,keyPath,_) = list.returnAssociatedValue()
            
         /*
          // Remove 25.08
          let currentKeyPath = keyPath as? WritableKeyPath<M1,[M2]>
            
            if currentKeyPath != nil {
                self.itemModel[keyPath: currentKeyPath!].append(contentsOf: self.temporaryDestinationModelContainer[title] ?? [])
                /*qualora la chiave nel temporaryDestination non esiste passa un array vuoto */
                print("AddModelToItemContainer() -> currentKeyPath is not Nil")
            }
        // End remove 25.08
          */
         
            // Add 25.08
            
            if let currentKeyPath = keyPath as? WritableKeyPath<M1,[M2]> {
                
                self.itemModel[keyPath: currentKeyPath].append(contentsOf: self.temporaryDestinationModelContainer[title] ?? [])
                /*qualora la chiave nel temporaryDestination non esiste passa un array vuoto */
                print("addModelToItemContainer: currentKeyPath as <M1:[M2]> - count in the itemModel:\(self.itemModel[keyPath: currentKeyPath].count)")
            }
            
            else if let currentKeyPath = keyPath as? WritableKeyPath<M1,[String]> {
              
             //   var idCollection: [String] = []
                
                for element in self.temporaryDestinationModelContainer[title] ?? [] {
                    
                    let idElement = element.id
                   // idCollection.append(idElement)
                    self.itemModel[keyPath: currentKeyPath].append(idElement)
                }
              
            //    self.itemModel[keyPath: currentKeyPath].append(contentsOf: idCollection)
                print("addModelToItemContainer: currentKeyPath as <M1:[String]> - count in the itemModel:\(self.itemModel[keyPath: currentKeyPath].count)")
                
            }

            // end 25.08
            
            
            self.temporaryDestinationModelContainer[title] = []
            print("Dentro AggiungiAction - keycount: \(temporaryDestinationModelContainer.keys.count) - \(temporaryDestinationModelContainer.keys.description)")
        }
    }
    
    private func splitModelList(allModelList:[ModelList]) -> (vmList:[ModelList],imList:[ModelList],currentList:String){
        
        var fonteModelList:[ModelList] = []
        var destinazioneModelList:[ModelList] = []
        
        for list in allModelList {
            
            let containerType = list.returnAssociatedValue().2

            if containerType == .fonte {fonteModelList.append(list)}
            else {destinazioneModelList.append(list)}
            
        }
        
      let currentList = fonteModelList.isEmpty ? "" : fonteModelList[0].returnAssociatedValue().0
      let destinazioneModelListOrdered = destinazioneModelList.sorted {
            
            $0.returnAssociatedValue().2.returnAssociatedValue().1.rawValue <
                $1.returnAssociatedValue().2.returnAssociatedValue().1.rawValue
            
        }
        
        print("Separazione Liste Active")
       /* print("Dentro SeparazioneListe: vmList:\(fonteModelList.count) - nameVMlist:\(fonteModelList.description), imList:\(destinazioneModelList.count)-nameIMlist:\(destinazioneModelList.description)") */
        return (fonteModelList,destinazioneModelListOrdered,currentList)
        
    }
         
}

/*
struct SelettoreMyModel_Previews: PreviewProvider {
    
  //  static var propertyVM: PropertyVM = PropertyVM()
    static var viewModel: AccounterVM = AccounterVM()
    
    static var previews: some View {
        
        ZStack {
            Color.cyan.opacity(0.8)
            Group{
                VStack{
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                    Text("Prova Prova Prova Prova")
                        .bold()
                }
                .padding()
                .foregroundColor(Color.white)
        
            }
        
            SelettoreMyModel<_,IngredientModel>(itemModel: .constant(DishModel()), allModelList: ModelList.dishIngredientsList)
            
          //  SelettoreIngrediente_NewDishSubView(newDish: .constant(DishModel()))

        }.onTapGesture {
            SelettoreMyModel_Previews.test()
        }
       
    }
    
    static func test() {
        
        for x in 1...20 {
            
        var ingrediente = IngredientModel()
            
            ingrediente.intestazione = "\(x.description)' ingredient"
            
            viewModel.allMyIngredients.append(ingrediente)
            
        }
        
    }
    
}
*/
