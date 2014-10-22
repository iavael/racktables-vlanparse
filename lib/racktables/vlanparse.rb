require 'racktables/vlanparse/exception'
require 'racktables/vlanparse/version'

module RackTables
  class VLAN
    def self.parse(vlan)
      input = vlan + "\0"
      output = {
        :native => nil,
        :allowed => [],
        :type => nil
      }
      status = :start
      vlanbuf = ""
      input.each_char do |chr|
        case chr
        when "A", "T"
          raise ParsingError.new("Port type can be only at the beginning of the string") if status != :start
          output[:type] = chr == "A" ? :access : :trunk
          status = chr == "A" ? :atype : :ttype
        when "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
          if status == :start
            output[:type] = :access
            status = :anum
          elsif status == :atype || status == :anum
            status = :anum
          elsif status == :ttype || status == :tnum
            status = :tnum
          elsif status == :nextvlan || status == :nnum
            status = :nnum
          else
            raise ParsingError.new("There shouldn't be number")
          end
          vlanbuf += chr
        when "+", "\0"
          raise ParsingError.new("Invalid character at the beginning of the string") if status == :start
          raise ParsingError.new("VLAN number expected") if status == :nextvlan
          raise ParsingError.new("Null character in the input") if status == :end
          raise ParsingError.new("You must set native VLAN on access port") if status == :atype
          raise ParsingError.new("You cannot set tagged VLAN on access port") if chr == "+" && status == :anum
          raise ParsingError.new("VLAN number must be between 1 and 4095") if !vlanbuf.empty? && ( vlanbuf.to_i > 4095 || vlanbuf.to_i < 1 )
          if status == :ttype
            output[:native] = nil
          elsif status == :tnum || ( chr == "\0" && status == :anum )
            output[:native] = vlanbuf
            output[:allowed] = [ vlanbuf ]
          elsif status == :nnum
            output[:allowed] += [ vlanbuf ]
          end
          vlanbuf = ""
          status = chr == "+" ? :nextvlan : :end
        else
          raise ParsingError.new("Invalid character in the string")
        end
      end
      return output
    end
  end
end
