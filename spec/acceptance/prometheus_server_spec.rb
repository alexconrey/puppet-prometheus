require 'spec_helper_acceptance'

describe 'prometheus server' do
  it 'prometheus server via main class works idempotently with no errors' do
    pp = "class{'prometheus': manage_prometheus_server => true }"

    # Run it twice and test for idempotency
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe service('prometheus') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end
  describe port(9090) do
    it { is_expected.to be_listening.with('tcp6') }
  end
  it 'prometheus server via server class works idempotently with no errors' do
    pp = 'include prometheus::server'

    # Run it twice and test for idempotency
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe service('prometheus') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end
  describe port(9090) do
    it { is_expected.to be_listening.with('tcp6') }
  end
end
