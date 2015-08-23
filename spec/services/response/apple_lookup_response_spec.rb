require "rails_helper"

describe Response::AppleLookupResponse do
  describe "receiving a successfull response" do

    let(:json_response) { JSON.parse(apple_lookup_api_response)["results"].first }

    let(:apple_lookup_api_response)   { File.read("spec/fixtures/apple_lookup_api_response.json") }

    subject { Response::AppleLookupResponse.new(apple_lookup_api_response) }

    describe "valid?" do
      it "returns true" do
        expect(subject.valid?).to be true
      end
    end

    describe "build_top_apps_response" do
      it "returns an array that contains a hash with a apple_store_id key" do
        expect(subject.build_top_apps_response.first[:apple_store_id]).to eq(json_response["trackId"])
      end

      it "returns an array that contains a hash with a metadata key" do
        expect(subject.build_top_apps_response.first).to have_key(:metadata)
      end

      it "returns the following keys on the metadata hash" do
        [ :price, :app_name, :description,
          :version_number  , :publisher_name,
          :small_icon_url  , :average_user_rating].each do |key|
          expect(subject.build_top_apps_response.first[:metadata]).to have_key(key)
        end
      end
    end
  end

  describe "receiving an unsuccesfull response" do

    let(:bad_request_response) { RestClient::BadRequest.new }

    subject { Response::AppleLookupResponse.new(bad_request_response) }

    describe "valid?" do
      it "returns false" do
        expect(subject.valid?).to be false
      end
    end

    describe "error" do
      it "returns an error hash" do
        expect(subject.error).to eq({ error: 400, message: "Bad Request"})
      end
    end
  end
end