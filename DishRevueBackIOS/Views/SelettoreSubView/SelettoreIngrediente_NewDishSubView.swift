//
//  SelettoreIngrediente_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 24/02/22.
//

import SwiftUI

///Main View Selettore Generico di MyModelProtocol. l'elencoModelList : [ModelList] usa degli array predefiniti. In caso di custom array, occorre tener presente che il limite max (teorico/grafico) è di 4 liste, di cui almeno una per tipo (container destinazione o container fonte), e il limite min è 2 (una per tipo)
struct SelettoreIngrediente_NewDishSubView<M1:MyModelProtocol,M2:MyModelProtocol>: View {
    
    var screenHeight: CGFloat = UIScreen.main.bounds.height

    @EnvironmentObject var viewModel: AccounterVM
    @Binding var itemModel: M1
    var elencoModelList: [ModelList] = []
   // @State private var modelListCorrente: ModelList
    @State private var modelListCorrente: String = ""
    
    private var viewModelList: [ModelList] = []
    private var itemModelList: [ModelList] = []
   // private var temporaryListKey: [String] = []
    
    @State private var temporaryDestinationModelContainer: [String:[M2]] = [:]
    
    init(itemModel: Binding<M1>, elencoModelList: [ModelList]) {
        
        _itemModel = itemModel
        self.elencoModelList = elencoModelList
        (_,self.viewModelList, self.itemModelList) = separazioneListe(elencoModelList: elencoModelList)
        
        _modelListCorrente = State(initialValue: elencoModelList[0].returnAssociatedValue().0)
        
    }

    private func separazioneListe(elencoModelList:[ModelList]) -> (tempList:[String:[M2]],vmList:[ModelList],imList:[ModelList]){
        
        var fonteModelList:[ModelList] = []
        var destinazioneModelList:[ModelList] = []
        var temporaryDestinationModelList:[String:[M2]] = [:]
        
        for list in elencoModelList {
            
            let(title,_,type) = list.returnAssociatedValue()
         //   if AnyKeyPath.rootType == AccounterVM.self { }
            if type == .fonte { fonteModelList.append(list) }
            else if type == .destinazione {
                destinazioneModelList.append(list)
                temporaryDestinationModelList[title] = []
            }
          //  allListName.append(title)
        }
        print("Dentro SeparazioneListe.temporaryKey:\(temporaryDestinationModelList.keys.count), vmList:\(fonteModelList.count), imList:\(destinazioneModelList.count)")
        return (temporaryDestinationModelList,fonteModelList,destinazioneModelList)
        
    }
    
  /*  private func separazioneListe(elencoModelList:[ElencoModelList]) -> (vmList:[ElencoModelList],imList:[ElencoModelList],temList:[String]) {
        
        var viewModelList:[ElencoModelList]
        var itemModelList:[ElencoModelList]
        var temporaryListKey: [String]
        
        for list in elencoModelList {
            
            if list.returnTypeCase() == .itemModelContainer("") {
                
                itemModelList.append(list)
                temporaryListKey.append(list.returnAssociatedString())
                
            }
            else if list.returnTypeCase() == .viewModelContainer("",\.allMyIngredients) {
                
                viewModelList.append(list)
            }
            
        }
        
        return (viewModelList,itemModelList,temporaryListKey)
        
    } */
    
    
    
  /*  private var isAggiungiButtonDisabled: Bool {
        
        modelListCorrente == .ingredientiPrincipali || modelListCorrente == .ingredientiSecondari || (temporarySelectionIngredients["IngredientiPrincipali"]!.isEmpty && temporarySelectionIngredients["IngredientiSecondari"]!.isEmpty)
  
    } */
    
    var body: some View {

        VStack(alignment: .leading) {
            
            SwitchItemModelContainer(itemModelList: itemModelList, listaDaMostrare: $modelListCorrente)
                .padding(.horizontal)
                .padding(.top)
            
            SwitchViewModelContainer(viewModelList: viewModelList, listaDaMostrare: $modelListCorrente)
                .padding()
                .background(Color.cyan.opacity(0.5))
            
          /* SwitchListeIngredientiPiatto(newDish: $itemModel, listaDaMostrare: $modelListCorrente)
                .padding(.horizontal)
                .padding(.top)
            
            SwitchListeIngredienti(listaDaMostrare: $modelListCorrente)
                .padding()
                .background(Color.cyan.opacity(0.5)) */

          /*  ListaIngredienti_ConditionalView(newDish: $newDish, listaDaMostrare: $listaDaMostrare, temporarySelectionIngredients: $temporarySelectionIngredients) */
            // .refreshable -> per aggiornare
            
            ListaIngredienti_ConditionalView<_, M2>(itemModel: $itemModel, listaDaMostrare: $modelListCorrente, elencoModelList: elencoModelList, itemModelList: itemModelList, temporaryDestinationModelList: $temporaryDestinationModelContainer)
            
            CSButton_large(title: "Aggiungi", accentColor: Color.white, backgroundColor: Color.cyan.opacity(0.5), cornerRadius: 0.0) {
                
                self.aggiungiNewDishIngredients()
                
                }//.disabled(isAggiungiButtonDisabled)
        }
        .background(Color.white.cornerRadius(20.0).shadow(radius: 5.0))
        .frame(width: (screenHeight * 0.40))
        .frame(height: screenHeight * 0.60 )
  
    }
    
    // Methodi & Oggetti
    
    private func aggiungiNewDishIngredients() {

       /* self.newDish.ingredientiPrincipali.append(contentsOf: self.temporarySelectionIngredients["IngredientiPrincipali"]!)
        
        self.newDish.ingredientiSecondari.append(contentsOf: self.temporarySelectionIngredients["IngredientiSecondari"]!) */
        
        for list in itemModelList {
            
            let (title,keyP,_) = list.returnAssociatedValue()
            let wkp = keyP as! WritableKeyPath<M1,[M2]>
            self.itemModel[keyPath: wkp].append(contentsOf: self.temporaryDestinationModelContainer[title]!)
         //   self.itemModel[keyPath: wkp] = self.temporaryDestinationModelContainer[title]!
            self.temporaryDestinationModelContainer[title] = []
        }
        
        print("Action AggiungiListe -> Al momento Svuota le Liste temporanee. Da configurare")
        
      //  self.temporarySelectionIngredients["IngredientiPrincipali"]! = []
     //   self.temporarySelectionIngredients["IngredientiSecondari"]! = []
      
    }
         
}

struct SelettoreIngrediente_NewDishSubView_Previews: PreviewProvider {
    
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
        
          //  SelettoreIngrediente_NewDishSubView(newDish: .constant(DishModel()))

        }.onTapGesture {
            SelettoreIngrediente_NewDishSubView_Previews.test()
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
