# Example demonstrating `cmdstanr` build issues in nixpkgs

Of course you will have to use the nix environment to see the issues

    cd cmdstanr-example
    direnv allow

or else

    nix shell

Note that I have set a few things up in `flake.nix`, like an R libs
path (seems to suffer from a similar problem) and the `CMDSTAN`
environment variable and installation path via
`cmdstanr::set_cmdstan_path()`.  Once you are in the appropriate
environment, just run

    R --vanilla

and then

    source("example.R")

at your R prompt.