Brand.delete_all
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

Gender.delete_all
Gender.create!([
  {Gender: "F"},
  {Gender: "M"}
])

Lengthfit.delete_all
Lengthfit.create!([
  {LengthFit: "Perfect"},
  {LengthFit: "Slightly Long"},
  {LengthFit: "Slightly Short"},
  {LengthFit: "Too Long"},
  {LengthFit: "Too Short"}
])

Material.delete_all
Material.create!([
  {Material: "Leather"},
  {Material: "Leatherette"},
  {Material: "Polyurethane"},
  {Material: "PVC"},
  {Material: "Rubber"}
])

Sizetype.delete_all
Sizetype.create!([
  {SizeType: "Europe", ToMondo1: 6.67, ToMondo0: -10.0, SizeTypeInterval: 0.5, MinSize: 32.0, MaxSize: 49.0},
  {SizeType: "Mondopoint", ToMondo1: 1.0, ToMondo0: 0.0, SizeTypeInterval: 5.0, MinSize: 200.0, MaxSize: 320.0},
  {SizeType: "UK/Australia", ToMondo1: 8.47, ToMondo0: 201.67, SizeTypeInterval: 0.5, MinSize: 0.0, MaxSize: 14.0},
  {SizeType: "US/Canada", ToMondo1: 8.47, ToMondo0: 292.0, SizeTypeInterval: 0.5, MinSize: 1.0, MaxSize: 15.0}
])

Style.delete_all
Style.create!([
  {Style: "Balmoral"},
  {Style: "Boat Shoe"},
  {Style: "Brouge"},
  {Style: "Cross Trainer"},
  {Style: "Derby"},
  {Style: "Dress Boot"},
  {Style: "Dress Shoe"},
  {Style: "Driving Shoe"},
  {Style: "Hiker"},
  {Style: "Loafer (Slip-on)"},
  {Style: "Oxford (Lace-up)"},
  {Style: "Patent Leather"},
  {Style: "Penny Loafer"},
  {Style: "Runner"},
  {Style: "Saddle Shoe"},
  {Style: "Sandal"},
  {Style: "Tennis"},
  {Style: "Walker"},
  {Style: "Wingtip"},
  {Style: "Work Boot"}
])

Typetorealsize.initialise

puts "Finished seeding!"