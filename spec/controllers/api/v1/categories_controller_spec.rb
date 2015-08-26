require "rails_helper"

describe Api::V1::CategoriesController do

  render_views

  let(:apple_store_api_response)   { File.read("spec/fixtures/apple_store_api_raw_response.json") }

  let(:apple_lookup_api_response)   { File.read("spec/fixtures/apple_lookup_api_multiple_response.json") }

  before(:each) do
    stub_request(:get, %r{https://itunes\.apple\.com/WebObjects/MZStore\.woa.*/}).to_return( body: apple_store_api_response )
    stub_request(:get, %r{https://itunes\.apple\.com/lookup\.*}).to_return( body: apple_lookup_api_response )
  end
  
  let(:hash_response) { JSON.parse(response.body) }

  describe "top_apps" do
    context "performing a valid action" do

      before(:each) do
        get :top_apps, category_id: 3, monetization: "free", format: :json
      end

      it "returns a valid http code" do
        expect(response.status).to eq 200
      end

      it "returns a hash" do
        expect(hash_response.class).to be Hash
      end

      it "returns a hash with the key response" do
        expect(hash_response).to have_key("response")
      end

    end

    context "performing an action without required params" do
      context "without category_id" do
        before(:each) do
          get :top_apps, monetization: "free", format: :json
        end

        it "returns an http code error" do
          expect(response.status).to eq 400
        end

        it "contains an error message" do
          expect(hash_response["error_message"]).to eq("Parameter category_id can't be blank .")
        end
      end

      context "without monetization" do
        before(:each) do
          get :top_apps, category_id: 3, format: :json
        end

        it "returns an http code error" do
          expect(response.status).to eq 400
        end

        it "contains an error message" do
          expect(hash_response["error_message"]).to eq("Parameter monetization can't be blank .")
        end
      end
    end
  end

  describe "app_by_ranking_position" do
    context "performing a valid action" do

      before(:each) do
        get :app_by_ranking_position, category_id: 3, monetization: "free", rank_position: 1, format: :json
      end

      it "returns a valid http code" do
        expect(response.status).to eq 200
      end

      it "returns a hash" do
        expect(hash_response.class).to be Hash
      end

      it "returns a hash with the key response" do
        expect(hash_response).to have_key("response")
      end
    end

    context "performing an action without required params" do
      context "without category_id" do
        before(:each) do
          get :app_by_ranking_position, monetization: "free", rank_position: 1, format: :json
        end

        it "returns an http code error" do
          expect(response.status).to eq 400
        end

        it "contains an error message" do
          expect(hash_response["error_message"]).to eq("Parameter category_id can't be blank .")
        end
      end
      context "without monetization" do
        before(:each) do
          get :app_by_ranking_position, category_id: 3, rank_position: 1, format: :json
        end

        it "returns an http code error" do
          expect(response.status).to eq 400
        end

        it "contains an error message" do
          expect(hash_response["error_message"]).to eq("Parameter monetization can't be blank .")
        end
      end
    end
  end

  describe "publishers_ranking" do
    context "performing a valid action" do

      before(:each) do
        get :publishers_ranking, category_id: 3, monetization: "free", format: :json
      end

      it "returns a valid http code" do
        expect(response.status).to eq 200
      end

      it "returns a hash" do
        expect(hash_response.class).to be Hash
      end

      it "returns a hash with the key response" do
        expect(hash_response).to have_key("response")
      end
    end

    context "performing an action without required params" do
      context "without category_id" do
        before(:each) do
          get :publishers_ranking, monetization: "free", format: :json
        end

        it "returns an http code error" do
          expect(response.status).to eq 400
        end

        it "contains an error message" do
          expect(hash_response["error_message"]).to eq("Parameter category_id can't be blank .")
        end
      end

      context "without monetization" do
        before(:each) do
          get :top_apps, category_id: 3, format: :json
        end

        it "returns an http code error" do
          expect(response.status).to eq 400
        end

        it "contains an error message" do
          expect(hash_response["error_message"]).to eq("Parameter monetization can't be blank .")
        end
      end      
    end
  end

end