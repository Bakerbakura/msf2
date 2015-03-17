class TempShoe < ActiveRecord::Base
	self.primary_key = :ShoeID
	belongs_to :owner, class_name: "TempCustomer", primary_key: "tCustID", foreign_key: "OwnerID"

	before_save do
		t2rsid = Typetorealsize.find_by_BrandStyleMaterial!("#{self.Brand}|#{self.Style}|#{self.Material}").T2RS_ID
		
		self.Size = self.Size.to_f
		preRealSize = Shoe.sizeToPreSize(self.Size, self.SizeType, self.LengthFit)
		self.preRealSize = preRealSize
		self.RealSize = Shoe.preToRealSize(t2rsid, preRealSize)
		self.T2RS_ID = t2rsid
	end
	after_save do 
		self.owner.updateStats
	end
end
