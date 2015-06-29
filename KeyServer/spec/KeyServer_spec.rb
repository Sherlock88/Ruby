require_relative "./spec_helper"
require_relative "../KeyServer"

describe Key do
  
  before do
    @key = Key.new
    @keys = Array.new
  end
  
  it "check for instance" do
    @key.should be_an_instance_of Key
    Thread.new { @key.periodic_refresh }
  end
  
  it 'generate_api_key' do
    api_key = @key.generate
    api_key.should be_an_instance_of String
  end
  
  it 'can_allocate_api_key' do
    api_key_generated = @key.generate
    api_key_allocated = @key.serve
    api_key_generated.should eql api_key_allocated
  end
  
  it 'cant_allocate_api_key' do
    api_key_generated = @key.generate
    @keys << api_key_generated
    @key.serve
    api_key_allocated = @key.serve
    api_key_allocated.should eql false
  end
  
  it 'can_allocate_api_key_after_deallocation' do
    api_key_generated = @key.generate
    @keys << api_key_generated
    @key.serve
    api_key_allocated = @key.serve
    api_key_allocated.should eql false
    sleep (Constants::UNBLOCK_TIMEOUT + 3)
    api_key_allocated = @key.serve
    p api_key_allocated
    api_key_allocated.should_not eql false
    expect(@keys).to contain_exactly(api_key_allocated)
  end

end