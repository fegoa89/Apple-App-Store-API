require "rails_helper"

describe PublishersRanking do

  describe "performing a successfull api request" do

    subject { PublishersRanking.new(category_id: 1234, monetization: "free") }
    #
    # The file has 2 responses for the same publisher_id and one for a different publisher_id
    # just for make it easier to test, knowing that the output of apple_lookup_build_response
    # would be two elements in the array. It is deeply tested on
    # spec/services/response/publishers_ranking_spec.rb , where all this "magic" happens
    #
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

      it "it is be ordered" do
        expect(subject.perform_request.first[:ranking_position]).to be < subject.perform_request.last[:ranking_position]
      end 
    end
  end

  context "performing an unsuccessfull request" do

    let(:apple_store_api_response_error)   { File.read("spec/fixtures/apple_store_api_xml_error") }

    let(:apple_store_api_response)   { File.read("spec/fixtures/apple_store_api_raw_response.json") }

    context "when the apple_store_api response is a failure" do

      before(:each) do
        stub_request(:get, %r{https://itunes\.apple\.com/WebObjects/MZStore\.woa.*/}).to_return( body: apple_store_api_response_error )
        stub_request(:get, %r{https://itunes\.apple\.com/lookup\.*}).to_return( body: [] )
      end

      it "returns a hash with a error" do
        expect(subject.perform_request).to eq( { error: 400, message: "Bad Request" } )
      end
    end

    context "when the apple_store_api response is a valid but apple_lookup_api response is a failure" do

      before(:each) do
        stub_request(:get, %r{https://itunes\.apple\.com/WebObjects/MZStore\.woa.*/}).to_return( body: apple_store_api_response )
        PublishersRanking.any_instance.should_receive(:get_app_metadata).and_return(RestClient::BadRequest.new)
      end

      it "returns a hash with a error" do
        expect(subject.perform_request).to eq( { error: 400, message: "Bad Request" } )
      end
    end
  end
end