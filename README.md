# MixTestObserver

MixTestObserver is a semiauto test runner. Run `mix test` when each time you write whose target path to the observing file.

For why:

- Elixir execution environment is separated from my editor (but sharing some directories).
- I want to run tests right away when I write codes.
- I sometimes think that run tests when I want it.


For your information:

- Maybe what you're looking for is [mix-test.watch](https://github.com/lpil/mix-test.watch) which is _auto_ test runner.

## Versions

This has been confirmed to work under the following conditions.

```
$ elixir -v
Erlang/OTP 24 [erts-12.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit]

Elixir 1.13.1 (compiled with Erlang/OTP 24)
```

## Installation

If available in Hex, the package can be installed by adding `mix_test_observer` to your list of dependencies in `mix exs`:

```
def deps do
  [
    {:mix_test_observer, "~> 0.1.0", only: [:dev]},
  ]
end
```

See also [FileSystem hex](https://github.com/falood/file_system#system-support), on which this package depends.

Documentation is [here](https://hexdocs.pm/mix_test_observer).
Documentation is generated with [ExDoc](https://github.com/elixir-lang/ex_doc).
and published on [HexDocs](https://hexdocs.pm).


## Usage

Run the mix task:

```
mix test.observer <filepath>
```

Start observing `<filepath>`.

Next try writing test target path to `<filepath>` like `$ echo 'test/' > <filepath>`,
then you can get the test results (`mix test test/`).

- If test target path is not matched `test/` or `*/test/*`, the observer run `mix test --failure` and `mix test --stale`.
- If you hope to get test results in file, run with `--output <output_filepath>` following your `<filepath>`, like `mix test.observer <filepath> --output <output_filepath>`.
- If you hope to configure `mix test` options, you can add it to the end of command, like `mix test.observer <filepath> --include external:true`.

For your information:

- Maybe you should prepare the shortcut function on your editor which write 'filepath:line' or 'filepath' to `<filepath>`.


## License

Copyright 2022 ta.to.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


## Thanks

- Kokura Elixir community 'kokura.ex'
