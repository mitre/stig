control 'aide' do
  impact 'high'
  title 'Aide: Configure the aide service'
  tag 'aide'
  describe package('aide') do
    it { should be_installed }
  end

  describe file('/var/lib/aide/aide.db.gz') do
    it { should be_file }
    it { should be_owned_by 'root' }
  end

  describe file('/var/lib/aide/aide.db.new.gz') do
    it { should be_file }
    it { should be_owned_by 'root' }
  end

  describe file('/var/lib/aide/aide.db') do
    it { should_not be_file }
  end

  # CENTOS6: 1.3.2
  if %w(rhel fedora centos redhat).include?(os[:family])
    describe file('/etc/aide.conf') do
      it { should be_file }
      it { should exist }

      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its(:mode) { should cmp 0o600 }

      its(:content) { should match('Generated by Chef for ') }
      its(:content) { should match('^LSPP\s*=') }
    end

    describe crontab('root').commands('/usr/sbin/aide --check')  do
      its('minutes') { should cmp 0 }
      its('hours') { should cmp 5 }
      its('days') { should cmp '*' }
      its('months') { should cmp '*' }
      its('weekdays') { should cmp '*' }
    end
  end
end
