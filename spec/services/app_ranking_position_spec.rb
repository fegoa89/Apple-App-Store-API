require "rails_helper"

describe AppRankingPosition do

  subject { AppRankingPosition.new(category_id: 1234, monetization: "free", rank_position: 1) }

  describe "validations" do
    context "with category_id, monetization and rank_position" do
      it "is a valid object" do
        expect(subject.valid?).to be true
      end
    end

    context "when rank_position is not present" do
      it "is not a valid object" do
        subject.rank_position = nil
        expect(subject.valid?).to be false
      end

      it "contains an error message" do
        subject.rank_position = nil
        expect(subject.valid?).to be false
        expect(subject.errors.messages[:rank_position]).to eq(["is not a number"])
      end
    end

    context "when rank_position is not between 1 and 200" do
      it "is not a valid object" do
        subject.rank_position = 0
        expect(subject.valid?).to eq false
      end

      it "shows an error message when the number is below zero" do
        subject.rank_position = 0
        expect(subject.valid?).to eq false
        expect(subject.errors.messages[:rank_position]).to eq(["must be greater than or equal to 1"])
      end

      it "shows an error message when the number is over two hundred" do
        subject.rank_position = 201
        expect(subject.valid?).to eq false
        expect(subject.errors.messages[:rank_position]).to eq(["must be less than or equal to 200"])
      end
    end
  end

  describe "perform_request" do
    context "performing a successfull request" do
      let(:apple_lookup_api_response)  { File.read("spec/fixtures/apple_lookup_api_response.json") }
      let(:apple_store_api_response)   { File.read("spec/fixtures/apple_store_api_raw_response.json") }
      let(:json_response)              { JSON.parse(apple_lookup_api_response)["results"].first }

      before(:each) do
        stub_request(:get, %r{https://itunes\.apple\.com/WebObjects/MZStore\.woa.*/}).to_return( body: apple_store_api_response )
        stub_request(:get, %r{https://itunes\.apple\.com/lookup\.*}).to_return( body: apple_lookup_api_response )
      end

      it "contains only one result" do
        expect(subject.perform_request.count).to be 1
      end

      it "returns an array" do
        expect(subject.perform_request.class).to eq Array
      end

      it "contains a metadata key" do
        expect(subject.perform_request.first).to have_key(:metadata)
      end

      it "contains a apple_store_id key" do
        expect(subject.perform_request.first[:apple_store_id]).to eq(json_response["trackId"])
      end

    end
  end
end