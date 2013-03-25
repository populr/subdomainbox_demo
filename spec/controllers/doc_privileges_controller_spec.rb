require 'spec_helper'

describe DocPrivilegesController do
  before(:each) do
    @request.env['HTTP_ACCEPT'] = 'application/json'

    controller.stub(:subdomainbox)
  end

  describe "GET new" do
    context "for a document I own" do
      before(:each) do
        user = Factory(:user)

        @doc = Factory(:doc)
        @doc.add_owner!(user)

        sign_in user
        get :new, :doc_id => @doc.id
      end

      it "should assign a new doc_privilege as @doc_privilege" do
        assigns(:doc_privilege).should_not be_persisted
      end

      it "should be successful" do
        response.should be_success
      end
    end

    context "for a document I don't own" do
      it "should respond with 403" do
        user = Factory(:user)

        @doc = Factory(:doc)
        @doc.add_editor!(user)

        sign_in user
        get :new, :doc_id => @doc.id
        response.status.should == 403
      end
    end
  end

  describe "POST create with the email address of another user" do
    context "for a document I own" do
      before(:each) do
        user = Factory(:user)
        @collaborator = Factory(:user)

        @doc = Factory(:doc)
        @doc.add_owner!(user)

        sign_in user
        post :create, :doc_id => @doc.id, :doc_privilege => { :collaborator_email => @collaborator.email }
      end

      it "should add the specified collaborator as an editor" do
        @doc.reload
        @doc.editors.should include(@collaborator)
      end

      it "should redirect to the doc index" do
        response.should redirect_to(docs_url)
      end
    end

    context "for a document I don't own" do
      before(:each) do
        user = Factory(:user)
        @collaborator = Factory(:user)

        @doc = Factory(:doc)
        @doc.add_editor!(user)

        sign_in user
        post :create, :doc_id => @doc.id, :doc_privilege => { :collaborator_email => @collaborator.email }
      end

      it "should not add the specified collaborator as an editor" do
        @doc.reload
        @doc.editors.should_not include(@collaborator)
      end

      it "should respond with 403" do
        response.status.should == 403
      end
    end
  end
end

