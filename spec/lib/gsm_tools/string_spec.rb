require 'spec_helper'

describe GSMTools, "string" do
  it "must add the method to_gsm to the String class" do
    "hello".should respond_to(:to_gsm)
  end
end
