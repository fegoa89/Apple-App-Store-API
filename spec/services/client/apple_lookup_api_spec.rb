require "rails_helper"

describe Client::AppleLookupApi do

  let(:params_given) { ["1", "2", "3"] }

  subject { Client::AppleLookupApi.new( params_given ) }

  describe "initialize" do
    it "gets initialized with give arrays params" do
      expect(subject.ids).to eq(params_given)
    end
  end

  describe "get_top_apps" do
    before(:each) do
      stub_request(:get, %r{https://itunes\.apple\.com/lookup\.*}).to_return( body: [] )
    end

    it "calls the apple store api" do
      expect(subject.get_apps_metadata).to be_empty
    end

  end
end