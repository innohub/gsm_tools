#encoding: utf-8

require 'spec_helper'

describe GSMTools, "base" do
  it "must check for correct non-GSM 7-bit string" do
    GSMTools.is_gsm_7bit?(GSM_7BIT_CHARS).should == true
    GSMTools.is_gsm_7bit?("你好").should == false
  end

  it "must encode the correct unicode chars to GSM 7-bit" do
    GSM_UNICODE_MAP.each_slice(2) do |gsm, unicode|
      GSMTools.is_gsm_7bit?(unicode.chr('UTF-8')).should == true
      result = GSMTools.to_gsm(unicode.chr('UTF-8'))
      (result.length == 1 ? (result.ord.should == gsm) : result.bytes.collect {|x| x }.should == gsm)
    end
  end

  it "must be able to decode form GSM 7-bit" do
    gsm_7bit = GSMTools.to_gsm(GSM_7BIT_CHARS)
    reverted = GSMTools.gsm_to_s(gsm_7bit)
    reverted.should == GSM_7BIT_CHARS
  end

  it "must calculate the length of GSM 7-bit string properly" do
    gsm_7bit = GSMTools.to_gsm("0123456789abcde")
    gsm_7bit.length.should == 15
    gsm_7bit = GSMTools.to_gsm("0123456789abcde[]{}~")
    gsm_7bit.length.should == 25
  end

  it "must encode non GSM 7-bit characters to UCS-2" do
    GSMTools.to_gsm("你好").length.should == 4
  end

  it "must check the length and segments of the GSM string" do
    GSMTools.gsm_string_counter("hello there").should == { :length => 11,
                                                              :segments => 1,
                                                              :remaining_length_for_segment => 149 }

    GSMTools.gsm_string_counter("Andreasen gag high friggin Argyll Argyll artful Tyrol archon stock serial studbook Argyll Argyll archbishop drink sitcom restful Argyll stubborn objects scoffs actinolite quinta stump pigs electric").should == { :length => 197,
                                                              :segments => 2,
                                                              :remaining_length_for_segment => 109 }

    GSMTools.gsm_string_counter("Axndreasen gag high friggin Argyll Argyll artful Tyrol archon stock serial studbook Argyll Argyll archbishop drink sitcom restful Argyll stubborn objects scoffs actinolite quinta stump pigs electric andrew angelo ang andrew angelo ang andrew angelo ang andrew angelo ang andrew angelo ang andrew angelo ang").should == { :length => 306,
                                                              :segments => 2,
                                                              :remaining_length_for_segment => 0 }

    GSMTools.gsm_string_counter("Axndreasen gag high friggin Argyll Argyll artful Tyrol archon stock serial studbook Argyll Argyll archbishop drink sitcom restful Argyll stubborn objects scoffs actinolite quinta stump pigs electric andrew angelo ang andrew angelo ang andrew angelo ang andrew angelo ang andrew angelo ang andrew angelo an[").should == { :length => 307,
                                                              :segments => 3,
                                                              :remaining_length_for_segment => 152 }

    GSMTools.gsm_string_counter("Andreasen gag high friggin Argyll Argyll artful Tyrol archon stock serial studbook Argyll Argyll archbishop drink sitcom restful Argyll stubborn objects scoffs actinolite quinta stump pigs electric andrew angelo ang andrew angelo ang andrew angelo ang andrew angelo ang andrew angelo ang andrew angelo ang fdafda fdafa dsafsaf dsaf dsaf dsa fs af sa fsa fsdaf dasf dsa f dsaf dsa fds afd sa fdsa fdsafasfdsa fas fd saf da fd afdsafdasfdasf dsaf das f asf as[").should == { :length => 459,
                                                              :segments => 3,
                                                              :remaining_length_for_segment => 0 }

    GSMTools.gsm_string_counter("Andreasen gag high friggin Argyll Argyll artful Tyrol archon stock serial studbook Argyll Argyll archbishop drink sitcom restful Argyll stubborn objects scoffs actinolite quinta stump pigs electric andrew angelo ang andrew angelo ang andrew angelo ang andrew angelo ang andrew angelo ang andrew angelo ang fdafda fdafa dsafsaf dsaf dsaf dsa fs af sa fsa fsdaf dasf dsa f dsaf dsa fds afd sa fdsa fdsafasfdsa fas fd saf da fd afdsafdasfdasf dsaf das f asf as[x").should == { :invalid => true }

    GSMTools.gsm_string_counter("你好我是洪一尧ANG").should == { :length => 10,
                                                :segments => 1,
                                                :remaining_length_for_segment => 60 }

    GSMTools.gsm_string_counter("你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG").should == { :length => 70,
                                                :segments => 1,
                                                :remaining_length_for_segment => 0 }

    GSMTools.gsm_string_counter("你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG!").should == { :length => 71,
                                                :segments => 2,
                                                :remaining_length_for_segment => 63 }

    GSMTools.gsm_string_counter("你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG!!!!").should == { :length => 134,
                                                :segments => 2,
                                                :remaining_length_for_segment => 0 }

    GSMTools.gsm_string_counter("你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG[").should == { :length => 201,
                                                :segments => 3,
                                                :remaining_length_for_segment => 0 }

    GSMTools.gsm_string_counter("你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG你好我是洪一尧ANG!!").should == { :invalid => true }
  end
end
