require 'spec_helper'

describe User do


  describe "#owned_docs" do
    before(:each) do
      @user = Factory(:user)
      @owned_doc = Factory(:doc)
      @owned_doc.add_owner!(@user)

      @editor_doc = Factory(:doc)
      @editor_doc.add_editor!(@user)
    end

    it "should include all docs of which the user is an owner" do
      @user.owned_docs.should include(@owned_doc)
    end

    it "should include all docs of which the user is an editor" do
      @user.owned_docs.should_not include(@editor_doc)
    end
  end

  describe "#editor_docs" do
    before(:each) do
      @user = Factory(:user)
      @owned_doc = Factory(:doc)
      @owned_doc.add_owner!(@user)

      @editor_doc = Factory(:doc)
      @editor_doc.add_editor!(@user)
    end

    it "should not include all docs of which the user is an owner" do
      @user.editor_docs.should_not include(@owned_doc)
    end

    it "should include all docs of which the user is an editor" do
      @user.editor_docs.should include(@editor_doc)
    end
  end

end
