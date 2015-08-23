require "rails_helper"

describe Client::AppleStoreApi do

  let(:params_given) { { category_id: 6001, monetization: "free" } }

  subject { Client::AppleStoreApi.new( params_given[:category_id], params_given[:monetization] ) }

  describe "initialize" do
    it "gets initialized with give category_id" do
      expect(subject.category_id).to eq(params_given[:category_id])
    end

    it "gets initialized with give monetization" do
      expect(subject.monetization).to eq(params_given[:monetization])
    end
  end

  describe "get_top_apps" do
    before(:each) do
      stub_request(:get, %r{https://itunes\.apple\.com/WebObjects/MZStore\.woa.*/}).to_return( body: [] )
    end

    it "calls the apple store api" do
      expect(subject.get_top_apps).to be_empty
    end

  end
end