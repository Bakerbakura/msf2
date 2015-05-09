class Customer < ActiveRecord::Base
  has_secure_password
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

	self.primary_key = :CustID
  # database fields: CustID, Email, Gender, password_digest, ShoeSize, ShoeSizeError, ShoeCount
  has_many :shoes, primary_key: "CustID", foreign_key: "OwnerID", dependent: :destroy
  
  # validates_presence_of :Email, :Gender, :password
  # validates_presence_of :password_confirmation
  # validates_presence_of :Email_confirmation
  # validates_format_of :Email, with: EMAIL_REGEX, on: :create,               message: "Invalid Email address format."
  # validates_length_of :Email, maximum: 30,                                  message: "Email address should have length less than 30 characters"
  # validates_length_of :password, minimum: 8,                                message: "Password should contain at least 8 characters"
  # validates_inclusion_of :Gender, in: ["M","F"],                            message: "Invalid gender."

  def Customer.updateStats(_custID)
   Customer.find_by_CustID!(_custID).updateStats
  end

  def updateStats
    realSizes = self.shoes.map{|s| s.RealSize}.extend(DescriptiveStatistics)
      # use map instead of pluck because self.shoes returns an array, not an AR:Relation object
    self.update!(ShoeSize: realSizes.mean, ShoeSizeError: realSizes.standard_deviation, ShoeCount: realSizes.count)
  end

  def predictSizeToBuy(_brand, _style, _material)
    t2rs = Typetorealsize.find_by_BrandStyleMaterial("#{_brand}|#{_style}|#{_material}")
    results = []
    
    Sizetype.all.each do |st|
      pred_div = Shoe.FromMondo((self.ShoeSize - t2rs.ToMondo0)/t2rs.ToMondo1, st.SizeType)/st.SizeTypeInterval # prediction divided by STInterval
      case pred_div.round
      when pred_div.floor
        then pref1, pref2 = pred_div.floor*st.SizeTypeInterval, pred_div.ceil*st.SizeTypeInterval
      when pred_div.ceil
        then pref1, pref2 = pred_div.ceil*st.SizeTypeInterval, pred_div.floor*st.SizeTypeInterval
      end
      
      results << {
        sizeType: st.SizeType,
        prediction: (pred_div).round(1) * st.SizeTypeInterval,
        error: (Math.sqrt(t2rs.Uncertainty*t2rs.Uncertainty + self.ShoeSizeError*self.ShoeSizeError)/st.ToMondo1).round(3),
        pref1: pref1,
        pref2: pref2
      }
    end

    return results
  end

  def Customer.emptyShoeSizeSweep()
    Customer.where(ShoeSize: nil).each {|cust| cust.updateStats}
  end
end
