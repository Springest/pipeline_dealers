require "pipeline_dealers"
require "support/test_model"

describe PipelineDealers::Backend::Http::Collection do
  let(:connection) { double("Connection") }
  let(:backend)    { double("Backend").tap { |b| b.stub(:connection).and_return(connection) } }
  let(:collection) { described_class.new(backend, client: double("Client"), model_klass: TestModel) }

  subject { collection }

  context "transparant pagination" do
    let(:expected_params_a) { ["test_models.json", { page: 1, per_page: 200 } ] }
    let(:expected_params_b) { ["test_models.json", { page: 2, per_page: 200 } ] }

    let(:response_a) do
      [
        200, # Status code
        {    # 'JSON' body
          "pagination" => {
            "page"      => 1,
            "pages"     => 2,
            "per_page"  => 1,
            "total"     => 2,
            "url"       => '/resource',
          },
          "entries" => [model_a.attributes]
        }
      ]
    end

    let(:response_b) do
      [
        200, # Status code
        {    # 'JSON' body
          "pagination" => {
            "page"      => 2,
            "pages"     => 2,
            "per_page"  => 1,
            "total"     => 2,
            "url"       => '/resource',
          },
          "entries" => [model_b.attributes]
        }
      ]
    end

    let(:model_a) { TestModel.new(collection: subject, attributes: { name: "Maarten" }) }
    let(:model_b) { TestModel.new(collection: subject, attributes: { name: "Hoogendoorn" }) }

    it "fetches the correct models" do
      connection.should_receive(:get).ordered.once.with(*expected_params_a).and_return(response_a)
      connection.should_receive(:get).ordered.once.with(*expected_params_b).and_return(response_b)

      subject.all.to_a.should =~ [model_a, model_b]
    end

    it "returns records that are not new" do
      connection.should_receive(:get).ordered.once.with(*expected_params_a).and_return(response_a)
      connection.should_receive(:get).ordered.once.with(*expected_params_b).and_return(response_b)

      a, b = subject.all.to_a

      a.new_record?.should == false
      b.new_record?.should == false
    end
  end

  context "limit fetching" do
    let(:expected_params) { ["test_models.json", { page:1, per_page: 1} ] }

    let(:response) do
      [
        200, # Status code
        {    # 'JSON' body
          "pagination" => {
             "page"      => 1,
             "pages"     => 2,
             "per_page"  => 1,
             "total"     => 2,
             "url"       => '/resource',
           },
          "entries" => [model_a.attributes]
        }
      ]
    end

    let(:model_a) { TestModel.new(collection: subject, attributes: { name: "Maarten"}) }

    it "fetches only the resouces before the limit" do
      connection.should_receive(:get).once.with(*expected_params).and_return(response)
      subject.first.should == model_a
    end
  end

  describe "cacheing" do
    let(:response) do
      [
        200, # Status code
        {
          "pagination" => {
             "page"      => 1,
             "pages"     => 1,
             "per_page"  => 1,
             "total"     => 1,
             "url"       => '/resource',
           },
          "entries" => [{}]
        }
      ]
    end

    before do
      connection.stub(:get).and_return(response)
    end

    context "not cached" do
      subject { described_class.new(backend, client: double("Client"), model_klass: TestModel, cached: false) }

      it "doesn't try to cache the result" do
        connection.should_not_receive(:cache)
        subject.all.to_a
      end
    end

    context "cached" do
      subject { described_class.new(backend, client: double("Client"), model_klass: TestModel, cached: true) }

      it "caches the request" do
        backend.should_receive(:cache)
        subject.all
      end
    end
  end

  describe "building new objects" do
    context "with no initial attributes" do
      subject { collection.new }
      it { should be_kind_of TestModel }
      its(:persisted?) { should == false}
    end

    context "with initial attributes" do
      context "valid attributes" do
        subject { collection.new(name: "Springest") }

        its(:name) { should == "Springest" }
      end

      context "invalid attributes" do
        context "invalid name" do
          it "raises an exception" do
            expect { subject.new(no_such_name: "Springest") }.to raise_error(PipelineDealers::Error::InvalidAttributeName)
          end
        end
      end
    end
  end
end
