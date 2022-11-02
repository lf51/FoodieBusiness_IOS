//
//  DishesView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

struct DishListView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var tabSelection: Int // non Usata
    let backgroundColorView: Color
    
    @State private var openFilter: Bool = false
    @State private var filterProperty:FilterPropertyModel = FilterPropertyModel()
    
    var body: some View {
        
        NavigationStack(path:$viewModel.dishListPath) {
            
            CSZStackVB(title: "I Miei Piatti", backgroundColorView: backgroundColorView) {
 

              /*  VStack {
                    
                    CSDivider()
                    ScrollView {
                        ForEach(viewModel.allMyDish) { piatto in
                            
                            GenericItemModel_RowViewMask(model: piatto) {
                                
                                piatto.vbMenuInterattivoModuloCustom(viewModel: viewModel, navigationPath: \.dishListPath)
                                
                                vbMenuInterattivoModuloCambioStatus(myModel:piatto,viewModel: viewModel)
 
                                vbMenuInterattivoModuloEdit(currentModel: piatto, viewModel: viewModel, navPath: \.dishListPath)
                                
                                vbMenuInterattivoModuloTrash(currentModel: piatto, viewModel: viewModel)
                            }
                            
                        }

                    }
                } */
                
                
                // fine temporaneo
                
                BodyListe_Generic(filterProperty: $filterProperty, containerKP: \.allMyDish, navigationPath: \.dishListPath)

            }
            .navigationDestination(for: DestinationPathView.self, destination: { destination in
                destination.destinationAdress(backgroundColorView: backgroundColorView, destinationPath: .dishList, readOnlyViewModel: viewModel)
            })
     
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    LargeBar_TextPlusButton(
                        buttonTitle: "Nuovo Piatto",
                        font: .callout,
                        imageBack: Color("SeaTurtlePalette_2"),
                        imageFore: Color.white) {
                           // viewModel.dishListPath.append(DishModel())
                            self.viewModel.dishListPath.append(DestinationPathView.piatto(DishModel()))
                        }
                
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    CSButton_image(frontImage: "slider.horizontal.3", imageScale: .large, frontColor: Color("SeaTurtlePalette_3")) {
                        self.openFilter.toggle()
                    }
                    .padding([.top,.trailing],5)
                    .overlay(alignment: .topTrailing) {
                        let count = filterProperty.countChange
                        
                        if count != 0 {
                            
                            Text("\(count)")
                                .fontWeight(.bold)
                                .font(.caption)
                                .foregroundColor(Color.white)
                                .padding(4)
                                .background {
                                   Color("SeaTurtlePalette_1")
                                        //.clipShape(Circle())
                                }
                                .clipShape(Circle())
                        }
                            
                    }

                }
            }
            .popover(isPresented: $openFilter, attachmentAnchor: .point(.top)) {
                vbLocalFilterPop()
                    .presentationDetents([.height(350)])
          
            }

        
        }
    }
    
    // Method
    
    @ViewBuilder private func vbLocalFilterPop() -> some View {
     
            FilterRowContainer(backgroundColorView: backgroundColorView) {
             
                    self.filterProperty = FilterPropertyModel()
                
            } content: {

                FilterRow_Generic(allCases: DishModel.PercorsoProdotto.allCases, filterCollection: $filterProperty.percorsoPRP, selectionColor: Color.white.opacity(0.5), image: "fork.knife")
            
                let checkAvailability = checkStatoScorteAvailability()
                
                FilterRow_Generic(allCases: Inventario.TransitoScorte.allCases, filterCollection: $filterProperty.inventario, selectionColor: Color.teal.opacity(0.6), image: "cart")
                    .opacity(checkAvailability ? 1.0 : 0.3)
                    .disabled(!checkAvailability)
                
                FilterRow_Generic(allCases: StatusTransition.allCases, filterCollection: $filterProperty.status, selectionColor: Color.mint.opacity(0.8), image: "circle.dashed")
                
                FilterRow_Generic(allCases: TipoDieta.allCases, filterCollection: $filterProperty.dietePRP, selectionColor: Color.orange.opacity(0.6), image: "person.fill.checkmark")
                
                FilterRow_Generic(allCases: AllergeniIngrediente.allCases, filterCollection: $filterProperty.allergeniIn, selectionColor: Color.red.opacity(0.7), image: "allergens")
                
              
                
            }
                
            
        }
    

    
    
    private func checkStatoScorteAvailability() -> Bool {
        
        self.filterProperty.percorsoPRP.contains(.prodottoFinito) &&
        self.filterProperty.percorsoPRP.count == 1
        
    }
    
}


struct DishListView_Previews: PreviewProvider {
    
    static var previews: some View {
       
            DishListView(tabSelection: .constant(1), backgroundColorView: Color("SeaTurtlePalette_1"))
            .environmentObject(testAccount)
    }
}

