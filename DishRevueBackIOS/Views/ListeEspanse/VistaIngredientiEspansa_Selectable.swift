//
//  VistaIngredientiEspansa_Selectable.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 10/02/24.
//

import Foundation
import SwiftUI
import MyFoodiePackage
import MyFilterPackage
import MyPackView_L0

struct VistaIngredientiEspansa_Selectable: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    @Binding private var currentDish: ProductModel
    let backgroundColorView: Color
    let rowViewSize:RowSize
    let destinationPath:DestinationPath
    
    @State private var filterCore:CoreFilter<IngredientModel> = CoreFilter()
    
    init(
        currentDish: Binding<ProductModel>,
        backgroundColorView: Color,
        rowViewSize:RowSize,
        destinationPath: DestinationPath) {
        
        _currentDish = currentDish
        self.backgroundColorView = backgroundColorView
        self.rowViewSize = rowViewSize
        self.destinationPath = destinationPath
    }
   
    var body: some View {
        
        CSZStackVB(
            title: "Seleziona Ingredienti",
            titlePosition: .bodyEmbed([.horizontal,.top],15),
            backgroundColorView: backgroundColorView) {
        
                VStack(alignment:.leading) {
                    
                    let container = self.viewModel.ricercaFiltra(containerPath: \.db.allMyIngredients, coreFilter: filterCore)
                   // let container = container_0.filter({$0.status != .bozza()})
                    
                    HStack {
                        
                        Grid(alignment:.leading,verticalSpacing: 5) {
                            
                            GridRow(alignment:.lastTextBaseline) {
                                
                                Image(systemName: "leaf.fill")
                                    .imageScale(.medium)
                                    .foregroundStyle(Color.seaTurtle_3)
                                Text("Principali:")
                                    .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                                Text("\(self.currentDish.ingredientiPrincipali?.count ?? 0)")
                                    .monospaced()
                                
                            }
                            
                            GridRow(alignment:.lastTextBaseline)  {
                                Image(systemName: "leaf.fill")
                                    .imageScale(.medium)
                                    .foregroundStyle(Color.orange)
                                Text("Secondari:")
                                    .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                                Text("\(self.currentDish.ingredientiSecondari?.count ?? 0)")
                                    .monospaced()
                                
                            }
                        }

                    Spacer()
                        
                    CSTextField_4(
                        textFieldItem: $filterCore.stringaRicerca,
                        placeHolder: "Nome/Allergene",
                        image: "text.magnifyingglass",
                        imageBasicColor: .gray,
                        imageActiveColor: .black,
                        imageScale: .medium,
                        showDelete: true)
                        
                    }

                    vbFilterView(container: container)
                    
                    ScrollView(showsIndicators: false) {
                        
                        ForEach(container) { ing in
                            
                            let valuePath = self.currentDish.individuaPathIngrediente(idIngrediente: ing.id)
                            let valueRow = self.checkSelection(rifIng: ing.id, path: valuePath.path)
                            
                            ing.returnModelRowView(rowSize: rowViewSize)
                                .opacity(valuePath.path != nil ? 1.0 : 0.4)
                                .overlay(alignment: .bottomTrailing) {
                                    
                                    CSButton_image(
                                        frontImage: valueRow.image,
                                        imageScale: .large,
                                        frontColor: valueRow.colore) {
                                            withAnimation {
                                                selectDeselectAction(rif: ing.id, valuePath: valuePath)
                                            }
                                        }
                                        .padding(.trailing,10)
                                        .padding(.bottom,5)
                                        .shadow(radius: 5.0)
                                }
  
                        }
  
                    }
                    
                    CSDivider()
                }
         
    
            } // chiusa CSZStack
   
    }
    
    //Method
    
    @ViewBuilder private func vbFilterView(container:[IngredientModel]) -> some View {
        
                MyFilterRow(
                    allCases: [StatoScorte.inStock],
                    filterCollection: $filterCore.filterProperties.inventario,
                    selectionColor: Color.teal.opacity(0.6)) { value in
                        container.filter({
                            
                            $0.statusScorte() == value
                            
                           /* self.viewModel.currentProperty.inventario.statoScorteIng(idIngredient: $0.id) == value*/
                        }).count
                    }

                MyFilterRow(
                    allCases: OrigineIngrediente.allCases,
                    filterProperty: $filterCore.filterProperties.origineING,
                    selectionColor: Color.brown) { value in
                        container.filter({$0.values.origine == value}).count
                    }
 
        }
    
    private func checkSelection(rifIng:String,path:WritableKeyPath<ProductModel,[String]?>?) -> (colore:Color,image:String) {
        
        guard path != nil else { return (.gray,"leaf") }
        
        if path == \.ingredientiPrincipali { return (.seaTurtle_3,"leaf.fill")}
        else if path == \.ingredientiSecondari { return (.orange,"leaf.fill")}
        else { return (.black,"leaf")}
        
    }
    
    private func selectDeselectAction(rif:String,valuePath:(path:WritableKeyPath<ProductModel,[String]?>?,index:Int?)) {
        
        guard let currentPath = valuePath.path,
              let currentIndex = valuePath.index else {
       
            var principali = self.currentDish.ingredientiPrincipali ?? []
            principali.append(rif)
            
            self.currentDish.ingredientiPrincipali = principali
            
            return }
        
        
        if currentPath == \.ingredientiPrincipali {
            self.currentDish.ingredientiPrincipali?.remove(at: currentIndex)
            var secondari = self.currentDish.ingredientiSecondari ?? []
            
            secondari.append(rif)
            self.currentDish.ingredientiSecondari = secondari
        }
        else {
            
            self.currentDish.ingredientiSecondari?.remove(at: currentIndex)
        }
    
    }
    
    
 
    
}
