Puppet::Type.type(:macfirewall).provide(:ruby) do

  confine :operatingsystem => :darwin
  defaultfor :operatingsystem => :darwin
  commands   :socketfilterfw   => '/usr/libexec/ApplicationFirewall/socketfilterfw'

  def get_application_on_firewall(app)
      begin
        output = socketfilterfw(['--getappblocked', app])
      rescue Puppet::ExecutionFailure => e
        Puppet.debug("#get_application_allowed_on_firewall had an error -> #{e.inspect}")
        return nil
      end
  #    Puppet.warning("#{output}: Output of the execution!!!!!!!")
      return nil if output.include? "not part of the firewall"
      return app if output.include? "Incoming connection"
      nil
      return nil
  end

  def get_application_state_on_firewall(app)
      begin
        output = socketfilterfw(['--getappblocked', app])
      rescue Puppet::ExecutionFailure => e
        Puppet.debug("#get_application_allowed_on_firewall had an error -> #{e.inspect}")
        return nil
      end
  #    Puppet.warning("#{output}: Output of the execution!!!!!!!")
      return "blocked" if output.include? "is blocked"
      return "permitted" if output.include? "is permitted"
      return "not in the firewall"
  end

  def set_access
  #  Puppet.warning("Set_Access Called!!!!!!!")
    if resource[:access] == :permitted
      then
        socketfilterfw(['--unblockapp', resource[:name]])
        socketfilterfw(['--setglobalstate', 'off'])
        socketfilterfw(['--setglobalstate', 'on'])
      elsif resource[:access] == :blocked
        socketfilterfw(['--blockapp', resource[:name]])
        socketfilterfw(['--setglobalstate', 'off'])
        socketfilterfw(['--setglobalstate', 'on'])
      elsif resource[:access].nil?
        Puppet.warning("access not specified! Access will be permitted by default.")
        socketfilterfw(['--unblockapp', resource[:name]])
        socketfilterfw(['--setglobalstate', 'off'])
        socketfilterfw(['--setglobalstate', 'on'])
    end
  end

  def exists?
    get_application_on_firewall(resource[:name]) != nil
  end

  def destroy
    socketfilterfw(['--remove', resource[:name]])
  end

  def create
    socketfilterfw(['--add', resource[:name]])
    set_access
  end

  def application
    get_application_on_firewall(resource[:name])
  end

  def application=(value)
    socketfilterfw(['--add', resource[:name]])
  end

  def access
  #  Puppet.warning("Blocked method called!!!")
    get_application_state_on_firewall(resource[:name])
  end

  def access=(value)
#    Puppet.warning("#{value}: Value of the blocked method for Sync!!!")
    set_access
  end

  def self.instances
  #  Puppet.warning("Instances Method Enter!!!")
        firewall_properties = {}
        apps = socketfilterfw(['--listapps'])
        app = apps.split("\n\n")
        app.shift
        app.each.collect do |line|
          pathpart, statuspart = line.split("\n \t", 2)
          path=pathpart.split(':')
          status=statuspart.split

          case status[1]
          when 'Allow'
  #          Puppet.warning("#{path[1].strip}: Value of the PERMITTED method for Sync!!!")
            new(:name => path[1].strip,
              :ensure => :present,
              :access => :permitted,
            )
          when 'Block'
  #          Puppet.warning("#{path[1].strip}: Value of the BLOCKED method for Sync!!!")
          new(:name => path[1].strip,
              :ensure => :present,
              :access => :blocked,
            )
          end
        end
  end


  def self.prefetch(resources)
#    Puppet.warning("Prefetch Method Enter!!!")
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

end
