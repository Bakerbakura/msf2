Brand.create!([
  {Brand: "Adidas"},
  {Brand: "Aldo"},
  {Brand: "Armani"},
  {Brand: "Asics"},
  {Brand: "Birkenstock"},
  {Brand: "Bostonian"},
  {Brand: "Carhartt"},
  {Brand: "Champion"},
  {Brand: "Clarks"},
  {Brand: "Cole Haan"},
  {Brand: "Columbia"},
  {Brand: "Converse"},
  {Brand: "Crocs"},
  {Brand: "Dansko"},
  {Brand: "DC"},
  {Brand: "Diesel"},
  {Brand: "Dockers"},
  {Brand: "Dr. Martens"},
  {Brand: "Dream Pairs"},
  {Brand: "Ecco"},
  {Brand: "Etnies"},
  {Brand: "Fred Perry"},
  {Brand: "Frye"},
  {Brand: "Hi-Tec"},
  {Brand: "John Fluevog"},
  {Brand: "Kamik"},
  {Brand: "Keen"},
  {Brand: "Lacoste"},
  {Brand: "Marc Jacobs"},
  {Brand: "Merrell"},
  {Brand: "Mizuno"},
  {Brand: "Muck Boot"},
  {Brand: "New Balance"},
  {Brand: "Nike"},
  {Brand: "Original Penguin"},
  {Brand: "Polo Ralph Lauren"},
  {Brand: "Puma"},
  {Brand: "Reebok"},
  {Brand: "Reef"},
  {Brand: "Rockport"},
  {Brand: "Salomon"},
  {Brand: "Sanuk"},
  {Brand: "Saucony"},
  {Brand: "Skechers"},
  {Brand: "Sperry Top-Sider"},
  {Brand: "Tamarac"},
  {Brand: "Teva"},
  {Brand: "Timberland"},
  {Brand: "Timberland Pro"},
  {Brand: "To Boot New York"},
  {Brand: "Ugg"}
])
Gender.create!([
  {Gender: "F"},
  {Gender: "M"}
])
Lengthfit.create!([
  {LengthFit: "Perfect"},
  {LengthFit: "Slightly Long"},
  {LengthFit: "Slightly Short"},
  {LengthFit: "Too Long"},
  {LengthFit: "Too Short"}
])
Material.create!([
  {Material: "Leather"},
  {Material: "Leatherette"},
  {Material: "Polyurethane"},
  {Material: "PVC"},
  {Material: "Rubber"}
])
Sizetype.create!([
  {SizeType: "EU",          ToMondo1: 20.0/3.0, ToMondo0: -10.0,      SizeTypeInterval: 0.5, MinSize: 32.0,   MaxSize: 49.0},
  {SizeType: "Mondopoint",  ToMondo1: 1.0,      ToMondo0: 0.0,        SizeTypeInterval: 5.0, MinSize: 200.0,  MaxSize: 320.0},
  {SizeType: "UK",          ToMondo1: 25.4/3.0, ToMondo0: 605/3.0,    SizeTypeInterval: 0.5, MinSize: 0.0,    MaxSize: 14.0},
  {SizeType: "US",          ToMondo1: 25.4/3.0, ToMondo0: 630.4/3.0,  SizeTypeInterval: 0.5, MinSize: 1.0,    MaxSize: 15.0}
])
Style.create!([
  {Style: "Athletic"},
  {Style: "Boots"},
  {Style: "Fashion Sneakers"},
  {Style: "Loafers & Slip-Ons"},
  {Style: "Mules & Clogs"},
  {Style: "Outdoor"},
  {Style: "Oxfords"},
  {Style: "Sandals"},
  {Style: "Slippers"},
  {Style: "Work & Safety"}
])

brands = Brand.pluck(:Brand)
styles = Style.pluck(:Style)
materials = Material.pluck(:Material)

inserts = []
brands.each do |brand|
  styles.each do |style|
    materials.each do |material|
      inserts.push "(\'#{brand}|#{style}|#{material}\')"
    end
  end
end
Typetorealsize.connection.execute("INSERT INTO typetorealsizes (\"BrandStyleMaterial\") VALUES #{inserts.join(', ')}")

puts "Finished seeding Typetorealsizes table."
puts "Finished seeding all tables."