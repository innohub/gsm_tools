#encoding: utf-8
#
# Unicode/GSM Reference: http://unicode.org/Public/MAPPINGS/ETSI/GSM0338.TXT

require 'iconv'

module GSMTools
  NL = "\n"
  CR = "\r"
  BS = '\\'

  NON_GSM_7BIT_MATCHER = /[^@£\$¥èéùìòÇ\nØø\rÅåΔ_ΦΓΛΩΠΨΣΘΞÆæßÉ !"#¤%&'\(\)\*\+,-\.\/0123456789:;<=>\?¡ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÑÜ§¿abcdefghijklmnopqrstuvwxyzäöñüà\^{}\\\[~\]\|€]/

  GSM_7BIT_MAP = [
    0x00, '@'.ord,
    0x01, '£'.ord,
    0x02, '$'.ord,
    0x03, '¥'.ord,
    0x04, 'è'.ord,
    0x05, 'é'.ord,
    0x06, 'ù'.ord,
    0x07, 'ì'.ord,
    0x08, 'ò'.ord,
    0x09, 'Ç'.ord,
    0x0a, 0x000A,
    0x0b, 'Ø'.ord,
    0x0c, 'ø'.ord,
    0x0d, 0x000D,
    0x0e, 'Å'.ord,
    0x0f, 'å'.ord,
    0x10, 'Δ'.ord,
    0x11, '_'.ord,
    0x12, 'Φ'.ord,
    0x13, 'Γ'.ord,
    0x14, 'Λ'.ord,
    0x15, 'Ω'.ord,
    0x16, 'Π'.ord,
    0x17, 'Ψ'.ord,
    0x18, 'Σ'.ord,
    0x19, 'Θ'.ord,
    0x1a, 'Ξ'.ord,
    0x1b, 0x00A0,
    0x1c, 'Æ'.ord,
    0x1d, 'æ'.ord,
    0x1e, 'ß'.ord,
    0x1f, 'É'.ord,
    0x20, " ".ord,
    0x21, '!'.ord,
    0x22, '"'.ord,
    0x23, '#'.ord,
    0x24, '¤'.ord,
    0x25, '%'.ord,
    0x26, '&'.ord,
    0x27, "'".ord,
    0x28, '('.ord,
    0x29, ')'.ord,
    0x2a, '*'.ord,
    0x2b, '+'.ord,
    0x2c, ','.ord,
    0x2d, '-'.ord,
    0x2e, '.'.ord,
    0x2f, '/'.ord,
    0x30, '0'.ord,
    0x31, '1'.ord,
    0x32, '2'.ord,
    0x33, '3'.ord,
    0x34, '4'.ord,
    0x35, '5'.ord,
    0x36, '6'.ord,
    0x37, '7'.ord,
    0x38, '8'.ord,
    0x39, '9'.ord,
    0x3a, ':'.ord,
    0x3b, ';'.ord,
    0x3c, '<'.ord,
    0x3d, '='.ord,
    0x3e, '>'.ord,
    0x3f, '?'.ord,
    0x40, '¡'.ord,
    0x41, 'A'.ord,
    0x42, 'B'.ord,
    0x43, 'C'.ord,
    0x44, 'D'.ord,
    0x45, 'E'.ord,
    0x46, 'F'.ord,
    0x47, 'G'.ord,
    0x48, 'H'.ord,
    0x49, 'I'.ord,
    0x4a, 'J'.ord,
    0x4b, 'K'.ord,
    0x4c, 'L'.ord,
    0x4d, 'M'.ord,
    0x4e, 'N'.ord,
    0x4f, 'O'.ord,
    0x50, 'P'.ord,
    0x51, 'Q'.ord,
    0x52, 'R'.ord,
    0x53, 'S'.ord,
    0x54, 'T'.ord,
    0x55, 'U'.ord,
    0x56, 'V'.ord,
    0x57, 'W'.ord,
    0x58, 'X'.ord,
    0x59, 'Y'.ord,
    0x5a, 'Z'.ord,
    0x5b, 'Ä'.ord,
    0x5c, 'Ö'.ord,
    0x5d, 'Ñ'.ord,
    0x5e, 'Ü'.ord,
    0x5f, '§'.ord,
    0x60, '¿'.ord,
    0x61, 'a'.ord,
    0x62, 'b'.ord,
    0x63, 'c'.ord,
    0x64, 'd'.ord,
    0x65, 'e'.ord,
    0x66, 'f'.ord,
    0x67, 'g'.ord,
    0x68, 'h'.ord,
    0x69, 'i'.ord,
    0x6a, 'j'.ord,
    0x6b, 'k'.ord,
    0x6c, 'l'.ord,
    0x6d, 'm'.ord,
    0x6e, 'n'.ord,
    0x6f, 'o'.ord,
    0x70, 'p'.ord,
    0x71, 'q'.ord,
    0x72, 'r'.ord,
    0x73, 's'.ord,
    0x74, 't'.ord,
    0x75, 'u'.ord,
    0x76, 'v'.ord,
    0x77, 'w'.ord,
    0x78, 'x'.ord,
    0x79, 'y'.ord,
    0x7a, 'z'.ord,
    0x7b, 'ä'.ord,
    0x7c, 'ö'.ord,
    0x7d, 'ñ'.ord,
    0x7e, 'ü'.ord,
    0x7f, 'à'.ord,
    #[0x1B, 0x0A], 0x000C, # Removed for now, Need to figure out how to Regex match this character
    [0x1B, 0x14], '^'.ord,
    [0x1B, 0x28], '{'.ord,
    [0x1B, 0x29], '}'.ord,
    [0x1B, 0x2f], 0x005C,
    [0x1B, 0x3c], '['.ord,
    [0x1B, 0x3d], '~'.ord,
    [0x1B, 0x3e], ']'.ord,
    [0x1B, 0x40], '|'.ord,
    [0x1B, 0x65], '€'.ord
  ]

  @@uni_to_gsm = Hash.new
  @@gsm_to_uni = Hash.new
  GSM_7BIT_MAP.each_slice(2) { |gsm, uni| @@uni_to_gsm[uni] = gsm; @@gsm_to_uni[gsm] = uni; }

  class << self
    def is_gsm_7bit? str
      str.match(NON_GSM_7BIT_MATCHER).nil?
    end

    def to_gsm str
      if self.is_gsm_7bit?(str)
        str.unpack('U*').collect { |utf8_char| @@uni_to_gsm[utf8_char] }.flatten.pack('c*')
      else
        Iconv.iconv('UCS-2', 'UTF-8', str).first
      end
    end

    def gsm_string_counter str
      hash = {}

      if self.is_gsm_7bit?(str)
        hash = { :length => 0, :segments => 1, :remaining_length_for_segment => 160 }
        gsm_str = self.to_gsm(str)
        hash[:length] = gsm_str.length

        case gsm_str.length
        when 0..160
          hash[:segments] = 1
          hash[:remaining_length_for_segment] = 160 - gsm_str.length
        when 161..306
          hash[:segments] = 2
          hash[:remaining_length_for_segment] = 306 - gsm_str.length
        when 307..459
          hash[:segments] = 3
          hash[:remaining_length_for_segment] = 459 - gsm_str.length
        else
          hash = { :invalid => true }
        end

      else
        hash = { :length => 0, :segments => 1, :remaining_length_for_segment => 70 }
        hash[:length] = str.length

        case str.length
        when 0..70
          hash[:segments] = 1
          hash[:remaining_length_for_segment] = 70 - str.length
        when 71..134
          hash[:segments] = 2
          hash[:remaining_length_for_segment] = 134 - str.length
        when 135..201
          hash[:segments] = 3
          hash[:remaining_length_for_segment] = 201 - str.length
        else
          hash = { :invalid => true }
        end
      end

      return hash
    end

    def gsm_to_s gsm
      last_is_escape = false
      collect = gsm.unpack('c*').collect do |bin_char|
        if bin_char == 27
          last_is_escape = true
          next
        end

        if last_is_escape
          last_is_escape = false
          @@gsm_to_uni[[27, bin_char]]
        else
          @@gsm_to_uni[bin_char]
        end
      end
      collect.reject { |x| x.nil? }.flatten.pack('U*')
    end

  end
end
