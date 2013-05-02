require 'spec_helper'

describe Doc do

  it "should respond to #privilege" do
    Doc.new.should respond_to(:privilege)
  end

  it "should respond to #privilege=" do
    Doc.new.should respond_to(:privilege=)
  end

  it "should respond to #title" do
    Doc.new.should respond_to(:title)
  end

  it "should respond to #title=" do
    Doc.new.should respond_to(:title=)
  end

  it "should respond to #body" do
    Doc.new.should respond_to(:body)
  end

  it "should respond to #body=" do
    Doc.new.should respond_to(:body=)
  end

  it "should respond to #subdomain" do
    Doc.new.should respond_to(:subdomain)
  end

  it "should respond to #subdomain=" do
    Doc.new.should respond_to(:subdomain=)
  end

  describe "subdomain" do
    it "should default to a non-empty string" do
      doc = Doc.new
      doc.save!
      doc.subdomain.should_not be_blank
    end

    context "when saved with an empty subdomain" do
      it "should default to a non-empty string" do
        doc = Factory(:doc)
        doc.subdomain = ''
        doc.save!
        doc.subdomain.should_not be_blank
      end
    end

    it "should be unique" do
      doc = Factory(:doc, :subdomain => 'hello')
      doc2 = Factory.build(:doc, :subdomain => 'hello')
      doc2.should_not be_valid
    end

    it "should contain only alphanumeric characters" do
      doc = Factory.build(:doc, :subdomain => 'hello.world')
      doc.should_not be_valid
    end
  end


  describe "title" do
    context "when created without a title" do
      it "should default to 'Untitled'" do
        doc = Doc.new
        doc.save!
        doc.title.should == 'Untitled'
      end
    end

    context "when created with a title" do
      it "should not overwrite the assigned title" do
        doc = Doc.new(:title => 'Hello World')
        doc.save!
        doc.title.should == 'Hello World'
      end
    end
  end

  describe "#as_json" do
    it "should include the privilege" do
      doc = Doc.new
      doc.privilege = 'w'
      doc.as_json['privilege'].should == 'w'
    end

    context "when the privilege is nil" do
      it "should not include privilege in the json" do
      doc = Doc.new
      doc.as_json.should_not have_key('privilege')
      end
    end
  end

  describe "#add_owner!" do
    it "should add a user with a privilege of 'o'" do
      user = Factory(:user)
      doc = Factory(:doc)
      doc.add_owner!(user)
      doc.doc_privileges.first.privilege.should == 'o'
    end
  end

  describe "#add_editor!" do
    it "should add a user with a privilege of 'w'" do
      user = Factory(:user)
      doc = Factory(:doc)
      doc.add_editor!(user)
      doc.doc_privileges.first.privilege.should == 'w'
    end
  end

  describe "#owners" do
    before(:each) do
      @owner = Factory(:user)
      @editor = Factory(:user)
      @doc = Factory(:doc)
      @doc.add_owner!(@owner)
      @doc.add_editor!(@editor)
    end

    it "should include all owners" do
      @doc.owners.should include(@owner)
    end

    it "should exclude all editors" do
      @doc.owners.should_not include(@editor)
    end
  end

  describe "#editors" do
    before(:each) do
      @owner = Factory(:user)
      @editor = Factory(:user)
      @doc = Factory(:doc)
      @doc.add_owner!(@owner)
      @doc.add_editor!(@editor)
    end

    it "should include all owners" do
      @doc.editors.should include(@owner)
    end

    it "should include all editors" do
      @doc.editors.should include(@editor)
    end
  end

  describe "#owner?" do
    it "should be true when the user is a owner" do
      user = Factory(:user)
      doc = Factory(:doc)
      doc.add_owner!(user)
      doc.owner?(user).should be_true
    end

    it "should be false when the user is not a owner" do
      user = Factory(:user)
      doc = Factory(:doc)
      doc.owner?(user).should be_false
    end
  end

  describe "#editor?" do
    it "should be true when the user is a editor" do
      user = Factory(:user)
      doc = Factory(:doc)
      doc.add_editor!(user)
      doc.editor?(user).should be_true
    end

    it "should be false when the user is not a editor" do
      user = Factory(:user)
      doc = Factory(:doc)
      doc.editor?(user).should be_false
    end
  end

  describe "#other_collaborators" do

    it "should include owners" do
      main = Factory(:user)
      user = Factory(:user)

      doc = Factory(:doc)
      doc.add_owner!(user)
      doc.add_editor!(main)

      doc.other_collaborators(main).should include(user)
    end

    it "should include editors" do
      main = Factory(:user)
      user = Factory(:user)

      doc = Factory(:doc)
      doc.add_editor!(main)
      doc.add_editor!(user)

      doc.other_collaborators(main).should include(user)
    end

    it "should not include the specified user" do
      main = Factory(:user)

      doc = Factory(:doc)
      doc.add_editor!(main)

      doc.other_collaborators(main).should_not include(main)
    end
  end

end
