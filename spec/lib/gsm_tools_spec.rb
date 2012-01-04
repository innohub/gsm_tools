require 'spec_helper'

describe GSMTools, "initialize" do
  it "must initialize GSMTools module" do
    GSMTools.class.should == Module
  end

  it "must initialize GSMTools::String module" do
    GSMTools::String.class.should == Module
  end
end
