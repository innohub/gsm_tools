module GSMTools
  module String
    def to_gsm
      GSMTools.to_gsm self
    end
  end
end

class String
  include GSMTools::String
end
