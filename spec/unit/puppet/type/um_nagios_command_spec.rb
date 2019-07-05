require 'spec_helper'
require 'puppet/type/um_nagios_command'

RSpec.describe 'the um_nagios_command type' do
  it 'loads' do
    expect(Puppet::Type.type(:um_nagios_command)).not_to be_nil
  end
end
