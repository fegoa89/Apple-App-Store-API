require "rails_helper"

describe Response::PublishersRanking do
  describe "build_hash" do
    #
    # The file has 2 responses for the same publisher_id and one for a different publisher_id
    # just for make it easier to test, knowing that the output of apple_lookup_build_response
    # would be two elements in the array.
    #
    let(:apple_store_api_response)   { File.read("spec/fixtures/apple_lookup_api_multiple_response.json") }

    let(:apple_lookup_build_response) { Response::AppleLookupResponse.new(apple_store_api_response).build_top_apps_response }

    subject { Response::PublishersRanking.new(apple_lookup_build_response).build_hash }

    context "testing format returned" do
      it "returns an array" do
        expect(subject.class).to eq Array
      end

      it "contains two hashes" do
        expect(subject.count).to eq 2
      end
    end

    context "comparing that the array has the correct order" do
      it "it is ordered" do
        expect(subject.first[:ranking_position]).to be < subject.last[:ranking_position]
      end
    end

    context "setting rank position" do
      it "the first element should have the first ranking position" do
        expect(subject.first[:ranking_position]).to eq 1
      end

      it "the second element should have the second ranking position" do
        expect(subject.last[:ranking_position]).to eq 2
      end
    end

    context "setting the number of apps" do
      it "the first element should have 2 on number_of_apps" do
        expect(subject.first[:number_of_apps]).to eq 2
      end

      it "the first element should have 1 on number_of_apps" do
        expect(subject.last[:number_of_apps]).to eq 1
      end
    end

    context "setting app_names" do
      it "the first element should have 2 names app_names" do
        expect(subject.first[:app_names].count).to eq 2
      end

      it "the last element should have only one" do
        expect(subject.last[:app_names].count).to eq 1
      end

      it "the app_names equals to the ones with the same publisher_id" do
        # Goes through the api lookup response and map the names that should be setted on the app_names array
        expected_names = apple_lookup_build_response.each.map { |response| 
          if subject.first[:publisher_id] == response[:metadata][:publisher_id]
            response[:metadata][:app_name]
          end 
        }
        expect(subject.first[:app_names]).to eq(expected_names.compact)
      end
    end
  end
end