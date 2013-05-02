require 'spec_helper'

describe DocsController do
  before(:each) do
    controller.stub(:subdomainbox)
  end

  describe "GET index" do
    it "should assign all docs I own as @owned_docs" do
      user = Factory(:user)

      own_doc = Factory(:doc)
      own_doc.add_owner!(user)

      edit_doc = Factory(:doc)
      edit_doc.add_editor!(user)

      sign_in user
      get :index
      assigns(:owned_docs).should eq([own_doc])
    end

    it "should assign all docs I can edit as @editor_docs" do
      user = Factory(:user)

      own_doc = Factory(:doc)
      own_doc.add_owner!(user)

      edit_doc = Factory(:doc)
      edit_doc.add_editor!(user)

      sign_in user
      get :index
      assigns(:editor_docs).should eq([edit_doc])
    end

    it "should not assign docs I cannot edit" do
      user = Factory(:user)
      doc = Factory(:doc)

      sign_in user
      get :index
      assigns(:owned_docs).should have(0).items
      assigns(:editor_docs).should have(0).items
    end
  end

  describe "GET show" do
    before(:each) do
      @request.env['HTTP_ACCEPT'] = 'application/json'
    end

    context "for a document I own" do
      before(:each) do
        user = Factory(:user)

        @doc = Factory(:doc)
        @doc.add_owner!(user)

        sign_in user
        get :show, :id => @doc.id
      end

      it "should assign the doc as @doc" do
        assigns(:doc).should eq(@doc)
      end

      it "should be successful" do
        response.should be_success
      end
    end

    context "for a document I can edit" do
      before(:each) do
        user = Factory(:user)

        @doc = Factory(:doc)
        @doc.add_editor!(user)

        sign_in user
        get :show, :id => @doc.id
      end

      it "should assign the doc as @doc" do
        assigns(:doc).should eq(@doc)
      end

      it "should be successful" do
        response.should be_success
      end
    end

    context "for a document I cannot edit" do
      it "should respond with 404" do
        user = Factory(:user)

        @doc = Factory(:doc)

        sign_in user
        get :show, :id => @doc.id
        response.status.should == 404
      end
    end
  end

  describe "GET edit" do
    before(:each) do
      @request.env['HTTP_ACCEPT'] = 'application/json'
    end

    context "for a document I own" do
      before(:each) do
        user = Factory(:user)

        @doc = Factory(:doc)
        @doc.add_owner!(user)

        sign_in user
        get :edit, :id => @doc.id
      end

      it "should assign the doc as @doc" do
        assigns(:doc).should eq(@doc)
      end

      it "should be successful" do
        response.should be_success
      end
    end

    context "for a document I can edit" do
      before(:each) do
        user = Factory(:user)

        @doc = Factory(:doc)
        @doc.add_editor!(user)

        sign_in user
        get :edit, :id => @doc.id
      end

      it "should assign the doc as @doc" do
        assigns(:doc).should eq(@doc)
      end

      it "should be successful" do
        response.should be_success
      end
    end

    context "for a document I cannot edit" do
      it "should respond with 404" do
        user = Factory(:user)

        @doc = Factory(:doc)

        sign_in user
        get :edit, :id => @doc.id
        response.status.should == 404
      end
    end
  end

  describe "POST star" do
    before(:each) do
      @user = Factory(:user)
      @doc = Factory(:doc)
      @doc.reload

      sign_in @user
    end

    it "should star the doc on behalf of the user" do
      User.any_instance.should_receive(:star!)
      post :star, :id => @doc.id
    end

    it "should redirect back to the published doc" do
      new_location = controller.send(:published_doc_url, @doc)
      post :star, :id => @doc.id
      response.should redirect_to(new_location)
    end
  end

  describe "POST create" do
    before(:each) do
      @request.env['HTTP_ACCEPT'] = 'application/json'
    end

    before(:each) do
      @user = Factory(:user)

      sign_in @user
      post :create, :doc => { :title => 'Hello World' }
    end

    it "should create a new doc of which the user is an owner" do
      @user.should have(1).owned_doc
    end

    it "should create the doc with the specified attributes" do
      @user.docs.first.title.should == 'Hello World'
    end

    it "should be successful" do
      response.should be_success
    end
  end

  describe "PUT update" do
    before(:each) do
      @request.env['HTTP_ACCEPT'] = 'application/json'
    end

    context "for a document I own" do
      before(:each) do
        user = Factory(:user)

        @doc = Factory(:doc)
        @doc.add_owner!(user)

        sign_in user
        put :update, :id => @doc.id, :doc => { :title => 'Modified' }
      end

      it "should update the doc" do
        @doc.reload.title.should == 'Modified'
      end

      it "should be successful" do
        response.should be_success
      end
    end

    context "for a document I can edit" do
      before(:each) do
        user = Factory(:user)

        @doc = Factory(:doc)
        @doc.add_editor!(user)

        sign_in user
        put :update, :id => @doc.id, :doc => { :title => 'Modified' }
      end

      it "should update the doc" do
        @doc.reload.title.should == 'Modified'
      end

      it "should be successful" do
        response.should be_success
      end
    end

    context "for a document I cannot edit" do
      before(:each) do
        user = Factory(:user)

        @doc = Factory(:doc)

        sign_in user
        put :update, :id => @doc.id, :doc => { :title => 'Modified' }
      end

      it "should not update the doc" do
        @doc.reload.title.should_not == 'Modified'
      end

      it "should respond with 404" do
        response.status.should == 404
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @request.env['HTTP_ACCEPT'] = 'application/json'
    end

    context "for a document I own" do
      before(:each) do
        user = Factory(:user)

        @doc = Factory(:doc)
        @doc.add_owner!(user)

        sign_in user
        delete :destroy, :id => @doc.id
      end

      it "should destroy the doc" do
        lambda {
          Doc.find(@doc.id)
        }.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should be successful" do
        response.should be_success
      end
    end

    context "for a document I can edit" do
      before(:each) do
        user = Factory(:user)

        @doc = Factory(:doc)
        @doc.add_editor!(user)

        sign_in user
        delete :destroy, :id => @doc.id
      end

      it "should not destroy the doc" do
        lambda {
          Doc.find(@doc.id)
        }.should_not raise_error
      end

      it "should respond with 403" do
        response.status.should == 403
      end
    end

    context "for a document I cannot edit" do
      before(:each) do
        user = Factory(:user)

        @doc = Factory(:doc)

        sign_in user
        delete :destroy, :id => @doc.id
      end

      it "should not destroy the doc" do
        lambda {
          Doc.find(@doc.id)
        }.should_not raise_error
      end

      it "should respond with 404" do
        response.status.should == 404
      end
    end
  end

end

