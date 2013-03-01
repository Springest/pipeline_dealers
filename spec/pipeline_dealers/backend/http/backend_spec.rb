require "pipeline_dealers"
require "support/test_model"

module PipelineDealers::Backend
  describe Http do
    let(:backend) { described_class.new(api_key: "zekret")  }
    let(:collection) { Http::Collection.new(backend, client: double("Client"), model_klass: TestModel) }
    let(:connection) { subject.connection }

    subject { backend }

    describe "saving a model" do
     context "that is new" do
       let(:model) { collection.new(name: "Springest") }
       after(:each) { model.save }

       it "uses the POST method" do
         connection.should_receive(:post).and_return([200, {}])
       end

       it "posts to the correct address" do
         connection.should_receive(:post).with("test_models.json", anything).and_return([200, {}])
       end

       it "posts the correct attributes" do
         connection.should_receive(:post).with(anything, "moeha" => { "name" => "Springest" }).and_return([200, {}])
       end
     end

     context "that has been persisted" do
       let(:model) { TestModel.new(collection: collection, persisted: true, attributes: { "id" => 123, name: "Springest"}) }
       after(:each) { model.save }

       it "uses the PUT method" do
         connection.should_receive(:put).and_return([200, {}])
       end

       it "posts to the correct address" do
         connection.should_receive(:put).with("test_models/123.json", anything).and_return([200, {}])
       end

       it "posts the correct attributes" do
         connection.should_receive(:put).with(anything, "moeha" => { "name" => "Springest" }).and_return([200, {}])
       end
     end
   end
 end
end
