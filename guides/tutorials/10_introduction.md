Lucie is a terminal application development framework written in Ruby. The aim of the framework is to make the terminal application development faster and easier with providing generators, plugins, components like Rails does for web developers.

### MVC

Lucie based on Model, View, Contoller (MVC) design pattern, where model represents permanent data, controller implements the business logic and view helps in using templates to generate files or output.

When a Lucie based application is executed, first it dispatches the request and finds the appropriate controller using the first command line attribute. If a second attribute is also defined, it calls the action on the controller with the same name as the attribute, otherwise it calls the index method. Each other attribute is stored in a <code>params</code> instance variable. Mandatory and optional parameters can be defined in controller if some additional information are required by the action.

Controller implements the business logic, using models and templates for data source and representation. Model uses database to store and fetch data.

