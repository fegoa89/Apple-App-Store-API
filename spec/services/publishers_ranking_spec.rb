require "rails_helper"

describe PublishersRanking do

  describe "performing a successfull api request" do
    subject { PublishersRanking.new(category_id: 1234, monetization: "free") }

    let(:apple_store_api_response)   { File.read("spec/fixtures/apple_store_api_raw_response.json") }

    let(:apple_lookup_api_response)   { File.read("spec/fixtures/apple_lookup_api_multiple_response.json") }

    context "performing a successfull request" do
      before(:each) do
        stub_request(:get, %r{https://itunes\.apple\.com/WebObjects/MZStore\.woa.*/}).to_return( body: apple_store_api_response )
        stub_request(:get, %r{https://itunes\.apple\.com/lookup\.*}).to_return( body: apple_lookup_api_response )
      end

      it "returns an array" do
        expect(subject.perform_request.class).to eq Array
      end

      it "contains 2 hashes" do
        expect(subject.perform_request.count).to eq 2
      end

      it "should be ordered" do
        expect(subject.perform_request.first[:ranking_position]).to be < subject.perform_request.last[:ranking_position]
      end 
    end
  end
end