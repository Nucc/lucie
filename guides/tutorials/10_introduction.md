Lucie is a terminal application development framework written in Ruby. The aim of the framework is to make the terminal application development faster and easier with providing generators, plugins, components. With specifying a common framework, easier to share workflow management solutions among companies worldwide or creating application that doesn't require graphical user interface.

### MVC

Lucie based on Model, View, Contoller (MVC) design pattern. Using this principle data can be totally separated from business logic and from its representation. Models represent object that need to be permanent, controllers implement business logic and views help in representing models using templates to generate files or output.

When a Lucie based application is executed, first it dispatches the request and finds the appropriate controller using the first command line attribute. If a second attribute is also defined, it calls the action on the controller with the same name as the attribute, otherwise it calls the index method. Each other attribute is stored in a <code>params</code> instance variable. Mandatory and optional parameters can be defined in controller if some additional information are required by the action.

Controller implements the business logic, using models and templates for data source and representation. Model uses database to store and fetch data.

### Directory structure

<table>
  <tr><td><code>/app/controllers</code></td><td> Controllers for business logic </td></tr>
  <tr><td><code>/app/models</code></td><td>Models which store permanent information</td></tr>
</table>

  `/app/models:` Models which store permanent information
  `/app/views: Template files`
  `/config: Configuration files`
  `/lib: Libraries for shared resources`
