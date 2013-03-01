class TestModel < PipelineDealers::Model
  self.collection_url = "test_models"
  self.attribute_name = "moeha"

  attrs :name
end
