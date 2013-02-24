# Lucy

The plan of this project is to create a framework for console applications. It would be a bit different to Thor, Rake, Getopt based command line frameworks, because it would based on MVC design pattern, where appears the controller layer to handle the command, the view to define templates for configuration files and the model to store data in XML or NoSQL database.

Currently it's under hard developing.

Here is an example of dataflow:

We have an application to manage nginx webserver configuration. We want to create a new host in the next process. The name of the application is WorkSpace, so we use the ws shortened name for the command.

`$ ws host create --domain lucy.ie --server web1`

The `HostController`'s create action will handle the request, gets the parameters in params hash. Domain is mandatory parameter for the host command and server is mandatory only for create sub-command.

<pre>
# /app/controllers/host_controller.rb:
class HostController &lt; Controller::Base
  mandatory "-d", "--domain", "Domain name of the host"

  def create
    mandatory "-s", "--server", "Hosting server"

    @domain = params[:domain]
    @server = ip_address(find_host(params[:server]))

    Host.create!(:domain => {:_value => @domain, :server => @server)

    template "nginx/vhost", :ssh, @server, "/etc/nginx/vhosts/#{domain}"
    run "nginx -s reload", :on => @server
  end
end
</pre>

Controller stores the new domain and its base host in Host model. It uses the `nginx/vhost` template to generate a new configuration file on `@server` at `/etc/nginx/vhosts/#{domain}`. After configuration is generated it reloads nginx.

The host model is an XML configuration that looks like this:

<pre>
# /app/models/host.rb
class Host &lt; XmlModel
  root :configuration

  Element :domain do
    Attribute :server
  end
end
</pre>

The root of `Host` is `:configuration`, so it will be under the `<configuration>` node. Domain is an xml element, server is its attribute, so the result will be this:

<pre>
&lt;configuration&gt;
  &lt;hosts&gt;
    &lt;domain server='web1'>lucy.ie&lt;/domain&gt;
  &lt;/hosts&gt;
&lt;/configuration&gt;
</pre>

The template defines an Nginx configuration. `HostController#create` applies this template and render its content on `@server` to `/etc/nginx/vhosts/lucy.ie`.

<pre>
# /app/templates/nginx/vhost:
server {
  listen          80;
  server_name     &lt;%= @domain %&gt;

  location / {
    root /var/www/&lt;%= @domain %&gt;
  }
}
</pre>

So this would be a simple process in Lucy, if you're interested, let me know!

## Contributing

If you want to join to the project, first drop me a mail to nucc@bteam.hu about your ideas. After just

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
