class Shoe < ActiveRecord::Base
	self.primary_key = :ShoeID
#	attr_accessor :ShoeID, :OwnerID, :T2RS_ID, :Brand, :Style, :Material, :SizeType, :LengthFit, :Size, :preRealSize, :RealSize
  belongs_to :owner, class_name: "Customer", primary_key: "CustID", foreign_key: "OwnerID", inverse_of: :shoes
  belongs_to :typetorealsize, primary_key: "T2RS_ID", foreign_key: "T2RS_ID", inverse_of: :shoes

  before_save do
  	t2rs = Typetorealsize.find_by_BrandStyleMaterial!("#{self.Brand}|#{self.Style}|#{self.Material}")
  	t2rsid = t2rs.T2RS_ID
  	
    t2rs.update_column(:modified, true)
    self.Size = (self.Size).to_f
  	self.preRealSize = Shoe.sizeToPreSize(self.Size, self.SizeType, self.LengthFit)
  	self.RealSize = Shoe.preToRealSize(t2rsid, self.preRealSize)
  	self.T2RS_ID = t2rsid
  end
  after_save do
    self.typetorealsize.increment(:shoeCount)
    self.owner.updateStats
  end
  before_destroy do
    self.typetorealsize.increment(:shoeCount,-1)
    self.owner.updateStats
  end

  def Shoe.sizeToPreSize(_size, _sizeType, _lengthFit)
  	interval = Sizetype.find_by_SizeType!(_sizeType).SizeTypeInterval
    __size = _size.to_f

  	return case _lengthFit
  		when "Too Short"			then ToMondo(__size + 1.0*interval,	_sizeType)
  		when "Slightly Short"	then ToMondo(__size + 0.5*interval,	_sizeType)
  		when "Perfect"				then ToMondo(__size,								_sizeType)
  		when "Slightly Long"	then ToMondo(__size - 0.5*interval,	_sizeType)
  		when "Too Long"				then ToMondo(__size - 1.0*interval,	_sizeType)
  		else "INVALID _LENGTHFIT!"
  	end
  end

  def Shoe.preToRealSize(_t2rsid, _preSize)
  	t2rs = Typetorealsize.find_by_T2RS_ID!(_t2rsid)
  	return _preSize*t2rs.ToMondo1 + t2rs.ToMondo0
  end

  def update_RealSize!
    t2rs = self.typetorealsize
    self.update!(RealSize: self.preRealSize*t2rs.ToMondo1 + t2rs.ToMondo0)
  end

  def Shoe.ToMondo(_size, _sizeType)  # converts from specific SizeType (e.g. UK, EU, etc.) to Mondopoint
  	st = Sizetype.find_by_SizeType!(_sizeType)
  	return _size*st.ToMondo1 + st.ToMondo0
  end

  def Shoe.FromMondo(_mondoSize, _sizeType) # converts from Mondopoint to specific SizeType (e.g. UK, EU, etc.)
  	st = Sizetype.find_by_SizeType!(_sizeType)
  	return (_mondoSize - st.ToMondo0)/st.ToMondo1
  end
end
