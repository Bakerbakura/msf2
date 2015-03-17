class TempCustomer < ActiveRecord::Base
	self.primary_key = :tCustID
	has_many :shoes, class_name: "TempShoe", primary_key: "tCustID", foreign_key: "OwnerID", dependent: :destroy

	def updateStats
		realSizes = self.shoes.pluck(:RealSize).extend(DescriptiveStatistics)
		self.update!(ShoeSize: realSizes.mean, ShoeSizeError: realSizes.standard_deviation)
	end

	def predictSizeToBuy(_brand, _style, _material, _sizeType)
  t2rs = Typetorealsize.find_by_BrandStyleMaterial("#{_brand}|#{_style}|#{_material}")
  stToMondo1 = Sizetype.find_by_SizeType!(_sizeType).ToMondo1
  return {
    prediction: Shoe.FromMondo((self.ShoeSize - t2rs.ToMondo0)/t2rs.ToMondo1, _sizeType),
    error: Math.sqrt(t2rs.Uncertainty*t2rs.Uncertainty + self.ShoeSizeError*self.ShoeSizeError)/stToMondo1
  }
	end
end