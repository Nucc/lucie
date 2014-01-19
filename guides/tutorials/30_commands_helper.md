Commands Helper provides methods for terminal application.

## Initialization

Command Helper is part of the Lucie library but it's not imported when the application starts. The reason is Lucie tries to be as fast as possible and loading too many libraries with the application would make it slow. When you want to use commands in your controller you need to include <code>Lucie::Commands</code> when the controller is initializating.

    class WorkflowController < Controller::Base
      include Lucie::Commands
    end

## Methods

### 1. Run command in shell

Very often is required in the controller to call other system applications. <code>sh(command)</code> is for executing other applications. It returns true, if the response

    class RepositoryController < Controller::Base

      def init
        status = sh "git init ."
        print output
      end

    end

  Running the application:

    app repository init

### 2. Filesystem operations

Filesystem is the basic part of every application, but for a shell application it's particular. Changing directory, change permission or owner of a file, remove files or directories are basic operations in terminals. Ruby provides a full library just for file and directory operations, so you can use those as well. Here there will be some methods which are very similar to commands in shell.

#### 2.1 Changing directory

The following code changes the current directory to <code>/tmp</code> and prints out the current directory to stdout

    def init
      cd "/tmp"
      puts pwd
    end

    # /tmp



### 3. System output