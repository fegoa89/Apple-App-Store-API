require "rails_helper"

describe Response::AppleStoreResponse do

  let(:monetization_type)          { "free" }
  let(:monetization_array_positon) { Response::AppleStoreResponse::MONETIZATION_POSITION[monetization_type] }

  describe "receiving a successfull response" do

    let(:apple_store_api_response)   { File.read("spec/fixtures/apple_store_api_raw_response.json") }

    let(:charts_by_monetization)     { JSON.parse(apple_store_api_response)["topCharts"] }

    subject { Response::AppleStoreResponse.new(apple_store_api_response, monetization_type) }

    describe "valid?" do
      it "returns true" do
        expect(subject.valid?).to be true
      end
    end

    describe "top_charts_monetization" do

      it "returns the arrive equivalent to the monetization type given" do
        expect(subject.top_charts_for_monetization).to eq(charts_by_monetization[monetization_array_positon]["adamIds"])
      end

    end
  end

  describe "receiving an unsuccessfull response" do
    let(:apple_store_api_response_error)   { File.read("spec/fixtures/apple_store_api_xml_error") }

    let(:monetization_type)                { "free" }

    subject { Response::AppleStoreResponse.new(apple_store_api_response_error, monetization_type) }

    describe "valid?" do
      it "returns true" do
        expect(subject.valid?).to be false
      end
    end

    describe "error" do

      it "returns a hash with an error" do
        expect(subject.error).to eq( { error: 400, message: "Bad Request" } )
      end
    end

  end
end