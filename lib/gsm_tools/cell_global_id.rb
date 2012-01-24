class CellGlobalId

  attr_reader :raw_hex_value, :mcc, :mnc, :lac, :cell_id

  def initialize(str)
    @raw_hex_value = str.gsub(/.{2}/, '\0 ').split
    octet_1 = @raw_hex_value[0].hex.to_s(2).rjust(8, "0")
    octet_2 = @raw_hex_value[1].hex.to_s(2).rjust(8, "0")
    octet_3 = @raw_hex_value[2].hex.to_s(2).rjust(8, "0")

    @mcc = octet_1[4,4].to_i(2).to_s
    @mcc << octet_1[0,4].to_i(2).to_s
    @mcc << octet_2[4,4].to_i(2).to_s
    @mcc = @mcc.to_i.to_s

    @mnc = octet_3[4,4].to_i(2).to_s
    @mnc << octet_3[0,4].to_i(2).to_s
    @mnc << ""
    @mnc << octet_2[0,4].to_i(2).to_s unless octet_2[0,4].match(/1111/)
    @mnc = @mnc.to_i.to_s

    @lac = @raw_hex_value[3] + @raw_hex_value[4]
    @cell_id = @raw_hex_value[5] + @raw_hex_value[6]
  end
end
