require 'spec_helper'

describe BreweriesController do
  render_views
  
  describe "GET 'index'" do
    before(:each) do
      first  = Factory(:brewery, :name => "First Brewery")
      second = Factory(:brewery, :name => "Second Brewery")
      third  = Factory(:brewery, :name => "Third Brewery")
      @breweries = [first, second, third]
    end
    
    it "should be successful" do
      get :index
      response.should be_success
    end
    
    it "should have the right title" do
      get :index
      response.should have_selector("title", :content => "Breweries")
    end
    
    it "should have a link to the 'new' page" do
      get :index
      response.should have_selector("a", :href => new_brewery_path)
    end
    
    it "should list all of the breweries" do
      get :index
      @breweries.each do |brewery|
        response.should have_selector("li", :content => brewery.name)
      end
    end
    
    it "should link to all of the breweries" do
      get :index
      @breweries.each do |brewery|
        response.should have_selector("a", :href => brewery_path(brewery))
      end
    end
    
    it "should display a delete link" do
      get :index
      @breweries.each do |brewery|
        response.should have_selector("a", :href => brewery_path(brewery),
                                           :content => "delete")
      end
    end
  end
  
  describe "GET 'new'" do
    it "should be successful" do
      get "new"
      response.should be_success
    end
    
    it "should have the right title" do
      get "new"
      response.should have_selector("title", :content => "New Brewery")
    end
  end
  
  describe "POST 'create'" do
    describe "failure" do
      before(:each) do
        # invalid attributes
        @attr = { :name => "" }
      end
      
      it "should not create a brewery" do
        lambda do
          post :create, :brewery => @attr
        end.should_not change(Brewery, :count)
      end
    
      it "should have the right title" do
        post :create, :brewery => @attr
        response.should have_selector("title", :content => "New Brewery")
      end
      
      it "should render the 'new' page" do
        post :create, :brewery => @attr
        response.should render_template('new')
      end
    end
    
    describe "success" do
      before(:each) do
        # valid attributes
        @attr = { :name => "Brauhaus" }
      end
      
      it "should create a brewery" do
        lambda do
          post :create, :brewery => @attr
        end.should change(Brewery, :count).by(1)
      end
      
      it "should redirect to the new brewery's 'show' page" do
        post :create, :brewery => @attr
        response.should redirect_to(brewery_path(assigns(:brewery)))
      end
      
      it "should leverage the power of suggestion" do
        post :create, :brewery => @attr
        flash[:success].should =~ /field trip/i
      end
    end
  end
  
  describe "GET 'show'" do
    before(:each) do
      @brewery = Factory(:brewery)
    end
    
    it "should be successful" do
      get :show, :id => @brewery
      response.should be_success
    end
    
    it "should have the right title" do
      get :show, :id => @brewery
      response.should have_selector("title", :content => @brewery.name)
    end
    
    it "should retrieve the correct brewery" do
      get :show, :id => @brewery
      assigns(:brewery).should == @brewery
    end
    
    it "should have a subheading displaying the brewery's name" do
      get :show, :id => @brewery
      response.should have_selector("h2", :content => @brewery.name)
    end
  end
  
  describe "GET 'edit'" do
    before(:each) do
      @brewery = Factory(:brewery)
    end
    
    it "should be successful" do
      get :edit, :id => @brewery
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @brewery
      response.should have_selector("title", :content => "Edit Brewery")
    end
  end
  
  describe "PUT 'update'" do
    before(:each) do
      @brewery = Factory(:brewery)
    end
    
    describe "failure" do
      before(:each) do
        @attr = { :name => "" }
      end
      
      it "should render the brewery's 'edit' page" do
        put :update, :id => @brewery, :brewery => @attr
        response.should render_template('edit')
      end
      
      it "should have the right title" do
        put :update, :id => @brewery, :brewery => @attr
        response.should have_selector("title", :content => "Edit Brewery")
      end
    end
    
    describe "success" do
      before(:each) do
        @attr = { :name => "New Brauhaus" }
      end
      
      it "should update the brewery's attributes" do
        put :update, :id => @brewery, :brewery => @attr
        @brewery.reload
        @brewery.name.should == @attr[:name]
      end
      
      it "should redirect to the brewery's 'show' page" do
        put :update, :id => @brewery, :brewery => @attr
        response.should redirect_to(brewery_path(@brewery))
      end
      
      it "should give confirmation" do
        put :update, :id => @brewery, :brewery => @attr
        flash[:success].should =~ /updated/i
      end
    end
  end
  
  describe "DELETE 'destroy'" do
    before(:each) do
      @brewery = Factory(:brewery)
    end
    
    it "should remove the brewery from the database" do
      lambda do
        delete :destroy, :id => @brewery
      end.should change(Brewery, :count).by(-1)
    end
    
    it "should redirect to the brewery 'index' page" do
      delete :destroy, :id => @brewery
      response.should redirect_to(breweries_path)
    end
    
    it "should display confirmation" do
      delete :destroy, :id => @brewery
      flash[:success].should =~ /deleted/i
    end
  end
end
