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
  
  
  it 'can_generate_api_key_end_point_e1' do
    api_key = @key.generate
    api_key.should be_an_instance_of String
  end
  
  
  it 'can_allocate_api_key_end_point_e2' do
    api_key_generated = @key.generate
    api_key_allocated = @key.serve
    api_key_generated.should eql api_key_allocated
  end
  
  
  it 'cant_allocate_api_key_end_point_e2' do
    api_key_allocated = @key.serve
    api_key_allocated.should eql false
  end
  
  
  it 'can_unblock_api_key_end_point_e3' do
    api_key_generated = @key.generate
    api_key_allocated = @key.serve
    api_key_not_allocated = @key.serve
    api_key_not_allocated.should eql false
    @key.unblock api_key_allocated
    unblocked_api_key_reallocated = @key.serve
    unblocked_api_key_reallocated.should eql api_key_allocated
  end
  
  
  it 'can_delete_api_key_end_point_e4' do
    api_key_generated = @key.generate
    @key.purge api_key_generated
    api_key_not_allocated = @key.serve
    api_key_not_allocated.should eql false
  end
  
  
  it 'can_refresh_api_key_to_prevent_from_auto_deletion_end_point_e5' do
    api_key_generated = @key.generate
    api_key_allocated = @key.serve
    @key.setTimestamp(api_key_allocated, Time.now - Constants::DELETION_TIMEOUT - 10)
    @key.refresh api_key_allocated
    @key.periodic_refresh false
    timestamp = @key.getTimestamp(api_key_allocated)
    timestamp.should_not eql false
  end
  
  
  it 'auto_unblock_api_key_due_to_timeout_r1' do
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
  
  
  it 'auto_delete_api_key_due_to_timeout' do
    api_key_generated = @key.generate
    @keys << api_key_generated
    new_timestamp = Time.now - Constants::DELETION_TIMEOUT - 5
    @key.setTimestamp(api_key_generated, new_timestamp)
    @key.periodic_refresh false
    api_key_allocated = @key.serve
    api_key_allocated.should eql false
  end

end