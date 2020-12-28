//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Vicente Montoya on 9/9/20.
//  Copyright © 2020 Vicente Montoya. All rights reserved.
//

import SwiftUI

//MARK: - Theme
struct Theme: Codable, Hashable{
    
    static func == (lhs: Theme, rhs: Theme) -> Bool {
        if lhs.name == rhs.name {
            if lhs.content == rhs.content {
                if lhs.numberOfPairsOfCards == rhs.numberOfPairsOfCards{
                    if lhs.foregroundColor == rhs.foregroundColor {
                        return true
                    }
                }
            }
        }
        return false
        
    }
    
    var name: String
    var content: [String]
    var numberOfPairsOfCards: Int?
    var foregroundColor: UIColor.RGB
}

extension Array where Element == Theme{
    mutating func remove(theme: Theme){
        for index in 0..<self.count{
            if self[index] == theme{
                remove(at: index)
            }
        }
    }
}

struct ThemeChooser: View {
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        
        NavigationView{
            List{
                ForEach(themes, id: \.self){ theme in
                    NavigationLink(
                        destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme))
                            .navigationBarTitle(theme.name))
                    {
                        VStack(alignment: .leading){
                            Text(theme.name).foregroundColor(Color(UIColor(theme.foregroundColor)))
                            HStack{
                                ForEach(0..<theme.content.count){ index in
                                    Text(theme.content[index])
                                }
                            }
                        }
                    }
                }
                .onDelete{ indexSet in
                    indexSet.map{ self.themes[$0] }.forEach{ theme in
                        self.themes.remove(theme: theme)
                    }
                }
            }
            .navigationBarTitle("Memorize")
            .navigationBarItems(leading:
                Button(action: {  }, label: { Image(systemName: "plus").imageScale(.large) } ),
                                trailing:
                EditButton()
            )
                .environment(\.editMode, $editMode)
        }
    }
    
    //MARK: Default Themes
    
    @State var themes = [halloween, animals, sports, faces, flags, foods]
    
    static var halloween: Theme = Theme(name: "Halloween", content: ["👻", "🎃", "🕷", "🍬", "🍭", "🕸", "🦇", "🌙", "🍂", "💀", "☠️", "🤖"], numberOfPairsOfCards: 10, foregroundColor: UIColor.RGB.init(red: 1.0, green: 125.0/255.0, blue: 41.0/255.0, alpha: 1.0))
    static var animals: Theme = Theme(name: "Animals", content: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐮", "🐷", "🐵","🐙","🐠","🐬","🐴"], numberOfPairsOfCards: 10, foregroundColor: UIColor.RGB.init(red: 252.0/255.0, green: 62.0/255.0, blue: 62.0/255.0, alpha: 1.0))
    static var sports: Theme = Theme(name: "Sports", content: ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🥏", "🎱", "🏓", "🏸","🥊","🤿","⛳️","🥍"], numberOfPairsOfCards: 10, foregroundColor: UIColor.RGB.init(red: 135.0/255.0, green: 243.0/255.0, blue: 69.0/255.0, alpha: 1.0))
    static var faces: Theme = Theme(name: "Faces", content: ["😀", "😄", "😕", "😒", "😔", "😉", "😍", "😂", "😠", "😭", "🤪", "🙄","😴","🥵","😙","🙃"], numberOfPairsOfCards: 10, foregroundColor: UIColor.RGB.init(red: 252.0/255.0, green: 229.0/255.0, blue: 0.0/255.0, alpha: 1.0))
    static var flags: Theme = Theme(name: "Flags", content: ["🇻🇪", "🇺🇸", "🇬🇧", "🇸🇪", "🇩🇪", "🇧🇪", "🇦🇺", "🇻🇳", "🇰🇷", "🇪🇸", "🇳🇬", "🇬🇷","🇫🇷","🇮🇹","🇮🇶","🇮🇷"], numberOfPairsOfCards: 10, foregroundColor: UIColor.RGB.init(red: 183.0/255.0, green: 66.0/255.0, blue: 230.0/255.0, alpha: 1.0))
    static var foods: Theme = Theme(name: "Foods", content: ["🍎", "🍕", "🍿", "🍒", "🍜", "🍩", "🥐", "🧀", "🥩", "🥚", "🌮", "🍦","☕️","🍷","🥗","🍔"], numberOfPairsOfCards: 10, foregroundColor: UIColor.RGB.init(red: 69.0/255.0, green: 201.0/255.0, blue: 255.0/255.0, alpha: 1.0))
}

struct ThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooser()
    }
}
