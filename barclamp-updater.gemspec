#
# Copyright 2011-2013, Dell
# Copyright 2013-2015, SUSE Linux GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "barclamp/updater/version"

Gem::Specification.new do |s|
  ignores = %w(
    .gitignore
    .rubocop.yml
    .travis.yml
  )

  s.name = "barclamp-updater"
  s.version = Barclamp::Updater::Version
  s.authors = ["Thomas Boerger"]
  s.email = ["tboerger@suse.com"]
  s.summary = "TBD"
  s.description = "TBD"
  s.homepage = "https://github.com/crowbar/barclamp-updater"
  s.license = "Apache-2.0"

  s.required_ruby_version = "~> 2.0"

  s.files = `git ls-files -z`.split("\x0").delete_if do |f|
    ignores.include? f
  end

  s.executables = s.files.grep(/^bin\//) { |f| File.basename(f) }
  s.test_files = s.files.grep(/^(spec|features)\//)
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "yard"
  s.add_development_dependency "rspec"
  s.add_development_dependency "sqlite3"

  s.add_dependency "barclamp-workbench", "~> 0.0.0"
  s.add_dependency "rails", "~> 4.1.0"
end
