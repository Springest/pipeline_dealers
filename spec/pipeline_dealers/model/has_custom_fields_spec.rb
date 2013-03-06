require "pipeline_dealers"

describe PipelineDealers::Model::HasCustomFields do
  class ModelWithCustomFields < PipelineDealers::Model
    include HasCustomFields
    self.collection_url = "models"
    self.attribute_name = "model"
    attrs :name
  end

  class CustomModelField < PipelineDealers::Model::CustomField
    self.collection_url = "admin/model_custom_field_labels"
  end

  let(:client)     { PipelineDealers::Client.new }
  let(:backend)    { client.backend }
  let(:connection) { backend.connection }

  let(:collection) do
    PipelineDealers::Backend::Http::Collection.new(backend, client: double("Client"), model_klass: ModelWithCustomFields, custom_fields: { model_klass: CustomModelField, cached: true, cache_key: :custom_field_cache_key })
  end

  let(:custom_attributes) { {

    "custom_label_90" => 42,
    "custom_label_91" => "Yeah"
  } }

  let(:custom_field_label_entries) {
    [
      {
        "id"=>90,
        "name"=>"TheAnswerForEverything",
        "is_required"=>false,
        "field_type"=>"numeric"
      },
      {
        "id"=>91,
        "name"=>"Really?",
        "is_required"=>false,
        "field_type"=>"text"
      }
    ]
  }

  let(:custom_field_labels) { {
     "entries"=> custom_field_label_entries,
     "pagination" => {"page" => 1, "pages" => 1, "per_page" => 2, "total" => 2}
    }
  }

  subject { ModelWithCustomFields.new(client: double("Client"), collection: collection, persisted: true, attributes: { "id" => 123, name: "Springest", custom_fields: custom_attributes} ) }

  context "reading custom fields" do
    before { client.stub(:custom_fields).and_return { PLD::CustomField::Collection.new(backend, klass: CustomModelField, cached: true, cache_key: :custom_field_cache_key) } }

    let(:custom_field_models) do
       custom_field_labels.collect { |label| CustomModelField.new(client: double("Client"), collection: model_custom_fields, persisted: true, attributes: label["entries"]) }
    end

    it "fetcheing the translation map is cache" do
      connection.should_receive(:get).once.with("admin/model_custom_field_labels.json", anything()).and_return([200, custom_field_labels])
      subject.custom_fields
      subject.custom_fields
    end

   it "translates the custom fields to recognizable labels" do
      connection.should_receive(:get).once.with("admin/model_custom_field_labels.json", anything()).and_return([200, custom_field_labels])

      subject.custom_fields.should == {
        "TheAnswerForEverything" => 42,
        "Really?" => "Yeah"
      }
    end
  end

  context "storing" do
    before { client.stub(:model_custom_fields).and_return { PLD::CustomField::Collection.new(backend, klass: CustomModelField) } }

    it "reposts the correct attributes" do
      expected_attributes = {
        "model" => {
          "name" => "Springest",
          "custom_fields" => custom_attributes
         }
      }

      connection.should_receive(:get).once.with("admin/model_custom_field_labels.json", anything()).and_return([200, custom_field_labels])
      connection.should_receive(:put).once.with("models/123.json", expected_attributes).and_return([200, expected_attributes[:model]])

      subject.save
    end

    let(:updated_custom_attributes) { {
      "custom_label_90" => 43,
      "custom_label_91" => "Whoo"
    } }

    it "posts the correct change" do
      expected_attributes = {
        "model" => {
          "name" => "Springest",
          "custom_fields" => updated_custom_attributes
         }
      }

      connection.should_receive(:get).once.with("admin/model_custom_field_labels.json", anything()).and_return([200, custom_field_labels])
      connection.should_receive(:put).once.with("models/123.json", expected_attributes).and_return([200, expected_attributes[:model]])

      subject.custom_fields["TheAnswerForEverything"] = 43
      subject.custom_fields["Really?"] = "Whoo"
      subject.save
    end
  end
end
