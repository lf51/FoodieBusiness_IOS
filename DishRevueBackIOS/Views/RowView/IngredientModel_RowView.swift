//
//  IngredientModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/04/22.
//
/*
 Spaghetti,pesto.Bucatini,sugo,basilico.Trofie,gamberi,aglio,olio
 
 */
import SwiftUI
import MyPackView_L0
import MyFoodiePackage


struct IngredientModel_RowView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    let item: IngredientModel
    let rowSize:RowSize
    
    var body: some View { vbSwitchLocalRowSize() }
    
    // ViewBuilder
    
    @ViewBuilder private func vbSwitchLocalRowSize() -> some View {
        
        switch rowSize {
            
        case .sintetico:
            vbRegular(frameWidth: 300)
        case .ridotto:
            vbRegular(frameWidth: 300)
        case .normale(let width):
            vbRegular(frameWidth: width)
       /* case .ibrido(let width):
            vbRegular(frameWidth: width)*/
        }
        
        
    }
        
    
    @ViewBuilder private func vbRegular(frameWidth:CGFloat?) -> some View {
        
        CSZStackVB_Framed(frameWidth:frameWidth) {
            
            VStack(alignment:.leading,spacing: 5.0) {
                
                VStack(alignment:.leading,spacing: 0) {
                    
                    vbIntestazioneIngrediente()
                    //    vbSubIntestazioneIngrediente()
                    vbDishCountIn()
                    
                }
                
                .padding(.top,5)
                
                //  Spacer()
                
                HStack {
                    
                    let(image,size) = self.item.associaImmagine()
                    
                    CSText_tightRectangleVisual(
                        fontWeight: .bold,
                        textColor: Color.seaTurtle_4,
                        strokeColor: Color.seaTurtle_1,
                        fillColor: Color.seaTurtle_1) {
                        HStack {
                            csVbSwitchImageText(string: image,size: size)
                            Text(self.item.origine.simpleDescription())
                        }
                    }
                    
                    let isDefaultValue = self.item.provenienza == .defaultValue
                    
                    CSText_tightRectangleVisual(
                        fontWeight: .bold,
                        textColor: Color.seaTurtle_1,
                        strokeColor: Color.seaTurtle_1,
                        fillColor: Color.seaTurtle_4) {
                        HStack {
                            
                            csVbSwitchImageText(string: self.item.provenienza.imageAssociated(),size:.large, slash: isDefaultValue)
                            
                            Text(self.item.provenienza.simpleDescription())
                        }
                    }.opacity(isDefaultValue ? 0.4 : 1.0)
                    
                    Spacer()
                    // 07.09
                    // vbDishCountIn()
                    // end 07.09
                }
                
                //    Spacer()
                
                VStack(spacing:3) {
                    
                    vbProduzioneIngrediente()
                    vbConservazioneIngrediente()
                    vbAllergeneScrollRowView(listaAllergeni: self.item.allergeni)
                    
                }
                .padding(.bottom,5)
                //  .padding(.vertical,5)
                
            } // chiuda VStack madre
            // ._tightPadding()
            .padding(.horizontal,10)
            //  .padding(.vertical,5)
        } // chiusa Zstack Madre
        
        
    }
    
    @ViewBuilder private func vbDishCountIn() -> some View {
        
        let (dishCount,substitution) = self.item.dishWhereIn(readOnlyVM: self.viewModel)
        let isInPausa = self.item.status.checkStatusTransition(check: .inPausa)
        let isDisponibile = self.item.status.checkStatusTransition(check: .disponibile)
        
        HStack {
            
            CSEtichetta(text: "\(dishCount)",
                        fontStyle: .title3,
                        fontWeight: .semibold,
                        textColor: Color.seaTurtle_4,
                        image: "fork.knife.circle",
                        imageColor: Color.seaTurtle_4,
                        imageSize: .large,
                        backgroundColor: Color.seaTurtle_2,
                        backgroundOpacity: isDisponibile ? 1.0 : 0.4)
            .blur(radius: isDisponibile ? 0.0 : 1.0)
            
            
            if isInPausa {
                
                CSEtichetta(text: "\(substitution)",
                            fontStyle: .title3,
                            fontWeight: .semibold,
                            textColor: Color.seaTurtle_4,
                            image: "arrow.left.arrow.right.circle",
                            imageColor: Color.seaTurtle_4,
                            imageSize: .large,
                            backgroundColor: Color.seaTurtle_2,
                            backgroundOpacity: 1.0)
                
            }
            
            Spacer()
            
            let statoScorte = self.viewModel.currentProperty.inventario.statoScorteIng(idIngredient: self.item.id)
            
            HStack(spacing:3) {
                
                Text(statoScorte.rawValue)
                    .italic()
                    .bold()
                    .font(.subheadline)
                
                Image(systemName: statoScorte.imageAssociata())
                    .imageScale(.medium)
                
            }
            .foregroundStyle(statoScorte.coloreAssociato())
            
        }
        
        
        
        
    }
    
    @ViewBuilder private func vbProduzioneIngrediente() -> some View {
        
        HStack(spacing: 4.0) {
            
            csVbSwitchImageText(string: self.item.produzione.imageAssociated(), size: .large)
                .foregroundStyle(Color.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                Text(self.item.produzione.extendedDescription())
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundStyle(Color.white)
                    .italic()
            }
            
        }
        
        
    }
    
    @ViewBuilder private func vbConservazioneIngrediente() -> some View {
        
        HStack(spacing: 4.0) {
            
            csVbSwitchImageText(string: self.item.conservazione.imageAssociated(), size: .large)
                .foregroundStyle(Color.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                Text(self.item.conservazione.extendedDescription())
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundStyle(Color.white)
                    .italic()
            }
            
        }
        
        
    }
    
    @ViewBuilder private func vbIntestazioneIngrediente() -> some View {
        
        let dashedColor = self.viewModel.currentProperty.inventario.statoScorteIng(idIngredient: self.item.id).coloreAssociato()
        
        HStack(alignment:.lastTextBaseline) {
            
            Text(self.item.intestazione)
                .font(.title2)
                .fontWeight(.semibold)
                .lineLimit(1)
                .allowsTightening(true)
                .foregroundStyle(Color.white)
                .overlay(alignment:.topTrailing) {
                    
                    if self.item.produzione == .biologico {
                        
                        Text("Bio")
                            .font(.system(.caption2, design: .monospaced, weight: .black))
                            .foregroundStyle(Color.green)
                            .offset(x: 10, y: -4)
                    }
                }
            
            // 07.09
            
            /*   let isRiservaActive = {
             self.item.status == .completo(.inPausa) ||
             self.item.status == .bozza(.inPausa)
             }()
             
             if isRiservaActive {
             
             HStack {
             let dishCount = dishWhereIn()
             
             Text("\(dishCount)")
             Image(systemName: "arrow.left.arrow.right.circle")
             .imageScale(.medium)
             .foregroundStyle(isRiservaActive ? Color.seaTurtle_3 : Color.seaTurtle_1 )
             .overlay {
             
             if !isRiservaActive {
             
             Image(systemName: "circle.slash")
             .imageScale(.medium)
             .foregroundStyle(Color.seaTurtle_1)
             .rotationEffect(Angle(degrees: 90.0))
             
             }
             
             }
             
             }
             
             
             } */
            
            // end 07.09
            
            Spacer()
            
            vbEstrapolaStatusImage(
                itemModel: self.item,
                dashedColor: dashedColor)
            
        }
        
    }
    
}

struct IngredientModel_RowView_Previews: PreviewProvider {
    
   static let user = UserRoleModel()
    
    @StateObject static var viewModel: AccounterVM = {
        var viewM = AccounterVM(from: initServiceObject)
        viewM.db.allMyIngredients = [ ingredientSample,ingredientSample2,ingredientSample3,ingredientSample4
        
        ]
        return viewM
    }()
    @State static var ingredientSample =  IngredientModel(
        intestazione: "Guanciale Nero",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .altro,
        produzione: .convenzionale,
        provenienza: .restoDelMondo,
        allergeni: [.glutine],
        origine: .animale,
        status: .completo(.disponibile)
    )
    
    @State static var ingredientSample2 =  IngredientModel(
        intestazione: "Merluzzo",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .surgelato,
        produzione: .convenzionale,
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
        status: .completo(.inPausa))
    
    @State static var ingredientSample4 =  IngredientModel(
        intestazione: "Mozzarella di Bufala",
        descrizione: "Guanciale di Maialino nero dei Nebrodi (Sicilia).",
        conservazione: .congelato,
        produzione: .convenzionale,
        provenienza: .europa,
        allergeni: [.latte_e_derivati],
        origine: .animale,
        status: .bozza())
    
    static var previews: some View {
        
        ZStack {
            
            Color.seaTurtle_1.ignoresSafeArea()
            
            VStack(spacing:50) {
                
                IngredientModel_RowView(item: ingredientSample2, rowSize: .normale())
                    .frame(height:150)
                IngredientModel_SmallRowView(titolare: ingredientSample2, sostituto: nil)
                    .frame(height:50)
              //  IngredientModel_RowView(item: ingredientSample3)
              //  IngredientModel_RowView(item: ingredientSample4)
                
            }
        }.environmentObject(viewModel)
    }
}
