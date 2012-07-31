module GSMTools
  module String
    def to_gsm
      GSMTools.to_gsm self
    end

    def is_gsm_7bit?
      GSMTools.is_gsm_7bit? self
    end
  end
end

class String
  include GSMTools::String
end
