RSpec.describe GcpData do
  it "has a version number" do
    expect(GcpData::VERSION).not_to be nil
  end

  context "GOOGLE_PROJECT" do
    it "from env" do
      ENV['GOOGLE_PROJECT'] = "project-from-env"
      ENV['GOOGLE_REGION'] = "asia-east1"
      expect(GcpData.project).to eq "project-from-env"
      expect(GcpData.region).to eq "asia-east1"
    end
  end

  context "GOOGLE_APPLICATION_CREDENTIALS" do
    it "from file" do
      ENV['GOOGLE_APPLICATION_CREDENTIALS'] = "spec/fixtures/credentials.json"
      expect(GcpData.project).to eq "project-123"
    end
  end

  context "gcloud" do
    let(:gcloud_config) { null }
    let(:null) do
      double(:null).as_null_object
    end

    it "from cli" do
      allow(GcpData).to receive(:gcloud_config).and_return(gcloud_config)
      expect(GcpData.project).to eq null
    end
  end
end
