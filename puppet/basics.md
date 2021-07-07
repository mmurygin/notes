# Basics

## Definitions
1. **Node** - an individual server or device managed by Puppet.
1. **Resources** - single units of configuration in Puppet.
1. **Provider** - is the translation layer that sits between Puppet's resource representation and the native system tools it uses to discover and modify the underlying system state.
1. **Class** - a collection of Puppet code that makes a sense as a logical group.
1. **Manifest** - a text file for holding Puppet code (usually `.pp` file).
1. **Profile** - a class that defines a specific set of configuration. Should be limited to a single unit of configuration: like nginx server, or database.
1. **Role** - a class that defines the business role of a node.
    * each node should have only one role
    * made up only from profiles

## Docs
1. Get list of resources

    ```
    puppet describe --list
    ```

1. Get resource documentation

    ```
    puppet describe service
    ```


## Development
1. View puppet resource

    ```
    puppet resource file /tmp/test
    ```

1. Validate file

    ```
    puppet parser validate file
    ```

1. Preview changes

    ```
    puppet agent -t --noop
    ```

1. Preview changes with file diff

    ```
    puppet agent -t --noop --show_diff
    ```

