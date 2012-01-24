require 'spec_helper'

describe GSMTools, "Cell Global ID" do
  it "must be able to initialize and parse a hex string correctly" do
    cell_gid = CellGlobalId.new("15f5302f022d86")
    cell_gid.mcc.should == "515"
    cell_gid.mnc.should == "3"
    cell_gid.lac.should == "2f02"
    cell_gid.cell_id.should == "2d86"
  end
end
