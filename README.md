# Gry

Gry Generates a .Rubocop.Yml automatically.

[![Build Status](https://travis-ci.org/pocke/gry.svg?branch=master)](https://travis-ci.org/pocke/gry)
[![Coverage Status](https://coveralls.io/repos/github/pocke/gry/badge.svg?branch=master)](https://coveralls.io/github/pocke/gry?branch=master)
[![Gem Version](https://badge.fury.io/rb/gry.svg)](https://badge.fury.io/rb/gry)

Gry extracts coding style guide as a `.rubocop.yml` from your code that already exists.


## Installation

```sh
$ gem install gry
```

## Usage

```sh
# Generate a .rubocop.yml for all configurable cops.
$ gry >> .rubocop.yml

# Generate a .rubocop.yml for specified cops only.
$ gry Style/AndOr Style/VariableName >> .rubocop.yml
```


License
-------


Copyright 2017 Masataka Pocke Kuwabara

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
