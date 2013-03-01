require "pipeline_dealers"
require "pipeline_dealers/test"

module PipelineDealers
  describe "Client with TestBackend"  do
    subject { TestClient.new }

    describe "storing a model" do
      describe "#create" do
        it "stores the model" do
          expect do
            subject.companies.create(name: "My Company")
          end.to change { subject.companies.count }.from(0).to(1)
        end
      end

      describe "#save" do
        let(:model) { subject.companies.new(name: "Some Company") }

        it "stores the model data" do
          expect { model.save }.to change(model, :id).from(nil).to(Integer)
        end
      end

      let(:other_client) { TestClient.new }

      it "is accessable from all instances" do
        other_client.companies.first.should == subject.companies.first
      end
    end

    describe "destroying a model" do
      let!(:model) { subject.companies.create(name: "My Company") }

      describe "#destroy" do
        it "decreases the count" do
          expect { model.destroy }.to change { subject.companies.count }.from(1).to(0)
        end

        it "empties the collection" do
          expect { model.destroy }.to change {
            subject.companies.all.to_a == []
          }.from(false).to(true)
        end
      end
    end

    describe "Custom fields" do
      context "not defined" do
        let(:model) { subject.companies.new }

        describe "assignment" do
          it "does not throw an exception" do
            expect { model.custom_fields[:field] = :value }.not_to raise_error
          end

          it "stores the custom field" do
            model.custom_fields[:field] = :value
            model.custom_fields[:field].should == :value
          end
        end

        describe "retrieval" do
          let(:model) { subject.companies.new }

          before do
            model.custom_fields[:field] = :value
            model.save
          end

          describe "via the collection" do
            it "return the correct value" do
              subject.companies.first.custom_fields[:field].should == :value
            end
          end
        end
      end
    end
  end
end
