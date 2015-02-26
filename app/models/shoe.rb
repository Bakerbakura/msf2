class Shoe < ActiveRecord::Base
	self.primary_key = :ShoeID
#	attr_accessor :ShoeID, :OwnerID, :T2RS_ID, :Brand, :Style, :Material, :SizeType, :LengthFit, :Size, :preRealSize, :RealSize

  before_save do
  	t2rs = Typetorealsize.find_by_BrandStyleMaterial!("#{self.Brand}|#{self.Style}|#{self.Material}")
  	t2rsid = t2rs.T2RS_ID
  	
    t2rs.modified = true
    t2rs.save!
    self.Size = (self.Size).to_f
  	preRealSize = Shoe.sizeToPreSize(self.Size, self.SizeType, self.LengthFit)
  	self.preRealSize = preRealSize
  	self.RealSize = Shoe.preToRealSize(t2rsid, preRealSize)
  	self.T2RS_ID = t2rsid
  end
  after_save do
    Customer.updateShoeStats(self.OwnerID)
  end

  def Shoe.sizeToPreSize(_size, _sizeType, _lengthFit)
  	interval = Sizetype.find_by_SizeType!(_sizeType).SizeTypeInterval
    __size = _size.to_f

  	return case _lengthFit
  		when "Too Short"			then ToMondo(__size + 0.4*interval,	_sizeType)
  		when "Slightly Short"	then ToMondo(__size + 0.2*interval,	_sizeType)
  		when "Perfect"				then ToMondo(__size,								_sizeType)
  		when "Slightly Long"	then ToMondo(__size - 0.2*interval,	_sizeType)
  		when "Too Long"				then ToMondo(__size - 0.4*interval,	_sizeType)
  		else "INVALID _LENGTHFIT!"
  	end
  end

  def Shoe.preToRealSize(_t2rsid, _preSize)
  	t2rs = Typetorealsize.find_by!(T2RS_ID: _t2rsid)
  	return _preSize*t2rs.ToMondo1 + t2rs.ToMondo0
  end

  def Shoe.ToMondo(_size, _sizeType)
  	st = Sizetype.find_by_SizeType!(_sizeType)
  	return _size*st.ToMondo1 + st.ToMondo0
  end

  def Shoe.FromMondo(_mondoSize, _sizeType)
  	st = Sizetype.find_by_SizeType!(_sizeType)
  	return (_mondoSize - st.ToMondo0)/st.ToMondo1
  end
end