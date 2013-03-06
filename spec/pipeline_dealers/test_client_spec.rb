require "pipeline_dealers"
require "pipeline_dealers/test"

module PipelineDealers
  describe "Client with TestBackend"  do
    let(:client) { TestClient.new }
    subject { client }

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

      context "when stored" do
        let!(:company) { subject.companies.create(name: "Springest") }

        it "makes it able to find it using .first" do
          subject.companies.first.should == company
        end
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

    describe "Notes on nested model" do
      let!(:model) { subject.companies.create(name: "AWESOME") }

      context "no notes added" do
        it "has no notes" do
          model.notes.all.to_a.should == []
        end
      end

      context "after a note has been added" do
        it "has one note" do
          expect do
            model.notes.create(content: "Note Content")
          end.to change { model.notes.all.to_a.length }.by(1)
        end
      end
    end

    describe "selection options on collections" do
      let!(:company_a) { client.companies.create(name: "Company A") }
      let!(:company_b) { client.companies.create(name: "Company B") }

      context "without any selections" do
        subject { client.companies.all.to_a }
        it { should =~ [company_a, company_b] }
      end

      context "with limit" do
        subject { client.companies.limit(1).to_a }
        its(:length) { should == 1 }
        it { should =~ [company_a] }
      end

      context "filtered" do
        context "on company a" do
          subject { client.companies.where(id: company_a.id).all.to_a }
          it { should =~ [company_a] }
        end

        context "on company b" do
          subject { client.companies.where(id: company_b.id).all.to_a }
          it { should =~ [company_b] }
        end
      end
    end
  end
end
