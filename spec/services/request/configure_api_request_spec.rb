require "rails_helper"

describe Request::ConfigureApiRequest do

  let(:yml_file) { Rails.application.secrets }

  context "building request params in order to perform an AppleStoreApi call" do

    let(:params) { { category_id: 123, monetization: "free" } }

    subject { Request::ConfigureApiRequest.new(params) }

    describe "initialize" do
      it "gets initialized with given params" do
        expect(subject.params).to eq(params)
      end
    end

    describe "apple_store_header" do
      it "returns the header containing the following keys and values" do
        yml_file.headers.each do |key, value|
          expect(subject.apple_store_header[key.to_sym]).to eq(value)
        end
      end
    end

    describe "apple_store_url" do
      it "returns the request url with params" do
        url_params = { l: yml_file.language, popId: yml_file.pop_id, genreId: params[:category_id], dataOnly: yml_file.data_only }
        expected_url = yml_file.urls["apple_store"] + url_params.map { |k, v| "#{k}=#{v}" }.join("&")
        expect(subject.apple_store_url).to eq( expected_url )
      end
    end
  end

  context "building request params in order to perform an AppleLookupApi call" do

    let(:params) { { ids: ["111", "222", "333"] } }

    subject { Request::ConfigureApiRequest.new(params) }

    describe "initialize" do
      it "gets initialized with given params" do
        expect(subject.params).to eq(params)
      end
    end

    describe "apple_lookup_url" do
      it "returns the request url with params" do
        expect(subject.apple_lookup_url).to eq(yml_file.urls["apple_lookup"] + "id=#{params[:ids].join(',')}")
      end
    end
  end
end