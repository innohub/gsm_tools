#encoding: utf-8

require 'spec_helper'

describe GSMTools, "base" do
  it "must check for correct non-GSM 7-bit string" do
    GSMTools.is_gsm_7bit?(GSM_7BIT_CHARS).should == true
    GSMTools.is_gsm_7bit?("你好").should == false
  end

  it "must encode the correct unicode chars to GSM 7-bit" do
    GSM_UNICODE_MAP.each_slice(2) do |gsm, unicode|
      result = GSMTools.to_gsm(unicode.chr('UTF-8'))
      (result.length == 1 ? (result.ord.should == gsm) : result.bytes.collect {|x| x }.should == gsm)
    end
  end

  it "must be able to decode form GSM 7-bit" do
    gsm_7bit = GSMTools.to_gsm(GSM_7BIT_CHARS)
    reverted = GSMTools.gsm_to_s(gsm_7bit)
    reverted.should == GSM_7BIT_CHARS
  end
end
