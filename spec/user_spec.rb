require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe User do
  describe "should have default role user" do
    before do
      @user = User.new
    end
    it "should have default role :user" do
      @user.roles.should == "user"
    end
    it "should has_role?(:user)" do
      @user.has_role?(:user).should be_true
    end
    it "should has_roles?(:user)" do
      @user.has_roles?(:user).should be_true
    end
  end
  
  describe "should have available roles" do
    before do
      @user = User.new
    end
    it "has some roles available" do
      @user.available_roles.length == 4
    end
    it "has some roles available" do
     #  @user.available_roles.should == %w(user admin editor reader)
    end
  end
  
  describe "should permit add roles" do
    before do
      @user = User.new
      @user.add_roles :admin
    end
    it "and check these" do
      @user.has_role?(:admin)
      @user.has_roles?(:user, :admin)
      @user.has_roles?(:admin, :user)
    end
    it "more than once" do
      @user.add_roles :admin, :editor, :reader
      @user.has_roles?(:admin, :editor, :reader)
    end
  end

  describe "should persist" do
    before(:each) do
      @user = User.new
      @user.add_roles :admin
    end
    it "when store it in database" do
      @user.save.should be_true
    end 
    it "when store it in database" do
      @user.save
      user = User.find(@user.id)
      user.has_roles?(:user, :admin).should be_true
    end     
    it "should fails when try to save invalid roles" do
      @user.add_roles :invalid
      @user.save.should be_false      
    end   
    it "should invalid if added an invalid role" do
      @user.add_roles :invalid
      @user.valid?.should be_false
    end
    it "should contains error message if added and invalid role" do
      @user.add_roles :invalid
      @user.valid?.should be_false
      @user.errors[:roles].should include("contains an invalid role")
    end
  end
    
  describe "should permit remove roles and check for this" do
    before(:each) do
      @user = User.new
      @user.add_roles :admin, :editor
    end
    it "should permit remove roles" do
      @user.remove_roles :editor      
      @user.has_roles?(:user, :admin).should be_true
      @user.has_role?(:editor).should be_false
    end
  end
  
  describe "should respond to is_role?" do
    before(:each) do
      @user = User.new
      @user.add_roles :editor
    end
    it "sample roles" do
      @user.is_user?.should be_true
      @user.is_editor?.should be_true
      @user.is_admin?.should be_false
    end
  end  
    
end  