require 'spec_helper'

describe RackTables::VLANParse do
  it 'should have a version number' do
    expect(RackTables::VLANParse::VERSION).not_to be nil
  end
end

describe RackTables::VLAN do
  it 'should parse "100"' do
    expect(RackTables::VLAN.parse("100")).to eq({ :native => "100", :allowed => ["100"], :type => :access })
  end

  it 'should parse "T"' do
    expect(RackTables::VLAN.parse("T")).to eq({ :native => nil, :allowed => [], :type => :trunk })
  end

  it 'should parse "T+200"' do
    expect(RackTables::VLAN.parse("T+200")).to eq({ :native => nil, :allowed => ["200"], :type => :trunk })
  end

  it 'should parse "A100"' do
    expect(RackTables::VLAN.parse("A100")).to eq({ :native => "100", :allowed => ["100"], :type => :access })
  end

  it 'should parse "T100"' do
    expect(RackTables::VLAN.parse("T100")).to eq({ :native => "100", :allowed => ["100"], :type => :trunk })
  end

  it 'should parse "T100+200"' do
    expect(RackTables::VLAN.parse("T100+200")).to eq({ :native => "100", :allowed => ["100", "200"], :type => :trunk })
  end

  it 'should parse "T100+200+300"' do
    expect(RackTables::VLAN.parse("T100+200+300")).to eq({ :native => "100", :allowed => ["100", "200", "300"], :type => :trunk })
  end

  it 'should not parse ""' do
    expect { RackTables::VLAN.parse("") }.to raise_error(RackTables::VLAN::ParsingError, "Invalid character at the beginning of the string")
  end

  it 'should not parse "+"' do
    expect { RackTables::VLAN.parse("+") }.to raise_error(RackTables::VLAN::ParsingError, "Invalid character at the beginning of the string")
  end

  it 'should not parse "?"' do
    expect { RackTables::VLAN.parse("?") }.to raise_error(RackTables::VLAN::ParsingError, "Invalid character in the string")
  end

  it 'should not parse "A"' do
    expect { RackTables::VLAN.parse("A") }.to raise_error(RackTables::VLAN::ParsingError, "You must set native VLAN on access port")
  end

  it 'should not parse "A100+"' do
    expect { RackTables::VLAN.parse("A100+") }.to raise_error(RackTables::VLAN::ParsingError, "You cannot set tagged VLAN on access port")
  end

  it 'should not parse "A100+200"' do
    expect { RackTables::VLAN.parse("A100+200") }.to raise_error(RackTables::VLAN::ParsingError, "You cannot set tagged VLAN on access port")
  end

  it 'should not parse "A+200"' do
    expect { RackTables::VLAN.parse("A+200") }.to raise_error(RackTables::VLAN::ParsingError, "You must set native VLAN on access port")
  end

  it 'should not parse "T100+"' do
    expect { RackTables::VLAN.parse("T100+") }.to raise_error(RackTables::VLAN::ParsingError, "VLAN number expected")
  end

  it 'should not parse "A9999"' do
    expect { RackTables::VLAN.parse("A9999") }.to raise_error(RackTables::VLAN::ParsingError, "VLAN number must be between 1 and 4095")
  end

  it 'should not parse "9999"' do
    expect { RackTables::VLAN.parse("9999") }.to raise_error(RackTables::VLAN::ParsingError, "VLAN number must be between 1 and 4095")
  end

  it 'should not parse "T100+200\0+300"' do
    expect { RackTables::VLAN.parse("T100+200"+"\0"+"+300") }.to raise_error(RackTables::VLAN::ParsingError, "Null character in the input")
  end
end
