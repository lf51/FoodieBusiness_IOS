//
//  SelettoreIngrediente_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/02/22.
//

import SwiftUI

///Selettore Generico di MyModelProtocol. I [ModelList] hanno un un limite max (teorico/grafico) di 4 liste, di cui almeno una per tipo (container destinazione o container fonte), e un limite min di 2 (una per tipo). Il value dei keypath deve portare ad un array.

struct CheckCount {
    
    static var initCount: Int = 0
    static var itemCount: Int = 0
}

struct SelettoreMyModel<M1:MyModelProtocol,M2:MyModelProtocol>: View {
    
    var screenHeight: CGFloat = UIScreen.main.bounds.height

    @EnvironmentObject var viewModel: AccounterVM
    @Binding var itemModel: M1
    @Binding var closeButton: Bool?
    @Binding var creaButton: Bool?
    let allModelList: [ModelList]

    @State private var modelListCorrente: String = ""
    
    private var viewModelList: [ModelList] = []
    private var itemModelList: [ModelList] = []
    
    @State private var temporaryDestinationModelContainer: [String:[M2]] = [:]
    
    init(itemModel: Binding<M1>, allModelList: [ModelList], closeButton:Binding<Bool?>, creaButton:Binding<Bool?>? = nil) {
        
        _itemModel = itemModel
        _closeButton = closeButton
        _creaButton = creaButton ?? .constant(nil)
        self.allModelList = allModelList
        
        let currentList:String
        (self.viewModelList, self.itemModelList, currentList) = splitModelList(allModelList: allModelList)
        
        _modelListCorrente = State(initialValue: currentList)
        CheckCount.initCount += 1
        
    }

    private var isButtonDisabled: Bool {
        
    //    print("IsButtonDisabled - step 1")
        
        for itemList in itemModelList {
            
            if itemList.returnAssociatedValue().0 == self.modelListCorrente { return true }
            
        }
        
     //   print("IsButtonDisabled - step 2")
     
        for (_,container) in temporaryDestinationModelContainer {
            
            if !container.isEmpty {return false}
            
        }
     //   print("IsButtonDisabled - step 3")
        
        return true
    }
 
    var body: some View {

        VStack(alignment: .leading) {
            
            HStack {
                
                Text("Init: \(CheckCount.initCount)")
                Text("Item: \(CheckCount.itemCount)")
                
              /*  CSButton_large(
                    title: self.creaButton != nil ? "[+] Nuovo" : "Selettore",
                    accentColor: self.creaButton != nil ? Color.white : Color.black,
                    backgroundColor: Color.cyan.opacity(0.5),
                    cornerRadius: 20.0,
                    corners:.bottomRight,
                    paddingValue: 5.0) { self.creaButton!.toggle() }.disabled(self.creaButton == nil) */
                    
                CSButton_large(
                    title: "Chiudi",
                    accentColor: Color.red,
                    backgroundColor: Color.cyan.opacity(0.5),
                    cornerRadius: 20.0,
                    corners:.bottomLeft,
                    paddingValue: 5.0) { self.closeButton!.toggle() }
             
            }
   
            SwitchItemModelContainer<_,M2>(itemModel:$itemModel,itemModelList: itemModelList, modelListCorrente: $modelListCorrente)
                .padding(.horizontal)
              //  .padding(.top)
            
            SwitchViewModelContainer(viewModelList: viewModelList, modelListCorrente: $modelListCorrente)
                .padding()
                .background(Color.cyan.opacity(0.5))
                
            CurrentModelListView<_, M2>(itemModel: $itemModel, modelListCorrente: $modelListCorrente, allModelList: allModelList, itemModelList: itemModelList, temporaryDestinationModelList: $temporaryDestinationModelContainer)
            // .refreshable -> per aggiornare
            
            CSButton_large(title: "Aggiungi", accentColor: Color.white, backgroundColor: Color.cyan.opacity(0.5), cornerRadius: 0.0) {
                
                self.addModelToItemContainer()
                
                }
                .disabled(isButtonDisabled)
        }
        .background(Color.white.cornerRadius(20.0).shadow(radius: 5.0))
        .frame(width: (screenHeight * 0.40))
        .frame(height: screenHeight * 0.60 )
        .onChange(of: itemModel) { _ in
            CheckCount.itemCount += 1
        }
  
    }
    
    // Methodi & Oggetti
    
    private func addModelToItemContainer() {
        
        for list in self.itemModelList {
            
            let (title,keyPath,_) = list.returnAssociatedValue()
            let currentKeyPath = keyPath as? WritableKeyPath<M1,[M2]>
            
            if currentKeyPath != nil {
                self.itemModel[keyPath: currentKeyPath!].append(contentsOf: self.temporaryDestinationModelContainer[title] ?? [])
                /*qualora la chiave nel temporaryDestination non esiste passa un array vuoto */
                print("AddModelToItemContainer() -> currentKeyPath is not Nil")
            }
          /*  print("TemporaryContainer[\(title)] is empty: \(self.temporaryDestinationModelContainer[title]?.isEmpty.description)")*/
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
