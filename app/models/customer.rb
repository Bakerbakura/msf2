class Customer < ActiveRecord::Base
  has_secure_password
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

	self.primary_key = :CustID
#  attr_accessor :CustID, :Email, :Email_confirmation, :Gender, :ShoeSize, :ShoeSizeError, :password, :password_confirmation, :preferredSizeType
  
  # validates_presence_of :Email, :Gender, :password, :preferredSizeType
  # validates_presence_of :password_confirmation
  # validates_presence_of :Email_confirmation
  # validates_format_of :Email, with: EMAIL_REGEX, on: :create,               message: "Invalid Email address format."
  # validates_length_of :Email, maximum: 30,                                  message: "Email address should have length less than 30 characters"
  # validates_length_of :password, minimum: 8,                                message: "Password should contain at least 8 characters"
  # validates_inclusion_of :Gender, in: ["M","F"],                            message: "Invalid gender."
  # validates_inclusion_of :preferredSizeType, in: Sizetype.pluck(:SizeType), message: "Invalid preferredSizeType."

  def Customer.updateShoeStats(_custID)
  	realSizes = Shoe.where(OwnerID: _custID).pluck(:RealSize).extend(DescriptiveStatistics)
    cust = Customer.find_by_CustID!(_custID)
  	cust.ShoeSize = realSizes.mean
  	cust.ShoeSizeError = realSizes.standard_deviation
  	cust.save!
  end

  def Customer.predictSizeToBuy(_custID, _brand, _style, _material, _sizeType)
  	t2rs = Typetorealsize.find_by_BrandStyleMaterial("#{_brand}|#{_style}|#{_material}")
  	cust = Customer.find_by_CustID(_custID)
  	stToMondo1 = Sizetype.find_by_SizeType!(_sizeType).ToMondo1
  	return {
      prediction: Shoe.FromMondo((cust.ShoeSize - t2rs.ToMondo0)/t2rs.ToMondo1, _sizeType),
  		error: Math.sqrt(t2rs.Uncertainty*t2rs.Uncertainty + cust.ShoeSizeError*cust.ShoeSizeError)/stToMondo1
    }
  end

  def Customer.emptyShoeSizeSweep()
    Customer.where(ShoeSize: nil).pluck(:CustID).each do |custid|
      Customer.updateShoeStats(custid)
    end
  end
end
