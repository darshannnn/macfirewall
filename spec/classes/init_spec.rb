require 'spec_helper'
describe 'macfirewall' do

  context 'with defaults for all parameters' do
    it { should contain_class('macfirewall') }
  end
end
