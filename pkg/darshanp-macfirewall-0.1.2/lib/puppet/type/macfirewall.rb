   Puppet::Type.newtype(:macfirewall) do
     @doc = "configure mac application firewall"
     # ... the code ... and more ...
     ensurable

     newparam(:name, :namevar => true) do
          desc "Application path to be allowed throught the firewall."
     end


     newproperty(:access) do
       desc "Application to be allowed throught the firewall."
       newvalues(:permitted, :blocked)
     end

   end
