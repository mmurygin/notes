# Package management with go


* `go.mod`: defines the module's path and the dependency requirements.
* `go.sum`: is an auto-generated dependencies lock file.

## Keeping Tidy

The command `go mod tidy` is a command used to clean up the go.mod file and the module's go.sum file in a Go project. It performs a number of tasks to organize and optimize the dependencies of a Go module:

It adds any missing modules to go.mod that are needed to build the current module.
It removes unused modules from go.mod.
It adds any missing entries to go.sum for modules in go.mod.

`go mod verify` is a command to check integrity of downloaded packages.

## Vulnerablities

`govulncheck` is a command-line tool for checking the vulnerabilities of Go packages. It uses the Go module database (located at https://pkg.go.dev/) to check for known vulnerabilities in the dependencies of a Go project.

## Updating dependencies

* `go list` - check for newer versions
* `go list -m -u all` will list all of the modules that are dependencies of the current module, along with the latest version available for each

## Vendoring

The `go mod vendor` command creates a directory named "vendor" in the root of the current module and copies all packages needed to build and test the current module into that directory. This is useful for creating a snapshot of all the dependencies of a project, which can be checked into version control and used to ensure that builds are reproducible. This enables better debugging of third-party dependencies and also gives a diff of what changed in a dependency that is updated with go get.
