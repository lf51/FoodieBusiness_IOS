//
//  CustomLabel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct CSLabel_1Button: View {
    
    var placeHolder: String
    var imageName: String?
    var backgroundColor: Color
    var backgroundOpacity: Double?
    
    @Binding var toggleBottone: Bool?
    
    init(placeHolder: String, imageName: String? = nil, backgroundColor: Color, backgroundOpacity:Double? = nil, toggleBottone: Binding<Bool?>? = nil) {
        
        self.placeHolder = placeHolder
        self.imageName = imageName
        self.backgroundColor = backgroundColor
        self.backgroundOpacity = backgroundOpacity

        _toggleBottone = toggleBottone ?? Binding.constant(nil)
        
    } // VOGLIO TROVARE UN MODO PER OMETTERE IL TOGGLEBOTTONE INVECE DI PASSARE ESPLICITAMENTE NIL

    var body: some View {
        
        HStack {
            
            Label {
                Text(placeHolder)
                    .fontWeight(.medium)
                    .font(.system(.subheadline, design: .monospaced))
            } icon: {
         
                csVbSwitchImageText(string: imageName)
            }
            ._tightPadding()
            .background(
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(backgroundColor.opacity(backgroundOpacity ?? 0.2))
            )
            
            if toggleBottone != nil {
                
                Button {
                    withAnimation(.default) {
                        
                        toggleBottone!.toggle()
                    }
                    
                } label: {
                     
                    Image(systemName: toggleBottone! ? "minus.circle" : "plus.circle")
                        .imageScale(.large)
                        .foregroundColor(toggleBottone! ? .red : .blue)
                }
            }
            
            Spacer()
        }
    }
}

struct CSLabel_2Button: View {
    
    var placeHolder: String
    var imageName: String
    var backgroundColor: Color
    
    @Binding var toggleBottonePLUS: Bool?
    @Binding var toggleBottoneTEXT: Bool?
    
    var testoBottoneTEXT: String?
    
    init(placeHolder: String, imageName: String, backgroundColor: Color, toggleBottonePLUS: Binding<Bool?>? = nil, toggleBottoneTEXT: Binding<Bool?>? = nil, testoBottoneTEXT: String) {
        
        self.placeHolder = placeHolder
        self.imageName = imageName
        self.backgroundColor = backgroundColor

        _toggleBottonePLUS = toggleBottonePLUS ?? Binding.constant(nil)
        _toggleBottoneTEXT = toggleBottoneTEXT ?? Binding.constant(nil)
        
        self.testoBottoneTEXT = testoBottoneTEXT
        
    } // VOGLIO TROVARE UN MODO PER OMETTERE IL TOGGLEBOTTONE INVECE DI PASSARE ESPLICITAMENTE NIL

    var body: some View {
        
        HStack {
            
            Label {
                Text(placeHolder)
                    .fontWeight(.medium)
                    .font(.system(.subheadline, design: .monospaced))
            } icon: {
                Image(systemName: imageName)
            }
            ._tightPadding()
            .background(
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(backgroundColor.opacity(0.2))
                    
            )
            
            Spacer()
            
            if toggleBottonePLUS != nil {
                
                Button {
                    withAnimation(.default) {
                        
                        toggleBottonePLUS!.toggle()
                    }
                    
                } label: {
                     
                    Image(systemName: toggleBottonePLUS! ? "minus.circle" : "plus.circle")
                        .imageScale(.large)
                        .foregroundColor(toggleBottonePLUS! ? .red : .blue)
                    
                }.disabled(toggleBottoneTEXT ?? false)
            }
            
            Spacer()
            
            if toggleBottoneTEXT != nil {
      
                Button {
                    withAnimation(.default) {
                        toggleBottoneTEXT!.toggle()
                    }
                } label: {
                    Text(testoBottoneTEXT ?? "")
                        .fontWeight(.semibold)
                }
                .buttonStyle(.borderedProminent)
                .brightness(toggleBottoneTEXT ?? false ? 0.0 : -0.05)
                .disabled(toggleBottonePLUS ?? false)
    
            }
        }
    }
}

struct CSLabel_1Picker: View {
    
    let placeHolder: String
    let imageName: String
    let labelColor: Color
    let pickerColor: Color    
    
    @Binding var selectedProgram: AvailabilityMenu
    var isThereConditionToDisablePicker: Bool
    
    init(placeHolder: String, imageName: String, backgroundColor: Color, pickerColor:Color? = nil, availabilityMenu: Binding<AvailabilityMenu>, conditionToDisablePicker: Bool? = nil) {
        
        self.placeHolder = placeHolder
        self.imageName = imageName
        self.labelColor = backgroundColor
        self.pickerColor = pickerColor ?? Color.clear

        self.isThereConditionToDisablePicker = conditionToDisablePicker ?? false
        _selectedProgram = availabilityMenu
        
    }

    var body: some View {
        
        HStack {
            
            Label {
                Text(placeHolder)
                    .fontWeight(.medium)
                    .font(.system(.subheadline, design: .monospaced))
            } icon: {
                Image(systemName: imageName)
            }
            ._tightPadding()
            .background(
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(labelColor.opacity(0.2))
            )
    
            Spacer()
            
            Picker(selection:$selectedProgram) {
                
                ForEach(AvailabilityMenu.allCases, id:\.self) {schedule in
                    
                    Text(schedule.shortDescription())
                    
                }
                
            } label: {Text("")}
            .pickerStyle(SegmentedPickerStyle())
            .opacity(isThereConditionToDisablePicker ? 0.6 : 1.0)
            .disabled(isThereConditionToDisablePicker)
          
        }
    }
}


/*struct CustomLabel_Previews: PreviewProvider {
    static var previews: some View {
        CustomLabel()
    }
}*/

