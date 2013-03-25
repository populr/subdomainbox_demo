require 'spec_helper'

describe DocPrivilege do

  it "should respond to #collaborator_email" do
    DocPrivilege.new.should respond_to(:collaborator_email)
  end

  it "should respond to #collaborator_email=" do
    DocPrivilege.new.should respond_to(:collaborator_email=)
  end

  context "when created with a collaborator_email" do
    context "when that email corresponds to a user" do
      it "the user id of the new doc privilege should be that of the user" do
        user = Factory(:user)
        doc = Factory(:doc)
        privilege = doc.doc_privileges.new(:collaborator_email => user.email)
        privilege.save
        privilege.user.should eq(user)
      end
    end

    context "when that email corresponds to a user" do
      it "should assign an error on :collaborator_email" do
        doc = Factory(:doc)
        privilege = doc.doc_privileges.new(:collaborator_email => 'snoopy@peanuts.com')
        privilege.save
        privilege.errors[:collaborator_email].should_not be_blank
      end
    end
  end

end
