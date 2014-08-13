require 'spec_helper'

describe RackTables::VLANParse do
  it 'should have a version number' do
    expect(RackTables::VLANParse::VERSION).not_to be nil
  end
end

describe RackTables::VLAN do
  vlan = RackTables::VLAN.new

  it 'should parse "100"' do
    expect(vlan.parse("100")).to eq({ :native => "100", :allowed => ["100"], :type => :access })
  end

  it 'should parse "A100"' do
    expect(vlan.parse("A100")).to eq({ :native => "100", :allowed => ["100"], :type => :access })
  end

  it 'should parse "T100"' do
    expect(vlan.parse("T100")).to eq({ :native => "100", :allowed => ["100"], :type => :trunk })
  end

  it 'should parse "T100+200"' do
    expect(vlan.parse("T100+200")).to eq({ :native => "100", :allowed => ["100", "200"], :type => :trunk })
  end

  it 'should parse "T100+200+300"' do
    expect(vlan.parse("T100+200+300")).to eq({ :native => "100", :allowed => ["100", "200", "300"], :type => :trunk })
  end
end
