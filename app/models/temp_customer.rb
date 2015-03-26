class TempCustomer < ActiveRecord::Base
	self.primary_key = :tCustID
	has_many :shoes, class_name: "TempShoe", primary_key: "tCustID", foreign_key: "OwnerID", dependent: :destroy

	def updateStats
		realSizes = self.shoes.pluck(:RealSize).extend(DescriptiveStatistics)
		self.update!(ShoeSize: realSizes.mean, ShoeSizeError: realSizes.standard_deviation)
	end

	def predictSizeToBuy(_brand, _style, _material, _sizeType)
    t2rs = Typetorealsize.find_by_BrandStyleMaterial!("#{_brand}|#{_style}|#{_material}")
    st = Sizetype.find_by_SizeType!(_sizeType)
    pred_div = Shoe.FromMondo((self.ShoeSize - t2rs.ToMondo0)/t2rs.ToMondo1, _sizeType)/st.SizeTypeInterval
    case pred_div.round
    when pred_div.floor
      then pref1, pref2 = pred_div.floor*st.SizeTypeInterval, pred_div.ceil*st.SizeTypeInterval
    when pred_div.ceil
      then pref1, pref2 = pred_div.ceil*st.SizeTypeInterval, pred_div.floor*st.SizeTypeInterval
    end
    
    return {
      prediction: (10*pred_div).round * st.SizeTypeInterval,
      error: Math.sqrt(t2rs.Uncertainty*t2rs.Uncertainty + self.ShoeSizeError*self.ShoeSizeError)/st.ToMondo1,
      pref1: pref1,
      pref2: pref2
    }
	end
end