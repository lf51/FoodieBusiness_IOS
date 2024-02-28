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
    @State private var hideDescription:Bool = true
    
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
        case .fromSharedLibrary:
            vbFromSharedLibrary(frameWidth: nil)

        }
        
    }
        
    @ViewBuilder private func vbRegular(frameWidth:CGFloat?) -> some View {
        
        CSZStackVB_Framed(frameWidth:frameWidth) {
            
            VStack(alignment:.leading,spacing: 8.0) {
                
                VStack(alignment:.leading,spacing: 0) {
                    
                    HStack(alignment:.lastTextBaseline){
                        
                        vbIntestazioneIngrediente()
                        
                        Spacer()
                        
                        vbStatusIngrediente()
                        
                    }

                    vbSubIntestazione()
                    
                }
                .padding(.top,5)
 
                vbDescriptionSwap()

                VStack(spacing:3) {
                    
                    vbProduzioneIngrediente()
                    
                    vbConservazioneIngrediente()
                    
                    vbAllergeneScrollRowView(listaAllergeni: self.item.values.allergeni)
                    
                }
                .padding(.bottom,5)

            } // chiuda VStack madre
            .padding(.horizontal,10)
        } // chiusa Zstack Madre
        
    }
    
    @ViewBuilder private func vbFromSharedLibrary(frameWidth:CGFloat?) -> some View {
        
        CSZStackVB_Framed(frameWidth: frameWidth) {
            
            VStack(alignment:.leading,spacing: 5.0) {
  
                vbIntestazioneIngrediente()
                        .padding(.top,5)
                
                vbOrigineProvenienza()
                
                VStack(spacing:3) {
                    
                    vbProduzioneIngrediente()
                    vbConservazioneIngrediente()
                    vbAllergeneScrollRowView(listaAllergeni: self.item.values.allergeni)
                    
                }
                .padding(.bottom,5)
                
            }
            .padding(.horizontal,10)
        }
        
        
    }
    
    // ViewBuilder di funzionamento
    
    @ViewBuilder private func vbIntestazioneIngrediente() -> some View {

        let value:(font:Font,imageSize:Image.Scale) = {
           
            if self.rowSize.returnType() == .normale() { return (.title2,.medium)}
            else { return (.title3,.small)}
        }()
        
       // let type = self.item.getIngredientType(viewModel: self.viewModel)
        let type = self.item.ingredientType
        
        let image = type.imageAssociated()
        let color = type.coloreAssociato()
        
        HStack(alignment:.center,spacing: 3) {
            
            Image(systemName: image)
                .imageScale(value.imageSize)
                .foregroundStyle(color)
            
            Text(self.item.intestazione.capitalized)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .allowsTightening(true)
                    .foregroundStyle(Color.white)
                    .overlay(alignment:.topTrailing) {
                        
                        if self.item.values.produzione == .biologico {
                            
                            Text("Bio")
                                .font(.system(.caption2, design: .monospaced, weight: .black))
                                .foregroundStyle(Color.green)
                                .offset(x: 10, y: -4)
                        }
                    }
        }

    }
    
    @ViewBuilder private func vbStatusIngrediente() -> some View {

        vbEstrapolaStatusImage(
            itemModel: self.item,
            viewModel: self.viewModel)
        
    }
    
    @ViewBuilder private func vbSubIntestazione() -> some View {

        let statoScorte = self.item.statusScorte()
        let transitionScorte = self.item.transitionScorte()

        let value:(raw:String,image:String,color:Color) = {
            
            if transitionScorte == .inArrivo {
                return (transitionScorte.rawValue,transitionScorte.imageAssociata(),transitionScorte.coloreAssociato())
            } else {
                return (statoScorte.rawValue,statoScorte.imageAssociata(),statoScorte.coloreAssociato())
            }
        }()
        
        HStack {
            
            vbDishIn()
            
            Spacer()
            
            HStack(spacing:3) {
                
                Text(value.raw)
                    .italic()
                    .bold()
                    .font(.subheadline)
                
                Image(systemName: value.image)
                    .imageScale(.medium)
                
            }
            .foregroundStyle(value.color)
            
        }
    }
    
    @ViewBuilder private func vbDishIn() -> some View {
        
        let (dishCount,substitution) = self.item.dishWhereIn(readOnlyVM: self.viewModel)
        let isInPausa = self.item.getStatusTransition() == .inPausa
        
        let type = self.item.ingredientType
        let isDiTerzi = type == .asProduct
        
        CSEtichetta(text: "\(dishCount)",
                    fontStyle: .title3,
                    fontWeight: .semibold,
                    textColor: Color.seaTurtle_4,
                    image: "fork.knife.circle",
                    imageColor: Color.seaTurtle_4,
                    imageSize: .large,
                    backgroundColor: Color.seaTurtle_2,
                    backgroundOpacity: isInPausa ? 0.4 : 1.0)
                    .blur(radius: isInPausa ? 1.0 : 0.0)
        
        
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
        
        if isDiTerzi {
            Text(type.simpleDescription())
                .italic()
                .font(.subheadline)
                .foregroundStyle(Color.seaTurtle_3)
                .fontWeight(.semibold)
        }
    }
    
    @ViewBuilder private func vbDescriptionSwap() -> some View {
        
        let isNotDescrived:Bool = {
            
            guard let descrizione = self.item.descrizione else { return true }
            return descrizione.isEmpty
        }()
        
        let describeButton:Color = isNotDescrived ? .gray : .seaTurtle_4
        
        HStack {
            
            if hideDescription { vbOrigineProvenienza() }
            else { vbDescriptionScrollRow() }
            
            Spacer()
            
            CSButton_image(
                activationBool: self.hideDescription,
                frontImage: "arrow.triangle.2.circlepath",
                imageScale: .medium,
                backColor: describeButton,
                frontColor: .seaTurtle_2,
                rotationDegree: 120) {
                    withAnimation(.linear) {
                        self.hideDescription.toggle()
                    }
                }
                .shadow(color: .gray, radius: 1.0,x:1.5)
                .csModifier(self.rowSize != .normale(), transform: { image in
                    image
                        .hidden()
                })
                .disabled(isNotDescrived)
            
        }
    }
    
    @ViewBuilder private func vbDescriptionScrollRow() -> some View {
        
        HStack(spacing:4) {
            
            Image(systemName: "list.bullet.rectangle")
                .imageScale(.medium)
                .foregroundStyle(Color.seaTurtle_3)
            
            ScrollView(.horizontal,showsIndicators: false) {
                Text(self.item.descrizione ?? "no description")
                    .font(.headline)
                    .italic()
                    .foregroundStyle(Color.black)
                    .opacity(0.6)
            }
        }
    }
    
    @ViewBuilder private func vbOrigineProvenienza() -> some View {
        
        HStack {
            
            let text = self.item.values.origine.simpleDescription()
            let(image,size) = self.item.associaImmagine()
            let provenienza = self.item.values.provenienza
            let noPlace = provenienza == .defaultValue
            
            CSEtichetta(
                text: text,
                fontStyle: .headline,
                fontWeight: .semibold,
                fontDesign: .default,
                textColor: .seaTurtle_4,
                image: image,
                imageColor: nil,
                imageSize: .large,
                backgroundColor: .seaTurtle_1,
                backgroundOpacity: 1.0)
            
            CSEtichetta(
                text: provenienza.simpleDescription(),
                fontStyle: .headline,
                fontWeight: .semibold,
                fontDesign: .default,
                textColor: .seaTurtle_1,
                image: provenienza.imageAssociated(),
                imageColor: nil,
                imageSize: .large,
                backgroundColor: .seaTurtle_4,
                backgroundOpacity: 0.8)
            .opacity(noPlace ? 0.4 : 1.0)
            
            Spacer()
           /* CSText_tightRectangleVisual(
                fontWeight: .bold,
                textColor: Color.seaTurtle_4,
                strokeColor: Color.seaTurtle_1,
                fillColor: Color.seaTurtle_1) {
                HStack {
                    csVbSwitchImageText(string: image,size: size)
                    Text(self.item.values.origine.simpleDescription())
                }
            } */
            
         /*  let isDefaultValue = self.item.values.provenienza == .defaultValue
            
            CSText_tightRectangleVisual(
                fontWeight: .bold,
                textColor: Color.seaTurtle_1,
                strokeColor: Color.seaTurtle_1,
                fillColor: Color.seaTurtle_4) {
                HStack {
                    
                    csVbSwitchImageText(string: self.item.values.provenienza.imageAssociated(),size:.large, slash: isDefaultValue)
                    
                    Text(self.item.values.provenienza.simpleDescription())
                }
            }.opacity(isDefaultValue ? 0.4 : 1.0)*/
            
           // Spacer()
            // 07.09
            // vbDishCountIn()
            // end 07.09
        }
    }
    
    @ViewBuilder private func vbProduzioneIngrediente() -> some View {
        
        HStack(spacing: 4.0) {
            
            csVbSwitchImageText(string: self.item.values.produzione.imageAssociated(), size: .large)
                .foregroundStyle(Color.white)
            
            ScrollView(.horizontal, showsIndicators: false) {

                Text(self.item.values.produzione.moreDescription())
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundStyle(Color.white)
                    .italic()
            }
        }
    }
    
    @ViewBuilder private func vbConservazioneIngrediente() -> some View {
        
        HStack(spacing: 4.0) {
            
            csVbSwitchImageText(string: self.item.values.conservazione.imageAssociated(), size: .large)
                .foregroundStyle(Color.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                Text(self.item.values.conservazione.extendedDescription())
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundStyle(Color.white)
                    .italic()
            }
            
        }
        
        
    }
}
/*
struct IngredientModel_RowView_Previews: PreviewProvider {
    
   static let user = UserRoleModel()
    
    @StateObject static var viewModel: AccounterVM = {
        var viewM = AccounterVM(userManager: UserManager(userAuthUID: "TEST_USER_UID"))
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
}*/
