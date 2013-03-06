require "pipeline_dealers"
require "pipeline_dealers/test"


class SomeClass
  def pld_client
    # Normally this gets executed, but not during this test
    PipelineDealers::Client.new(SOME_OPTIONS)
  end

  def create_company
    company = pld_client.companies.create(name: "MyCompany")
    company.notes.create(content: "whoo, awesome")
  end
end

describe SomeClass do
  let(:client) { PipelineDealers::TestClient.new }
  before { subject.stub(:pld_client).and_return(client) }

  describe "#create_company" do
    it "creates a company" do
      expect { subject.create_company }.to change(client.companies, :count).by(1)
    end

    it "creates a note" do
      expect { subject.create_company }.to change(client.notes, :count).by(1)
    end
  end
end
