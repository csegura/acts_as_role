require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Access do
  describe "defaults" do
    before do
      @access = Access.new
    end
    it "should have default role :Access" do
      @access.flag.should be_empty
      @access.flag.should_not be_nil
    end
  end
  
  describe "should have available roles" do
    before do
      @access = Access.new
    end
    it "has some roles available" do
      @access.available_flags.length == 3
    end
    it "has some roles available" do
     #  @access.available_roles.should == %w(Access admin editor reader)
    end
  end
  
  describe "should permit add roles" do
    before(:each) do
      @access = Access.new
      @access.add_flags :owner
    end
    it "and check these" do
      @access.has_flag?(:owner).should be_true
    end
    it "more than once" do
      @access.add_flags :manager
      @access.has_flags?(:owner, :manager)
    end
  end

  describe "should persist" do
    before(:each) do
      @access = Access.new
      @access.add_flags :manager
    end
    it "when store it in database" do
      @access.save.should be_true
    end 
    it "when store it in database" do
      @access.add_flags :owner
      @access.save
      access = Access.find(@access.id)
      access.has_flags?(:manager, :owner).should be_true
    end     
    it "should fails when try to save invalid roles" do
      @access.add_flags :invalid
      @access.save.should be_false      
    end   
    it "should invalid if added an invalid role" do
      @access.add_flags :invalid
      @access.valid?.should be_false
    end
    it "should contains error message if added and invalid role" do
      @access.add_flags :invalid
      @access.valid?.should be_false
      @access.errors[:flag].should include("invalid role")
    end
  end
    
  describe "should permit remove roles and check for this" do
    before(:each) do
      @access = Access.new
      @access.add_flags :owner, :manager
    end
    it "should permit remove roles" do
      @access.remove_flags :manager      
      @access.has_flags?(:owner, :manager).should be_false
      @access.has_flags?(:manager).should be_false
    end
  end
  
  describe "should respond to is_role?" do
    before(:each) do
      @access = Access.new
      @access.add_flags :owner, :manager
    end
    it "respond to roles" do
      @access.is_owner?.should be_true
      @access.is_manager?.should be_true
      @access.is_employee?.should be_false
    end
  end
      
end