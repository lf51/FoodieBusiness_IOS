//
//  ProductModel_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/04/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

public enum RowSize:Equatable,Hashable { // Nota 22.06.23

    case sintetico
    case ridotto
    case normale(_ limitedTo:CGFloat? = nil)
    case fromSharedLibrary
  //  case ibrido(_ limitedTo:CGFloat? = nil)
    
    func returnType() -> RowSize {
        
        switch self {
        case .sintetico:
            return .sintetico
        case .ridotto:
            return .ridotto
        case .normale(_):
            return .normale()
        case .fromSharedLibrary:
            return .normale()
            
       /* case .ibrido(_):
            return .ibrido() */
        }
    }
    
    func getFrameWidth() -> CGFloat? {
        
        switch self {
        case .sintetico:
            return 300
        case .ridotto:
            return 300
        case .fromSharedLibrary:
            return 300
        case .normale(let width):
            return width
            
       /* case .ibrido(let width):
            return width */

        }
        
    }
    
}

struct ProductModel_RowView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    let item: ProductModel
    let rowSize:RowSize
    
    @State private var hideDescription:Bool = true
    
    init(item: ProductModel, rowSize: RowSize = .normale()) {
        
        self.item = item
        self.rowSize = rowSize

    }
    
    var body: some View { vbSwitchRowSize() }
    
    // View da Switchare
    
    @ViewBuilder private func vbSwitchRowSize() -> some View {
        
        switch rowSize {
            
        case .sintetico:
            vbSinteticRow()
        case .ridotto:
            vbSmallRow()
        default:
            vbNormalRow()
        }
    }
    
    @ViewBuilder private func vbSinteticRow() -> some View {
        
        CSZStackVB_Framed(frameWidth:rowSize.getFrameWidth()) {
            
            VStack(alignment:.leading) {

                    vbIntestazioneDishRow()
                    vbSubIntestazioneDishRow()

            } // chiuda VStack madre
            .padding(.vertical,5)
            .padding(.horizontal,10)
            
        }
    }
    
    @ViewBuilder private func vbSmallRow() -> some View {
        
        CSZStackVB_Framed(frameWidth:rowSize.getFrameWidth()) {
            
            VStack(alignment:.leading) {
                
                VStack(alignment:.leading) {

                    vbIntestazioneDishRow()
                    vbSubIntestazioneDishRow()
                
                }
                 .padding(.top,5)
                
                Spacer()
                vbBadgeRow()
                vbNoticeAllergeni()
                    .padding(.bottom,5)

            } // chiuda VStack madre
            .padding(.horizontal,10)
            
        } // chiusa Zstack Madre
    }
    
    @ViewBuilder private func vbNormalRow() -> some View {
        
        CSZStackVB_Framed(frameWidth:rowSize.getFrameWidth()) {
            
            VStack(alignment:.leading) {
                
                VStack {

                    vbIntestazioneDishRow()
                    vbSubIntestazioneDishRow()
 
                }
                 .padding(.top,5)
                
                Spacer()
                
                VStack(alignment:.leading,spacing:10) {
                    
                    vbBadgeRow()
                    
                    if hideDescription { vbIngredientView() }
                    else { vbDescriptionScrollRow() }
     
                    vbDieteCompatibili()
                }
                
                Spacer()
 
                    let listaAllergeni = self.item.calcolaAllergeniNelPiatto(viewModel: self.viewModel)
                
                    vbAllergeneScrollRowView(listaAllergeni: listaAllergeni)
                     .padding(.bottom,5)

            } // chiuda VStack madre
            .padding(.horizontal,10)
                            
        } // chiusa Zstack Madre
        
    }
    

    // ViewBuilder di funzionamento
    @ViewBuilder private func vbIntestazioneDishRow() -> some View {
        
        let value:(font:Font,imageSize:Image.Scale) = {
           
            if self.rowSize.returnType() == .normale() { return (.title2,.medium)}
            else { return (.title3,.small)}
        }()
        
        let productType:ProductType = {
            
            if let categoria = self.viewModel.modelFromId(id: item.categoriaMenu, modelPath: \.db.allMyCategories) {
                return categoria.productType
            } else {
                return .noValue
            }
        }()
    
        let percorsoImage = self.item.adress.imageAssociated(to: productType)
        
        HStack(alignment:.center,spacing: 3) {
            
            Image(systemName: percorsoImage.system)
                .imageScale(value.imageSize)
                .foregroundStyle(percorsoImage.color)
            
            Text(self.item.intestazione)
                .font(value.font)
                .fontWeight(.semibold)
                .lineLimit(1)
                .allowsTightening(true)
                .foregroundStyle(Color.white)
              //  .fixedSize()
            
            Spacer()
            
                vbEstrapolaStatusImage(
                    itemModel: self.item,
                    viewModel: self.viewModel)
          //  }
            
        }
        
    }
    
    @ViewBuilder private func vbSubIntestazioneDishRow() -> some View {
        
        let (price,count) = csIterateDishPricing()
        // add 21.09
        let moneyCode = Locale.current.currency?.identifier ?? "EUR"
        let priceDouble = Double(price) ?? 0
     
        HStack(alignment:.center,spacing: 3) {
            
            let adress = self.item.adress
            
            if adress != .finito {
              
                vbReviewLine()
                
            } else {
                Text(adress.simpleDescription().lowercased())
                    .italic()
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.seaTurtle_2)
            }
           
            Spacer()
            
            HStack(alignment:.top,spacing:1) {
              //  Text("€ \(price)") // 21.09
                Text("\(priceDouble,format: .currency(code: moneyCode))")
                    .fontWeight(.bold)
                    .font(.title3)
                    .foregroundStyle(Color.seaTurtle_4)
                
                Text("+\(count)")
                    .fontWeight(.bold)
                    .font(.caption2)
                    .foregroundStyle(Color.seaTurtle_3)
            }
            
            
        }
       .font(.subheadline)
        
    }
    
    @ViewBuilder private func vbReviewLine() -> some View {
        
        let (mediaRating,ratingCount,_) = self.item.ratingInfo(readOnlyViewModel: viewModel)
        
        Group {
            Text("\(mediaRating,specifier: "%.1f")") // media
                .fontWeight(.light)
                .foregroundStyle(Color.seaTurtle_1)
                .padding(.horizontal,5)
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color.seaTurtle_2)
                )

            Group {
                Text("/")
                Text("\(ratingCount) recensioni") // valore da importare
                    .italic()
            }
            .fontWeight(.semibold)
            .foregroundStyle(Color.seaTurtle_2)
        }
        
    }
    
    @ViewBuilder private func vbBadgeRow() -> some View {
        
        let areAllBio = self.item.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.values.produzione, quality: .biologico)
        
        let isDelGiorno = self.viewModel.checkMenuDiSistemaContainDish(idPiatto: self.item.id, menuDiSistema: .delGiorno)
        let isAdviceByTheChef = self.viewModel.checkMenuDiSistemaContainDish(idPiatto: self.item.id, menuDiSistema: .delloChef)

        let isNotDescribed:Bool = {
            let conditionOne = self.item.descrizione == nil
            let conditionTwo = self.item.descrizione?.isEmpty ?? true
            return conditionOne || conditionTwo
        }()
        
        HStack {
         
            vbBadgeRowFixBlock()
                .fixedSize()
            
            ScrollView(.horizontal,showsIndicators: false){
                
                HStack {
                    
                    if areAllBio {
                        
                        CSEtichetta(
                            text: "BIO",
                            textColor: .seaTurtle_1,
                            image: "💯",
                            imageColor: nil,
                            imageSize: .large,
                            backgroundColor: Color.green,
                            backgroundOpacity: 1.0)

                    }
                
                    if self.item.ingredienteSottostante == nil {
                        
                        vbBadgeRowQualityPreparazione()
                        
                    }
                    
                    if isDelGiorno {
                        
                        CSEtichetta(
                            text: "del Giorno",
                            textColor: Color.white,
                            image: "fork.knife.circle.fill",
                            imageColor: Color.yellow,
                            imageSize: .medium,
                            backgroundColor: Color.pink,
                            backgroundOpacity: 0.5)
                    }

                    if isAdviceByTheChef {
                        
                        CSEtichetta(
                            text: "dello Chef",
                            textColor: Color.white,
                            image: "👨🏻‍🍳", //"🗣️", // person.wave.2
                            imageColor: nil,
                            imageSize: .large,
                            backgroundColor: Color.purple,
                            backgroundOpacity: 0.7)
                    }
                    
                } // chiusa HStack Interno
                
            } // chiusa ScrollHorizontal
            
            let describeButton:Color = isNotDescribed ? .gray : .seaTurtle_4
            
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
                .disabled(isNotDescribed)
   

        } // end HastackMadre
    }
    
    @ViewBuilder private func vbBadgeRowFixBlock() -> some View {
        
        let menuWhereIsIn = self.viewModel.allMenuContaining(idPiatto: self.item.id).countWhereDishIsIn
        
        let basePreparazione = self.item.calcolaBaseDellaPreparazione(readOnlyVM: self.viewModel)
        
        let sottostante:IngredientModel? = self.item.getIngredienteCollegatoAsProduct(viewModel: viewModel)
        
        CSEtichetta(
            text: "\(menuWhereIsIn)",
            fontStyle: .subheadline,
            fontWeight: .semibold,
            textColor: .seaTurtle_4,
            image: "menucard",
            imageColor: .seaTurtle_4,
            imageSize: .medium,
            backgroundColor:.seaTurtle_2,
            backgroundOpacity: 1.0)

        CSEtichetta(
            text: "",
            textColor: .seaTurtle_2,
            image: basePreparazione.imageAssociate(),
            imageColor: nil,
            imageSize: .large,
            backgroundColor:Color.white.opacity(0),
            backgroundOpacity: 1.0)
        
        if let sottostante {
            
            let statoScorte = sottostante.statusScorte()
            let transition = sottostante.transitionScorte()
            
            let value:(raw:String,image:String,color:Color) = {
                
                if transition == .inArrivo {
                    
                    return (transition.rawValue,transition.imageAssociata(),transition.coloreAssociato())
                } else {
                    
                    return (statoScorte.rawValue,statoScorte.imageAssociata(),statoScorte.coloreAssociato())
                }
                
            }()
            
            CSEtichetta(
                text: value.raw,
                fontStyle: .subheadline,
                fontWeight: .semibold,
                fontDesign: .default,
                textColor: .seaTurtle_1,
                image: value.image,
                imageColor: .seaTurtle_1,
                imageSize: .medium,
                backgroundColor: value.color,
                backgroundOpacity: 1.0)

        }
        
    }
    
    @ViewBuilder private func vbBadgeRowQualityPreparazione() -> some View {
        
        let areAllLocal = self.item.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.values.provenienza, quality: .km0)
        
        let areAllItalian = self.item.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.values.provenienza, quality: .italia)
        
        if areAllItalian {
            
            CSEtichetta(
                text: "🇮🇹",
                fontStyle: .subheadline,
                textColor: Color.white,
                image: "💯",
                imageColor: nil,
                imageSize: .large,
                backgroundColor: Color.white.opacity(0.5),
                backgroundOpacity: 1.0)
        }
        
        if areAllLocal {
            
            CSEtichetta(
                text: "locale",
                textColor: Color.white,
                image: "💯",
                imageColor: nil,
                imageSize: .large,
                backgroundColor: Color.yellow.opacity(0.5),
                backgroundOpacity: 1.0)
        }
        
    }
    
    @ViewBuilder private func vbIngredientView() -> some View {
        
        let sottostante = self.item.getSottostante(viewModel: self.viewModel).sottostante
        
        if let sottostante { vbIngredientsSintetic(sottostante:sottostante) }
        else { vbIngredientScrollRow() }
    }
    /// solo per viewRow ibride
    @ViewBuilder private func vbIngredientsSintetic(sottostante:IngredientSubModel) -> some View {

            let conservazione = sottostante.conservazione
            let origine = sottostante.origine
            let provenienza = sottostante.provenienza
            let noPlace = provenienza == .defaultValue
        
            HStack {
                
                ScrollView(.horizontal,showsIndicators: false) {
                    
                    HStack {
                        
                        CSEtichetta(
                            text: "\(conservazione.simpleDescription())",
                            fontStyle: .headline,
                            fontWeight: .semibold,
                            fontDesign: .default,
                            textColor: .seaTurtle_4,
                            image: conservazione.imageAssociated(),
                            imageColor: nil,
                            imageSize: .large,
                            backgroundColor: .seaTurtle_4,
                            backgroundOpacity: 0.2)
                        
                        CSEtichetta(
                            text: "\(origine.simpleDescription())",
                            fontStyle: .headline,
                            fontWeight: .semibold,
                            fontDesign: .default,
                            textColor:.seaTurtle_4,
                            image: origine.imageAssociated(),
                            imageColor: nil,
                            imageSize: .large,
                            backgroundColor: .seaTurtle_1,
                            backgroundOpacity: 1.0)
                        
                        CSEtichetta(
                            text: "\(provenienza.simpleDescription())",
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
                    }
                }
            }
    }
    
    @ViewBuilder private func vbIngredientScrollRow() -> some View {
 
        let allFilteredIngredients:[IngredientModel] = self.item.allMinusArchiviati(viewModel: self.viewModel)
    
            HStack(spacing: 4.0) {
   
                    Image(systemName: "list.bullet.rectangle")
                        .imageScale(.medium)
                        .foregroundStyle(Color.seaTurtle_4)
  
                if !allFilteredIngredients.isEmpty {
                    
                    ScrollView(.horizontal,showsIndicators: false) {
                        
                        HStack(alignment:.lastTextBaseline, spacing: 2.0) {
                            
                            ForEach(allFilteredIngredients) { ingredient in
                                
                                let (isPrincipal,hasAllergene,isTemporaryOff,idSostituto,isBio) = self.analizingIngredient(ingredient: ingredient)
                                
                               HStack(spacing:5) {
                                    
                                   Text(ingredient.intestazione)
                                        .font(isPrincipal ? .headline : .subheadline)
                                        .foregroundStyle(isTemporaryOff ? Color.seaTurtle_1 : Color.seaTurtle_4)
                                        .strikethrough(isTemporaryOff, color: Color.gray)
                                        .underline(isBio, pattern: .solid, color: Color.green)
                                        .overlay(alignment:.topTrailing) {
                                            if hasAllergene {
                                                Text("*")
                                                    .foregroundStyle(Color.black)
                                                    .offset(x: 5, y: -3)
                                            }
                                        }

                                   if idSostituto != nil {
                                        
                                       let (isActive,name,allergeniIn) = self.viewModel.infoFromId(id: idSostituto!, modelPath: \.db.allMyIngredients)
                                       
                                       if isActive {
                                           
                                           Text("(\(name))")
                                               .font(isPrincipal ? .headline : .subheadline)
                                               .foregroundStyle(Color.seaTurtle_3)
                                               .overlay(alignment:.topTrailing) {
                                                   if allergeniIn {
                                                       Text("*")
                                                           .foregroundStyle(Color.black)
                                                           .offset(x: 5, y: -3)
                                                   }
                                               }
                                       }
                                       
                                        
                                    }

                                }
                                
                                Text("•")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.seaTurtle_4)
               
                            }
                        }
                    }
                } else {
                    
                    Text("Lista Ingredienti Vuota")
                        .italic()
                        .font(.headline)
                        .foregroundStyle(Color.seaTurtle_1)
                    Spacer()
                }
                
            }
       // }
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
    
    @ViewBuilder private func vbDieteCompatibili() -> some View {
        
        HStack(spacing: 4.0) {
            
            Image(systemName: "person.fill.checkmark")
                .imageScale(.medium)
                .foregroundStyle(Color.seaTurtle_4)
         
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack(spacing: 2.0) {
                    
                    ForEach(TipoDieta.allCases,id:\.self) { diet in
                        
                        let value = checkDietCompatibility(for: diet)
                        
                        CSEtichetta(
                            isBarrato: value.isBarrato,
                            text: diet.simpleDescription(),
                            fontStyle: .subheadline,
                            textColor: .seaTurtle_1,
                            image: value.image,
                            imageColor: value.colorImage,
                            imageSize: .medium,
                            backgroundColor: diet.coloreAssociato(),
                            backgroundOpacity: value.backOpacity)


                    }
                }
            }
        }
    }
    
    @ViewBuilder private func vbNoticeAllergeni() -> some View {
        
        let listaAllergeni = self.item.calcolaAllergeniNelPiatto(viewModel: self.viewModel)
        let string = listaAllergeni.isEmpty ? "Non contiene Allergeni" : "Contiene Allergeni"
    
        HStack(spacing:4.0) {
            Image(systemName: "allergens")
                .imageScale(.medium)
            Text(string)
        }
        .fontWeight(.semibold)
        .font(.caption)
        .underline(!listaAllergeni.isEmpty)
        .foregroundStyle(Color.black)
    }

    // Metodi di funzionamento
    
    private func csIterateDishPricing() -> (price:String,count:String) {
        
        var mandatoryPrice:String = "0.00"
        let pricingCount = self.item.pricingPiatto.count
        let normalizedCount = pricingCount > 0 ? (pricingCount - 1) : pricingCount
        let stringCount:String = String(normalizedCount)
        
        guard !self.item.pricingPiatto.isEmpty else {
          
            return (mandatoryPrice,stringCount)
        }
            
            for format in self.item.pricingPiatto {
                
                if format.type == .mandatory {
                    mandatoryPrice = format.price
                    break
                }
               
            }

            return (mandatoryPrice,stringCount)
            
    }

    private func analizingIngredient(ingredient:IngredientModel) -> (isPrincipal:Bool,hasAllergene:Bool,isTemporary:Bool,idSostituto:String?,isBio:Bool) {
        
        let ingredientiPrincipali = self.item.ingredientiPrincipali ?? []
        let isPrincipal = ingredientiPrincipali.contains(ingredient.id)
    
        let hasAllergene:Bool = {
            if let allergens = ingredient.values.allergeni {
                return !allergens.isEmpty
            } else { return false }
        }()
        let isItBio = ingredient.values.produzione == .biologico
  
        var isOff: Bool = false
        
        if self.item.idIngredienteDaSostituire == ingredient.id {isOff = true}
        else { isOff = ingredient.statusTransition == .inPausa }
        var idSostituto: String? = nil

        if isOff {
            let allTemporaryOff = self.item.elencoIngredientiOff ?? [:]
            
            for (key,value) in allTemporaryOff {
                
                if ingredient.id == key {
                    // Modifica 02.09
                    let isAlreadyIn = self.item.checkIngredientsInPlain(idIngrediente: value)
                    idSostituto = isAlreadyIn ? nil : value
                    // end - Vedi Nota Vocale 02.09 - bug "Menta(Mango)"
                    break
                }
            }
        }
        
        return (isPrincipal,hasAllergene,isOff,idSostituto,isItBio)
        // end 30.08

    }
    
    private func checkDietCompatibility(for tipo:TipoDieta) -> (isBarrato:Bool,image:String,colorImage:Color,backOpacity:CGFloat) {
        
        let dietAvaible = self.item.returnDietAvaible(viewModel: self.viewModel).inDishTipologia
        
        if dietAvaible.contains(tipo) {
            return (false,"checkmark.circle.fill",Color.white,0.8)
        }
        else {
            return (true,"x.circle.fill",Color.red.opacity(0.25),0.2)
        }
        
        
    }
    
   
    
} // chiusa Struct
