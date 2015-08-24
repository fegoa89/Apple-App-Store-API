require "rails_helper"

describe Base do

  subject { Base.new( category_id: 1234, monetization: "free" ) }

  describe "validations" do

    context "with category_id and monetization present" do
      it "is a valid object" do
        expect(subject.valid?).to be true
      end
    end

    context "without category_id or monetization" do
      it "validates the presence of category_id" do
        subject.category_id = ""
        expect(subject.valid?).to be false
        expect(subject.errors.messages[:category_id]).to eq(["can't be blank", "is not a number"])
      end

      it "validates the presence of monetization" do
        subject.monetization = ""
        expect(subject.valid?).to be false
        expect(subject.errors.messages[:monetization]).to eq(["can't be blank", " is not a valid monetization type"])
      end
    end

    context "with an invalid category_id param or monetization given" do
      it "returns an numericality error for category_id" do
        subject.category_id = "something"
        expect(subject.valid?).to be false
        expect(subject.errors.messages[:category_id]).to eq(["is not a number"])
      end

      it "returns an inclusion error for monetization" do
        subject.monetization = "whatever"
        expect(subject.valid?).to be false
        expect(subject.errors.messages[:monetization]).to eq(["#{subject.monetization} is not a valid monetization type"])
      end
    end
  end

  describe "perform_request" do

    let(:apple_store_api_response)   { File.read("spec/fixtures/apple_store_api_raw_response.json") }

    context "performing a successfull request" do
      before(:each) do
        stub_request(:get, %r{https://itunes\.apple\.com/WebObjects/MZStore\.woa.*/}).to_return( body: apple_store_api_response )
        stub_request(:get, %r{https://itunes\.apple\.com/lookup\.*}).to_return( body: apple_lookup_api_response )
      end

      let(:apple_lookup_api_response)   { File.read("spec/fixtures/apple_lookup_api_response.json") }

      let(:json_response) { JSON.parse(apple_lookup_api_response)["results"].first }

      it "returns an array" do
        expect(subject.perform_request.class).to eq Array
      end

      it "contains a apple_store_id key" do
        expect(subject.perform_request.first[:apple_store_id]).to eq(json_response["trackId"])
      end

      it "contains a metadata key" do
        expect(subject.perform_request.first).to have_key(:metadata)
      end

    end

    context "performing an unsuccessfull request" do

      let(:apple_store_api_response_error)   { File.read("spec/fixtures/apple_store_api_xml_error") }

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
          Base.any_instance.should_receive(:get_app_metadata).and_return(RestClient::BadRequest.new)
        end

        it "returns a hash with a error" do
          expect(subject.perform_request).to eq( { error: 400, message: "Bad Request" } )
        end
      end
    end
  end
end