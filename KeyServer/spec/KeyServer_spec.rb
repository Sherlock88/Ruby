require_relative "./spec_helper"
require_relative "../Key"

describe Key do
  
  before do
    @key = Key.new
    @keys = Array.new
  end
  
  it 'check for instance' do
    @key.should be_an_instance_of Key
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
  
  it 'delete_api_key_due_to_timeout' do
    api_key_generated = @key.generate
    @keys << api_key_generated
    new_timestamp = Time.now - Constants::DELETION_TIMEOUT - 5
    @key.setTimestamp(api_key_generated, new_timestamp)
    @key.periodic_refresh false
    api_key_allocated = @key.serve
    api_key_allocated.should eql false
  end

  it 'can_allocate_api_key_after_unblocking_due_to_timeout' do
    api_key_generated = @key.generate
    @keys << api_key_generated
    @key.serve
    api_key_allocated = @key.serve
    api_key_allocated.should eql false
    @key.setTimestamp(api_key_generated, Time.now - Constants::UNBLOCK_TIMEOUT - 5)
    @key.periodic_refresh false
    api_key_allocated = @key.serve
    api_key_allocated.should_not eql false
    expect(@keys).to contain_exactly(api_key_allocated)
  end

end