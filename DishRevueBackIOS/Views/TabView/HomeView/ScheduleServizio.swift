//
//  ScheduleServizio.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 29/10/22.
//

import SwiftUI

struct ScheduleServizio:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    var body: some View {
        
        vbInfServizioStruttura()
    }
    
    // Method
    
    private func ricavaScheduleServizio() -> (rifMenuDataEsatta:[String],menuByDay:[GiorniDelServizio:[MenuModel]]) {
        
        let allMenuAvaible = self.viewModel.allMyMenu.filter({
            $0.status.checkStatusTransition(check: .disponibile)})
        
        let allDataEsatta = allMenuAvaible.filter({$0.isAvaibleWhen == .dataEsatta}).sorted(by: {$0.dataInizio < $1.dataInizio})

        let allExactDate = allDataEsatta.map({$0.id}) // .1
        
        let allRange = allMenuAvaible.filter({
            $0.isAvaibleWhen == .intervalloAperto ||
            $0.isAvaibleWhen == .intervalloChiuso
        })
       
        let allRangeActive = allRange.filter({
            $0.dataInizio < Date.now
        })
        
        let menuByDay:[GiorniDelServizio:[MenuModel]] = {
            
            var mpDict:[GiorniDelServizio:[MenuModel]] = [:]
            
            for day in GiorniDelServizio.allCases {
                
                let filterByDay = allRangeActive.filter({$0.giorniDelServizio.contains(day)})
                
                mpDict.updateValue(filterByDay, forKey: day)
            }
            
            return mpDict
        }()
    
        return (allExactDate,menuByDay)
    }
    
    @ViewBuilder private func vbInfServizioStruttura() -> some View {
        
        let (allExactDate,menuByDay) = self.ricavaScheduleServizio()
        
        VStack(alignment:.leading,spacing:10) {
            
            VStack(alignment:.leading,spacing:10) {
            
                HStack {
                    Text("Orario Settimanale:")
                        .font(.system(.headline, design: .monospaced, weight: .black))
                        .foregroundColor(Color("SeaTurtlePalette_2"))
                    CSInfoAlertView(title: "Info", message: .infoScheduleServizio)
                }
                
               // VStack(alignment:.leading,spacing:5) {
                Grid(alignment: .leading, verticalSpacing: 5) {
                    
                    let order = menuByDay.sorted { $0.key.orderValue() < $1.key.orderValue() }
                    
                    ForEach(order, id: \.key) { key, value in
                    
                        DayWeekTimeRow(key: key, value: value)
                    }
                }
            }
            
            VStack(alignment:.leading,spacing:10){
                
                Text("Date con Menu Specifici:")
                    .font(.system(.headline, design: .monospaced, weight: .black))
                    .foregroundColor(Color("SeaTurtlePalette_2"))
                
                ForEach(allExactDate,id:\.self) { rif in
                    
                    if let model = self.viewModel.modelFromId(id: rif, modelPath: \.allMyMenu) {
                        
                        let dataExact = csTimeFormatter().data.string(from: model.dataInizio)
                        let disable = model.tipologia.isDiSistema()
                        
                        VStack(alignment:.leading,spacing:5) {
                            
                            HStack {
                                
                               // Text("•")
                                 //   .fontWeight(.black)
                                
                                Text(dataExact)
                                    .font(.system(.body, design: .monospaced, weight: .semibold))
                                  //  .fontWeight(.black)
                                    .foregroundColor(Color("SeaTurtlePalette_4"))
                                
                                NavigationLink(value: DestinationPathView.menu(model)) {
                                    Image(systemName: "arrow.up.forward.app")
                                        .foregroundColor(Color("SeaTurtlePalette_3"))
                                }
                                .opacity(disable ? 0.5 : 1.0)
                                .disabled(disable)
                                
                            }
                            
                            Text("\(model.intestazione)\n\(model.descrizione)")
                                .italic()
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color.black)
                        }
                        
                    }
                    
                   
                }
                
            }
            
            
        }
    }
    

    
}

private struct DayWeekTimeRow:View {
    
    let key:GiorniDelServizio
    let value:[MenuModel]
    
    @State private var openDetail:Bool = false
    
    var body: some View {
        
            let (stringOpenTime,stringCloseTime) = weekTimeRow()
            let disableAction = value.isEmpty

            GridRow {
                
                HStack {
                    Image(systemName: "\(key.imageAssociated()).fill")
                        .imageScale(.medium)
                        .foregroundColor(Color("SeaTurtlePalette_3"))
                        .opacity(disableAction ? 0.4 : 1.0)
                    
                    Text(key.simpleDescription())
                        .font(.system(.headline, design: .monospaced, weight: .semibold))
                        .foregroundColor(Color.black)
                    Spacer()
                }
                  //  Spacer()
                
                    
                    HStack(spacing:3) {
                       
                        Text("\(stringOpenTime)")
                            .foregroundColor(Color.green)
                            .fontWeight(.semibold)
                            .font(.subheadline)
                            .opacity(0.8)
                        Text("-")
                            .foregroundColor(Color.gray)
                        Text("\(stringCloseTime)")
                            .foregroundColor(Color.red)
                          //  .brightness(0.05)
                            .fontWeight(.black)
                            .opacity(0.85)
                        Spacer()
                    }
                    .font(.system(.headline, design: .monospaced, weight: .semibold))
                    .lineLimit(1)

                HStack {
                    
                   
                        CSButton_image(
                            activationBool: self.openDetail,
                            frontImage: "chevron.compact.up",
                            backImage: "chevron.compact.down",
                            imageScale: .medium,
                            backColor: Color("SeaTurtlePalette_4"),
                            frontColor: Color("SeaTurtlePalette_3")) {
                                withAnimation {
                                    self.openDetail.toggle()
                                }
                            }
                            .opacity(disableAction ? 0.6 : 1.0)
                            .disabled(disableAction)
                    
                    
                    }
                }
        
        if self.openDetail {
            
            let orderValue = value.sorted(by: {
                csTimeConversione(data: $0.oraInizio) < csTimeConversione(data: $1.oraInizio)
            })
            
            ForEach(orderValue) { value in
                
                let openTime = csTimeFormatter().ora.string(from: value.oraInizio)
                let closeTime = csTimeFormatter().ora.string(from: value.oraFine)
                
                GridRow {
                    
                    HStack {
                        Text("\(value.intestazione)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .foregroundColor(Color.black)
                          //  .gridCellColumns(2)
                      //  Spacer()
                    }

                        HStack(spacing:3) {
                          //  Spacer()
                            Text("\(openTime)")
                              //  .foregroundColor(Color.green)
                                .opacity(0.9)
                            Text("-")
                                .foregroundColor(Color.gray)
                            Text("\(closeTime)")
                              //  .foregroundColor(Color.red)
                              //  .brightness(0.05)
                                .fontWeight(.semibold)
                                .opacity(1.0)
                         // Spacer()
                        }
                        .font(.subheadline)
                        .foregroundColor(Color.black)
                    
                    HStack {
                    
                        NavigationLink(value: DestinationPathView.menu(value)) {
                            Image(systemName: "arrow.up.forward.circle")
                                .font(.subheadline)
                                .foregroundColor(Color("SeaTurtlePalette_3"))
                        }
                        
                    }
                    
                }
                if value.descrizione != "" {
                    GridRow {
                        Text(value.descrizione)
                            .italic()
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.black)
                            .gridCellColumns(2)
                    }
                }
            }
            
        }

    }
    // Method
    
    private func weekTimeRow() -> (openTime:String,closeTime:String) {
        
        let orario:[Int] = {
            
            self.value.map({csTimeConversione(data: $0.oraInizio)}) +
            self.value.map({csTimeConversione(data: $0.oraFine)})
            
        }()
        guard let oraApertura = orario.min() else { return ("","Chiuso")}
       
        let reverseOpenDate = csTimeReverse(value: oraApertura)
        let stringOpenTime = csTimeFormatter().ora.string(from: reverseOpenDate) //.1
        
        let oraChiusura = orario.max() ?? 0
        let reverseCloseDate = csTimeReverse(value: oraChiusura)
        let stringCloseTime = csTimeFormatter().ora.string(from: reverseCloseDate) // .2
 
        return (stringOpenTime,stringCloseTime)
    }
}

/*
struct ScheduleServizio_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleServizio()
    }
}
*/
